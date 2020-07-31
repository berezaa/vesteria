local module = {}

local network


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

function module.init(Modules)
	network = Modules.network
	network:create("questTriggerOccurred", "BindableEvent", "Event", function(player, trigger, data)
		-- TODO: implement (ctrl+shift+F for occurances of questTriggerOccurred)
	end)
end

return module
