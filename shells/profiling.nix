{ pkgs-unstable }:

let
  cuda = pkgs-unstable.cudaPackages;
in
# backendStdenv picks a gcc that nvcc accepts
(pkgs-unstable.mkShell.override { stdenv = cuda.backendStdenv; }) {
  packages = [
    cuda.cuda_nvcc
    cuda.cuda_cudart
    cuda.nsight_compute   # ncu, ncu-ui
    cuda.nsight_systems   # nsys, nsys-ui
  ];

  shellHook = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
    export CUDA_PATH=${cuda.cuda_nvcc}
    # Nsight GUIs are Qt apps and misbehave on native Wayland (Hyprland)
    export QT_QPA_PLATFORM=xcb
    export QT_SCALE_FACTOR=''${NSIGHT_QT_SCALE:-1}
  '';
}
