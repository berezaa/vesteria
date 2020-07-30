local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local network = Modules.load("network")

network:create("playerRequest_claimGifts", "RemoteFunction", "OnServerInvoke", function(player)
	local playerData = playerDataContainer[player]
	if playerData and playerData.globalData then
		if ((not playerData.globalData.alphaGiftClaimed2) and (not playerData.alphaGiftClaimed2)) or ((not playerData.globalData.alphaGiftClaimed) and (not playerData.alphaGiftClaimed)) then
			if game:GetService("BadgeService"):UserHasBadgeAsync(player.userId, 2124445897) then
				if int__tradeItemsBetweenPlayerAndNPC(player, {}, 0, {{id = 158, stacks = 1}}, 50000, "gift:alpha") then
					playerData.globalData.alphaGiftClaimed2 = true
					playerData.alphaGiftClaimed2 = true
					playerData.globalData.alphaGiftClaimed = true
					playerData.alphaGiftClaimed = true
					return true
				else
					return false, "Hmm, is your inventory full or something?"
				end
			end
		end

		if ((not playerData.globalData.spiderGiftClaimed) and (not playerData.spiderGiftClaimed)) then
			if player.Name == "berezaa" or game:GetService("MarketplaceService"):PlayerOwnsAsset(player, 4027043310) then
				if int__tradeItemsBetweenPlayerAndNPC(player, {}, 0, {{id = 177, stacks = 1}}, 50000, "gift:spider") then
					playerData.globalData.spiderGiftClaimed = true
					playerData.spiderGiftClaimed = true
					return true
				else
					return false, "Hmm, is your inventory full or something?"
				end
			end
		end
	end

	return false
end)

return module