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
		local final_keymap = vim.tbl_deep_extend("force", default_keymap_opts, mapping[2] or {})
		vim.keymap.set("n", key, mapping[1], final_keymap)
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

return M
