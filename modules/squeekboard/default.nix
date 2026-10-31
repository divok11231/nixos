{ ... }:

{
  flake.modules.homeManager.squeekboard =
    { pkgs, ... }:
    let
      osk = "${pkgs.systemd}/bin/busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b";
      oskShow = pkgs.writeShellScriptBin "osk-show" "${osk} true";
      oskHide = pkgs.writeShellScriptBin "osk-hide" "${osk} false";
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

      # Take the bottom half of the screen. Squeekboard sizes the panel to a
      # third of the height in landscape and ~5/16 of the width in portrait,
      # then applies these multipliers (capped at 2.0 and 2/3 of the screen).
      dconf.settings."sm/puri/Squeekboard" = {
        scale-in-horizontal-screen-orientation = 1.5;
        scale-in-vertical-screen-orientation = 2.0;
      };

      # Squeekboard picks the layout for the active input source ("us") and
      # prefers the _wide variant on landscape screens. Override both.
      xdg.dataFile."squeekboard/keyboards/us.yaml".source = ./ipad.yaml;
      xdg.dataFile."squeekboard/keyboards/us_wide.yaml".source = ./ipad.yaml;

      # iPad dark keyboard: light letter keys and darker function keys on a
      # near-black tray, rounded with a hairline shadow. User CSS outranks
      # squeekboard's own stylesheet, so plain selectors are enough.
      # Writes ~/.config/gtk-3.0/gtk.css
      gtk = {
        enable = true;
        gtk3.extraCss = ''
          sq_view {
            background-color: #1c1c1e;
            font-family: Inter, sans-serif;
            font-size: 1.4em;
          }

          sq_view sq_button,
          sq_view.wide sq_button {
            color: #ffffff;
            background: #58585c;
            border: none;
            border-radius: 7px;
            box-shadow: 0 1px 0 0 rgba(0, 0, 0, 0.6);
            margin: 4px 3px;
          }

          sq_button:active {
            background: #7c7c80;
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
            background: #58585c;
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
