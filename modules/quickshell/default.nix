{ ... }:

# The QML tree is deployed into the store, so ~/.config/quickshell is read-only.
# Anything the service needs to write lives in ~/.local/state/quickshell.
{
  flake.modules.nixos.quickshell = {
    services.upower.enable = true;
  };

  flake.modules.homeManager.quickshell =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        quickshell
        # pactl only ships from pulseaudio
        pulseaudio
        upower
        power-profiles-daemon
        brightnessctl
        playerctl
        papirus-icon-theme
        # nightlight toggle runs wlsunset
        wlsunset
      ];

      xdg.configFile."quickshell".source = ./qml;

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
    };
}
