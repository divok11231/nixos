{ inputs, ... }:

# nixpkgs-unstable pinned next to the stable one, exposed as an option so
# modules can reach for `config.pkgs-unstable` instead of relying on
# `specialArgs`.
{
  flake.modules.nixos.unstable = { lib, pkgs, ... }: {
    options.pkgs-unstable = lib.mkOption {
      type = lib.types.raw;
      default = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
      };
      description = "The nixpkgs-unstable package set, for packages the stable channel is too old for.";
    };
  };
}
