local module = {}

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
local network = modules.load("network")
local levels = modules.load("levels")
local monsterLookup = require(game.ReplicatedStorage:WaitForChild("monsterLookup"))

local function playerRequest_claimBounty(player, monsterName)
	local playerData = network:invoke("getPlayerData", player)
	if not playerData then
		return false, "PlayerData not found."
	end
	if not player:FindFirstChild("bountyHunter") then
		return false, "Not a bounty hunter."
    end

	local monster = monsterLookup[monsterName]
	if monster then
		local page = monster.monsterBookPage
		local bountyData = playerData.bountyBook
		local monsterData = bountyData[monsterName]
		if page and monsterData then
			local bountyPageInfo = levels.bountyPageInfo[tostring(page)]
			local lastBounty = monsterData.lastBounty or 0
			local bountyInfo = bountyPageInfo[lastBounty + 1]
			if bountyInfo and monsterData.kills >= bountyInfo.kills then
				-- this line is duplicated in client monsterBook ui module
				local money = math.floor(levels.getBountyGoldReward(bountyInfo, monster))
				local rewards = {}
				local wasRewarded = network:invoke("tradeItemsBetweenPlayerAndNPC", player, {}, 0, rewards, money, "etc:bounty")
				if wasRewarded then
					monsterData.lastBounty = lastBounty + 1
					playerData.nonSerializeData.setPlayerData("bountyBook", bountyData)
					return true
				end
				return false, "No room in inventory."
			end
			return false, "No bounty available."
		end
		return false, "Invalid monster."
	end
end

network:create("playerRequest_claimBounty", "RemoteFunction", "OnServerInvoke", playerRequest_claimBounty)

return module