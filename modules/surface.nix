{ inputs, ... }:

# ordovician's Surface Pro (intel) hardware: the patched kernel, the IPTS
# touchscreen and the on-screen keyboard that goes with it.
{
  flake.modules.nixos.surface =
    { ... }:
    {
      imports = [ inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel ];

      hardware.microsoft-surface.kernelVersion = "stable";
      hardware.enableRedistributableFirmware = true;
      hardware.sensor.iio.enable = true;

      # The device node the lisgd gesture service reads.
      services.udev.extraRules = ''
        SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="IPTSD Virtual Touchscreen 045E:099F", SYMLINK+="input/ipts-touchscreen", GROUP="input", MODE="0660"
      '';

      # iptsd loses a race with the kernel ipts driver at boot (IOCTL returns
      # EBUSY) and, being a static unit, then stays dead until something
      # restarts it. That strands /dev/input/ipts-touchscreen, which lisgd
      # depends on. Retry instead of giving up.
      # Touch intermittently stops registering fingers until a hand is swiped
      # across the panel, i.e. the heatmap baseline drifts and fingertips no
      # longer clear the activation threshold. Use the average as the neutral
      # value and lower the thresholds (defaults 24/20). Raise them if ghost
      # touches appear.
      services.iptsd.config.Contacts = {
        Neutral = "average";
        ActivationThreshold = 18;
        DeactivationThreshold = 14;
      };

      systemd.services."iptsd@".unitConfig = {
        StartLimitIntervalSec = 120;
        StartLimitBurst = 30;
      };

      systemd.services."iptsd@".serviceConfig = {
        Restart = "on-failure";
        RestartSec = "2s";
      };

      # This Surface Pro 7 never resumes from s2idle: the kernel stops at
      # "PM: suspend entry" and only a hard reboot recovers. Idle powers the
      # panel off instead (see quickshell's shell.qml), and the power button
      # toggles the panel rather than shutting down (bound in mango).
      services.logind.settings.Login = {
        HandlePowerKey = "ignore";
        HandleLidSwitch = "ignore";
      };
      home-manager.users.kovid = {
        systemd.user.services.quickshell.Service.Environment = [
          "QS_IDLE_SCREEN_OFF=eDP-1"
        ];
        wayland.windowManager.mango.settings.bind = [
          "NONE,XF86PowerOff,sleep_toggle_monitor,eDP-1"
        ];
      };

      # Plays squeekboard's key-press sounds. Effects need the group.
      programs.feedbackd.enable = true;
      users.users.kovid.extraGroups = [ "feedbackd" ];
    };
}
