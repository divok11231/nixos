{ ... }:

{
  wayland.windowManager.mango = {
    enable = true;
    settings = {
      monitor_rule = "name:^eDP-1$,width:2736,height:1824,refresh:59.959,x:0,y:0,scale:1.5";
      touch_enable = 1;
      touch_enable_mouse_emulation = 1;
      focus_on_activate=1;
      sloppy_focus= 1;
      bind = [
        "ALT,Return,spawn,foot"
        "ALT,Q,killclient"
        "SUPER,M,quit"

        # Applications
        "ALT,P,spawn,rofi -show drun"
        "ALT,N,spawn,thunar"
        "ALT+SHIFT,Return,spawn,foot"
        "ALT,W,spawn,firefox"
        "ALT,Z,spawn,firefox --private-window"

        # Focus windows
        "ALT,J,focusstack,next"
        "ALT,K,focusstack,prev"

        # Layouts
        "ALT,T,setlayout,[]="
        "ALT,F,setlayout,><>"
        "ALT,M,setlayout,[M]"
        "ALT+SHIFT,Space,togglefloating"

        # View workspaces 1–9
        "ALT,1,view,1"
        "ALT,2,view,2"
        "ALT,3,view,3"
        "ALT,4,view,4"
        "ALT,5,view,5"
        "ALT,6,view,6"
        "ALT,7,view,7"
        "ALT,8,view,8"
        "ALT,9,view,9"

        # Move windows to workspaces 1–9
        "ALT+SHIFT,1,tag,1"
        "ALT+SHIFT,2,tag,2"
        "ALT+SHIFT,3,tag,3"
        "ALT+SHIFT,4,tag,4"
        "ALT+SHIFT,5,tag,5"
        "ALT+SHIFT,6,tag,6"
        "ALT+SHIFT,7,tag,7"
        "ALT+SHIFT,8,tag,8"
        "ALT+SHIFT,9,tag,9"
      ];
    };
  };
}
