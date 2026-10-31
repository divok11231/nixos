{ ... }:

# System-wide tooling. GUI applications live in the apps feature; the binaries
# the quickshell service shells out to live with the quickshell feature.
{
  flake.modules.nixos.tooling =
    { config, pkgs, ... }:
    {
      environment.systemPackages =
        with pkgs;
        [
          wireguard-tools

          # Monitoring
          htop
          btop
          fastfetch
          tree
          killall

          # Wayland session utilities
          grim
          slurp
          wl-clipboard
          cliphist

          # Editor
          vim

          # Dev
          gh
          bun
          cmake
          ninja
          gnumake
          pkg-config
          clang
          gcc
          git
          nodejs
          python3
          sshuttle
          lazygit

          # Network / files
          wget
          curl
        ]
        # claude-code rides the unstable channel: nixos-26.05 pins 2.1.223,
        # too old.
        ++ [ config.pkgs-unstable.claude-code ];
    };
}
