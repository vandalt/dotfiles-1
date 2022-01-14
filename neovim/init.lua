-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.cmd [[
  augroup Packer
    autocmd!
    autocmd BufWritePost init.lua PackerCompile
  augroup end
]]

local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Package manager
  use 'tpope/vim-fugitive' -- Git commands in nvim
  use 'tpope/vim-rhubarb' -- Fugitive-companion to interact with github
  use 'tpope/vim-commentary' -- "gc" to comment visual regions/lines
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'justinmk/vim-dirvish'
  use 'christoomey/vim-tmux-navigator'
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  -- use 'joshdick/onedark.vim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'arkav/lualine-lsp-progress' -- Integration with progress notifications
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
  use '/home/michael/Repositories/neovim_development/onedark.nvim'
  -- use '/home/michael/Repositories/neovim_development/nvim-lspconfig-worktrees/nvim-lspconfig'
  use 'bfredl/nvim-luadev'
  use 'kristijanhusak/orgmode.nvim'
  use 'mhartington/formatter.nvim'
  use 'ziglang/zig.vim'
end)

--Set highlight on search
vim.o.hlsearch = false

--Make line numbers default
vim.wo.number = true

--Enable mouse mode
vim.o.mouse = 'a'

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

--Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

--Set colorscheme (order is important here)
vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 1
vim.cmd [[colorscheme onedark]]

-- Set completeopt
vim.o.completeopt = 'menuone,noinsert'

--Use filetype.lua
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

--Add spellchecking
vim.cmd [[ autocmd FileType gitcommit setlocal spell ]]
vim.cmd [[ autocmd FileType markdown setlocal spell ]]

local onedark = require('lualine.themes.onedark')
for _, mode in pairs(onedark) do
  mode.a.gui = nil
end

--Set statusbar
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = onedark,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'filename' },
    lualine_c = { 'lsp_progress' },
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
}

--Fire, walk with me
vim.opt.guifont = 'Monaco:h18'
vim.g.firenvim_config = { localSettings = { ['.*'] = { takeover = 'never' } } }

--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.api.nvim_set_keymap('n', 'k', "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap('n', 'j', "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

--Add move line shortcuts
vim.api.nvim_set_keymap('n', '<A-j>', ':m .+1<CR>==', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':m .-2<CR>==', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<Esc>:m .+1<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<Esc>:m .-2<CR>==gi', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-j>', ":m '>+1<CR>gv=gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<A-k>', ":m '<-2<CR>gv=gv", { noremap = true })

--Remap escape to leave terminal mode
vim.api.nvim_set_keymap('t', '<Esc>', [[<c-\><c-n>]], { noremap = true })

--Disable numbers in terminal mode
vim.cmd [[
  augroup Terminal
    autocmd!
    au TermOpen * set nonu
  augroup end
]]

--Add map to enter paste mode
vim.o.pastetoggle = '<F3>'

require("indent_blankline").setup {
  char = '┊',
  filetype_exclude = { 'help', 'packer' },
  buftype_exclude = { 'terminal', 'nofile' },
  show_trailing_blankline_indent = false,
}

-- Toggle to disable mouse mode and indentlines for easier paste
ToggleMouse = function()
  if vim.o.mouse == 'a' then
    vim.cmd [[IndentBlanklineDisable]]
    vim.wo.signcolumn = 'no'
    vim.o.mouse = 'v'
    vim.wo.number = false
    print 'Mouse disabled'
  else
    vim.cmd [[IndentBlanklineEnable]]
    vim.wo.signcolumn = 'yes'
    vim.o.mouse = 'a'
    vim.wo.number = true
    print 'Mouse enabled'
  end
end

vim.api.nvim_set_keymap('n', '<leader>bm', '<cmd>lua ToggleMouse()<cr>', { noremap = true })

--Start interactive EasyAlign in visual mode (e.g. vipga)
-- Note this overwrites a useful ascii print thing
-- vim.api.nvim_set_keymap('x', 'ga', '<Plug>(EasyAlign)', {})

--Start interactive EasyAlign for a motion/text object (e.g. gaip)
-- vim.api.nvim_set_keymap('n', 'ga', '<Plug>(EasyAlign)', {})

--Add neovim remote for vimtex
-- vim.g.vimtex_compiler_progname = 'nvr'
-- vim.g.tex_flavor = 'latex'

-- Gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Telescope
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    fzf = {
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
require('telescope').load_extension 'fzf'

--Add leader shortcuts
function TelescopeFiles()
  local opts = { previewer = false }
  local ok = pcall(require"telescope.builtin".git_files, opts)
  if not ok then require"telescope.builtin".find_files(opts) end
end

vim.api.nvim_set_keymap('n', '<leader>f', [[<cmd>lua TelescopeFiles()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap( 'n', '<leader><space>', [[<cmd>lua require('telescope.builtin').buffers({sort_lastused = true})<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sb', [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>st', [[<cmd>lua require('telescope.builtin').tags()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>?', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sd', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>sp', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>so', [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gc', [[<cmd>lua require('telescope.builtin').git_commits()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gb', [[<cmd>lua require('telescope.builtin').git_branches()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gs', [[<cmd>lua require('telescope.builtin').git_status()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua require('telescope.builtin').git_bcommits()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wo', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>]], { noremap = true, silent = true })

-- Fugitive shortcuts
vim.api.nvim_set_keymap('n', '<leader>ga', ':Git add %:p<CR><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gg', ':GBrowse<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gd', ':Gdiff<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ge', ':Gedit<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gr', ':Gread<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gw', ':Gwrite<CR><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gl', ':silent! Glog<CR>:bot copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>gm', ':Gmove<Space>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>go', ':Git checkout<Space>', { noremap = true, silent = true })

-- alternative shorcuts without fzf
vim.api.nvim_set_keymap('n', '<leader>,', ':buffer *', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':e<space>**/', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sT', ':tjump *', { noremap = true })

-- Managing quickfix list
vim.api.nvim_set_keymap('n', '<leader>qo', ':copen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>qq', ':cclose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Qo', ':lopen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Qq', ':lclose<CR>', { noremap = true, silent = true })
vim.cmd [[autocmd FileType qf nnoremap <buffer> q :lclose <bar> cclose <CR> ]]

-- Get rid of annoying ex keybind
vim.api.nvim_set_keymap('', 'Q', '<Nop>', { noremap = true, silent = true })

-- Managing buffers
vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<CR>', { noremap = true, silent = true })

-- Random
vim.api.nvim_set_keymap('n', '<leader>;', ':', { noremap = true, silent = false })

-- LSP management
vim.api.nvim_set_keymap('n', '<leader>lr', ':LspRestart<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>li', ':LspInfo<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ls', ':LspStart<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>lt', ':LspStop<CR>', { noremap = true, silent = true })

-- Neovim management
vim.api.nvim_set_keymap('n', '<leader>nu', ':PackerUpdate<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>nc', ':e $HOME/Repositories/nix/nix-dotfiles/home-manager/configs/neovim/init.lua<CR>', { noremap = true, silent = true })

-- remove conceal on markdown files
vim.g.markdown_syntax_conceal = 0

-- Configure vim slime to use tmux
-- vim.g.slime_target = "tmux"
-- vim.g.slime_python_ipython = 1
-- vim.g.slime_dont_ask_default = 1
-- vim.g.slime_default_config = {socket_name = "default", target_pane = "{right-of}"}

-- Change preview window location
vim.g.splitbelow = true

-- Remap number increment to alt
vim.api.nvim_set_keymap('n', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-a>', '<C-a>', { noremap = true })
vim.api.nvim_set_keymap('n', '<A-x>', '<C-x>', { noremap = true })
vim.api.nvim_set_keymap('v', '<A-x>', '<C-x>', { noremap = true })

-- n always goes forward
vim.api.nvim_set_keymap('n', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'n', "'Nn'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('n', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('x', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })
vim.api.nvim_set_keymap('o', 'N', "'nN'[v:searchforward]", { noremap = true, expr = true })

-- map :W to :w (helps which-key issue)
vim.cmd [[ command! W  execute ':w' ]]

-- Neovim python support
vim.g.loaded_python_provider = 0

-- Highlight on yank
vim.cmd  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Clear white space on empty lines and end of line
vim.api.nvim_set_keymap('n', '<F6>', [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]], { noremap = true, silent = true })

-- Nerdtree like sidepanel
-- absolute width of netrw window
vim.g.netrw_winsize = -28

-- do not display info on the top of window
vim.g.netrw_banner = 0

-- sort is affecting only: directories on the top, files below
-- vim.g.netrw_sort_sequence = '[\/]$,*'

-- variable for use by ToggleNetrw function
vim.g.NetrwIsOpen = 0

-- Lexplore toggle function
ToggleNetrw = function()
  if vim.g.NetrwIsOpen == 1 then
    local i = vim.api.nvim_get_current_buf()
    while i >= 1 do
      if vim.bo.filetype == 'netrw' then
        vim.cmd([[ silent exe "bwipeout " . ]] .. i)
      end
      i = i - 1
    end
    vim.g.NetrwIsOpen = 0
    vim.g.netrw_liststyle = 0
    vim.g.netrw_chgwin = -1
  else
    vim.g.NetrwIsOpen = 1
    vim.g.netrw_liststyle = 3
    vim.cmd [[silent Lexplore]]
  end
end

vim.api.nvim_set_keymap('n', '<leader>wt', ':lua ToggleNetrw()<cr><paste>', { noremap = true, silent = true })

-- Function to open preview of file under netrw
vim.cmd [[
  augroup Netrw
    autocmd!
    autocmd filetype netrw nmap <leader>; <cr>:wincmd W<cr>
  augroup end
]]

-- directory managmeent, including autochdir
-- vim.cmd[[nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>]]

-- vim.api.nvim_exec([[
--   augroup BufferCD
--     autocmd!
--     autocmd BufEnter * silent! Glcd
--   augroup end
-- ]], false)

vim.cmd [[
  augroup nvim-luadev
    autocmd!
    function! SetLuaDevOptions()
      nmap <buffer> <C-c><C-c> <Plug>(Luadev-RunLine)
      vmap <buffer> <C-c><C-c> <Plug>(Luadev-Run)
      nmap <buffer> <C-c><C-k> <Plug>(Luadev-RunWord)
      map  <buffer> <C-x><C-p> <Plug>(Luadev-Complete)
      set filetype=lua
    endfunction
    autocmd BufEnter \[nvim-lua\] call SetLuaDevOptions()
  augroup end
]]

-- Diagnostic settings
vim.diagnostic.config {
  virtual_text = true,
  signs = true,
  update_in_insert = true,
}

-- LSP settings
-- log file location: $HOME/.cache/nvim/lsp.log
-- vim.lsp.set_log_level("debug")
require('vim.lsp.log').set_format_func(vim.inspect)

-- Add nvim-lspconfig plugin
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>Q', '<cmd>lua vim.diagnostic.setqflist()<CR>', opts)

  -- FormatRange = function()
  --   local start_pos = vim.api.nvim_buf_get_mark(0, '<')
  --   local end_pos = vim.api.nvim_buf_get_mark(0, '>')
  --   vim.lsp.buf.range_formatting({}, start_pos, end_pos)
  -- end

  -- vim.cmd [[
  --   command! -range FormatRange  execute 'lua FormatRange()'
  -- ]]

  -- vim.cmd [[
  --   command! Format execute 'lua vim.lsp.buf.formatting()'
  -- ]]
end

local handlers = {
  ['textDocument/hover'] = function(...)
    local buf = vim.lsp.handlers.hover(...)
    if buf then
      vim.api.nvim_buf_set_keymap(buf, 'n', 'K', '<Cmd>wincmd p<CR>', { noremap = true, silent = true })
    end
  end
}

local servers = {
  'clangd',
  -- 'ccls',
  -- 'gopls',
  'rust_analyzer',
  -- 'tsserver',
  -- 'cssls',
  -- 'bashls',
  -- 'denols',
  -- 'rnix',
  'ltex',
  'hls',
  'pyright',
  'yamlls',
  -- 'angularls',
  -- 'purescriptls',
  'jsonls',
  'julials',
}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    handlers = handlers,
  }
end

-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').sumneko_lua.setup {
  on_attach = on_attach,
  handlers = handlers,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file('', true),
        maxPreload = 2000,
        preloadFileSize = 1000,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

nvim_lsp.texlab.setup {
  on_attach = on_attach,
  handlers = handlers,
  settings = {
    texlab = {
      build = {
        args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '-pvc' },
        forwardSearchAfter = true,
        onSave = true,
      },
      forwardSearch = {
        executable = 'zathura',
        args = { '--synctex-forward', '%l:1:%f', '%p' },
        onSave = true,
      },
    },
  },
}

require('formatter').setup {
  filetype = {
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = 'black', -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end,
    },
    lua = {
      function()
        return {
          exe = 'stylua',
          args = {
            -- "--config-path "
            --   .. os.getenv("XDG_CONFIG_HOME")
            --   .. "/stylua/stylua.toml",
            '-',
          },
          stdin = true,
        }
      end,
    },
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = {'src/parser.c', 'src/scanner.cc'},
  },
  filetype = 'org',
}

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {'org'}, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = {'org'}, -- Required since TS highlighter doesn't support all syntax features (conceal)
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
}

require('orgmode').setup {
  org_agenda_files = { '~/Nextcloud/org/*' },
  org_default_notes_file = '~/Nextcloud/org/refile.org',
}

vim.api.nvim_set_keymap(
  'n',
  '<leader>os',
  [[<cmd>lua require('telescope.builtin').live_grep({search_dirs={'$HOME/Nextcloud/org'}})<cr>]],
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
  'n',
  '<leader>of',
  [[<cmd>lua require('telescope.builtin').find_files({search_dirs={'$HOME/Nextcloud/org'}})<cr>]],
  { noremap = true, silent = true }
)
