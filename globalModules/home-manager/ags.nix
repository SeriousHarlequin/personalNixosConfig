{ config, lib, pkgs, ... }:
let
  cfg = config.myHome.ags;

  appTs = ''
    import { App, Astal, Gtk, Widget } from "astal/gtk3"
    import { Variable, GLib, bind } from "astal"

    const clock = Variable("").poll(1000, () =>
        GLib.DateTime.new_now_local().format("%H:%M")!
    )

    const date = Variable("").poll(60000, () =>
        GLib.DateTime.new_now_local().format("%A, %d %B")!
    )

    const cpu = Variable("0").poll(3000, [
        "awk",
        "/^cpu /{total=$2+$3+$4+$5+$6+$7+$8; idle=$5; printf \"%.0f\", 100*(total-idle)/total}",
        "/proc/stat",
    ])

    const ram = Variable("0").poll(3000, [
        "awk",
        "/^MemTotal/{t=$2}/^MemAvailable/{a=$2}END{printf \"%.0f\", (t-a)*100/t}",
        "/proc/meminfo",
    ])

    function StatRow(icon: string, value: Variable<string>) {
        return new Widget.Box({
            children: [
                new Widget.Label({
                    css: "font-family: 'JetBrainsMono Nerd Font'; font-size: 16px; color: @base0D; min-width: 32px;",
                    label: icon,
                }),
                new Widget.Label({
                    hexpand: true,
                    halign: Gtk.Align.END,
                    label: bind(value).as(v => `''${v}%`),
                }),
            ],
        })
    }

    function Dashboard() {
        return new Widget.Window({
            application: App,
            name: "dashboard",
            layer: Astal.Layer.TOP,
            anchor: Astal.WindowAnchor.TOP,
            exclusivity: Astal.Exclusivity.IGNORE,
            visible: false,
            child: new Widget.Box({
                vertical: true,
                spacing: 12,
                css: `
                    margin-top: 10px;
                    padding: 24px;
                    min-width: 300px;
                    background-color: @base00;
                `,
                children: [
                    new Widget.Label({
                        halign: Gtk.Align.CENTER,
                        css: "font-size: 64px; font-weight: bold; color: @base06;",
                        label: bind(clock),
                    }),
                    new Widget.Label({
                        halign: Gtk.Align.CENTER,
                        css: "font-size: 13px; color: alpha(@base06, 0.6);",
                        label: bind(date),
                    }),
                    new Widget.Box({
                        css: "min-height: 1px; background-color: alpha(@base04, 0.3); margin: 4px 0;",
                    }),
                    StatRow("", cpu),
                    StatRow("", ram),
                ],
            }),
        })
    }

    App.start({
        main: Dashboard,
    })
  '';
in
{
  options.myHome.ags = {
    enable = lib.mkEnableOption "AGS dashboard widget";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.ags ];

    home.file.".config/ags/app.ts".text = appTs;

    systemd.user.services.ags = {
      Unit = {
        Description = "AGS dashboard";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.ags}/bin/ags run";
        Restart = "on-failure";
        RestartSec = 3;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    programs.niri.settings.binds."Mod+B".action.spawn =
      [ "${pkgs.ags}/bin/ags" "toggle" "dashboard" ];
  };
}
