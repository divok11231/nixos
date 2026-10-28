{ ... }:

# System-wide tooling. GUI applications live in the apps feature; the binaries
# the quickshell service shells out to live with the quickshell feature.
{
  flake.modules.nixos.tooling = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wireguard-tools

      # Terminal (mango's bind target and greetd's fallback)
      foot

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
    ];
  };
}
