{ inputs, ... }:

# Wires home-manager into NixOS. Which home-manager features a user gets is
# decided by the host, next to the system features it enables.
{
  flake.modules.nixos.home-manager = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
  };
}
