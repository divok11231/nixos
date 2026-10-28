return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local function word_stats()
      local wc = vim.fn.wordcount()

      local total_words = wc.words or 0
      local total_chars = wc.chars or 0

      if wc.visual_words then
        local sel_words = wc.visual_words
        local sel_chars = wc.visual_chars
        return string.format("%dw %dc (sel) | %dw total", sel_words, sel_chars, total_words)
      end

      return string.format("%dw %dc", total_words, total_chars)
    end

    table.insert(opts.sections.lualine_x, word_stats)

    return opts
  end,
}
