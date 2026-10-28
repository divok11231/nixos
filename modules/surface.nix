{ inputs, ... }:

# ordovician's Surface Pro (intel) hardware: the patched kernel, the IPTS
# touchscreen and the on-screen keyboard that goes with it.
{
  flake.modules.nixos.surface =
    { pkgs, ... }:
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
      systemd.services."iptsd@".unitConfig = {
        StartLimitIntervalSec = 120;
        StartLimitBurst = 30;
      };

      systemd.services."iptsd@".serviceConfig = {
        Restart = "on-failure";
        RestartSec = "2s";
      };

      environment.systemPackages = [ pkgs.wvkbd ];
    };
}
