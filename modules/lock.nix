{ ... }:

{
  flake.modules.nixos.lock = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      hyprlock
      hypridle
    ];
  };
}
