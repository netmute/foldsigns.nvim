local M = {}
local h = vim.health or require("health")
local i = vim.inspect
local defaults = require("foldsigns.defaults")

local function check_opt(name, expected)
	local actual = vim.opt[name]:get()
	if vim.deep_equal(actual, expected) then
		h.ok(string.format("`vim.opt.%s = %s`", name, i(actual)))
	else
		h.warn(string.format("`vim.opt.%s = %s` (plugin designed for `%s`)", name, i(actual), i(expected)))
	end
end

local function check_opt_not(name, forbidden)
	local actual = vim.opt[name]:get()
	if actual ~= forbidden then
		h.ok(string.format("`vim.opt.%s = %s`", name, i(actual)))
	else
		h.warn(string.format("`vim.opt.%s = %s` (probably not what you want)", name, i(actual)))
	end
end

local function check_fillchars(expected)
	local fillchars = vim.opt_global.fillchars:get() or {}
	for fillchar, want in pairs(expected) do
		local got = fillchars[fillchar]
		if got == want then
			h.ok(string.format("`vim.opt.fillchars.%s = %s`", fillchar, i(got)))
		else
			h.warn(string.format("`vim.opt.fillchars.%s = %s` (plugin designed for `%s`)", fillchar, i(got), i(want)))
		end
	end
end

function M.check()
	h.start("foldsigns")

	local ok = pcall(require, "foldchanged")
	if ok then
		h.ok("`'netmute/foldchanged.nvim'` installed")
	else
		h.error("`'netmute/foldchanged.nvim'` NOT installed")
	end

	check_opt_not("foldenable", false)
	check_opt_not("signcolumn", "no")
	check_opt("foldcolumn", "0")
	check_opt_not("foldmethod", "manual")
	check_opt("foldlevelstart", defaults.foldlevelstart)
	check_opt("foldnestmax", defaults.foldnestmax)
	check_opt("foldtext", defaults.foldtext)

	check_fillchars(defaults.fillchars)
end

return M
