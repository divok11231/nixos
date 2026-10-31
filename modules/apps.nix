{ ... }:

# GUI applications and user-level terminal tooling.
{
  flake.modules.homeManager.apps = { pkgs, ... }: {
    # Links open in firefox, not chromium: mimeapps.list decides what
    # xdg-open hands x-scheme-handler/{http,https} to, and the defaults
    # fall through to chromium's mimeinfo.cache without this.
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/discord" = [ "legcord.desktop" ];
        "x-scheme-handler/slack" = [ "slack.desktop" ];
        "application/vnd.ms-publisher" = [ "vim.desktop" ];
      };
      associations.added = {
        "text/html" = [ "firefox.desktop" ];
        "application/vnd.ms-publisher" = [ "vim.desktop" ];
      };
    };
    # The pre-declarative hand-written file must not block activation.
    xdg.configFile."mimeapps.list".force = true;

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
