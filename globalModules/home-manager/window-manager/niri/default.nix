{ config, lib, pkgs, inputs, ...}:
let
    cfg = config.myHome.niri;

    # awww (formerly swww) — pkgs.swww is now an alias for pkgs.awww, and the
    # binaries are awww / awww-daemon.
    awww = "${pkgs.awww}/bin/awww";
    awwwDaemon = "${pkgs.awww}/bin/awww-daemon";

    # Graphical wallpaper picker: fuzzel (dmenu mode) over a wallpapers dir,
    # then set the choice with awww. Runtime-only — no flake edits to swap.
    # Each entry gets an inline PNG thumbnail (cached) so wallpapers preview
    # themselves in the menu. Thumbnails are PNG because this fuzzel is built
    # with +png +svg but no JPEG.
    wallpaperPicker = pkgs.writeShellApplication {
        name = "wallpaper-picker";
        runtimeInputs = with pkgs; [ awww fuzzel imagemagick findutils gnused coreutils libnotify ];
        text = ''
            # Optional arg: WALLPAPER_DIR (defaults to ~/Pictures/wallpapers).
            walldir="''${1:-$HOME/Pictures/wallpapers}"
            thumbdir="''${XDG_CACHE_HOME:-$HOME/.cache}/wallpaper-thumbnails"

            if [ ! -d "$walldir" ]; then
                notify-send "Wallpaper picker" "Directory not found: $walldir"
                exit 1
            fi

            mkdir -p "$thumbdir"

            # Pick the target: "All monitors" (default) or a single output from
            # `awww query`. "All monitors" maps to no --outputs (every screen).
            # Skip the prompt entirely when only one monitor is connected.
            outargs=()
            mapfile -t outputs < <(awww query | sed -nE 's/^:? *([^:]+):.*/\1/p')
            if [ "''${#outputs[@]}" -gt 1 ]; then
                target="$( { echo 'All monitors'; printf '%s\n' "''${outputs[@]}"; } \
                    | fuzzel --dmenu --prompt 'monitor  ')"
                [ -z "$target" ] && exit 0
                [ "$target" != "All monitors" ] && outargs=(--outputs "$target")
            fi

            # Emit fuzzel dmenu lines: "<name>\0icon\x1f<thumbnail>".
            # Generate/refresh a cached thumbnail per wallpaper as needed.
            menu() {
                find -L "$walldir" -type f \
                    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
                       -o -iname '*.gif' -o -iname '*.webp' -o -iname '*.bmp' \) \
                    -printf '%P\n' | sort | while IFS= read -r name; do
                    src="$walldir/$name"
                    thumb="$thumbdir/$(printf '%s' "$src" | sha1sum | cut -c1-16).png"
                    if [ ! -f "$thumb" ] || [ "$src" -nt "$thumb" ]; then
                        magick "$src" -thumbnail '160x100^' -gravity center \
                            -extent 160x100 "$thumb" 2>/dev/null || continue
                    fi
                    printf '%s\0icon\x1f%s\n' "$name" "$thumb"
                done
            }

            selection="$(menu | fuzzel --dmenu --prompt '󰸉  ')"

            [ -z "$selection" ] && exit 0

            awww img "''${outargs[@]}" "$walldir/$selection" -t random
        '';
    };
in
{
    imports = [ inputs.niri.homeModules.niri ];


    options.myHome.niri = {
        enable = lib.mkEnableOption "Enable Niri styling for user";
    };

    config = lib.mkIf cfg.enable {
        programs.niri.enable = true;

        programs.niri.package = pkgs.niri;

        programs.niri.settings = {
            # 1. Inputs (Mouse/Keyboard/Touchpad)
            input = {
                keyboard.xkb.layout = "de";
                touchpad = {
                    tap = true;
                    dwt = true;
                };
            };

            spawn-at-startup = [
                # Start the awww daemon, wait for it to come up, then restore the
                # last wallpaper set with `awww img`. Only if nothing was restored
                # (first boot, empty cache) seed the stylix default so it's not blank.
                { command = [ "sh" "-c" "${awwwDaemon} & for _ in $(seq 1 50); do ${awww} query >/dev/null 2>&1 && break; sleep 0.1; done; ${awww} restore 2>/dev/null; ${awww} query 2>/dev/null | grep -q 'image:' || ${awww} img -t none ${config.stylix.image}" ]; }
            ];

            # 2. Layout & Styling
            # Stylix will automatically inject colors into 'focus-ring' 
            # and 'border' unless you override them here.
            layout = {
                gaps = 12;
                center-focused-column = "never";

                preset-column-widths = [
                    { proportion = 1.0 / 3.0; }
                    { proportion = 1.0 / 2.0; }
                    { proportion = 2.0 / 3.0; }
                ];
                default-column-width = { proportion = 1.0 / 2.0; };
            };

            # 3. Keybinds
            binds = with config.lib.niri.actions; {

                # Essentials
                "Mod+Shift+7".action = show-hotkey-overlay;
                "Mod+T".action = spawn "ghostty";
                "Mod+D".action = spawn "fuzzel";
                "Mod+Shift+W".action = spawn "${wallpaperPicker}/bin/wallpaper-picker";
                "Mod+W".action = spawn "firefox";
                "Mod+Q".action = close-window;
                "Mod+E".action = spawn "nautilus";
                "Mod+N".action = spawn "networkmanager_dmenu";
                "Mod+M".action.spawn = [ "ghostty" "-e" "btop" ];
                "Mod+S".action = spawn "pavucontrol";
                "Mod+BackSpace".action.spawn = [ "wlogout" "-b" "2" ];
                "Mod+Ctrl+Up".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+" ];
                "Mod+Ctrl+Down".action.spawn = [ "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-" ];

                "Mod+Shift+E".action = quit;
                "Mod+Shift+P".action = power-off-monitors;
                "Mod+Escape".action = spawn "swaylock";

                # Window Navigation
                "Mod+Left".action = focus-column-left;
                "Mod+Right".action = focus-column-right;
                "Mod+Up".action = focus-window-up;
                "Mod+Down".action = focus-window-down;

                "Mod+H".action = focus-column-left;
                "Mod+L".action = focus-column-right;
                "Mod+K".action = focus-window-up;
                "Mod+J".action = focus-window-down;

                "Mod+Alt+Left".action = focus-monitor-left;
                "Mod+Alt+Right".action = focus-monitor-right;
                "Mod+Alt+Up".action = focus-monitor-up;
                "Mod+Alt+Down".action = focus-monitor-down;

                "Mod+Alt+H".action = focus-monitor-left;
                "Mod+Alt+L".action = focus-monitor-right;
                "Mod+Alt+K".action = focus-monitor-up;
                "Mod+Alt+J".action = focus-monitor-down;

                # Window Manipulation
                "Mod+Shift+Left".action = move-column-left;
                "Mod+Shift+Right".action = move-column-right;

                "Mod+Shift+H".action = move-column-left;
                "Mod+Shift+L".action = move-column-right;

                "Mod+Alt+Shift+Left".action = move-column-to-monitor-left;
                "Mod+Alt+Shift+Right".action = move-column-to-monitor-right;
                "Mod+Alt+Shift+Up".action = move-column-to-monitor-up;
                "Mod+Alt+Shift+Down".action = move-column-to-monitor-down;

                "Mod+Alt+Shift+H".action = move-column-to-monitor-left;
                "Mod+Alt+Shift+L".action = move-column-to-monitor-right;
                "Mod+Alt+Shift+K".action = move-column-to-monitor-up;
                "Mod+Alt+Shift+J".action = move-column-to-monitor-down;

                "Mod+R".action = switch-preset-column-width;
                "Mod+F".action = maximize-column;
                "Mod+Shift+F".action = fullscreen-window;
                "Mod+C".action = center-column;

                "Mod+Minus".action = set-column-width "-10%";
                "Mod+Plus".action = set-column-width "+10%";
                "Mod+Shift+Minus".action = set-window-height "-10%";
                "Mod+Shift+Plus".action = set-window-height "+10%";

                "Mod+8".action = consume-or-expel-window-left;
                "Mod+9".action = consume-or-expel-window-right;

                "Mod+V".action = toggle-window-floating;
                "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;
                
                #Workspaces
                "Mod+Page_Up".action = focus-workspace-up;
                "Mod+Page_Down".action = focus-workspace-down;
                "Mod+U".action = focus-workspace-up;
                "Mod+I".action = focus-workspace-down;

                "Mod+Shift+Page_Up".action = move-column-to-workspace-up;
                "Mod+Shift+Page_Down".action = move-column-to-workspace-down;
                "Mod+Shift+U".action = move-column-to-workspace-up;
                "Mod+Shift+I".action = move-column-to-workspace-down;
                
                "Mod+O".action = toggle-overview;

                # Screenshot
                "Print".action.screenshot = { };
                #"Print+Shift".action.screenshot-screen = { };
                #"Print+Alt".action.screenshot-window = { };


            };

            # 4. Window Rules
            window-rules = [
                {
                    geometry-corner-radius = {
                        bottom-left = 12.0;
                        bottom-right = 12.0;
                        top-left = 12.0;
                        top-right = 12.0;
                    };
                    clip-to-geometry = true;
                    #matches = [{ app-id = "firefox"; }];
                    #open-maximized = true;
                }

                # Pavucontrol
                {
                    matches = [{ app-id = "org.pulseaudio.pavucontrol"; }];
                    open-floating = true;
                    
                    # Optional: Set a specific size so it's not a tiny square
                    default-column-width.proportion = 0.5;
                    default-window-height.proportion = 0.4;
                }

                # Nautilus
                {
                    matches = [{ app-id = "org.gnome.Nautilus";}];
                    open-floating = true;

                    default-column-width.proportion = 0.5;
                    default-window-height.proportion = 0.6;
                }
            ];
        };
    };
}
