{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
   
    tailscale
    wireguard-tools
    htop
    btop
    brightnessctl
    pavucontrol
    blueman
    networkmanagerapplet
    chromium
    # Desktop
    grim
    vlc 
    slurp
    wl-clipboard
    fastfetch
    # Editors
    vim
    neovim
    obsidian

    # Dev
    gh
    bun
    cmake
    ninja
    gnumake
    pkg-config
    clang-tools
    git
    gcc
    nodejs
    python3
    sshuttle
    clang
    hypridle
    hyprlock
    lazygit

    # Download
    nautilus
    neural-amp-modeler-lv2
    wget
    curl

    tree
    killall
  ];
}
