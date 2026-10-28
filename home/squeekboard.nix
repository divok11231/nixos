{ pkgs, ... }:

let
  oskShow = pkgs.writeShellScriptBin "osk-show" ''
    ${pkgs.systemd}/bin/busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b true
  '';
  oskHide = pkgs.writeShellScriptBin "osk-hide" ''
    ${pkgs.systemd}/bin/busctl --user call sm.puri.OSK0 /sm/puri/OSK0 sm.puri.OSK0 SetVisible b false
  '';
in
{
  home.packages = [ pkgs.squeekboard oskShow oskHide ];

  systemd.user.services.squeekboard = {
    Unit = {
      Description = "Squeekboard on-screen keyboard";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.squeekboard}/bin/squeekboard";
      Restart = "on-failure";
      Environment = [ "SQUEEKBOARD_KEYBOARD=us_wide" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # Theme: writes ~/.config/gtk-3.0/gtk.css
  gtk = {
    enable = true;
    gtk3.extraCss = ''
      sq_button {
        background-color: #362585;
        color: #ffffff;
      }

      sq_view {
        background-color: #000000;
      }

      sq_button.altline,
      sq_button.wide,
      sq_button.special {
        background: #151233;
      }

      sq_button:active,
      sq_button.altline:active,
      sq_button.special:active,
      sq_button.wide:active {
        background: #747077;
        border-color: #96949d;
      }

      sq_button.locked {
        background: #ffffff;
        color: #2b292f;
      }

      #Return {
        background: #bb1a2a;
        border-color: #ff0000;
      }

      #Return:active {
        background: #1c71d8;
        border-color: #3584e4;
      }
    '';
  };

}
