{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./autologin.nix
    ./temps.nix

    ../../modules/host-base.nix
    ../../modules/desktop.nix

    ../../modules/packages.nix
    ../../modules/users.nix
    ../../modules/fonts.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/lock.nix
    ../../modules/networking/hosts.nix
    ../../modules/opencode.nix

    ../../modules/ipts-touchscreen.nix
    ../../modules/wvkbd.nix
  ];

  networking.hostName = "ordovician";
  system.stateVersion = "26.05";

  hardware.microsoft-surface.kernelVersion = "stable";
  hardware.enableRedistributableFirmware = true;
  hardware.sensor.iio.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver ];
  };

  zramSwap.enable = true;
  services.seatd.enable = true;

  programs.gamescope.enable = true;
  programs.steam.gamescopeSession.enable = true;
}
