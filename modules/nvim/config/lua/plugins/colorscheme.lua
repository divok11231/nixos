return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      ----------------------------------------------------------------
      -- Theme
      ----------------------------------------------------------------
      style = "storm", -- storm | moon | night | day
      light_style = "day",

      transparent = false,
      terminal_colors = true,

      ----------------------------------------------------------------
      -- Background
      ----------------------------------------------------------------
      dim_inactive = false,
      lualine_bold = true,

      ----------------------------------------------------------------
      -- Styles
      ----------------------------------------------------------------
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},

        sidebars = "dark",      -- dark | transparent | normal
        floats = "dark",        -- dark | transparent | normal
      },

      ----------------------------------------------------------------
      -- Sidebar windows
      ----------------------------------------------------------------
      sidebars = {
        "qf",
        "help",
        "terminal",
        "neo-tree",
        "Trouble",
        "lazy",
      },

      ----------------------------------------------------------------
      -- Plugin integration
      ----------------------------------------------------------------
      plugins = {
        auto = true,
      },

      ----------------------------------------------------------------
      -- Palette overrides
      ----------------------------------------------------------------
      on_colors = function(colors)
        -- Example:
        -- colors.bg = "#1a1b26"
        -- colors.bg_dark = "#16161e"
        -- colors.comment = "#7a88cf"
      end,

      ----------------------------------------------------------------
      -- Highlight overrides
      ----------------------------------------------------------------
      on_highlights = function(hl, c)
        hl.CursorLineNr = {
          fg = c.orange,
          bold = true,
        }

        hl.LineNr = {
          fg = c.dark5,
        }

        hl.Visual = {
          bg = c.bg_highlight,
        }

        hl.FloatBorder = {
          fg = c.blue,
          bg = c.bg_dark,
        }

        hl.NormalFloat = {
          bg = c.bg_dark,
        }

        hl.WinSeparator = {
          fg = c.blue0,
        }

        hl.Pmenu = {
          bg = c.bg_dark,
        }

        hl.PmenuSel = {
          bg = c.bg_highlight,
        }

        hl.Search = {
          bg = c.orange,
          fg = c.bg,
        }

        hl.IncSearch = {
          bg = c.red,
          fg = c.bg,
        }

        hl.SignColumn = {
          bg = "NONE",
        }

        hl.EndOfBuffer = {
          fg = c.bg,
        }
      },
    },

    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}
