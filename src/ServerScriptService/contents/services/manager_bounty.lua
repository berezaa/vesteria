local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules = require(ReplicatedStorage.modules)
local Network = Modules.load("network")

local function playerRequest_claimBounty(player, monsterName)
	local playerData = playerDataContainer[player]
	if not playerData then
		return false, "PlayerData not found."
	end
	if not player:FindFirstChild("bountyHunter") then
		return false, "Not a bounty hunter."
    end

	local monster = monsterLookup[monsterName]
	if monster then
		local page = monster.monsterBookPage
		local playerBountyData = playerData.bountyBook[monsterName]
		if page and playerBountyData then
			local bountyPageInfo = levels.bountyPageInfo[tostring(page)]
			local lastBounty = playerBountyData.lastBounty or 0
			local bountyInfo = bountyPageInfo[lastBounty + 1]
			if bountyInfo and playerBountyData.kills >= bountyInfo.kills then
				-- this line is duplicated in client monsterBook ui module
				local goldReward = levels.getBountyGoldReward(bountyInfo, monster)
				local rewards = {}
				local wasRewarded = int__tradeItemsBetweenPlayerAndNPC(player, {}, 0, rewards, math.floor(goldReward), "etc:bounty")
				if wasRewarded then
					playerBountyData.lastBounty = lastBounty + 1
					--playerBountyData.kills = 0
					onClientRequestPropogateCacheData(player, "bountyBook")
					return true
				end
				return false, "No room in inventory."
			end
			return false, "No bounty available."
		end
		return false, "Invalid monster."
	end
end

Network:create("playerRequest_claimBounty", "RemoteFunction", "OnServerInvoke", playerRequest_claimBounty)

return module