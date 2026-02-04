{ config, lib, pkgs, ... }:

let
  cfg = config.myHome.wlogout;
in {
  options.myHome.wlogout = {
    enable = lib.mkEnableOption "wlogout power menu";
  };

  config = lib.mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          label = "lock";
          action = "loginctl lock-session";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "niri msg action quit";
          text = "Logout";
          keybind = "e";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
      ];
      
      style = ''
        window {
            background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent overlay */
        }

        button {
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
            border-style: solid;
            border-width: 2px;
            border-radius: 20px;
            margin: 20px;
            transition: box-shadow 0.2s ease-in-out, background-color 0.2s ease-in-out;
        }

        /* Set icons based on labels */
        #lock {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
        }
        #logout {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
        }
        #reboot {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }
        #shutdown {
            background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
        }
      '';
    };
  };
}
