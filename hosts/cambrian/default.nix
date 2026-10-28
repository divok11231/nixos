{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/host-base.nix
    ../../modules/desktop.nix

    ../../modules/packages.nix
    ../../modules/users.nix
    ../../modules/fonts.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/lock.nix
    ../../modules/docker.nix
    ../../modules/graphics.nix
    ../../modules/networking/hosts.nix
    ../../modules/opencode.nix
  ];

  networking.hostName = "cambrian";
  system.stateVersion = "26.05";

  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
