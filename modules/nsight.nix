{ inputs, ... }:

let
  unstableFor =
    system:
    import inputs.nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        allowBroken = true;
      };
    };

  nsightViewer =
    pkgs-unstable:
    let
      cuda = pkgs-unstable.cudaPackages;
    in
    pkgs-unstable.mkShell {
      packages = [
        cuda.nsight_systems # nsys, nsys-ui
        cuda.nsight_compute # ncu, ncu-ui
      ];

      shellHook = ''
        export QT_QPA_PLATFORM=xcb
        export QT_SCALE_FACTOR=''${NSIGHT_QT_SCALE:-1}
        export QT_XCB_GL_INTEGRATION=none

      '';
    };

  profiling =
    pkgs-unstable:
    let
      cuda = pkgs-unstable.cudaPackages;
    in
    # backendStdenv picks a gcc that nvcc accepts
    (pkgs-unstable.mkShell.override { stdenv = cuda.backendStdenv; }) {
      packages = [
        cuda.cuda_nvcc
        cuda.cuda_cudart
        cuda.nsight_compute # ncu, ncu-ui
        cuda.nsight_systems # nsys, nsys-ui
      ];

      shellHook = ''
        export LD_LIBRARY_PATH=/run/opengl-driver/lib:$LD_LIBRARY_PATH
        export CUDA_PATH=${cuda.cuda_nvcc}
        # Nsight GUIs are Qt apps and misbehave on native Wayland (Hyprland)
        export QT_QPA_PLATFORM=xcb
        export QT_SCALE_FACTOR=''${NSIGHT_QT_SCALE:-1}
      '';
    };
in
{
  # Only cambrian runs this feature; ordovician leaves it out of its list.
  flake.modules.homeManager.nsight = { pkgs, ... }: {
    home.packages = [ pkgs.cudaPackages.nsight_systems ];
  };

  perSystem =
    { system, ... }:
    let
      pkgs-unstable = unstableFor system;
    in
    {
      devShells.profiling = profiling pkgs-unstable;
      devShells.nsight-viewer = nsightViewer pkgs-unstable;
    };
}
