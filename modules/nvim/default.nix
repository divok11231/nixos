{ ... }:

# The Lua config is a directory of files, so it is deployed into the store like
# the quickshell tree. That means `:Lazy update` cannot write lazy-lock.json;
# bump plugin pins through this file instead.
{
  flake.modules.homeManager.nvim =
    { pkgs, ... }:
    {
      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };

      home.packages = with pkgs; [
        # Required by plugins
        ripgrep
        fd

        # LSPs
        lua-language-server
        nil
        clang-tools

        # Formatters
        stylua
        shfmt
        nixfmt

        # Markdown
        markdownlint-cli2
        markdown-toc

        # Tree-sitter CLI
        tree-sitter
      ];

      xdg.configFile."nvim".source = ./config;
    };
}
