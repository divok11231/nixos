{ ... }:

# Touchscreen gestures: squeekboard on-screen keyboard, and three-finger
# sideways swipes between workspaces (content follows the fingers), and a
# swipe down from the top edge for the app launcher.
{
  flake.modules.homeManager.gestures =
    { pkgs, config, ... }:
    let
      bin = "${config.home.profileDirectory}/bin";
    in
    {
      systemd.user.services.lisgd = {
        Unit = {
          Description = "Surface touchscreen gestures";
          After = [
            "graphical-session.target"
            "squeekboard.service"
          ];
          PartOf = [ "graphical-session.target" ];
          # lisgd dies if the IPTSD virtual touchscreen isn't there yet, and
          # iptsd itself can take a few seconds to win its boot-time race.
          # Keep retrying instead of tripping the default 5-in-10s limit.
          StartLimitIntervalSec = 120;
          StartLimitBurst = 30;
        };

        Service = {
          ExecStart = ''
            ${pkgs.lisgd}/bin/lisgd -v \
              -d /dev/input/ipts-touchscreen \
              -m 1500 -t 100 \
              -g "1,DU,B,*,R,${bin}/osk-show" \
              -g "2,UD,*,*,R,${bin}/osk-hide" \
              -g "3,RL,*,*,R,${bin}/mmsg dispatch viewtoright" \
              -g "3,LR,*,*,R,${bin}/mmsg dispatch viewtoleft" \
              -g "1,UD,T,*,R,${pkgs.quickshell}/bin/qs ipc call launcher toggle"
          '';
          Restart = "on-failure";
          RestartSec = "2s";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
