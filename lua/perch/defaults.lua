---@class Perch.Misc
---@field notes_dir string
---@field auto_save boolean
---@field file_extension "txt"|'md'
local misc = {
	notes_dir = vim.fn.stdpath("data") .. "/perch/",
	auto_save = true,
	file_extension = "txt",
}

---@class Perch.Keymaps
---@type table<string, {string, table|nil}>
local keymaps = {
	["<leader>tk"] = { "<cmd>lua require('perch').toggle()<CR>", { desc = "Toggle Perch" } },
}

---@class Perch.Options
---@field keymaps Perch.Keymaps
---@field misc Perch.Misc
local options = {
	misc = misc,
	keymaps = keymaps,
}

return options
