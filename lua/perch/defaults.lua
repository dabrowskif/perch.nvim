---@class Options
---@field keymaps Keymaps
---@field misc Misc

---@class Misc
---@field storage_path string
---@field auto_save boolean
---@field file_extension "txt"|'md',
local misc = {
	notes_dir = vim.fn.stdpath("data") .. "/perch/",
	auto_save = true,
	default_file_extension = "txt",
}

---@class Keymaps
---@field [string] {string, table}  -- Key is a string, value is a table containing: mode, command, options
local keymaps = {
	["<leader>tk"] = { "<cmd>lua require('perch').toggle()<CR>", { desc = "Toggle Perch" } },
}

local options = {
	misc = misc,
	keymaps = keymaps,
}

return options
