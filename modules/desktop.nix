{ pkgs, ... }:

# The desktop session every host runs: mango, wrapped in uwsm, offered by greetd.
# Portal, polkit and xwayland setup comes from mango's own NixOS module.
{
  programs.mango.enable = true;

  programs.uwsm.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${pkgs.uwsm}/bin/uwsm start mango'";
      user = "greeter";
    };
  };
}
