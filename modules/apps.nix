{ ... }:

# GUI applications and user-level terminal tooling.
{
  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Session
      swaybg
      networkmanagerapplet

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

      # Terminal userland
      fzf
      eza
      bat
      yazi
      unzip
      zip
    ];
  };
}
