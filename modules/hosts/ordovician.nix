{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.ordovician = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      # Machine facts
      ../../hosts/ordovician/hardware-configuration.nix
      # Auto-logs-in so the tablet boots straight into the session.
      ../../hosts/ordovician/autologin.nix

      # System features
      nixos.host-base
      nixos.users
      nixos.home-manager
      nixos.unstable
      nixos.tooling
      nixos.st
      nixos.fonts
      nixos.audio
      nixos.bluetooth
      nixos.lock
      nixos.graphics
      nixos.extra-hosts
      nixos.opencode
      nixos.quickshell
      nixos.mango
      nixos.surface
      nixos.thermals
      nixos.games

      # User features
      {
        home-manager.users.kovid.imports = [
          hm.users
          hm.apps
          hm.audio
          hm.nvim
          hm.kitty
          hm.gestures
          hm.quickshell
          hm.squeekboard
          hm.mango
        ];
      }

      # A lambda needs parens in list position: Nix parses a bare leading `{`
      # as the start of a set.
      ({ pkgs, ... }: {
        networking.hostName = "ordovician";
        system.stateVersion = "26.05";

        # Machine facts that no feature owns.
        zramSwap.enable = true;
        services.seatd.enable = true;

        hardware.graphics.extraPackages = with pkgs; [ intel-media-driver ];
      })
    ];
  };
}
