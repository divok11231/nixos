{ pkgs, config, ... }:

let
  bin = "${config.home.profileDirectory}/bin";
in
{
  systemd.user.services.lisgd = {
    Unit = {
      Description = "Surface touchscreen gestures";
      After = [ "graphical-session.target" "squeekboard.service" ];
      PartOf = [ "graphical-session.target" ];
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
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
