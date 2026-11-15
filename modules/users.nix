{ ... }:

{
  flake.modules.nixos.users = {
    users.users.kovid = {
      initialPassword = "kovid123";
      isNormalUser = true;
      # Every key allowed to log in. host-base turns off ~/.ssh/authorized_keys,
      # so a key missing here is locked out.
      openssh.authorizedKeys.keys = [
        # ordovician
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILKED9aeWNGLsGBz/n0JLMyY6DeUTdQTsApDuTgdMmoA kovid.l@hyderabad.bits-pilani.ac.in"
        # cambrian
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDR8nWJYWz5j1fNeWl2VSJUfcxCtdnjDRMGDII97aHde lkovid@gmail.com"
        # unlabelled; was in cambrian's ~/.ssh/authorized_keys since 2026-11-01
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGHtz+lQIU1Xlr47AGWNUh77CixatxRm5C++V42ah6UK"
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
