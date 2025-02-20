local BufUtils = require("perch.buf-utils")
local WinUtils = require("perch.win-utils")
local defaults = require("perch.defaults")

local M = {}

---@type number|nil
local buf = nil

---@type number|nil
local win = nil

---@type Perch.Options
M.options = defaults

local function setup_keymaps()
	local default_keymap_opts = { noremap = true, silent = true }

	for key, mapping in pairs(M.options.keymaps) do
		local modes = type(mapping[1]) == "table" and mapping[1] or { mapping[1] }
		local command = mapping[2]
		local opts = vim.tbl_deep_extend("force", default_keymap_opts, mapping[3] or {})
		for _, mode in ipairs(modes) do
			vim.keymap.set(mode, key, command, opts)
		end
	end
end

M.setup = function(opts)
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
	setup_keymaps()
end

M.open = function()
	if not BufUtils.is_valid(buf) then
		buf = BufUtils.init(M.options)
	end
	assert(type(buf) == "number", "Expected buf to be a number")
	win = WinUtils.open(buf)
end

M.close = function()
	if BufUtils.is_valid(buf) then
		assert(type(buf) == "number", "Expected buf to be a number")
		if M.options.misc.auto_save then
			BufUtils.save(buf)
		end
	end

	win = WinUtils.close(win)
end

M.toggle = function()
	if WinUtils.is_valid(win) then
		assert(type(win) == "number", "Expected win to be a number")
		M.close()
	else
		M.open()
	end
end

M.add_selection_to_buf = function()
	if not BufUtils.is_valid(buf) then
		buf = BufUtils.init(M.options)
	end
	assert(type(buf) == "number", "Expected win to be a number")

	local selection = ""
	if vim.fn.mode() == "V" then
		local start_pos = vim.fn.getpos("v")
		local end_pos = vim.fn.getpos(".")
		local start_line = start_pos[2]
		local end_line = end_pos[2]

		-- prevents the issue with selecting from bottom to top
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		selection = vim.fn.join(vim.fn.getline(start_line, end_line), "\n")
	else
		selection = vim.fn.getline(".")
	end

	local last_line = vim.api.nvim_buf_line_count(buf)
	local lines_to_insert = vim.fn.split(selection, "\n")
	vim.api.nvim_buf_set_lines(buf, last_line, last_line + #lines_to_insert, false, lines_to_insert)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", true)
end

return M
