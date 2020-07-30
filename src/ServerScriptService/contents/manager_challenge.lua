-- manages trades
-- author: Polymorphic

local module = {}

local replicatedStorage 	= game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local placeSetup 	= modules.load("placeSetup")
		local utilities 	= modules.load("utilities")

local httpService 			= game:GetService("HttpService")
local serverStorage 		= game:GetService("ServerStorage")

--[[
	challengeRequestData {}
		instance challenger
		instance playerChallenged
		
	tradeSessionData {}
		string guid
		string state
		
		playerTradeSessionData playerTradeSessionData_player1
		playerTradeSessionData playerTradeSessionData_player2
--]]

local pendingChallenge_guids = {}

-- if IFFIsActiveTrade is set, the trade must be ongoing to return the sessionData
local function propogateTradeDataUpdate(tradeSessionData)
	network:fireClient("signal_tradeSessionChanged", tradeSessionData.playerTradeSessionData_player1.player, tradeSessionData)	
	network:fireClient("signal_tradeSessionChanged", tradeSessionData.playerTradeSessionData_player2.player, tradeSessionData)	
end

local function clearPreviousChallengeRequests(player)
	for guid, challengeRequestData in pairs(pendingChallenge_guids) do
		if challengeRequestData.challenger == player or challengeRequestData.playerChallenged == player then
			pendingChallenge_guids[guid] = nil
		end
	end
end

local function playerRequest_acceptChallengeRequest(player, guid)
	
	if pendingChallenge_guids[guid] then
		-- cancel all current trades involving player except for this trade.
		local challengeRequestData = pendingChallenge_guids[guid]
		
		clearPreviousChallengeRequests(challengeRequestData.challenger)
		clearPreviousChallengeRequests(challengeRequestData.playerChallenged)
		
		
		-- INVALIDATE THE GUI
		pendingChallenge_guids[guid] = nil
		
		if not challengeRequestData.challenger.Parent or not challengeRequestData.playerChallenged.Parent then
			return false
		end 
		
		if challengeRequestData.wager then
			-- ensure they both have the gold to do the challenge
			local playerData_challenger 		= network:invoke("getPlayerData", challengeRequestData.challenger)
			local playerData_playerChallenged 	= network:invoke("getPlayerData", challengeRequestData.playerChallenged)
			if playerData_challenger.gold < challengeRequestData.wager or playerData_playerChallenged.gold < challengeRequestData.wager then
				return false
			end
		end
		
		-- do something INSANE!!!!!!!!!!!!!!!!!!!!!!!!!!! (let them fight!)
		network:invoke("requestPVPWhitelistPlayer_server", challengeRequestData.challenger, challengeRequestData.playerChallenged)
		network:invoke("requestPVPWhitelistPlayer_server", challengeRequestData.playerChallenged, challengeRequestData.challenger)
		
		network:fireClient("alertPlayerNotification", challengeRequestData.challenger, {text = "Your challenge with " .. challengeRequestData.playerChallenged.Name .. " was accepted, FIGHT!"})
		network:fireClient("alertPlayerNotification", challengeRequestData.playerChallenged, {text = "You've accepted " .. challengeRequestData.challenger.Name .. "'s challenge! Fight!"})
		
		return true
	end
	
	return false, "invalid or inactive guid"
end

local invitationCD = {}
local function playerRequest_requestChallenge(challenger, playerChallenged, wager)
	if challenger and playerChallenged and challenger ~= playerChallenged and (not wager or (type(wager) == "number" and wager > 0)) then		
		if true then
			if not invitationCD[challenger] or (tick() - invitationCD[challenger] > 3) then
				invitationCD[challenger] = tick()
				
				local guid = httpService:GenerateGUID(false)
				
				local challengeRequestData = {
					challenger 			= challenger;
					playerChallenged 	= playerChallenged;
					wager 				= wager;
				}
				
				pendingChallenge_guids[guid] = challengeRequestData
				
				-- under some circumstances, duel requests are accepted instantly
				if (game.PlaceId == 4653017449) or (game.PlaceId == 2061558182) then
					local guildId = game.ReplicatedStorage:FindFirstChild("guildId")
					if guildId then
						guildId = guildId.Value
						
						local challengerGuildId = challenger:FindFirstChild("guildId")
						local challengedGuildId = playerChallenged:FindFirstChild("guildId")
						if challengerGuildId and challengedGuildId then
							if challengerGuildId.Value == guildId then
								if challengedGuildId.Value == guildId then
									-- compare ranks
									local challengerData = network:invoke("getGuildMemberData", challenger, guildId)
									local challengedData = network:invoke("getGuildMemberData", playerChallenged, guildId)
									if
										challengerData and
										challengedData and
										challengerData.rank and
										challengedData.rank and
										network:invoke("getRankNumberFromRank", challengerData.rank) > network:invoke("getRankNumberFromRank", challengedData.rank)
									then
										-- a member of this guild has challenged a lower-ranked member of this guild to a duel, instantly accept
										playerRequest_acceptChallengeRequest(playerChallenged, guid)
										return true
									end
								else
									-- a member of this hall has challenged a non-member, instantly accept
									playerRequest_acceptChallengeRequest(playerChallenged, guid)
									return true
								end
							end
						elseif challengerGuildId and (not challengedGuildId) then
							if challengerGuildId.Value == guildId then
								-- a member of this hall has challenged a non-member, instantly accept
								playerRequest_acceptChallengeRequest(playerChallenged, guid)
								return true
							end
						end
					end
				end
				
				network:fireClient("signal_playerChallengeRequest", playerChallenged, challenger, guid)
				
				return true
			else
				return false, "stop sending challenges too fast"
			end
		end
	elseif challenger == playerChallenged then
		return false, "you can't challenge yourself."
	end
	
	return false, "invalid request"
end
		
local function onPlayerCharacterDied(player)
	local playerData = network:invoke("getPlayerData", player)
	
	if playerData then
		for i, whitelistPVPPlayer in pairs(playerData.nonSerializeData.whitelistPVPEnabled) do
			network:invoke("revokePVPWhitelistPlayer_server", player, whitelistPVPPlayer)
			network:invoke("revokePVPWhitelistPlayer_server", whitelistPVPPlayer, player)
		end
	end
end

local function main()
	network:create("playerRequest_requestChallenge", "RemoteFunction", "OnServerInvoke", playerRequest_requestChallenge)
	network:create("playerRequest_acceptChallengeRequest", "RemoteFunction", "OnServerInvoke", playerRequest_acceptChallengeRequest)
	
	network:create("signal_playerChallengeRequest", "RemoteEvent")
	network:create("signal_playerChallengeState", "RemoteEvent")
	
	network:connect("playerCharacterDied", "Event", onPlayerCharacterDied)
end

main()

return module