{ pkgs-unstable, ... }:

let
  system = pkgs-unstable.stdenv.hostPlatform.system;

  bun_1_3_13 = pkgs-unstable.bun.overrideAttrs (_old: rec {
    version = "1.3.13";

    src = pkgs-unstable.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-${
        {
          "x86_64-linux" = "linux-x64-baseline";
          "aarch64-linux" = "linux-aarch64";
          "aarch64-darwin" = "darwin-aarch64";
        }.${system}
      }.zip";

      hash = {
        "x86_64-linux" = "sha256-nYokKSpwaAkCBdqsCloiP19pc29Sh+N7+I07QDHtx1A=";
        "aarch64-linux" = "sha256-cLrkGzkIsKEg4eWMXIrzDnSvrjuNEbDT/djnh937SyI=";
        "aarch64-darwin" = "sha256-VGfj9l26Umuf6pjwzOBO+vwMY+Fpcz7Ce4dqOtMtoZA=";
      }.${system};
    };
  });
in
{
  environment.systemPackages = [
    (pkgs-unstable.opencode.override { bun = bun_1_3_13; })
  ];
}
