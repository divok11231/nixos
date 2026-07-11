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
    nixfmt-rfc-style

    # Markdown
    markdownlint-cli2
    markdown-toc

    # Tree-sitter CLI
    tree-sitter
  ];

  xdg.configFile."nvim".source = ../config/nvim;
}
