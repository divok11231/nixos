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
          # Take upstream's config and enable the patches we want. These
          # substituteInPlace calls fail the build if upstream rewords any of
          # the lines, which is the point: a patch must never get dropped
          # silently on a bump.
          cp config.def.h config.h
          cp patches.def.h patches.h

          # Box-drawing is compiled in but stays inert until these say
          # otherwise; reflow brings scrollback with it.
          substituteInPlace patches.h \
            --replace-fail '#define BOXDRAW_PATCH 0' '#define BOXDRAW_PATCH 1' \
            --replace-fail '#define REFLOW_PATCH 0' '#define REFLOW_PATCH 1'

          substituteInPlace config.h \
            --replace-fail 'const int boxdraw = 0;' 'const int boxdraw = 1;' \
            --replace-fail 'const int boxdraw_bold = 0;' 'const int boxdraw_bold = 1;' \
            --replace-fail 'const int boxdraw_braille = 0;' 'const int boxdraw_braille = 1;'

          # The shell in config.h is only a fallback for unset SHELL, but
          # point it at a real one instead of /usr/bin/zsh.
          substituteInPlace config.h \
            --replace-fail '"/usr/bin/zsh"' '"${pkgs.bashInteractive}/bin/bash"'

          # Stop make from copying the defaults over what we just wrote.
          touch config.h patches.h
        '';

        # The install target runs `tic -sx st.info`, which honours TERMINFO.
        preInstall = ''
          export TERMINFO="$out/share/terminfo"
          mkdir -p "$TERMINFO"
        '';

        installPhase = ''
          runHook preInstall
          make install PREFIX="$out"
          runHook postInstall
        '';

        postInstall = ''
          # The desktop file hardcodes upstream's /usr/local prefix.
          substituteInPlace "$out/share/applications/st-wl.desktop" \
            --replace-fail 'Exec=/usr/local/bin/st-wl -A .95' 'Exec=st-wl -A .95'

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
