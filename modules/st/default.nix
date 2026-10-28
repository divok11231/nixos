{ ... }:

# The terminal mango binds. st-wl is suckless st ported to Wayland: it builds
# its own renderer (wld) in-tree, generates the xdg-shell/xdg-decoration/
# primary-selection protocol sources with wayland-scanner, and installs a
# terminfo entry that ncurses picks up from the system path.
{
  flake.modules.nixos.st =
    { pkgs, ... }:
    let
      st-wl = pkgs.stdenv.mkDerivation {
        pname = "st-wl";
        # Upstream is untagged; bump rev and this together.
        version = "0-unstable-2026-10-28";

        src = pkgs.fetchFromGitHub {
          owner = "marchaesen";
          repo = "st-wl";
          rev = "86505348b5ebf1532229e201e5d782b8ea92266c";
          hash = "sha256-6ooB/qJQkTIMwtZL4fENtXlxn25Z0I6TJMdwyJcJJcw=";
        };

        strictDeps = true;

        nativeBuildInputs = with pkgs; [
          ncurses # tic, compiles st.info
          pkg-config
          wayland-scanner
        ];

        # pkg-config only sees buildInputs once strictDeps is on, which is why
        # wayland-protocols (XML the scanner reads) lives here and not with the
        # tools. libX11 is here because imlib2's Imlib2.h includes Xlib.h.
        buildInputs = with pkgs; [
          fontconfig
          freetype
          imlib2 # sixel and kitty graphics
          libxkbcommon
          pixman
          wayland
          wayland-protocols
          libx11
          zlib # kitty graphics
        ];

        postPatch = ''
          # config.h is vendored: the palette, alpha, box-drawn glyphs and
          # shell live there. patches.h comes from upstream's list with the
          # patches we want on, and these substituteInPlace calls fail the
          # build if upstream rewords any of those lines -- which is the
          # point, a patch must never get dropped silently on a bump.
          cp ${./config.h} config.h
          cp patches.def.h patches.h

          # Scrollback and the wheel bindings that drive it: plain wheel and
          # Shift+PageUp/Down scroll the buffer on the normal screen, and
          # apps on the alternate screen (less, htop) get line-by-line ^Y/^E
          # unless they ask for mouse reporting.
          #
          # Two better options stay off:
          #  - REFLOW gives the same scrollback plus re-wrapping on resize,
          #    but it calls selremove(), defined nowhere in this fork, and its
          #    3-argument selscroll clashes with st.c's 2-argument one.
          #  - BOXDRAW only ever compiles the X11 renderer for it: wl.c keeps
          #    the ATTR_BOXDRAW bit but never draws it, so it would drag in
          #    libXft to change nothing. The Nerd Font's own box glyphs show.
          substituteInPlace patches.h \
            --replace-fail '#define SCROLLBACK_PATCH 0' '#define SCROLLBACK_PATCH 1' \
            --replace-fail '#define SCROLLBACK_MOUSE_PATCH 0' '#define SCROLLBACK_MOUSE_PATCH 1' \
            --replace-fail '#define SCROLLBACK_MOUSE_ALTSCREEN_PATCH 0' \
            '#define SCROLLBACK_MOUSE_ALTSCREEN_PATCH 1'

          # The shell in config.h is only a fallback for unset SHELL, but
          # point it at a real one instead of /usr/bin/zsh.
          substituteInPlace config.h \
            --replace-fail '"/usr/bin/zsh"' '"${pkgs.bashInteractive}/bin/bash"'

          # Make regenerates config.h/patches.h from their .def templates
          # whenever `options` is newer than them: the build touches options
          # first, then decides our freshly written files are stale. Create
          # options now and stamp ours after it, so the copies stick.
          touch options
          touch config.h patches.h
        '';

        # Refuse to install a terminal that silently lost the palette or the
        # patches -- this is exactly what the make rules above will do if the
        # touch ordering ever regresses.
        preInstall = ''
          grep -q '#define SCROLLBACK_PATCH 1' patches.h
          grep -q '#define SCROLLBACK_MOUSE_ALTSCREEN_PATCH 1' patches.h
          grep -q '#212121' config.h
          grep -q '#define DEFAULT_ALPHA 0.9' config.h

          export TERMINFO="$out/share/terminfo"
          mkdir -p "$TERMINFO"
        '';

        installPhase = ''
          runHook preInstall
          make install PREFIX="$out"
          runHook postInstall
        '';

        postInstall = ''
          # The desktop file hardcodes upstream's /usr/local prefix. No -A
          # here: config.h's DEFAULT_ALPHA is the one source for alpha.
          substituteInPlace "$out/share/applications/st-wl.desktop" \
            --replace-fail 'Exec=/usr/local/bin/st-wl -A .95' 'Exec=st-wl'

          # Upstream installs only st-wl; mango's binds and muscle memory
          # reach for st.
          ln -s st-wl "$out/bin/st"
        '';

        meta = {
          description = "Simple terminal emulator for Wayland, a port of suckless st";
          homepage = "https://github.com/marchaesen/st-wl";
          license = pkgs.lib.licenses.mit;
          mainProgram = "st-wl";
          platforms = pkgs.lib.platforms.linux;
        };
      };
    in
    {
      environment.systemPackages = [ st-wl ];
    };
}
