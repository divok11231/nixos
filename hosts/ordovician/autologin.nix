{ pkgs, ... }:
{
  services.greetd.settings.initial_session = {
    command = "${pkgs.uwsm}/bin/uwsm start mango";
    user = "kovid";
  };
}
