{ ... }:

{
  flake.modules.nixos.users = {
    users.users.kovid = {
      initialPassword = "kovid123";
      isNormalUser = true;
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
