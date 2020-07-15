local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")

local Module = require(script.verify)
script.verify:Destroy()		

local function redeemcode(player, code)
	if string.sub(code,1,1) == "$" and string.len(code) > 6 and string.len(code) < 10 then
		if game.MarketplaceService:PlayerOwnsAsset(player, 2376885433) then
			local success = Module.Verify(player, code)
			if success then
				--[[
				spawn(function()
					game.BadgeService:AwardBadge(player.userId,1742681250)
				end)			
				]]
				return success			
			end
		end
	end	
end

network:create("playerRequest_redeemcode", "RemoteFunction", "OnServerInvoke", redeemcode)

return {}