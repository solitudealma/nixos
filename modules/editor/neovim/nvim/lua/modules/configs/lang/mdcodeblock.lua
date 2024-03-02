local global = require("core.global")

return function()
	global:hi({ ["MDCodeBlock"] = { bg = 234 } })
	require("hl-mdcodeblock").setup({
		minumum_len = 80,
	})
end
