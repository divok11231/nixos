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
        # launcher's clipboard view runs `cliphist list|decode|delete|wipe`
        cliphist
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

      # Clipboard history: every change to the Wayland clipboard gets appended
      # to cliphist's store, which is what the launcher's clipboard view
      # (ALT,V) reads with `cliphist list`.
      systemd.user.services.cliphist-store = {
        Unit = {
          Description = "Clipboard history watcher (wl-paste | cliphist store)";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
