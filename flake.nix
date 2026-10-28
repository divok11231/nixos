{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    mango = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      mango,
      ...
    }:
    let
      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config = {
          allowUnfree = true;
          allowBroken = true;
        };
      };

      homeModule = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
        home-manager.users.kovid.imports = [
          mango.hmModules.mango
          ./home
        ];
      };
    in
    {
      nixosConfigurations.cambrian = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };

        modules = [
          ./hosts/cambrian/default.nix
          mango.nixosModules.mango
          home-manager.nixosModules.home-manager
          homeModule
        ];
      };

      nixosConfigurations.ordovician = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit pkgs-unstable; };

        modules = [
          ./hosts/ordovician/default.nix
          nixos-hardware.nixosModules.microsoft-surface-pro-intel
          mango.nixosModules.mango
          home-manager.nixosModules.home-manager
          homeModule

          {
            home-manager.users.kovid = {
              disabledModules = [ ./home/nsys.nix ];
            };
          }
        ];
      };

      devShells.${system} = {
        profiling = import ./shells/profiling.nix { inherit pkgs-unstable; };
        nsight-viewer = import ./shells/nsight-viewer.nix { inherit pkgs-unstable; };
      };
    };
}
