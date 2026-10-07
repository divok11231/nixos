{ pkgs-unstable }:

let
  cuda = pkgs-unstable.cudaPackages;
in
pkgs-unstable.mkShell {
  packages = [
    cuda.nsight_systems   # nsys, nsys-ui
    cuda.nsight_compute   # ncu, ncu-ui
  ];

  shellHook = ''
    export QT_QPA_PLATFORM=xcb
    export QT_SCALE_FACTOR=''${NSIGHT_QT_SCALE:-1}
    export QT_XCB_GL_INTEGRATION=none

  '';
}
