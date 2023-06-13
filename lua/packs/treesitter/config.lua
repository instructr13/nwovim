local M = {}

function M.treesitter()
  local augroup = vim.api.nvim_create_augroup("treesitter-fold", {})

  vim.api.nvim_create_autocmd(
    { "BufEnter", "BufAdd", "BufNew", "BufNewFile", "BufWinEnter" },
    {
      group = augroup,
      callback = function()
        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      end,
    }
  )

  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      -- We need this
      "lua",

      -- noice.nvim prerequisites (also lua is in them)
      "vim",
      "regex",
      "bash",
      "markdown",
      "markdown_inline",
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 2000,
    },
    indent = { enable = false },
    yati = { enable = true },
    endwise = {
      enable = true,
    },
    autotag = {
      enable = true,
    },
    matchup = { -- It is in lua/packs/editor
      enable = true,
    },
    --[[
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    textsubjects = {
      enable = true,
      keymaps = {
        ["."] = "textsubjects-smart",
        [";"] = "textsubjects-big",
      },
    },
    ]]
  })

  require("nvim-treesitter.install").prefer_git = true
end

return M
