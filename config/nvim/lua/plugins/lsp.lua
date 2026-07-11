return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Configure fortls
        fortls = {
          -- 1. Tell the server to look for .cuf files
          clangd = {
            filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=never",
            },
          },
          settings = {
            fortls = {
              extra_suffixes = { ".cuf" },
            },
          },
        },
      },
      -- 2. Tell Neovim that .cuf files are actually "fortran" files
      setup = {
        fortls = function()
          vim.filetype.add({
            extension = {
              cuf = "fortran",
            },
          })
        end,
      },
    },
  },
}
