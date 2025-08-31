{ ... }:

{
  flake.modules.nixos.users = {
    users.users.kovid = {
      initialPassword = "kovid123";
      isNormalUser = true;
      # ordovician's key, so the hosts can reach each other over tailscale.
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKED9aeWNGLsGBz/n0JLMyY6DeUTdQTsApDuTgdMmoA kovid.l@hyderabad.bits-pilani.ac.in"
      ];
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "seat"
        "input"
      ];
    };
  };

  flake.modules.homeManager.users = {
    home.username = "kovid";
    home.homeDirectory = "/home/kovid";

    # Don't change after the first install.
    home.stateVersion = "26.05";

    programs.home-manager.enable = true;
  };
}
