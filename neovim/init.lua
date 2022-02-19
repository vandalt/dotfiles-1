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
  use 'wbthomason/packer.nvim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'numToStr/Comment.nvim'
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-sleuth'
  use 'justinmk/vim-dirvish'
  use 'christoomey/vim-tmux-navigator'
  -- UI to select things (files, grep results, open buffers...)
  use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'nvim-lualine/lualine.nvim'
  -- use 'arkav/lualine-lsp-progress'
  use 'j-hui/fidget.nvim'
  -- Add indentation guides even on blank lines
  use 'lukas-reineke/indent-blankline.nvim'
  -- Add git related info in the signs columns and popups
  use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
  -- Highlight, edit, and navigate code using a fast incremental parsing library
  use 'nvim-treesitter/nvim-treesitter'
  -- Additional textobjects for treesitter
  use 'nvim-treesitter/nvim-treesitter-textobjects'
  use 'neovim/nvim-lspconfig'
  -- use 'mjlbach/onedark.nvim'
  -- use '/home/michael/Repositories/neovim_development/nvim-lspconfig-worktrees/nvim-lspconfig'
  use '/home/michael/Repositories/neovim_development/onedark.nvim'
  use '$HOME/Repositories/neovim_development/projects.nvim'
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

--Add spellchecking
vim.cmd [[ autocmd FileType gitcommit setlocal spell ]]
vim.cmd [[ autocmd FileType markdown setlocal spell ]]

local onedark = require 'lualine.themes.onedark'
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
    -- lualine_c = { 'lsp_progress' },
    lualine_c = {function()
      return vim.fn['nvim_treesitter#statusline'](90)
    end},
    lualine_x = { 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },

  },
}

-- Enable fidget for lsp progress
require('fidget').setup()

-- Enable commentary.nvim
require('Comment').setup()

--Remap space as leader key
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

--Add move line shortcuts
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==')
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==')
vim.keymap.set('i', '<A-j>', '<Esc>:m .+1<CR>==gi')
vim.keymap.set('i', '<A-k>', '<Esc>:m .-2<CR>==gi')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv")

--Remap escape to leave terminal mode
vim.keymap.set('t', '<Esc>', [[<c-\><c-n>]])

--Disable numbers in terminal mode
vim.cmd [[
  augroup Terminal
    autocmd!
    au TermOpen * set nonu
  augroup end
]]

--Add map to enter paste mode
vim.o.pastetoggle = '<F3>'

require('indent_blankline').setup {
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

vim.keymap.set('n', '<leader>bm', ToggleMouse)

--Start interactive EasyAlign in visual mode (e.g. vipga)
-- Note this overwrites a useful ascii print thing
-- vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', {})

--Start interactive EasyAlign for a motion/text object (e.g. gaip)
-- vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', {})

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
  local telescope_opts = { previewer = false }
  local ok = pcall(require('telescope.builtin').git_files, telescope_opts)
  if not ok then
    require('telescope.builtin').find_files(telescope_opts)
  end
end

vim.keymap.set('n', '<leader>f', TelescopeFiles)
vim.keymap.set('n', '<leader><space>', function()
  require('telescope.builtin').buffers { sort_lastused = true }
end)

vim.keymap.set(
  'n',
  '<leader>sb',
  require('telescope.builtin').current_buffer_fuzzy_find
)
vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').live_grep)

vim.keymap.set('n', '<leader>so', function()
  require('telescope.builtin').tags { only_current_buffer = true }
end)

vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits)
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches)
vim.keymap.set('n', '<leader>gs', require('telescope.builtin').git_status)
vim.keymap.set('n', '<leader>gp', require('telescope.builtin').git_bcommits)
vim.keymap.set('n', '<leader>wo', require('telescope.builtin').lsp_document_symbols)

-- Fugitive shortcuts
vim.keymap.set('n', '<leader>ga', ':Git add %:p<CR><CR>', { silent = true })
vim.keymap.set('n', '<leader>gg', ':GBrowse<CR>', { silent = true })
vim.keymap.set('n', '<leader>gd', ':Gdiff<CR>', { silent = true })
vim.keymap.set('n', '<leader>ge', ':Gedit<CR>', { silent = true })
vim.keymap.set('n', '<leader>gr', ':Gread<CR>', { silent = true })
vim.keymap.set('n', '<leader>gw', ':Gwrite<CR><CR>', { silent = true })
vim.keymap.set('n', '<leader>gl', ':silent! Glog<CR>:bot copen<CR>', { silent = true })
vim.keymap.set('n', '<leader>gm', ':Gmove<Space>', { silent = true })
vim.keymap.set('n', '<leader>go', ':Git checkout<Space>', { silent = true })

-- alternative shorcuts without fzf
vim.keymap.set('n', '<leader>,', ':buffer *')
vim.keymap.set('n', '<leader>.', ':e<space>**/')
vim.keymap.set('n', '<leader>sT', ':tjump *')

-- Managing quickfix list
vim.keymap.set('n', '<leader>qo', ':copen<CR>', { silent = true })
vim.keymap.set('n', '<leader>qq', ':cclose<CR>', { silent = true })
vim.keymap.set('n', '<leader>Qo', ':lopen<CR>', { silent = true })
vim.keymap.set('n', '<leader>Qq', ':lclose<CR>', { silent = true })
vim.cmd [[autocmd FileType qf nnoremap <buffer> q :lclose <bar> cclose <CR> ]]

-- Get rid of annoying ex keybind
vim.keymap.set('', 'Q', '<Nop>', { silent = true })

-- Managing buffers
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { silent = true })

-- Random
vim.keymap.set('n', '<leader>;', ':')

-- LSP management
vim.keymap.set('n', '<leader>lr', ':LspRestart<CR>', { silent = true })
vim.keymap.set('n', '<leader>li', ':LspInfo<CR>', { silent = true })
vim.keymap.set('n', '<leader>ls', ':LspStart<CR>', { silent = true })
vim.keymap.set('n', '<leader>lt', ':LspStop<CR>', { silent = true })

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
vim.keymap.set('n', '<A-a>', '<C-a>')
vim.keymap.set('v', '<A-a>', '<C-a>')
vim.keymap.set('n', '<A-x>', '<C-x>')
vim.keymap.set('v', '<A-x>', '<C-x>')

-- n always goes forward
vim.keymap.set('n', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'n', "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set('n', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('x', 'N', "'nN'[v:searchforward]", { expr = true })
vim.keymap.set('o', 'N', "'nN'[v:searchforward]", { expr = true })

-- map :W to :w (helps which-key issue)
vim.cmd [[ command! W  execute ':w' ]]

-- Neovim python support
vim.g.loaded_python_provider = 0

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Clear white space on empty lines and end of line
vim.keymap.set(
  'n',
  '<F6>',
  [[:let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>]],
  { silent = true }
)

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

vim.keymap.set('n', '<leader>wt', ToggleNetrw)

-- Function to open preview of file under netrw
vim.cmd [[
  augroup Netrw
    autocmd!
    autocmd filetype netrw nmap <leader>; <cr>:wincmd W<cr>
  augroup end
]]

-- directory managmeent, including autochdir
-- vim.cmd[[nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>]]

-- vim.cmd [[
--   augroup BufferCD
--     autocmd!
--     autocmd BufEnter * silent! Glcd
--   augroup end
-- ]]

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

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
vim.keymap.set('n', '<leader>Q', vim.diagnostic.setqflist)

-- LSP settings
-- log file location: $HOME/.cache/nvim/lsp.log
-- vim.lsp.set_log_level 'debug'
require('vim.lsp.log').set_format_func(vim.inspect)

-- Add nvim-lspconfig plugin
local lspconfig = require 'lspconfig'
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local attach_opts = { silent = true, buffer = bufnr }
  -- Mappings.
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, attach_opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition , attach_opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, attach_opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, attach_opts)
  vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help, attach_opts)
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, attach_opts)
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, attach_opts)
  vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, attach_opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, attach_opts)
  vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, attach_opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, attach_opts)

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

  -- if client.resolved_capabilities.document_highlight then
  --   vim.cmd [[
  --   augroup lsp_document_highlight
  --     autocmd! * <buffer>
  --     autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
  --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
  --   augroup END
  -- ]]
  -- end
end

local handlers = {
  ['textDocument/hover'] = function(...)
    local bufnr, _ = vim.lsp.handlers.hover(...)
    if bufnr then
      vim.keymap.set('n', 'K', '<Cmd>wincmd p<CR>', { silent = true, buffer = bufnr })
    end
  end,
}

local servers = {
  'clangd',
  'gopls',
  -- 'clangd',
  -- 'ccls',
  -- 'gopls',
  -- 'tsserver',
  -- 'cssls',
  -- 'bashls',
  -- 'denols',
  -- 'rnix',
  'ltex',
  'hls',
  'pyright',
  'yamlls',
  'jsonls',
  'julials',
}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    handlers = handlers,
  }
end

require('lspconfig').rust_analyzer.setup {
  cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' },
  on_attach = on_attach,
  handlers = handlers,
}

-- require('lspconfig').html.setup {
--   on_attach = on_attach,
--   handlers = handlers,
--   init_options = {
--     provideFormatter = true,
--     embeddedLanguages = { css = true, javascript = true },
--     configurationSection = { 'html', 'css', 'javascript' },
--   },
-- }

-- require('lspconfig').r_language_server.setup{
--   on_attach = on_attach,
--   handlers = handlers
-- }

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

lspconfig.texlab.setup {
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

local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.org = {
  install_info = {
    url = 'https://github.com/milisims/tree-sitter-org',
    revision = 'main',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
  filetype = 'org',
}

require('orgmode').setup_ts_grammar()

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { 'org' }, -- Remove this to use TS highlighter for some of the highlights (Experimental)
    additional_vim_regex_highlighting = { 'org' }, -- Required since TS highlighter doesn't support all syntax features (conceal)
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

vim.keymap.set('n', '<leader>os', function()
  require('telescope.builtin').live_grep { search_dirs = { '$HOME/Nextcloud/org' } }
end)

vim.keymap.set('n', '<leader>of', function()
  require('telescope.builtin').find_files { search_dirs = { '$HOME/Nextcloud/org' } }
end)
--
-- local Project = require 'projects.project'
--
-- function string.starts(String, Start)
--   return string.sub(String, 1, string.len(Start)) == Start
-- end
--
-- local c_project = Project.new {
--   priority = 10,
--   workspace_folders = {
--     {
--       uri = vim.uri_from_fname '/home/michael/Repositories/neovim/neovim',
--       name = '/home/michael/Repositories/neovim/neovim',
--     },
--   },
--   -- resolve_project = function()
--   -- end,
--   match = function(self, bufname)
--     if string.starts(bufname, '/Users/michael/Repositories/neovim') then
--       return true
--     else
--       return false
--     end
--   end,
--
--   on_init = function(self)
--     local clangd_configuration = require('lspconfig.server_configurations.clangd').default_config
--     local lua_configuration = require('lspconfig.server_configurations.sumneko_lua').default_config
--     clangd_configuration.workspace_folders = self.workspace_folders
--     lua_configuration.workspace_folders = self.workspace_folders
--
--     self.clangd_id = vim.lsp.start_client(clangd_configuration)
--     self.lua_id = vim.lsp.start_client(lua_configuration)
--     self.clangd_client = vim.lsp.get_client_by_id(self.clangd_id)
--     self.lua_client = vim.lsp.get_client_by_id(self.lua_id)
--   end,
--
--   on_attach = function(self, bufnr)
--     if vim.api.nvim_buf_get_option(0, 'filetype') == 'lua' then
--       vim.lsp.buf_attach_client(bufnr, self.lua_id)
--     elseif vim.api.nvim_buf_get_option(0, 'filetype') == 'c' then
--       vim.lsp.buf_attach_client(bufnr, self.clangd_id)
--     end
--   end,
--
--   on_close = function(self, bufnr)
--     vim.lsp.buf_detach_client(bufnr, self.clangd_id)
--     vim.lsp.buf_detach_client(bufnr, self.lua_id)
--   end,
--
--   on_termination = function(self)
--     self.clangd_client.close()
--     self.lua_client.close()
--   end,
-- }
--
-- require('projects.manager').register(c_project)
--
-- local pyright_project = require('projects.lspconfig_wrapper')('pyright')
-- local pyright_project = require('projects.lspconfig_wrapper')('sumneko_lua')
--
-- require('projects.manager').register(pyright_project)
