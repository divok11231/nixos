{ ... }:

# kitty mirrors st (modules/st/config.h): JetBrainsMono at 13, the grey900
# background / grey200 foreground with Material-200 normal + A100 bright
# colors, teal200 cursor and selection, and 0.9 background opacity so
# mango's blur shows through like st's ALPHA_PATCH.
{
  flake.modules.homeManager.kitty = {
    programs.kitty = {
      enable = true;
      settings = {
        term = "xterm-256color";

        font_family = "JetBrainsMono Nerd Font";
        font_size = 13;

        # st draws its default background at alpha 0.9; dynamic so the
        # Ctrl+Shift+O/P bindings below can nudge it like st's changealpha.
        background_opacity = 0.9;
        dynamic_background_opacity = true;

        # st's cursor is a steady block.
        cursor_shape = "block";
        cursor_blink_interval = 0;

        background = "#212121"; # grey900
        foreground = "#eeeeee"; # grey200
        cursor = "#80cbc4"; # teal200, matches mango's focus border
        cursor_text_color = "#212121";
        selection_background = "#80cbc4"; # teal200
        selection_foreground = "#212121"; # grey900

        color0 = "#424242"; # grey800
        color1 = "#ef9a9a"; # red200
        color2 = "#a5d6a7"; # green200
        color3 = "#fff59d"; # yellow200
        color4 = "#90caf9"; # blue200
        color5 = "#ce93d8"; # purple200
        color6 = "#80cbc4"; # teal200
        color7 = "#eeeeee"; # grey200
        color8 = "#616161"; # grey700
        color9 = "#ff8a80"; # redA100
        color10 = "#b9f6ca"; # greenA100
        color11 = "#ffff8d"; # yellowA100
        color12 = "#82b1ff"; # blueA100
        color13 = "#ea80fc"; # purpleA100
        color14 = "#84ffff"; # cyanA100
        color15 = "#fafafa"; # grey50
      };
      keybindings = {
        # Same pair st uses for changealpha.
        "ctrl+shift+o" = "set_background_opacity +0.05";
        "ctrl+shift+p" = "set_background_opacity -0.05";
      };
    };
  };
}
