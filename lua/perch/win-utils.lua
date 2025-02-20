local WinUtils = {}

WinUtils.is_valid = function(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function attach_auto_hide(win, buf)
	vim.api.nvim_create_autocmd("WinLeave", {
		buffer = buf,
		once = true,
		callback = function()
			if WinUtils.is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
		end,
	})
end

WinUtils.open = function(buf)
	local width = vim.o.columns
	local height = vim.o.lines

	local win_width = math.floor(width * 0.6)
	local win_height = math.floor(height * 0.5)
	local row = math.floor((height - win_height) / 2)
	local col = math.floor((width - win_width) / 2)

	local title = vim.api.nvim_buf_get_name(buf)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = title,
		title_pos = "center",
	})

	-- vim.api.nvim_set_option_value("winblend", 10, { win = win })

	attach_auto_hide(win, buf)

	return win
end

WinUtils.close = function(win)
	-- TODO: check what force = true means
	vim.api.nvim_win_close(win, true)

	return nil
end

return WinUtils
