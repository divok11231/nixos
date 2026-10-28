{ config, inputs, ... }:

let
  nixos = config.flake.modules.nixos;
  hm = config.flake.modules.homeManager;
in
{
  flake.nixosConfigurations.cambrian = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      # Machine facts
      ../../hosts/cambrian/hardware-configuration.nix

      # System features
      nixos.host-base
      nixos.users
      nixos.home-manager
      nixos.unstable
      nixos.tooling
      nixos.fonts
      nixos.audio
      nixos.bluetooth
      nixos.lock
      nixos.docker
      nixos.graphics
      nixos.nvidia
      nixos.extra-hosts
      nixos.opencode
      nixos.mango

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
          hm.nsight
        ];
      }

      {
        networking.hostName = "cambrian";
        system.stateVersion = "26.05";

        environment.sessionVariables = {
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        };
      }
    ];
  };
}
