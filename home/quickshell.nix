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
      "${config.home.homeDirectory}/nixos/home/quickshell";

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Meloworld Quickshell";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.quickshell}/bin/qs -p %h/.config/quickshell/shell.qml";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}

