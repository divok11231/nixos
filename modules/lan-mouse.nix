{ ... }:

# One keyboard and mouse across cambrian and ordovician: push the pointer off
# the shared edge and input follows to the other host. lan-mouse 0.10 sends
# input in plaintext, so it only listens on tailscale (which encrypts).
# Left Ctrl+Shift+Super+Alt pulls the pointer back.
let
  port = 4242;

  # Each host's neighbour, and which edge of this host's screen leads there.
  peers = {
    cambrian = {
      side = "right";
      hostname = "ordovician";
      ip = "100.95.213.61";
    };
    ordovician = {
      side = "left";
      hostname = "cambrian";
      ip = "100.95.138.27";
    };
  };
in
{
  flake.modules.nixos.lan-mouse = {
    networking.firewall.interfaces.tailscale0.allowedUDPPorts = [ port ];
  };

  flake.modules.homeManager.lan-mouse =
    { pkgs, osConfig, ... }:
    let
      peer = peers.${osConfig.networking.hostName};
    in
    {
      home.packages = [ pkgs.lan-mouse ];

      xdg.configFile."lan-mouse/config.toml".source = (pkgs.formats.toml { }).generate "lan-mouse.toml" {
        inherit port;
        ${peer.side} = {
          inherit (peer) hostname;
          inherit port;
          ips = [ peer.ip ];
          activate_on_startup = true;
        };
      };

      systemd.user.services.lan-mouse = {
        Unit = {
          Description = "lan-mouse keyboard and mouse sharing";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse --daemon";
          Restart = "on-failure";
          RestartSec = "2s";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
