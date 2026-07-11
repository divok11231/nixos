{ pkgs, ... }:

{
  home.username = "kovid";
  home.homeDirectory = "/home/kovid";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
