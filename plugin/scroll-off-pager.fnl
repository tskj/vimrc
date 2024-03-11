;; incase you want different paddings
(local padding-top 15)
(local padding-bottom 15)


(fn empty-strings [n]
  (var result [])
  (for [_ 1 n]
    (table.insert result ""))
  result)


(fn scrolly []
  (let [win-height (vim.api.nvim_win_get_height 0)
        cursor-line (vim.fn.winline)

        cap (fn [y] (math.max y 1))]


    (var padding-top padding-top)
    (var padding-bottom padding-bottom)

    (when (> (+ padding-top padding-bottom 1) win-height)
      (set padding-top (math.floor (/ win-height 2)))
      (set padding-bottom (- win-height padding-top -1)))


    (when (<= cursor-line padding-top)
      (let [[current_y current_x] (vim.api.nvim_win_get_cursor 0)
             line-count (vim.api.nvim_buf_line_count 0)

             new-line (+ current_y padding-bottom)
             number-of-new-lines (- new-line line-count)]

        ;; insert synthetic lines
        (when (> number-of-new-lines 0)
          (vim.api.nvim_buf_set_lines 0 line-count new-line false (empty-strings number-of-new-lines)))

        (vim.api.nvim_win_set_cursor 0 [new-line 0])
        (vim.api.nvim_command "normal! zb")
        (vim.api.nvim_win_set_cursor 0 [current_y current_x])

        ;; remove synthetic lines
        (when (> number-of-new-lines 0)
          (vim.api.nvim_buf_set_lines 0 line-count new-line false []))))

    (when (>= cursor-line (- win-height padding-bottom -1))
      (let [[current_y current_x] (vim.api.nvim_win_get_cursor 0)]

        (vim.api.nvim_win_set_cursor 0 [(cap (- current_y padding-top)) 0])
        (vim.api.nvim_command "normal! zt")
        (vim.api.nvim_win_set_cursor 0 [current_y current_x])))))


(fn run-if-regular-buffer [f]
  (fn []
    (when (and (= vim.bo.buftype "") (~= vim.bo.filetype "netrw"))
      ;; probably modifiable and regular buffer
      (f))))

(vim.api.nvim_create_autocmd "CursorMoved" {:pattern "*" :callback (run-if-regular-buffer scrolly)})
