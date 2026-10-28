{ ... }:

# Touchscreen gestures, driving the squeekboard on-screen keyboard.
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
              -g "1,DU,N,*,R,${bin}/osk-hide"
          '';
          Restart = "on-failure";
          RestartSec = "2s";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
