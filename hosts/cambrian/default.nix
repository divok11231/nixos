# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  networking.hostName = "cambrian"; # Define your hostname.
  nixpkgs.config.allowUnfree = true;  
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_US.UTF-8";


  programs.xwayland.enable = true;
  environment.sessionVariables = {
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  security.rtkit.enable = true;
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  services.tailscale.enable = true;
  programs.firefox.enable = true;
  services.openssh.enable = true;
  imports = [
    ./hardware-configuration.nix
    ../../modules/packages.nix
    ../../modules/users.nix
    ../../modules/docker.nix
    ../../modules/fonts.nix
    ../../modules/bluetooth.nix
    ../../modules/graphics.nix
    ../../modules/audio.nix
    ../../modules/lock.nix
    ../../modules/desktop.nix
    ../../modules/networking/hosts.nix
    ../../modules/opencode.nix
  ];
networking.firewall = {
  enable = true;
  # Discord uses a wide range of UDP ports (usually 50000-65535) for WebRTC
  allowedUDPPortRanges = [ { from = 50000; to = 65535; } ];
};


  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd 'start-hyprland'";
        user = "greeter";
      };
    };
  };
  system.stateVersion = "26.05"; # Did you read the comment?

}

