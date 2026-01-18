local M = {}
local last_fillchar = {}
local defaults = require("foldsigns.defaults")

-- Only define signs if fillchar changed since last time
local function update_sign(sign, fillchar)
	if last_fillchar[sign] == fillchar then
		return
	end
	vim.fn.sign_define(sign, { text = fillchar })
	last_fillchar[sign] = fillchar
end

---@param ev { data: { win: integer, buf: integer } }
local function redraw(ev)
	vim.fn.sign_unplace("FoldSigns", { buffer = ev.data.buf })

	local fillchars = vim.opt_global.fillchars:get()
	update_sign("FoldSignsOpen", fillchars.foldopen)
	update_sign("FoldSignsClose", fillchars.foldclose)

	local last_foldlevel = 0
	for line = 1, vim.fn.line("$") do
		local foldlevel = vim.fn.foldlevel(line)
		if vim.fn.foldclosed(line) == line then
			vim.fn.sign_place(line, "FoldSigns", "FoldSignsClose", ev.data.buf, { lnum = line, priority = 1 })
		elseif foldlevel > last_foldlevel then
			vim.fn.sign_place(line, "FoldSigns", "FoldSignsOpen", ev.data.buf, { lnum = line, priority = 1 })
		end
		last_foldlevel = foldlevel
	end
end

local function set_only_if_unset(opt, value)
	local info = vim.api.nvim_get_option_info2(opt, {})
	if not info.was_set then
		vim.api.nvim_set_option_value(opt, value, {})
	end
end

function M.setup()
	set_only_if_unset("foldlevelstart", defaults.foldlevelstart)
	set_only_if_unset("foldlevel", defaults.foldlevel)
	set_only_if_unset("foldnestmax", defaults.foldnestmax)
	set_only_if_unset("foldtext", defaults.foldtext)

	local fillchars = vim.opt_global.fillchars:get()
	fillchars.fold = fillchars.fold or defaults.fillchars.fold
	fillchars.foldopen = fillchars.foldopen or defaults.fillchars.foldopen
	fillchars.foldclose = fillchars.foldclose or defaults.fillchars.foldclose
	vim.opt_global.fillchars = fillchars

	vim.api.nvim_create_autocmd("User", {
		pattern = "FoldChanged",
		callback = redraw,
	})
end

return M
