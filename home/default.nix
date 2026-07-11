{ ... }:

{
  imports = [
    ./packages.nix
    ./waybar
    ./wofi.nix
    ./dunst.nix
    ./hyprpaper.nix
    ./nvim.nix
    # ./hyprland
    # ./kitty.nix
    # ./git.nix
    # ./fish.nix
  ];

  home.username = "kovid";
  home.homeDirectory = "/home/kovid";

  # Don't change after the first install.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
