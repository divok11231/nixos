{ pkgs, ... }:

{
  home.packages = with pkgs; [

    kitty
    loupe
    alacritty
    firefox
    calibre
    zathura
    legcord
    ripgrep
    fd
    fzf
    eza
    bat
    yazi
    dunst
    wofi
    hyprpanel
    steam
    discord
    mpv
    hyprpaper
    unzip
    zip
  ];
}
