{ ... }:

{
  users.users.kovid = {
    initialPassword = "kovid123";
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };
}
