{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cudaPackages.nsight_systems
  ];
}
