{ ... }:

# Which systems this flake evaluates, and what formats its Nix files.
{
  systems = [ "x86_64-linux" ];

  perSystem = { pkgs, ... }: {
    formatter = pkgs.nixfmt-tree;
  };
}
