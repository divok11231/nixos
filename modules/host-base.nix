{ ... }:

# Identical machine-level defaults shared by every host in this flake.
# Host-specific facts (hostname, hardware, stateVersion) stay in modules/hosts/.
{
  flake.modules.nixos.host-base = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.systemd-boot.configurationLimit = 5;

    networking.networkmanager.enable = true;

    networking.firewall = {
      enable = true;
      # Discord uses a wide range of UDP ports (usually 50000-65535) for WebRTC
      allowedUDPPortRanges = [
        {
          from = 50000;
          to = 65535;
        }
      ];
    };

    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";

    security.rtkit.enable = true;

    services.tailscale.enable = true;
    services.openssh.enable = true;

    programs.firefox.enable = true;

    # System-level steam (not just the package) adds the 32-bit libs, controller
    # udev rules and Remote Play firewall ports, and is what gamescopeSession
    # hangs off of.
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    # Lets GSettings persist (squeekboard's auto-show, GTK theme switching).
    programs.dconf.enable = true;
  };
}
