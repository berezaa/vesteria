local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network = modules.load("network")
		local itemLookup = require(game.ReplicatedStorage:WaitForChild("itemData"))	


local module = {}


function module.getSellValue(itemBaseData, inventorySlotData)
	local baseSellValue = itemBaseData.sellValue or 0
	
	if inventorySlotData and inventorySlotData.enchantments then
		for i,enchantment in pairs(inventorySlotData.enchantments) do
			local enchantmentBaseData = itemLookup[enchantment.id]
			baseSellValue = baseSellValue + enchantmentBaseData.sellValue
		end
	end
	
	return baseSellValue
end

return module
