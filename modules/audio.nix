{ ... }:

{
  flake.modules.nixos.audio = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
      jack.enable = true;
    };
  };

  flake.modules.homeManager.audio = { pkgs, ... }: {
    home.packages = with pkgs; [
      # DAW
      reaper
      # routing and control
      pavucontrol
      # pipewire patchbay
      qpwgraph
      # because I'm lazy and want to link things by path
      neural-amp-modeler-lv2
      alsa-utils
      pipewire.jack
      guitarix
    ];
  };
}
