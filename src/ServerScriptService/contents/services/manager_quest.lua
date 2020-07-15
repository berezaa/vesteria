local module = {}

local HTTPService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("Network")
local Utilities = Modules.load("utilities")
local QuestLookup = require(ReplicatedStorage.questLookupNew)

local cachedPlayerQuestData = {}

function module.completeQuest(player, questId)
	
end

function module.returnPlayerQuestData(player)
	local playerQuestData = cachedPlayerQuestData[player]
	
	if playerQuestData then
		return playerQuestData
	elseif not playerQuestData and game.Players:FindFirstChild(player.Name) then
		module.loadQuestData(player)
		return module.returnPlayerQuestData(player)
	end
end

function module.loadQuestData(player)
	
end

function module.saveQuestData(player)
	
end

return module
