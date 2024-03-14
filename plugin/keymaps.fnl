(vim.keymap.set ""  :<space> "" {:noremap true})
(set vim.g.mapleader " ")

;; get the path to the Neovim configuration directory
(local nvim-dir (vim.fn.stdpath "config"))


;; use :Ex for now, switch to other file explorer in the future
(fn open-in-explorer [dir]
  (.. ":Ex " dir :<cr>))


;; remap esc in terminal mode
(vim.keymap.set :t "<Esc>" "<C-\\><C-n>" {:noremap true})
(vim.keymap.set :t "<C-Space>" "<Esc>" {:noremap true})


;; these are the regular bindings
(vim.keymap.set :n "<C-Enter>" (fn [] (vim.lsp.buf.code_action)) {:silent true}) ;; adding both for convenience
(vim.keymap.set :n "<M-Enter>" (fn [] (vim.lsp.buf.code_action)) {:silent true})
(vim.keymap.set :n "<Enter>" "m`o<Esc>k``" {:noremap true})
(vim.keymap.set :n "<S-Enter>" "i<Enter><Esc>k$" {:noremap true})
(vim.keymap.set :n "<C-s>" ":w<cr>")

; Leap
(vim.keymap.set [:n :x :o] "<leader>jf" "<Plug>(leap-forward)")
(vim.keymap.set [:n :x :o] "<leader>jF" "<Plug>(leap-backward)")


;; these are all my spacemacs-like keybindings
(let [map-set-leader (fn [lhs rhs] (vim.keymap.set :n (.. "<leader>" lhs) rhs {:noremap true}))]

  ;; closes all other windows in current layout
  ;; if you want to temporarily maximize the window,
  ;; checkout <leader> lo below
  (map-set-leader "wo" ":only<cr>")

  ;; new scratch buffer
  (map-set-leader "bs" ":enew<cr>")

  ;; map SPC f e d to open the file explorer at the neovim config directory
  (map-set-leader "fed" (open-in-explorer nvim-dir))

  ;; rename in spacemacs
  (map-set-leader "se" vim.lsp.buf.rename)

  ;; open file explorer in directory of current file
  (map-set-leader "ef" (open-in-explorer ""))

  ;; open terminal (in spacemacs this is SPC a t for "application: terminal")
  (map-set-leader "t" vim.cmd.terminal)

  (map-set-leader "wr" vim.cmd.WinResizerStartResize)

  ;; buffer home, go to start screen! (mini.starter)
  (map-set-leader "bh" (fn [] (MiniStarter.open)))
  (map-set-leader "bD" ":bd!<cr>")

  ;; layout stuff, which are neovim _tabs_
  (map-set-leader "lh" ;; layout home
    (fn []
      (vim.cmd.tabnew)
      (MiniStarter.open)))
  (map-set-leader "ln" vim.cmd.tabnext)
  (map-set-leader "lp" vim.cmd.tabprev)
  (map-set-leader "lc" vim.cmd.tabclose)
  (map-set-leader "lo" (fn []
                         (let [buffer-name (vim.api.nvim_buf_get_name (vim.api.nvim_get_current_buf))
                               cursor-position (vim.api.nvim_win_get_cursor 0)]
                           (vim.cmd.tabedit buffer-name)
                           (vim.api.nvim_win_set_cursor 0 cursor-position))))
  (map-set-leader "l<" (fn [] (vim.cmd.tabmove "-1")))
  (map-set-leader "l>" (fn [] (vim.cmd.tabmove "+1")))


  ;; compile all fennel config using make and then quit
  ;; (sadly there's no way to restart neovim automatically)
  (map-set-leader "qr"
    (fn []
      (vim.cmd (.. "cd " nvim-dir))
      (vim.cmd.terminal "make")
      ;; Setup an autocommand to quit Neovim after make completes
      (vim.api.nvim_create_autocmd "TermClose"
        {:pattern "term://*make"
         :callback (fn [] (vim.cmd "qa!"))}))))


; these are modifications of existing behavior from primeagen
(vim.keymap.set :v "p" "\"_dP" {:noremap true :silent true}) ;; don't overwrite register when pasting
(vim.keymap.set :v "d" "\"_d"  {:noremap true :silent true}) ;; don't overwrite register when pasting


(fn command-with-unchanged-unnamed-register [cmd]
  (fn []
    (let [old-unnamed (vim.fn.getreg "\"")]
      (vim.api.nvim_command (.. "normal! " cmd))
      (vim.fn.setreg "\"" old-unnamed))))


; clipboard integrations
(vim.keymap.set :n "<leader>cy" "\"+y" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cp" "\"+p" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cd" "\"+d" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cY" "\"+Y" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cP" "\"+P" {:noremap true :silent true})
(vim.keymap.set :n "<leader>cD" "\"+D" {:noremap true :silent true})

(vim.keymap.set :v "<leader>cY" "\"+y" {:noremap true :silent true})
(vim.keymap.set :v "<leader>cP" "\"+p" {:noremap true :silent true})
(vim.keymap.set :v "<leader>cD" "\"+d" {:noremap true :silent true})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cy"
                (command-with-unchanged-unnamed-register "\"+y")
                {:noremap true :silent true})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cp" "\"_d\"+P"  {:noremap true :silent true})

;; yank to clipboard without changing unnamed register:
(vim.keymap.set :v "<leader>cd"
                (command-with-unchanged-unnamed-register "\"+d")
                {:noremap true :silent true})


; quickfix and location list
(vim.keymap.set :n "[q" ":cprev<cr>" {:noremap true :silent true})
(vim.keymap.set :n "]q" ":cnext<cr>" {:noremap true :silent true})
(vim.keymap.set :n "[l" ":lprev<cr>" {:noremap true :silent true})
(vim.keymap.set :n "]l" ":lnext<cr>" {:noremap true :silent true})
