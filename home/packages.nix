{ pkgs, ... }:

{
  home.packages = with pkgs; [
    

    # Music
    reaper # Daw
    pavucontrol # routing and control because I am losing with
    qpwgraph # patchbay for pipewire
    neural-amp-modeler-lv2 # because Im lazy and I want to just link things by path
    alsa-utils
    pipewire.jack
    guitarix
    

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
