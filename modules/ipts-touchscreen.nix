{ ... }:

{
  services.udev.extraRules = ''
    SUBSYSTEM=="input", KERNEL=="event*", ATTRS{name}=="IPTSD Virtual Touchscreen 045E:099F", SYMLINK+="input/ipts-touchscreen", GROUP="input", MODE="0660"
  '';

  users.users.kovid.extraGroups = [ "input" ];
}
