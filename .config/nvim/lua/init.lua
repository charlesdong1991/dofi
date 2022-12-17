require('packer').startup(function(use)
  use "wbthomason/packer.nvim"
  use "gioele/vim-autoswap"
  use "chriskempson/base16-vim"
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "tpope/vim-obsession"
  use "tpope/vim-sleuth"
  use "tpope/vim-repeat"
  use "tpope/vim-commentary"
  use "airblade/vim-gitgutter"
  use "jiangmiao/auto-pairs"
  use "majutsushi/tagbar"
  use { "junegunn/fzf", run = ":call fzf#install()" }
  use "junegunn/fzf.vim"
  use "junegunn/gv.vim"
  use "ludovicchabant/vim-gutentags"
  use "christoomey/vim-tmux-navigator"
  use "dense-analysis/ale"
  use { "neoclide/coc.nvim", branch = "release" }
  use "alok/notational-fzf-vim"
  use "hashivim/vim-terraform"
  use "jamessan/vim-gnupg"
  use "junegunn/goyo.vim"
  use "preservim/vim-pencil"
  use "guns/vim-clojure-static"
  use "tpope/vim-fireplace"
  use {
    "iamcco/markdown-preview.nvim",
    run = function() vim.fn["mkdp#util#install"]() end
  }
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
  }
end)


-- Neovim Settings
------------------
vim.o.syntax = 'enable'
vim.o.clipboard = 'unnamedplus'
vim.o.number = true
vim.o.relativenumber = true
vim.o.lazyredraw = true
vim.o.showmatch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.cursorline = true
vim.o.hidden = true             -- Allows hidden modified buffers
vim.o.autoread = true           -- Reload file if changed outside vim
vim.o.fillchars = 'vert:┃'      -- Vertical split character
vim.o.mouse = 'a'
vim.o.signcolumn = 'yes'        -- Always show sign column
vim.o.shm = 'Ia'                -- Don't show intro message see h: shm
vim.cmd([[
  filetype plugin indent on
  set noshowmode
  set nosol
]])


-- Abbreviation shortcuts
-- ----------------------
-- insert current date
vim.cmd([[inoreabbrev idate <C-R>=strftime("%Y-%m-%d %H:%M")<CR>]])
vim.cmd([[inoreabbrev idateh <C-R>=strftime("%a, %b %d, %Y at %H:%M")<CR>]])


-- statusline
-- ----------
vim.cmd([[
function! GetGitHead()
    let l:branch = fugitive#Head()
    return strlen(l:branch)>0 ? l:branch.' • ' : ''
endfunction
]])

local stl = {
  "%{' '}",
  "%{GetGitHead()}",
  "%f",
  "%( [%M%R]%)",
  "%=",
  "%{&filetype}",
  " %{&fileencoding?&fileencoding:&encoding}",
  " %{&fileformat}",
  "   %l,%c%V %P",
  "%{' '}",
}

vim.o.statusline = table.concat(stl)


-- Python support
-- --------------
local home = os.getenv('HOME')
vim.g.python3_host_prog = home .. '/.pyenv/versions/nvim/bin/python'



-- Keymaps
-- -------
vim.g.mapleader = ' '                                                      -- leader
vim.g.maplocalleader = ' '
vim.keymap.set('n', 'Q', '<C-w>q', {noremap = true})                       -- close window
vim.keymap.set('n', 'X', ':bd<CR>', {noremap = true})                      -- delete buffer
vim.keymap.set('n', 'L', ':bn<CR>', {noremap = true})                      -- move buffers
vim.keymap.set('n', 'H', ':bp<CR>', {noremap = true})
vim.keymap.set('n', '<esc>', ':noh<CR>', {noremap = true, silent = true})  -- clear highlighting
vim.keymap.set('n', 's', ':w<CR>', {noremap = true})                       -- write buffer
vim.keymap.set('n', '<C-e>', '4<C-e>', {noremap = true})                   -- scroll steps
vim.keymap.set('n', '<C-y>', '4<C-y>', {noremap = true})
vim.keymap.set('v', '<C-e>', '4<C-e>', {noremap = true})
vim.keymap.set('v', '<C-y>', '4<C-y>', {noremap = true})
vim.keymap.set('n', 't', '<C-]>', {noremap = true})                        -- tags
vim.keymap.set('n', 'T', '<C-t>', {noremap = true})



-- Cursorline
-- ----------
vim.cmd([[
  " shows cursorline only in the active window
  augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
  augroup END
]])


-- Plugin settings
-- ---------------

-- Gitgutter
-- ---------
vim.api.nvim_set_var('gitgutter_override_sign_column_highlight', 0)


-- Neo-tree
-- --------
vim.keymap.set('n', '<leader>a', ':Neotree<CR>', {noremap = true})
vim.api.nvim_set_var('neo_tree_remove_legacy_commands', 1)

require("neo-tree").setup {
  enable_git_status = false,
  enable_diagnostics = false,
  enable_modified_markers = true, -- Show markers for files with unsaved changes.
  enable_refresh_on_write = true, -- Refresh the tree when a file is written. Only used if `use_libuv_file_watcher` is false.
  default_component_configs = {
    icon = {
      folder_closed = "▸",
      folder_open = "▾",
      folder_empty = " ",
      default = "*",
    }
  }
}


-- Tagbar
-- ------
vim.keymap.set('n', '<leader>;', ':TagbarToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_var('tagbar_left', 0)
vim.api.nvim_set_var('tagbar_sort', 0)
vim.api.nvim_set_var('tagbar_autofocus', 1)
vim.api.nvim_set_var('tagbar_compact', 1)
vim.api.nvim_set_var('tagbar_type_elixir', {
    ctagstype = 'elixir',
    kinds = {
        'f:functions',
        'functions:functions',
        'c:callbacks',
        'd:delegates',
        'e:exceptions',
        'i:implementations',
        'a:macros',
        'o:operators',
        'm:modules',
        'p:protocols',
        'r:records',
        't:tests'
    }
})


-- GutenTags
-- ---------
vim.api.nvim_set_var('gutentags_cache_dir', '~/dev/.tags/')


-- FZF
-- ---
vim.api.nvim_set_var('fzf_buffers_jump', 1)
vim.api.nvim_set_keymap('n', '<leader>f', ':FZF<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>b', ':Buffers<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>t', ':Tags<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>/', ':Ag<CR>', {noremap = true})


-- Goyo
-- ----
vim.api.nvim_set_var('goyo_width', 80)         -- (default: 80)
vim.api.nvim_set_var('goyo_height', 100)       -- (default: 85%)
vim.api.nvim_set_var('goyo_linenr', 0)         -- (default: 0)
vim.api.nvim_set_keymap('n', '<leader>g', ':Goyo<CR>', {noremap = true})


-- Pencil
-- ------
vim.cmd([[
  augroup pencil
    autocmd!
    autocmd FileType md,markdown call pencil#init({'wrap': 'soft'})
    autocmd FileType text,txt    call pencil#init()
  augroup END
]])


-- Vim Sleuth
-- ----------
vim.api.nvim_set_var('sleuth_automatic', 1)


-- DBUI
-- ----
vim.api.nvim_set_keymap('n', '<leader>d', ':DBUIToggle<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>r', '<Plug>(DBUI_ExecuteQuery)', {noremap = true})


-- ALE
-- ---
vim.api.nvim_set_var('ale_python_isort_options', '--profile black')
vim.api.nvim_set_var('ale_completion_enabled', 0)
vim.api.nvim_set_var('ale_linters', {
    python = {'pyflakes'},
    clojure = {'clj-kondo'},
    markdown = {'vale'},
    terraform = {'tflint'}
})
vim.api.nvim_set_var('ale_fixers', {
    ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
    python = {'isort', 'black'},
    terraform = {'terraform'},
    json = {'jq'}
})
vim.api.nvim_set_var('ale_fix_on_save', 1)
vim.api.nvim_set_var('ale_sign_error', '✖')
vim.api.nvim_set_var('ale_sign_warning', '▲')


-- COC
-- ---
-- extensions
vim.api.nvim_set_var('coc_global_extensions', {'coc-json', 'coc-git'})
-- GoTo code navigation.
-- --------------------
vim.keymap.set('n', 'gd', '<Plug>(coc-definition)', {noremap = true, silent = true})
vim.keymap.set('n', 'gy', '<Plug>(coc-type-definition)', {noremap = true, silent = true})
vim.keymap.set('n', 'gi', '<Plug>(coc-implementation)', {noremap = true, silent = true})
vim.keymap.set('n', 'gr', '<Plug>(coc-references)', {noremap = true, silent = true})


-- Notational Velocity
-- ------------------
vim.api.nvim_set_var('nv_search_paths', {'~/notes/'})
vim.api.nvim_set_keymap('n', '<leader>n', ':NV<CR>', {noremap = true})


-- Autoswap
-- --------
vim.api.nvim_set_var('autoswap_detect_tmux', 1)


-- Markdown preview
-- ----------------
vim.api.nvim_set_keymap('n', '<leader>p', '<Plug>MarkdownPreviewToggle', {noremap = true})


-- Source base16 file from env var
local function color_customize()
  local theme = os.getenv('BASE16_THEME')

  if theme
      and (not vim.g.colors_name or vim.g.colors_name ~= 'base16-' .. theme) then
    vim.api.nvim_command('let base16colorspace=256')
    vim.api.nvim_command('colorscheme base16-solarized-dark')
  end

  vim.api.nvim_set_hl(0, 'EndOfBuffer', {ctermfg = 0, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'SignColumn', {ctermfg = 8, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'VertSplit', {ctermfg = 18, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'LineNr', {ctermfg = 8, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'CursorLineNr', {ctermfg = 8, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'StatusLine', {ctermfg = 20, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'StatusLineNC', {ctermfg = 19, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'TabLine', {ctermfg = 19, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'TabLineSel', {ctermfg = 20, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'TabLineFill', {ctermfg = 20, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'GitGutterAdd', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'GitGutterChange', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'GitGutterDelete', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'GitGutterChangeDelete', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'DiffAdd', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'DiffChange', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'DiffDelete', {ctermbg = 0})
  vim.api.nvim_set_hl(0, 'ALEErrorSign', {ctermfg = 1, ctermbg = 0})
  vim.api.nvim_set_hl(0, 'ALEWarningSign', {ctermfg = 3, ctermbg = 0})
end

color_customize()
