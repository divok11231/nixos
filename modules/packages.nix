{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    
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
    slurp
    wl-clipboard

    # Editors
    vim
    neovim

    # Dev
    gh
    opencode
    cmake
    ninja
    gnumake
    pkg-config
    clang-tools
    git
    gcc
    nodejs
    python3
    clang
    hypridle
    hyprlock

    # Download
    wget
    curl


    
    tree
    killall
  ];
}
