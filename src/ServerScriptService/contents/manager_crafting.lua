local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local itemLookup = require(ReplicatedStorage:WaitForChild("itemData"))

local network

local function playerRequest_craftItem(player, itemId)
	local item = itemLookup[itemId]
	if item and item.recipe then
		local success, reason = network:invoke("tradeItemsBetweenPlayerAndNPC",
			player,
			item.recipe,
			0,
			{{id = item.id; stacks = 1}},
			0,
			"etc:crafting"
		)
		return success, reason
	end
end

function module.init(Modules)
	network = Modules.network
	network:create("playerRequest_craftItem", "RemoteFunction", "OnServerInvoke", playerRequest_craftItem)
end

return module