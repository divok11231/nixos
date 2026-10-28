{ pkgs, ... }:

# GUI applications and user-level tooling.
# Terminals: foot (system) + kitty (programs.kitty). Session utilities that
# quickshell invokes are declared next to the quickshell service.
{
  home.packages = with pkgs; [
    # Music
    reaper # DAW
    pavucontrol # routing and control
    qpwgraph # pipewire patchbay
    neural-amp-modeler-lv2 # because I'm lazy and want to link things by path
    alsa-utils
    pipewire.jack
    guitarix

    # Session
    swaybg

    # Desktop apps
    chromium
    vlc
    nautilus
    obsidian
    loupe
    calibre
    zathura
    legcord
    steam
    slack
    mpv
    networkmanagerapplet

    # Terminal userland
    fzf
    eza
    bat
    yazi
    unzip
    zip
  ];
}
