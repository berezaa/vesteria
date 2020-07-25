-- gameScripts are world local scripts for client effects (like blacksmith hammer)
local module = {}

local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage:WaitForChild("modules"))
local network = modules.load("network")
local utilities = modules.load("utilities")


local function addGameScript(gameScript)
    spawn(function()
        local gameScriptData = require(gameScript)
        if gameScriptData and gameScriptData.init then
            gameScriptData.init({network, utilities})
        end
    end)
end

for _, gameScript in pairs(collectionService:GetTagged("gameScript")) do
    addGameScript(gameScript)
end

collectionService:GetInstanceAddedSignal("gameScript"):connect(addGameScript)

return module