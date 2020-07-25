local module = {}

local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
local network = modules.load("network")

local itemLookup = require(replicatedStorage:WaitForChild("itemData"))

local function playerRequest_craftItem(player, itemId)
	local item = itemLookup[itemId]
	if item and item.recipe then
		local success, reason = network:invoke(
			"tradeItemsBetweenPlayerAndNPC",
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

local function main()
	network:create("playerRequest_craftItem", "RemoteFunction", "OnServerInvoke", playerRequest_craftItem)
end

spawn(main)

return module