{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    quickshell
    pulseaudio
    upower
    power-profiles-daemon
    brightnessctl
    playerctl
    papirus-icon-theme
  ];

  xdg.configFile."quickshell".source =
    config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/src/meloworld-dotfiles/quickshell";

  systemd.user.services.quickshell-bar = {
    Unit = {
      Description = "Meloworld Quickshell bar";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.quickshell}/bin/qs -p %h/.config/quickshell/bar-only";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
