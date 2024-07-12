local wk = require("which-key")
local oil = require("oil")

local keys = {
    ["-"] = { oil.open, "Open parent directory" },
}

wk.register(keys)
