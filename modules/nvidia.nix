{ ... }:

# cambrian's hybrid amd/nvidia setup.
{
  flake.modules.nixos.nvidia = { config, ... }: {
    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      powerManagement.enable = false;
      # Powers the 3050 fully off when nothing is offloaded to it (needs
      # offload mode and a Turing-or-newer GPU).
      powerManagement.finegrained = true;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
}
