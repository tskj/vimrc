(set vim.opt.guicursor
  ["n-v-c:block"
   "i-ci-ve:hor20"
   "r-cr:hor20"])

(set vim.o.guifont "FiraCode Nerd Font:h15")
(if vim.g.started_by_firenvim
  (set vim.o.guifont "FiraCode Nerd Font:h10"))

; sets current working directory you open a file or w/e (needed for terminal)
(set vim.o.autochdir true)

; more convenient with case insensitive search
(set vim.opt.ignorecase true)
(set vim.opt.smartcase true)

(set vim.opt.tabstop 2)
(set vim.opt.shiftwidth 2)
(set vim.opt.expandtab true)

; left gutter, I think it's probably best to not waste that space?
; it only appears to work with "no" though, so w/e
(set vim.opt.signcolumn "auto")

(set vim.opt.fileformats ["unix" "dos"])

; nowrap for long lines
(set vim.wo.wrap false)

; e.g. click and drag to resize split with mouse
(set vim.opt.mouse "a")

; we show the mode in status line anyway
(set vim.opt.showmode false)

; set to true if you want line numbers
(set vim.opt.number false)

; highlight searches, but clears on <Esc>
(set vim.opt.hlsearch true)
(vim.keymap.set :n "<Esc>" "<cmd>nohlsearch<CR>")

(set vim.opt.shm "sS") ;; removes search count
(set vim.opt.showcmd false) ;; removes selection count

(set vim.opt.confirm false)
(set vim.opt.swapfile false)
