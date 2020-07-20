local module = {}

local httpService = game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage.modules)
local network = modules.load("network")
local utilities = modules.load("utilities")
local questLookup = require(replicatedStorage.questLookupNew)

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

local function main()
	network:create("questTriggerOccurred", "BindableEvent", "Event", function(player, trigger, data)
		-- TODO: implement (ctrl+shift+F for occurances of questTriggerOccurred)
	end)
end

spawn(main)

return module
