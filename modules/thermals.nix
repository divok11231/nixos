{ ... }:

# ordovician throttles itself badly without help from the host.
{
  flake.modules.nixos.thermals = { pkgs, ... }: {
    # This prevents the Surface firmware from throttling the CPU to 200MHz when hot
    services.thermald.enable = true;

    boot.kernelModules = [ "coretemp" ];

    environment.systemPackages = with pkgs; [
      lm_sensors
    ];

    environment.etc."btop/btop.conf".text = ''
      show_coretemp = True
      cpu_sensor = "Auto"
    '';
  };
}
