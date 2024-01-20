return {
  {
    "lewis6991/gitsigns.nvim",

    version = "*",

    event = { "User GitFile" },

    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local presets = require("utils.keymap.presets")

        local leader_visual_keymap = presets.leader({ "n", "v" }, "g", {
          buffer = bufnr,
          silent = true,
        })

        local leader_keymap = presets.leader("n", "g", { buffer = bufnr })
        local keymap = presets.mode_only("n", { buffer = bufnr, expr = true })

        -- Navigation
        keymap("]c", function()
          if vim.wo.diff then
            return "]c"
          end

          vim.schedule(function()
            gs.next_hunk()
          end)

          return "<Ignore>"
        end, "Next Hunk")

        keymap("[c", function()
          if vim.wo.diff then
            return "[c"
          end

          vim.schedule(function()
            gs.prev_hunk()
          end)

          return "<Ignore>"
        end, "Previous Hunk")

        -- Actions
        leader_visual_keymap("s", function()
          vim.cmd("Gitsigns stage_hunk")
        end, "Stage Hunk")
        leader_visual_keymap("r", function()
          vim.cmd("Gitsigns reset_hunk")
        end, "Unstage Hunk")

        leader_keymap("S", gs.stage_buffer, "Stage Buffer")
        leader_keymap("u", gs.undo_stage_hunk, "Undo Stage Hunk")
        leader_keymap("R", gs.reset_buffer, "Unstage Buffer")
        leader_keymap("p", gs.preview_hunk, "Preview Hunk")
        leader_keymap("B", function()
          gs.blame_line({
            full = true,
          })
        end, "Blame Line")
        leader_keymap(
          "T",
          gs.toggle_current_line_blame,
          "Toggle Current Line Blame"
        )
        leader_keymap("d", gs.diffthis, "Diff This")
        leader_keymap("D", function()
          gs.diffthis("~")
        end, "Diff Current Buffer")
        leader_keymap("t", gs.toggle_deleted, "Toggle Deleted")

        -- Text object
        require("utils.keymap").keymap(
          { "o", "x" },
          "ih",
          function()
            vim.cmd("Gitsigns select_hunk")
          end,
          "Select Hunk",
          {
            silent = true,
          }
        )
      end,
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      diff_opts = {
        algorithm = "histogram",
        internal = true,
      },
      attach_to_untracked = true,
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        delay = 400,
      },
      preview_config = {
        border = "rounded",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },
  {
    "sindrets/diffview.nvim",

    cmd = { "DiffviewOpen" },
  },
  {
    "NeogitOrg/neogit",

    cmd = { "Neogit" },

    init = function()
      local keymap = require("utils.keymap").keymap

      keymap("n", "<leader>gg", "<cmd>Neogit<cr>", "Open Neogit")
    end,

    opts = {
      telescope_sorter = function()
        return nil
      end,

      integrations = {
        --telescope = true,
        diffview = true,
      },
    },
  },
}
