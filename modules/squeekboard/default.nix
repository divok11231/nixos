{ ... }:

{
  flake.modules.homeManager.squeekboard =
    { pkgs, ... }:
    let
      osk = "${pkgs.systemd}/bin/busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b";
      oskShow = pkgs.writeShellScriptBin "osk-show" "${osk} true";
      oskHide = pkgs.writeShellScriptBin "osk-hide" "${osk} false";
      # A short, soft tick for key presses, played by feedbackd on
      # squeekboard's "button-pressed" event. Lives in its own sound theme
      # that inherits freedesktop, so other event sounds are unchanged.
      clickTheme = pkgs.runCommand "squeekboard-click-sounds" { nativeBuildInputs = [ pkgs.sox ]; } ''
        dir=$out/share/sounds/keyclick
        mkdir -p $dir/stereo
        printf '[Sound Theme]\nName=keyclick\nInherits=freedesktop\nDirectories=stereo\n\n[stereo]\nOutputProfile=stereo\n' > $dir/index.theme
        sox -n -r 48000 -c 1 $dir/stereo/button-pressed.wav \
          synth 0.012 pinknoise highpass 1800 lowpass 6000 fade q 0 0.012 0.010 gain -8
      '';
      oskToggle = pkgs.writeShellScriptBin "osk-toggle" ''
        visible=$(${pkgs.systemd}/bin/busctl --user get-property sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 Visible)
        if [ "$visible" = "b true" ]; then ${osk} false; else ${osk} true; fi
      '';
    in
    {
      home.packages = [
        pkgs.squeekboard
        oskShow
        oskHide
        oskToggle
      ];

      systemd.user.services.squeekboard = {
        Unit = {
          Description = "Squeekboard on-screen keyboard";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${pkgs.squeekboard}/bin/squeekboard";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      # Only show when asked (lisgd gestures, dashboard toggle via osk-*),
      # never on its own when a text field takes focus.
      dconf.settings."org/gnome/desktop/a11y/applications".screen-keyboard-enabled = false;

      xdg.dataFile."sounds/keyclick".source = "${clickTheme}/share/sounds/keyclick";
      dconf.settings."org/gnome/desktop/sound".theme-name = "keyclick";

      # A bit under half the screen. Squeekboard sizes the panel to a
      # third of the height in landscape and ~5/16 of the width in portrait,
      # then applies these multipliers (capped at 2.0 and 2/3 of the screen).
      dconf.settings."sm/puri/Squeekboard" = {
        scale-in-horizontal-screen-orientation = 1.3;
        scale-in-vertical-screen-orientation = 1.7;
      };

      # Squeekboard picks the layout for the active input source ("us") and
      # prefers the _wide variant on landscape screens. Override both.
      xdg.dataFile."squeekboard/keyboards/us.yaml".source = ./ipad.yaml;
      xdg.dataFile."squeekboard/keyboards/us_wide.yaml".source = ./ipad.yaml;

      # iPad dark keyboard: light letter keys and darker function keys on a
      # near-black tray, rounded with a hairline shadow. User CSS outranks
      # squeekboard's own stylesheet regardless of specificity, so keep these
      # selectors plain: a more specific base rule would mask :active.
      # Writes ~/.config/gtk-3.0/gtk.css
      gtk = {
        enable = true;
        gtk3.extraCss = ''
          sq_view {
            background-color: #1c1c1e;
            font-family: Inter, sans-serif;
            font-size: 1.4em;
          }

          sq_button {
            color: #ffffff;
            background: #58585c;
            border: none;
            border-radius: 7px;
            box-shadow: 0 1px 0 0 rgba(0, 0, 0, 0.6);
            margin: 4px 3px;
          }

          /* Pressed: flash much lighter, like an iPad key under a finger. */
          sq_button:active {
            background: #a8a8ad;
            color: #1c1c1e;
          }

          sq_button.backspace,
          sq_button.return,
          sq_button.shift,
          sq_button.change-view,
          sq_button.change-view-2,
          sq_button.special {
            background: #343437;
            font-size: 0.6em;
          }

          sq_button.backspace:active,
          sq_button.return:active,
          sq_button.shift:active,
          sq_button.change-view:active,
          sq_button.change-view-2:active,
          sq_button.special:active {
            background: #8e8e93;
          }

          /* Shift: white for one capital, white and bold once caps-locked. */
          sq_button.latched,
          sq_button.locked {
            background: #f2f2f7;
            color: #1c1c1e;
          }
        '';
      };
    };
}
