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
    context_commentstring = {
      enable = true,
    },
    --[[
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

function M.syntax_tree_surfer()
  require("syntax-tree-surfer").setup({
    disable_no_instance_found_report = true,
    default_desired_types = {
      "function",
      "arrow_function",
      "function_definition",
      "if_statement",
      "else_clause",
      "else_statement",
      "elseif_statement",
      "for_statement",
      "while_statement",
      "switch_statement",
    },
  })

  local keymap = require("utils.keymap").keymap

  local keymap_swap = require("utils.keymap").omit(
    "append",
    "n",
    "v",
    { silent = true, expr = true }
  )

  keymap("n", "<A-k>", function()
    vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"

    return "g@l"
  end, "Swap Up", { silent = true, expr = true })

  keymap("n", "<A-j>", function()
    vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"

    return "g@l"
  end, "Swap Down", { silent = true, expr = true })

  keymap_swap("d", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"

    return "g@l"
  end, "Swap current node next")

  keymap_swap("u", function()
    vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"

    return "g@l"
  end, "Swap current node previous")
end

function M.syntax_tree_surfer_setup()
  local keymap = require("utils.keymap").keymap

  keymap("n", "vx", function()
    require("syntax-tree-surfer").select()
  end)

  keymap("n", "vn", function()
    require("syntax-tree-surfer").select_current_node()
  end)

  keymap("x", "J", function()
    require("syntax-tree-surfer").surf("next", "visual")
  end)

  keymap("x", "K", function()
    require("syntax-tree-surfer").surf("prev", "visual")
  end)

  keymap("x", "H", function()
    require("syntax-tree-surfer").surf("parent", "visual")
  end)

  keymap("x", "L", function()
    require("syntax-tree-surfer").surf("child", "visual")
  end)

  keymap("x", "<A-j>", function()
    require("syntax-tree-surfer").surf("next", "visual", true)
  end)

  keymap("x", "<A-k>", function()
    require("syntax-tree-surfer").surf("prev", "visual", true)
  end)

  keymap("n", "<C-p>", function()
    require("syntax-tree-surfer").go_to_top_node_and_execute_commands(
      false,
      { "normal! O", "normal! O", "startinsert" }
    )
  end)

  keymap("n", "<A-n>", function()
    require("syntax-tree-surfer").filtered_jump("default", true)
  end)

  keymap("n", "<A-p>", function()
    require("syntax-tree-surfer").filtered_jump("default", false)
  end)

  keymap("n", "gnh", "<cmd>STSSwapOrHold<cr>")
  keymap("x", "gnh", "<cmd>STSSwapOrHoldVisual<cr>")
end

return M
