---@class BufUtils
local BufUtils = {}

--- @param buf number|nil
--- @return boolean
BufUtils.is_valid = function(buf)
	return buf ~= nil and vim.api.nvim_buf_is_valid(buf)
end

--- @param buf number
local function attach_autosave(buf)
	vim.api.nvim_create_autocmd({ "BufHidden", "BufUnload", "WinClosed" }, {
		buffer = buf,
		callback = function()
			BufUtils.save(buf)
		end,
	})
end

--- @param dirpath string
--- @return string
local function generate_filename(dirpath)
	local parts = vim.fn.split(dirpath, "/")
	local dirname = parts[#parts]

	local hash = 0
	for i = 1, #dirpath do
		hash = (hash * 31 + string.byte(dirpath, i) * 1147483647) % 2147483647
	end

	return string.format("%x", hash) .. "-" .. dirname
end

---@param dirpath string
local function create_dir_if_not_exist(dirpath)
	local dir_check = io.popen("mkdir -p " .. dirpath)
	if dir_check then
		dir_check:close()
	else
		print("Error creating the directory: " .. dirpath)
	end
end

---@param filepath string
local function create_file_if_not_exist(filepath)
	local file = io.open(filepath, "a")
	if file then
		file:close()
	else
		print("Error creating the file.")
	end
end

--- @param opts Options
--- @return number
BufUtils.init = function(opts)
	local notes_dir = vim.fn.expand(opts.misc.notes_dir)
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h")
	local filename = generate_filename(project_name)
	local filepath = notes_dir .. filename .. "." .. opts.misc.default_file_extension

	create_dir_if_not_exist(notes_dir)
	create_file_if_not_exist(filepath)

	local buf = vim.api.nvim_create_buf(true, false)
	vim.api.nvim_buf_set_name(buf, filepath)
	vim.api.nvim_buf_call(buf, vim.cmd.edit)

	if opts.misc.auto_save then
		attach_autosave(buf)
	end

	return buf
end

--- @param buf number
BufUtils.save = function(buf)
	if BufUtils.is_valid(buf) then
		vim.api.nvim_buf_call(buf, vim.cmd.write)
	end
end

return BufUtils
