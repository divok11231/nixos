{ pkgs, ... }:
{
  services.greetd.settings.initial_session = {
    command = "${pkgs.uwsm}/bin/uwsm start hyprland-uwsm.desktop";
    user = "kovid";
  };
}
