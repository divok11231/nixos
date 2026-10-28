{ inputs, ... }:

# The session every host runs: mango, wrapped in uwsm, offered by greetd so the
# session gets a proper systemd user instance. Portals, polkit and xwayland
# come from mango's own NixOS module, imported right here with the feature.
{
  flake.modules.nixos.mango =
    { pkgs, ... }:
    {
      imports = [ inputs.mango.nixosModules.mango ];

      programs.mango.enable = true;

      programs.uwsm.enable = true;

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd '${pkgs.uwsm}/bin/uwsm start mango'";
          user = "greeter";
        };
      };
    };

  flake.modules.homeManager.mango = { ... }: {
    imports = [ inputs.mango.hmModules.mango ];

    wayland.windowManager.mango = {
      enable = true;
      settings = {

        exec = [ "swaybg -i /home/kovid/.config/hypr/sushi-dark.png -m fill" ];

        # Window effects
        blur = 1;
        blur_layer = 1;
        blur_optimized = 0;
        blur_params_num_passes = 4;
        blur_params_radius = 8;
        blur_params_noise = 0.02;
        blur_params_brightness = 0.9;
        blur_params_contrast = 0.9;
        blur_params_saturation = 1.2;

        shadows = 0;
        layer_shadows = 0;
        shadow_only_floating = 1;
        shadows_size = 10;
        shadows_blur = 15;
        shadows_position_x = 0;
        shadows_position_y = 0;
        shadows_color = "0x000000ff";

        border_radius = 8;
        no_radius_when_single = 0;
        no_border_when_single = 0;
        focused_opacity = 1.0;
        unfocused_opacity = 1.0;

        # Animations
        animations = 1;
        layer_animations = 1;
        animation_type_open = "slide";
        animation_type_close = "slide";
        animation_fade_in = 1;
        animation_fade_out = 1;
        tag_animation_direction = 1;
        zoom_initial_ratio = 0.3;
        zoom_end_ratio = 0.8;
        fade_in_begin_opacity = 0.5;
        fade_out_begin_opacity = 0.8;
        animation_duration_move = 500;
        animation_duration_open = 400;
        animation_duration_tag = 350;
        animation_duration_close = 400;
        animation_duration_focus = 0;

        # Gaps and colors
        gap_inner_horizontal = 8;
        gap_inner_vertical = 8;
        gap_outer_horizontal = 10;
        gap_outer_vertical = 10;
        border_px = 4;
        root_color = "0x201b14ff";
        border_color = "0x37474fff";
        focus_color = "0x80cbc4ff";
        maximized_screen_color = "0x89aa61ff";
        scratchpad_color = "0x516c93ff";
        global_color = "0xb153a7ff";
        overlay_color = "0x14a57cff";
        split_color = "0x80cbc4ff";
        drop_color = "0x37474fff";
        # Scroller
        scroller_structs = 20;
        scroller_default_proportion = 0.8;
        scroller_focus_center = 0;
        scroller_prefer_center = 0;
        edge_scroller_pointer_focus = 1;
        scroller_default_proportion_single = 1.0;
        scroller_proportion_preset = "0.5,0.8,1.0";

        # Master-stack
        new_is_master = 1;
        default_master_factor = 0.5;
        default_master_count = 1;
        smart_gaps = 0;

        # Dwindle
        dwindle_smart_split = 1;
        dwindle_manual_split = 1;
        dwindle_drop_simple_split = 0;

        # Overview
        hotarea_size = 10;
        enable_hotarea = 1;
        hotarea_corner = 2;
        overview_gap_inner = 5;
        overview_gap_outer = 30;

        # Focus and window behavior
        focus_on_activate = 1;
        idle_inhibit_ignore_visible = 0;
        focus_cross_monitor = 0;
        focus_cross_tag = 0;
        enable_floating_snap = 0;
        snap_distance = 30;
        drag_tile_to_tile = 1;
        tag_carousel = 1;
        monitor_rule = "name:^eDP-1$,width:2736,height:1824,refresh:59.959,x:0,y:0,scale:1.75";
        touch_enable = 1;
        touch_enable_mouse_emulation = 1;
        sloppy_focus = 1;
        bind = [
          "ALT,Return,spawn,st"
          "ALT,Q,killclient"
          "ALT+SHIFT,Q,quit"
          "ALT+SHIFT,F,togglefullscreen"
          # Applications
          "ALT,P,spawn_shell,qs ipc call launcher toggle"
          "ALT,V,spawn_shell,qs ipc call launcher openClipboard"
          "ALT,S,spawn_shell,grim -g \"$(slurp)\" - | wl-copy"
          "ALT,N,spawn,nautilus"
          "ALT+SHIFT,Return,spawn,st"
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
  };
}
