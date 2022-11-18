" Installation: Plug 'b3nj5m1n/kommentary'
" Instructions: https://github.com/b3nj5m1n/kommentary
"
" Notes:
"   You can toggle comments for the current line using `gcc`, for the current
"   visual selection using `gc`, and in combination with a motion using `gc`,
"   for example `gc5j`.
"

" =============================================================================
" Default configuration
" =============================================================================
" lua << EOF
" vim.api.nvim_set_keymap("n", "<leader>cic", "<Plug>kommentary_line_increase", {})
" vim.api.nvim_set_keymap("n", "<leader>ci", "<Plug>kommentary_motion_increase", {})
" vim.api.nvim_set_keymap("x", "<leader>ci", "<Plug>kommentary_visual_increase", {})
" vim.api.nvim_set_keymap("n", "<leader>cdc", "<Plug>kommentary_line_decrease", {})
" vim.api.nvim_set_keymap("n", "<leader>cd", "<Plug>kommentary_motion_decrease", {})
" vim.api.nvim_set_keymap("x", "<leader>cd", "<Plug>kommentary_visual_decrease", {})
" EOF


" =============================================================================
" Custom mapping
" =============================================================================
"
" lua << EOF
" -- You might wanna disable creation of default mapping
" --
" -- Add the following to disable default mappings.
" --
" -- vim.g.kommentary_create_default_mappings = false

" -- Create your custom default mappings.
" vim.api.nvim_set_keymap("n", "gcc", "<Plug>kommentary_line_default", {})
" vim.api.nvim_set_keymap("n", "gc", "<Plug>kommentary_motion_default", {})
" vim.api.nvim_set_keymap("v", "gc", "<Plug>kommentary_visual_default<C-c>", {})
" EOF


" =============================================================================
" Configure unsupported language
" =============================================================================
" lua << EOF
" require('kommentary.config').configure_language("rust", {
"     single_line_comment_string = "//",
"     multi_line_comment_strings = {"/*", "*/"},
" })
" EOF
"
" Configure multiple languages at once.
"
" lua << EOF
" require('kommentary.config').configure_language({"c", "rust"}, {
"     single_line_comment_string = "//",
"     multi_line_comment_strings = {"/*", "*/"},
" })
" EOF
"


" =============================================================================
" Use single/multi-line comments
" =============================================================================
" lua << EOF
" require('kommentary.config').configure_language("rust", {
"     prefer_single_line_comments = true,
"     -- or
"     -- prefer_multi_line_comments = true,
" })
" EOF
"
" If both are set to true, the default setting is used.
"
" lua << EOF
" require('kommentary.config').configure_language("default", {
"     prefer_single_line_comments = true,
" })
" EOF


" =============================================================================
" Configure multiple languages at once
" =============================================================================
" lua << EOF
" require('kommentary.config').configure_language({"c", "rust"}, {
"     prefer_single_line_comments = true,
" })
" EOF
