{ pkgs, inputs, ... }:

let
  eruptionPkg = (pkgs.callPackage "${inputs.eruption-nix}/eruption.nix" {}).overrideAttrs (old: {
    RUSTFLAGS = (old.RUSTFLAGS or "") + " --cap-lints warn";
  });
in
{
  services.dbus.packages = [ eruptionPkg ];
  security.polkit.enable = true;
  services.udev.packages = [ eruptionPkg ];

  environment.etc = {
    "eruption/eruption.conf".source = "${eruptionPkg}/etc/eruption/eruption.conf";
    "eruption/fx-proxy.conf".source = "${eruptionPkg}/etc/eruption/fx-proxy.conf";
    "eruption/audio-proxy.conf".source = "${eruptionPkg}/etc/eruption/audio-proxy.conf";
    "eruption/process-monitor.conf".source = "${eruptionPkg}/etc/eruption/process-monitor.conf";
    "eruption/profile.d/eruption.sh".source = "${eruptionPkg}/etc/eruption/profile.d/eruption.sh";
  };

  systemd.services = {
    eruption = {
      description = "Realtime RGB LED Driver for Linux";
      wants = [ "basic.target" ];
      wantedBy = [ "basic.target" ];
      startLimitIntervalSec = 300;
      startLimitBurst = 3;
      environment.RUST_LOG = "warn";
      serviceConfig = {
        RuntimeDirectory = "eruption";
        PIDFile = "/run/eruption/eruption.pid";
        ExecStart = "${eruptionPkg}/bin/eruption -c ${eruptionPkg}/etc/eruption/eruption.conf";
        TimeoutStopSec = 10;
        Type = "exec";
        Restart = "always";
        WatchdogSec = 8;
        WatchdogSignal = "SIGKILL";
        CPUSchedulingPolicy = "rr";
        CPUSchedulingPriority = 20;
      };
    };
    "eruption-install-files" = {
      description = "Install all files for Eruption";
      after = [ "network.target" ];
      before = [ "eruption.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "${pkgs.coreutils}/bin/rm -r /usr/share/eruption /usr/share/eruption-gui-gtk3 /var/lib/eruption/profiles /usr/share/man/man8/eruption.8 /usr/share/man/man8/eruption-cmd.8 /usr/share/man/man5/eruption.conf.5 /usr/share/man/man5/process-monitor.conf.5 /usr/share/man/man1/eruptionctl.1 /usr/share/man/man8/eruption-hwutil.8 /usr/share/man/man1/eruption-macro.1 /usr/share/man/man1/eruption-keymap.1 /usr/share/man/man1/eruption-netfx.1 /usr/share/man/man1/eruption-fx-proxy.1 /usr/share/man/man1/eruption-audio-proxy.1 /usr/share/man/man1/eruption-process-monitor.1";
      };
      script = ''
        for abs_path in $(find "${eruptionPkg}/usr/share" -type f) $(find "${eruptionPkg}/var/lib" -type f); do
          rel_path=$(realpath --relative-to="${eruptionPkg}" "$abs_path")
          mkdir -p $(dirname "/$rel_path")
          ln -sf "$abs_path" "/$rel_path"
        done
      '';
      enable = true;
    };
  };

  systemd.user.services = {
    "eruption-audio-proxy" = {
      description = "Audio proxy daemon for Eruption";
      requires = [ "sound.target" ];
      partOf = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      environment = { RUST_LOG = "warn"; PULSE_LATENCY_MSEC = "30"; };
      serviceConfig = {
        ExecStart = "${eruptionPkg}/bin/eruption-audio-proxy -c /etc/eruption/audio-proxy.conf daemon";
        Type = "exec";
        Restart = "always";
        RestartSec = 1;
      };
    };
    "eruption-fx-proxy" = {
      description = "Effects proxy daemon for Eruption";
      wants = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      environment.RUST_LOG = "warn";
      serviceConfig = {
        ExecStart = "${eruptionPkg}/bin/eruption-fx-proxy -c /etc/eruption/fx-proxy.conf daemon";
        Type = "exec";
        Restart = "always";
        RestartSec = 1;
      };
    };
    "eruption-process-monitor" = {
      description = "Process Monitoring and Introspection for Eruption";
      partOf = [ "graphical-session.target" ];
      bindsTo = [ "graphical-session.target" ];
      wantedBy = [ "graphical-session.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      environment.RUST_LOG = "warn";
      serviceConfig = {
        PassEnvironment = "WAYLAND_DISPLAY XDG_SESSION_TYPE XDG_CURRENT_DESKTOP DISPLAY XAUTHORITY";
        ExecStart = "${eruptionPkg}/bin/eruption-process-monitor -c /etc/eruption/process-monitor.conf daemon";
        Type = "exec";
        Restart = "always";
        RestartSec = 1;
      };
    };
  };

  environment.systemPackages = [ eruptionPkg pkgs.gtk3 ];
}
