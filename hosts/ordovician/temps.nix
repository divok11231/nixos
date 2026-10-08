{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];

  boot.kernelModules = [ "coretemp" ];

  # This prevents the Surface firmware from throttling the CPU to 200MHz when hot
  services.thermald.enable = true;

  environment.etc."btop/btop.conf".text = ''
    show_coretemp = True
    cpu_sensor = "Auto"
  '';
}

