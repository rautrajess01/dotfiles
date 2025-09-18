-- =============================================================================
-- ===  AUTCOMPLETION & UTILITIES (lazy.nvim format)                        ===
-- =============================================================================
--
--  NOTE: For icons to display correctly, you must install a Nerd Font
--        (e.g., FiraCode Nerd Font, JetBrainsMono Nerd Font) and configure
--        your terminal to use it.
--
-- =============================================================================

return {
  -- 🧠 Autocompletion Engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      -- Snippet engine & its source for nvim-cmp
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",

      -- Adds LSP completion capabilities
      "hrsh7th/cmp-nvim-lsp",

      -- Adds other completion sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",

      -- AI completion
      "Exafunction/codeium.nvim",

      -- Adds icons
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- loads vscode style snippets from installed plugins (e.g., friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      cmp.setup({
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(), -- Previous item
          ["<C-j>"] = cmp.mapping.select_next_item(), -- Next item
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),

        -- Order of sources matters!
        sources = cmp.config.sources({
          { name = "nvim_lsp" },   -- Contextual suggestions from your language server
          { name = "codeium" },    -- AI suggestions
          { name = "luasnip" },    -- Snippets
          { name = "buffer" },     -- Suggestions from text in your open files
          { name = "path" },       -- File system paths
        }),

        -- This is the section that adds icons and removes the tilde '~'
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text", -- show symbol and text
            maxwidth = 50,
            ellipsis_char = "...",
            -- This function removes the `~` from the menu details
            before = function(entry, vim_item)
              if entry.source.name == "nvim_lsp" and vim_item.menu then
                vim_item.menu = vim_item.menu:gsub("~", "")
              end
              return vim_item
            end,
          }),
        },
      })

      -- Setup nvim-autopairs integration
      local has_autopairs, npairs = pcall(require, "nvim-autopairs")
      if has_autopairs then
        cmp.event:on(
          "confirm_done",
          require("nvim-autopairs.completion.cmp").on_confirm_done()
        )
      end
    end,
  },

  -- ✂️ Snippet engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
  },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- 🌐 LSP support for cmp and other sources
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- 🔥 Codeium AI Completion
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({})
    end,
  },

  -- ⚡ Auto pairs for brackets, quotes, etc.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- 🎨 LSP icons in cmp menu
  { "onsails/lspkind.nvim" },
}
