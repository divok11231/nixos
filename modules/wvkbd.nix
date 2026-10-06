{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wvkbd
  ];
}
