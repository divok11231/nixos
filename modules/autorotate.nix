{ ... }:

# Follow the accelerometer: rotate the built-in panel when the tablet is
# turned. Touch input is mapped to the output, so it rotates with it; layer
# shells (bar, squeekboard) re-lay themselves out on the new size.
{
  flake.modules.homeManager.autorotate =
    { pkgs, ... }:
    let
      autorotate = pkgs.writeShellScript "autorotate" ''
        current=""
        ${pkgs.iio-sensor-proxy}/bin/monitor-sensor --accel | while read -r line; do
          # "Has accelerometer (orientation: normal, ...)" at start, then
          # "Accelerometer orientation changed: left-up" on every turn.
          case "$line" in
            *"orientation: normal"* | *"changed: normal") t=normal ;;
            *"orientation: bottom-up"* | *"changed: bottom-up") t=180 ;;
            *"orientation: left-up"* | *"changed: left-up") t=90 ;;
            *"orientation: right-up"* | *"changed: right-up") t=270 ;;
            *) continue ;;
          esac
          [ "$t" = "$current" ] && continue
          current=$t

          ${pkgs.wlr-randr}/bin/wlr-randr --output eDP-1 --transform "$t"
          # lisgd reads the output transform once at startup to reorient its
          # swipe directions and edges.
          ${pkgs.systemd}/bin/systemctl --user try-restart lisgd.service
        done
      '';
    in
    {
      systemd.user.services.autorotate = {
        Unit = {
          Description = "Rotate the screen to match the accelerometer";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          ExecStart = "${autorotate}";
          Restart = "on-failure";
          RestartSec = "2s";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
}
