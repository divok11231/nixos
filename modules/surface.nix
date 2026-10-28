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

      environment.systemPackages = [ pkgs.wvkbd ];
    };
}
