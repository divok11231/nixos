{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs-unstable =
  let
    pkgs = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    bun_1_3_13 = pkgs.bun.overrideAttrs (old: rec {
      version = "1.3.13";

      src = pkgs.fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-${
          {
            "x86_64-linux" = "linux-x64-baseline";
            "aarch64-linux" = "linux-aarch64";
            "aarch64-darwin" = "darwin-aarch64";
          }.${system}
        }.zip";

        hash = {
          "x86_64-linux" = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
          "aarch64-linux" = "sha256-cLrkGzkIsKEg4eWMXIrzDnSvrjuNEbDT/djnh937SyI=";
          "aarch64-darwin" = "sha256-VGfj9l26Umuf6pjwzOBO+vwMY+Fpcz7Ce4dqOtMtoZA=";
        }.${system};
      };
    });
  in
    pkgs // {
      opencode = pkgs.opencode.override {
        bun = bun_1_3_13;
      };
    };
  in {
    nixosConfigurations.cambrian = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit pkgs-unstable; };

      modules = [
        ./hosts/cambrian/default.nix
        home-manager.nixosModules.home-manager

        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit pkgs-unstable; };

          home-manager.users.kovid = import ./home;
        }
      ];
    };
  };
}
