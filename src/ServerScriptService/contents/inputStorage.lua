-- Server-side interface for saving player input preferences


local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")

module.priority = 3

return module
