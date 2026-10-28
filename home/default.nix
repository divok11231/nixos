{ ... }:

{
  imports = [
    ./packages.nix
    ./dunst.nix
    ./nvim.nix
    ./nsys.nix
    ./kitty.nix
    # ./git.nix
    ./mango.nix
    ./gestures.nix
    ./quickshell.nix
    ./squeekboard.nix
  ];

  home.username = "kovid";
  home.homeDirectory = "/home/kovid";

  # Don't change after the first install.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
