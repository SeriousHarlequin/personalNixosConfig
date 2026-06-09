{ config, lib, pkgs, ... }:
let
  cfg = config.myHome.ags;
  c = config.lib.stylix.colors;

  colorsTs = pkgs.writeText "colors.ts" ''
    export const css = `
        @define-color base00 #${c.base00};
        @define-color base01 #${c.base01};
        @define-color base04 #${c.base04};
        @define-color base06 #${c.base06};
        @define-color base08 #${c.base08};
        @define-color base0D #${c.base0D};

        levelbar trough {
            background-color: @base01;
            border-radius: 4px;
            min-height: 6px;
            border: none;
            padding: 0;
        }
        levelbar block.filled {
            background-color: @base0D;
            border-radius: 4px;
            min-height: 6px;
            border: none;
            padding: 0;
        }
        levelbar block.empty {
            background-color: transparent;
            border: none;
            padding: 0;
        }
    `;
  '';

  agsConfig = pkgs.runCommandLocal "ags-config" { } ''
    mkdir -p $out/widgets
    cp ${./app.ts} $out/app.ts
    cp ${colorsTs} $out/colors.ts
    cp ${./widgets/dashboard.ts} $out/widgets/dashboard.ts
    cp ${./widgets/sound.ts} $out/widgets/sound.ts
    cp ${./widgets/notifications.ts} $out/widgets/notifications.ts
  '';
in
{
  options.myHome.ags = {
    enable = lib.mkEnableOption "AGS dashboard widget";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ags ];

    systemd.user.services.ags = {
      Unit = {
        Description = "AGS dashboard";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.ags}/bin/ags run ${agsConfig}/app.ts";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    programs.niri.settings.binds = {
      "Mod+B".action.spawn = [ "${pkgs.ags}/bin/ags" "request" "toggle-dashboard" ];
      "Mod+A".action.spawn = [ "${pkgs.ags}/bin/ags" "request" "toggle-sound" ];
    };
  };
}
