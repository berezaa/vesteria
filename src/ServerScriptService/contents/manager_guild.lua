local module = {}

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local network

module.priority = 3

local guildRankValues = {
    member = 1;
    officer = 2;
    general = 3;
    leader = 4;
}

local function getRankNumberFromRank(rank)
	return guildRankValues[rank]
end


local DATA_MODIFY_COOLDOWN = 5

local guildNameStore = game:GetService("DataStoreService"):GetDataStore("guildNames")

local guildPurchases = 	{
	createGuild = 1e6;
	level = {
		[1] = {
			members = 10;
		};
		[2] = {
			members = 20;
			cost = 10e6,
		};
		[3] = {
			members = 40;
			cost = 100e6,
		};
		[4] = {
			members = 80;
			cost = 1e9,
		};
		[5] = {
			members = 140;
			cost = 10e9,
		}
	}
};

local guildDataFolder = Instance.new("Folder")
guildDataFolder.Name = "guildDataFolder"
guildDataFolder.Parent = game.ReplicatedStorage

local messagingService = game:GetService("MessagingService")


local guildDataCache = {}
local guildMessagingConnections = {}

--[[
	sendGuildMessage(guid, {
		messageType = "data_update";
		key = key;
		value = value;
		sender = player.Name;
		senderId = player.userId;
	})
]]

-- Update cache and replicated storage entry with new data.


local function guildDataUpdated(guid, guildDataEntry)
	guildDataCache[guid] = guildDataEntry
	local dataFolderEntry = guildDataFolder:FindFirstChild(guid)
	if dataFolderEntry == nil then
		dataFolderEntry = Instance.new("StringValue")
		dataFolderEntry.Name = guid
		dataFolderEntry.Parent = guildDataFolder
	end
	dataFolderEntry.Value = HttpService:JSONEncode(guildDataEntry)
	for i,player in pairs(game.Players:GetPlayers()) do
		if player:FindFirstChild("guildId") and player.guildId.Value == guid then
			network:fireClient("signal_guildDataUpdated", player, guildDataEntry)
		end
	end
end

local function guildMessageRecieved(guid, message)
	local data = message.Data
	local timestamp = message.Sent
	-- Message to guild members.
	if data.messageType == "chat" then
		local sender = data.sender
		local message = data.message

		for i,player in pairs(game.Players:GetPlayers()) do
			if player:FindFirstChild("guildId") and player.guildId.Value == guid then
				local chatMessage = "[Guild] " .. sender .. ": "..data.message
				network:fireClient("signal_alertChatMessage", player, {Text = chatMessage; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(160, 116, 255)} )
			end
		end
	elseif data.messageType == "data_update" then
		local guildData = guildDataCache[guid]
		if guildData then
			guildData.lastUpdated = timestamp
			guildData[data.key] = data.value
			guildDataUpdated(guid, guildData)
		end

    elseif data.messageType == "member_data" then
        -- soft update for things like leveling up, changing class
		local guildData = guildDataCache[guid]
        if guildData then
            local userId = data.userId
            guildData.members[tostring(userId)] = data.memberData
            guildDataUpdated(guid, guildData)
        end
	end
	-- allow an optional notice to all guild members via chat
	if data.notice then
		local sender = data.sender or "???"
		-- "Out" means don't include the message on the server that sent it
		-- (for level up message)
		if game.Players:FindFirstChild(sender) == nil or not data.notice.Out then
			if data.notice.Color then
				data.notice.Color = Color3.fromRGB(data.notice.Color.r, data.notice.Color.g, data.notice.Color.b)
			end
			for i,player in pairs(game.Players:GetPlayers()) do
				if player:FindFirstChild("guildId") and player.guildId.Value == guid then

					-- data.notice: {Text = chatMessage; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(145, 71, 255)}
					network:fireClient("signal_alertChatMessage", player, data.notice)
				end
			end
		end
	end
end

-- Send a message via messaging service.
local function sendGuildMessage(guid, messageData)
	local messageSuccess, messageError = pcall(function()
		messagingService:PublishAsync("guild-"..guid, messageData)
	end)
	return messageSuccess, messageError
end

local function sendGuildChat(player, message)
	local guildId = player:FindFirstChild("guildId") and player.guildId.Value
	if guildId and guildId ~= "" then
		local filteredText
		local filterSuccess, filterError = pcall(function()
			filteredText = game.Chat:FilterStringForBroadcast(message, player)
		end)
		if not filterSuccess then
			return false, "filter error: "..filterError
		elseif #filteredText > 200 then
			return false, "Message may not be longer than 200 characters."
		elseif #filteredText < 2 then
			return false, "Message must be at least 2 characters long"
		end
		return sendGuildMessage(guildId, {
			messageType = "chat";
			sender = player.Name;
			senderId = player.userId;
			message = filteredText;
		})
	else
		return false, "You're not in a guild!"
	end
end

-- Used to add/remove a player from a guild.
local function setPlayerGuildId(player, guildId)
	if player:FindFirstChild("guildId") then
		player.guildId.Value = guildId or ""
	end
	local guildFounderData = network:invoke("getPlayerData", player)
	if guildFounderData and guildFounderData.globalData then
		guildFounderData.globalData.guildId = guildId
		guildFounderData.nonSerializeData.setPlayerData("globalData", guildFounderData.globalData)
	end
end

-- Fetches guild data, returns cache data if available.
local function getGuildData(player, guid)
	if guid == "" then
		return nil
	end
	local guildDataEntry = guildDataCache[guid]
	if guildDataEntry then
		return guildDataEntry
	else
		local guildDataStore = game:GetService("DataStoreService"):GetDataStore("guild", guid)
		local dataSuccess, dataError = pcall(function()
			guildDataEntry = guildDataStore:GetAsync("guildData")
		end)
		if dataSuccess then
			if guildDataEntry then
				-- if this guild no longer has me as a member, purge my id
				local members = guildDataEntry.members
				if members and (not members[tostring(player.UserId)]) then
					setPlayerGuildId(player, nil)
					return nil
				end

				-- okay, we're good to go, return properly
				guildDataUpdated(guid, guildDataEntry)
				return guildDataEntry
			else
				-- guild no longer exists, purge my id
				setPlayerGuildId(player, nil)
				return nil
			end
		else
			network:invoke("reportError", player, "warning", "Guild Get Fail: ".. (dataError or "???"))
		end
	end
end

local function playerRequest_getGuildData(requestingPlayer, player)
	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId found."
	end
	return getGuildData(player, guildId.Value)
end



-- Fetches a player's data entry within a guild, if it exists
local function getGuildPlayerData(player, guid)
--[[
	userId = partyMemberPlayer.userId;
	level = partyMemberPlayer.level.Value;
	class = partyMemberPlayer.class.Value;
	rank = (partyMemberData.isLeader and "leader") or "member";
	founder = true;
	points = 0;
]]
	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "Guild data not found."
	end
	local members = guildData.members
	local guildPlayerData = members[tostring(player.userId)]
	if guildPlayerData == nil then
		return false, "Not a member of guild."
	end
	return guildPlayerData
end


local function playerRequest_getGuildMemberData(requestingPlayer, player)
	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId found."
	end
	return getGuildPlayerData(player, guildId.Value)
end


-- Master function used for donating to the guild, other actions
local function modifyGuildDataValue(player, guid, action, key, value, atomic, notice)
	action = action or "set"
	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "No guild data."
	end
	if os.time() - guildData.lastModified >= DATA_MODIFY_COOLDOWN then
		local guildDataStore = game:GetService("DataStoreService"):GetDataStore("guild", guid)
		local canceledReason
		local dataSuccess, dataError = pcall(function()
			guildDataStore:UpdateAsync("guildData", function(existingData)
                if atomic then
 --                   if guildData.lastModified == existingData.lastModified then
                        -- allow messagingService "soft updates" to sneak in through here
						guildData.lastModified = os.time()
                        existingData = guildData

 --                   else
 --                       canceledReason = "Atomic transaction out of sync"
 --                       return nil
 --                   end
				end
				if action == "increment" then
					existingData[key] = (existingData[key] or 0) + value
				elseif action == "set" then
					existingData[key] = value
				else
					canceledReason = "Invalid operation"
					return nil
				end
				guildDataUpdated(guid, existingData)
				return existingData
			end)
		end)
		if not dataSuccess then
			network:invoke("reportError", player, "warning", "Failed to update guild value: "..dataError)
			return false, "DataStore error"
		elseif canceledReason then
			return false, canceledReason
		else
			return true, "Success!"
		end
	else
		return false, "Try again later."
	end
end


-- Removes guild data cache and closes subscriptions.
local function unsubscribeGuildData(guid)
	guildDataCache[guid] = nil
	if guildMessagingConnections[guid] then
		guildMessagingConnections[guid]:Disconnect()
		guildMessagingConnections[guid] = nil
	end
	local dataFolderEntry = guildDataFolder:FindFirstChild(guid)
	if dataFolderEntry then
		dataFolderEntry:Destroy()
	end
end

-- Build a subscription for a guild.
local function subscribeGuild(guid)
	if guildMessagingConnections[guid] then
		return false, "Guild subscription already exists."
	end
	if guildDataCache[guid] == nil then
		return false, "Guild data does not exist."
	end

	local subscribeSuccess, subscribeError = pcall(function()
		local subscription = messagingService:SubscribeAsync("guild-"..guid, function(message)
			guildMessageRecieved(guid, message)
		end)
		guildMessagingConnections[guid] = subscription
	end)

	if subscribeSuccess then
		return true, "Subscribed!"
	else
		return false, subscribeError
	end
end



-- Fires whenever a player joins or leaves the server or a guild, used to subscribe/unsubscribe.
local function playerGuildChanged(player, guid)

	local activeGuilds = {}
	if guid then
		activeGuilds[guid] = true
	end

	-- Player needs a guild but guild data is not active?
	if guid and not guildDataCache[guid] then
		getGuildData(player, guid)
	end

	-- Cycle through all other players and see which guilds are active.
	for i, otherPlayer in pairs(game.Players:GetPlayers()) do
		if otherPlayer ~= player  and otherPlayer:FindFirstChild("teleporting") == nil and otherPlayer:FindFirstChild("DataSaveFailed") == nil then
			local guildTag = otherPlayer:FindFirstChild("guildId")
			if guildTag and guildTag.Value ~= "" then
				activeGuilds[guildTag.Value] = true
			end
		end
	end
	-- Cycle through guild cache and remove subscriptions for un-used guilds.
	for guildId, guildData in pairs(guildDataCache) do
		if not activeGuilds[guildId] then
			unsubscribeGuildData(guildId)
		end
	end
	-- Cycle through active guilds and build subscription for any guilds not yet initiated.
	for guildId, active in pairs(activeGuilds) do
		if active and guildMessagingConnections[guildId] == nil then
			-- Check to confirm cached data exists (it should!)
			local guildData = guildDataCache[guildId]
			if guildData then
				local subscriptionSuccess, subscriptionError = subscribeGuild(guid)
				if not subscriptionSuccess then
					network:invoke("reportError", player, "warning", "Failed to build guild subscription: "..subscriptionError)
				end
			else
				network:invoke("reportError", player, "critical", "Attempt to build subscription for guild with no data!")
				return
			end
		end
	end
end

-- Slap 'em with that guildId tag
local function onPlayerAdded(player)
	if player:FindFirstChild("guildId") == nil then
		local guildTag = Instance.new("StringValue")
		guildTag.Name = "guildId"
		guildTag.Parent = player
	end
end
for i,player in pairs(game.Players:GetPlayers()) do
	onPlayerAdded(player)
end
game.Players.PlayerAdded:connect(onPlayerAdded)

local function onPlayerLoaded(player, playerData)
	-- Tag the player's guild so others can see it.
	local guildTag = player.guildId

	local globalData = playerData.globalData
	if globalData and globalData.guildId then
		local guid =  globalData.guildId
		local guildData = getGuildData(player, guid)

		if guildData then
			-- Check that the player is still a member of the guild.
			if guildData.members[tostring(player.userId)] then
				guildTag.Value = guid
				playerGuildChanged(player, guid) -- The Msg. subscription isn't made until this point.
			else
				-- Removed from guild.
				local updatedPlayerData = network:invoke("getPlayerData", player)
				if updatedPlayerData.globalData then
					updatedPlayerData.globalData.guildId = nil
					updatedPlayerData.nonSerializeData.setPlayerData("globalData", updatedPlayerData.globalData)
				end
				network:fireClient("alertPlayerNotification", player, {text = "You were removed from your guild."; textColor3 = Color3.fromRGB(255, 57, 60)}, 10)
				playerGuildChanged(player, nil)
			end
		end
    end
    -- hook up some connections
    player.level.Changed:connect(function()
        local guid = player.guildId.Value
        if guid ~= "" then
            local guildData = getGuildData(player, guid)
            if guildData then
                local guildMemberData = guildData.members[tostring(player.userId)]
                if guildMemberData then
                    guildMemberData.level = player.level.Value
					guildMemberData.lastUpdate = os.time();
                    local notice = {Text = player.Name .. " has reached Lvl."..player.level.Value.."!"; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}; Out = true}

					sendGuildMessage(guid, {
                        messageType = "member_data";
                        memberData = guildMemberData;
                        sender = player.Name;
                        senderId = player.userId;
                        notice = notice;
                    })
                end
            end
        end
    end)
    player.class.Changed:connect(function()
        local guid = player.guildId.Value
        if guid ~= "" then
            local guildData = getGuildData(player, guid)
            if guildData then
                local guildMemberData = guildData.members[tostring(player.userId)]
                if guildMemberData then
                    guildMemberData.class = player.class.Value
                    local notice = {Text = player.Name .. " has become a "..player.class.Value.."!"; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}}
                    sendGuildMessage(guid, {
                        messageType = "member_data";
                        memberData = guildMemberData;
                        sender = player.Name;
                        senderId = player.userId;
                        notice = notice;
                    })
                end
            end
        end
    end)
end


local function onPlayerRemoving(player)
	playerGuildChanged(player, nil)
end
game.Players.PlayerRemoving:connect(onPlayerRemoving)

-- Creating a guild.
local function playerRequest_createGuild(player, properties)
	local playerData = network:invoke("getPlayerData", player)
	if playerData == nil then
		return false, "no player data."
	end
	local globalData = playerData.globalData
	if globalData == nil then
		return false, "no global data."
	end

	local isStudio = game:GetService("RunService"):IsStudio()

	-- davidii doesn't think this is necessary a'ight? who cares if they make a lot of guilds
--	if globalData.lastCreatedGuild and (os.time() - globalData.lastCreatedGuild <= 60 * 60 * 48) and (not isStudio) then
--		return false, "You must wait 48 hours before founding a new guild."
--	end

	if player:FindFirstChild("teleporting") or player:FindFirstChild("DataSaveFail") then
		return false, "There is an issue accessing your data, please try again later."
	end

	if globalData.guildId then
		return false, "Already in a guild."
	end

	local partyData = network:invoke("getPartyDataByPlayer", player)
	if partyData == nil then
		return false, "Only the leader of a full party can found a guild."
	end

	local numPlayers = 0

	local guildFounders = {}

	for i, partyMemberData in pairs(partyData.members) do
		numPlayers = numPlayers + 1
		local partyMemberPlayer = partyMemberData.player
		local partyMemberPlayerData = network:invoke("getPlayerData", partyMemberPlayer)
		if partyMemberPlayerData == nil or partyMemberPlayerData.globalData == nil then
			return false, "A player in your party is missing data."
		elseif partyMemberPlayerData.globalData.guildId then
			return false, "A player in your party is already in a guild."
		elseif partyMemberData.isLeader and partyMemberPlayer ~= player then
			return false, "Only the leader of a full party can found a guild."
		elseif partyMemberPlayer.level.Value < 10 then
			return false, "All players in your party must be at least Lvl. 10 to found a guild."
		end
		guildFounders[tostring(partyMemberPlayer.userId)] = {
            lastUpdate = os.time();
			name = partyMemberPlayer.Name;
			userId = partyMemberPlayer.userId;
			level = partyMemberPlayer.level.Value;
			class = partyMemberPlayer.class.Value;
			rank = (partyMemberData.isLeader and "leader") or "member";
			founder = true;
			points = 0;
		}
	end

	if (numPlayers ~= 6) and (not isStudio) then
		return false, "There must be exactly six members in your party to found a guild."
	end

	local guildCreationCost = guildPurchases.createGuild

	if playerData.gold >= guildCreationCost then

		local guildId = HttpService:GenerateGUID(false)


		-- Run the desired guild name through the Roblox Filter.
		local desiredGuildName = properties.name
		if properties.name == nil then
			return false, "No guild name provided."
		elseif typeof(properties.name) ~= "string" then
			return false, "Guild name must be a string."
		end
		local filteredText
		local filterSuccess, filterError = pcall(function()
			filteredText = game.Chat:FilterStringForBroadcast(desiredGuildName, player)
		end)
		if not filterSuccess then
			return false, "filter error: "..filterError
		elseif not filteredText or string.find(filteredText, "#") then
			return false, "Guild name rejected by Roblox filter."
		elseif #filteredText > 20 then
			return false, "Guild name must be no more than 20 characters long."
		elseif #filteredText < 3 then
			return false, "Guild name must be at least 3 characters long."
		end

		-- Check the guild name database(TM) for a conflict.
		local isNameTaken
		local nameCheckSuccess, nameCheckError = pcall(function()
			isNameTaken = guildNameStore:GetAsync(filteredText)
		end)
		if not nameCheckSuccess then
			network:invoke("reportError", player, "warning", "Guild namestore fail: ".. (nameCheckError or "???"))
			return false, "Guild name lookup failed due to DataStore error."
		elseif isNameTaken then
			return false, "That Guild name is already taken."
		end
		local guildName = filteredText

		-- now we jump into the meat.
		local guildDataStore = game:GetService("DataStoreService"):GetDataStore("guild", guildId)
		local abortDueToExistingData
		local guildData
		local guildSuccessfullyCreated

		-- oopsies required from here on out.
		local function applyGuildIdToFounders(guildIdToApply)
			for userId, userData in pairs(guildFounders) do
				local guildFounder = game.Players:GetPlayerByUserId(tonumber(userId))
				if guildFounder and guildFounder.Parent then
					setPlayerGuildId(guildFounder, guildIdToApply)
				end
			end
		end

		-- apply guild membership to all other users (this happens before yielding update async - may cause problems).
		applyGuildIdToFounders(guildId)
		local dataSuccess, dataError = pcall(function()
			guildDataStore:UpdateAsync("guildData", function(existingData)
				-- In the astronomically rare chance a guild with this data already exists.
				if existingData ~= nil then
					abortDueToExistingData = true
					return nil
				end
				-- We're good.

				guildData = {
					name = guildName;
					previousNames = {};
					members = guildFounders;
					lastModified = os.time();
					id = guildId;
					version = 1;

					level = 1;
					points = 0;
					bank = 0;
				}

				-- we did it!.
				guildSuccessfullyCreated = true

				return guildData
			end)
		end)
		if not dataSuccess then
			network:invoke("reportError", player, "warning", "Guild DataStore fail: ".. (dataError or "???"))
			applyGuildIdToFounders(nil) -- oopsie!
			return false, "DataStore failure!"
		elseif abortDueToExistingData then
			applyGuildIdToFounders(nil) -- oopsie!
			return false, "Guild ID already exists!"
		end

		-- final stretch.
		if guildSuccessfullyCreated then
			local globalData = playerData.globalData
			if globalData == nil or player.Parent == nil or player:FindFirstChild("teleporting") or player:FindFirstChild("DataSaveFail") then
				applyGuildIdToFounders(nil) -- oopsie!
				return false, "Issue with founder data"
			end

			-- take money and apply guild leader data.
			globalData.lastCreatedGuild = os.time()
			playerData.nonSerializeData.incrementPlayerData("gold",-guildCreationCost,"guild:create")
			globalData.guildId = guildId
			playerData.nonSerializeData.setPlayerData("globalData", globalData)

			-- run some really scary code that claims the guild name.
			spawn(function()
				local i = 1
				local guildNameClaimed
				local guildNameClaimError
				repeat
					local guildSuccess, guildError = pcall(function()
						guildNameStore:SetAsync(filteredText, true)
					end)
					if guildSuccess then
						guildNameClaimed = true
					else
						network:invoke("reportError", player, "warning", "Guild name claim fail: ".. (guildError or "???"))
						wait(2^i)
					end
				until guildNameClaimed
			end)

			playerGuildChanged(player, guildId)

			-- we did it guys.
			return true, "A new guild has been born!"
		else
			applyGuildIdToFounders(nil) -- oopsie!
			return false, "Guild failed to be created for some reason"
		end


	else
		return false, "You don't have enough money to found a guild."
	end
end

local pendingGuildInvites = {}


local function playerRequest_invitePlayerToGuild(player, invitedPlayer)
	if invitedPlayer.guildId.Value ~= "" then
		return false, "Player is already in a guild."
	end
	local guid = player.guildId.Value
	local guildPlayerData = getGuildPlayerData(player, guid)
	if guildPlayerData == nil then
		return false, "Could not find your guild."
	elseif guildPlayerData.rank ~= "leader" and guildPlayerData.rank ~= "officer" and guildPlayerData.rank ~= "general" then
		return false, "You do not have permission to invite new members."
	end

	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "Could not find guild data."
	end

	local memberCap = guildPurchases.level[guildData.level].members
	local existingMembers = 0
	for userId, userData in pairs(guildData.members) do
		existingMembers = existingMembers + 1
	end
	if existingMembers >= memberCap then
		return false, "Your guild is already at full capacity."
	end

	local playerResponse = network:invokeClient("serverPrompt_playerInvitedToServer", invitedPlayer, player, guid)
	if playerResponse then
		-- check nothing changed
		if player and player.Parent and invitedPlayer and invitedPlayer.Parent and invitedPlayer.guildId.Value == "" then
			local guildData = getGuildData(player, guid)
			local guildPlayerData = getGuildPlayerData(player, guid)
			if guildData and guildPlayerData then
				-- add player to the guild
				local guildMembers = guildData.members
				-- failsafe to allow someone to be re-invited if their lost their guild id for whatever reason
				guildMembers[tostring(invitedPlayer.userId)] = guildMembers[tostring(invitedPlayer.userId)] or {
                    lastUpdate = os.time();
					name = invitedPlayer.Name;
					userId = invitedPlayer.userId;
					level = invitedPlayer.level.Value;
					class = invitedPlayer.class.Value;
					rank = "member";
					points = 0;
				}
				local notice = {Text = invitedPlayer.Name .. " has joined the Guild. (Invited by "..player.Name..")"; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}}
				local success, reason = modifyGuildDataValue(player, guid, "set", "members", guildMembers, true, notice)
				if success then

					sendGuildMessage(guid, {
			            messageType = "member_data";
			            memberData = guildMembers[tostring(invitedPlayer.userId)];
			            sender = player.Name;
			            senderId = player.userId;
			            notice = notice;
			        })

					setPlayerGuildId(invitedPlayer, guid)
					guildDataUpdated(guid, guildData)
				end
				return success, reason

			end
		else
			return false, "Something changed during the player input and they can no longer be added."
		end
	else
		return false, "Player did not accept the guild invite."
	end
end


local function playerRequest_exileUserIdFromGuild(player, exiledUserId)
	local guid = player.guildId.Value
	local guildPlayerData = getGuildPlayerData(player, guid)
	if not guildPlayerData then
		return false, "Could not find your guild."
	end

	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "Guild data not found"
	end

    local exiledGuildPlayerData = guildData.members[tostring(exiledUserId)]
    if exiledGuildPlayerData == nil then
        return false, "Player is not in your guild."
    end

    local exiledUsername = exiledGuildPlayerData.name
    local playerGuildRankValue = guildRankValues[guildPlayerData.rank]
    local exiledGuildRankValue = guildRankValues[exiledGuildPlayerData.rank]

    if playerGuildRankValue <= exiledGuildRankValue then
        return false, "You cannot exile someone who does not rank beneath you."
    elseif exiledGuildPlayerData.founder and guildPlayerData.rank ~= "leader" then
        return false, "Only the leader can exile a founding member."
    end

    local guildMembers = guildData.members
    guildMembers[tostring(exiledUserId)] = nil;
    local notice = {Text = exiledUsername .. " has been exiled from the guild by "..player.Name.."!"; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}}
    local success, reason = modifyGuildDataValue(player, guid, "set", "members", guildMembers, true, notice)
    if success then
        local exiledPlayer = game.Players:GetPlayerByUserId(exiledUserId)
        -- ez boot if they are in the same server.
        if exiledPlayer then
            setPlayerGuildId(exiledPlayer, nil)
        end

        -- booted
		sendGuildMessage(guid, {
            messageType = "member_data";
            memberData = nil;
            sender = player.Name;
            senderId = player.userId;
            notice = notice;
        })
		guildDataUpdated(guid, guildData)
        return true, "Successfully exiled player."
    else
        return false, "Failed to exile: "..reason
    end
end


local function abandonGuild(player, guid)
	local success, problem = pcall(function()
		setPlayerGuildId(player, nil)
		local guildDataStore = game:GetService("DataStoreService"):GetDataStore("guild", guid)
		local guildData = guildDataStore:RemoveAsync("guildData")
		guildNameStore:RemoveAsync(guildData.name)
	end)
	return success, problem
end

local function playerRequest_leaveMyGuild(player, confirmAbandon)
	local guid = player.guildId.Value
	local guildPlayerData = getGuildPlayerData(player, guid)
	if guildPlayerData == nil then
		return false, "Could not find your guild."
	end

	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "Guild data not found"
	end

	if guildPlayerData.rank == "leader" then
		local memberCount = 0
		for _, member in pairs(guildData.members) do
			memberCount = memberCount + 1
		end

		if memberCount > 1 then
			return false, "If you wish to abandon your guild, you must first exile all other members."
		end

		if confirmAbandon then
			return abandonGuild(player, guid)
		end

		return false, "confirmAbandon"
	end

	local exiledUserId = player.userId
    local guildMembers = guildData.members
    guildMembers[tostring(exiledUserId)] = nil;
    local notice = {Text = player.Name .. " has left the guild."; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}}
    local success, reason = modifyGuildDataValue(player, guid, "set", "members", guildMembers, true, notice)
    if success then

		-- alert other servers that the guild has been left
		sendGuildMessage(guid, {
            messageType = "member_data";
            memberData = nil;
            sender = player.Name;
            senderId = player.userId;
            notice = notice;
        })

        setPlayerGuildId(player, nil)
		guildDataUpdated(guid, guildData)
        return true, "Successfully left the guild."
    else
        return false, "Failed to leave: "..reason
    end
end

local function playerRequest_changeUserIdRankValue(player, rankedUserId, newRankValue)
    local guid = player.guildId.Value
	local guildPlayerData = getGuildPlayerData(player, guid)
	if not guildPlayerData then
		return false, "Could not find your guild."
	end

	local guildData = getGuildData(player, guid)
	if guildData == nil then
		return false, "Guild data not found"
	end

    local rankedGuildPlayerData = guildData.members[tostring(rankedUserId)]
    if rankedGuildPlayerData == nil then
        return false, "Player is not in your guild."
    end
    local rankedUsername = rankedGuildPlayerData.name
    local playerGuildRankValue = guildRankValues[guildPlayerData.rank]
    local rankedGuildRankValue = guildRankValues[rankedGuildPlayerData.rank]
	local isChangingLeaders = (playerGuildRankValue == 4) and (newRankValue == 4)
    if (newRankValue >= playerGuildRankValue) and (not isChangingLeaders) then
        return false, "You cannot rank someone to a rank that is not beneath you."
    elseif rankedGuildRankValue >= playerGuildRankValue then
        return false, "You cannot change the rank of someone who does not rank beneath you."
    end

    local newRank = "member"
    for rankName, rankValue in pairs(guildRankValues) do
        if newRankValue == rankValue then
            newRank = rankName
        end
    end

    local guildMembers = guildData.members
    guildMembers[tostring(rankedUserId)].rank = newRank
	local notice = {Text = rankedUsername .. "'s rank has been changed to "..newRank.." by "..player.Name.."."; Font = "SourceSansBold"; Color = {r=161, g=132, b=194}}

	if isChangingLeaders then
		guildMembers[tostring(player.UserId)].rank = 3
		notice.Text = player.Name.." has stepped down as leader, appointing "..rankedUsername.." as the new leader!"
	end

    local success, reason = modifyGuildDataValue(player, guid, "set", "members", guildMembers, true, notice)
    if success then
		guildDataUpdated(guid, guildData)

		-- tell other servers about the promotion
		sendGuildMessage(guid, {
            messageType = "member_data";
            memberData = guildMembers[tostring(rankedUserId)];
            sender = player.Name;
            senderId = player.userId;
            notice = notice;
        })

        return true, "Successfully ranked player."
    else
        return false, "Failed to rank: "..reason
    end
end


local guildHallPlaceId = 4653017449

local hallLocationsByPlaceId = {
	[2064647391] = "mushtown",
	[2119298605] = "nilgarf",
	[2470481225] = "warriorStronghold",
	[3112029149] = "treeOfLife",
	[2546689567] = "portFidelio",
}
local properNamesByHallLocation = {
	["mushtown"] = "Mushtown",
	["nilgarf"] = "Nilgarf",
	["warriorStronghold"] = "Warrior Stronghold",
	["treeOfLife"] = "Tree of Life",
	["portFidelio"] = "Port Fidelio",
}

local function getHallLocationFromPlaceId()
	return hallLocationsByPlaceId[game.PlaceId]
end

local function getPlaceIdFromHallLocation(hallLocationIn)
	for placeId, hallLocation in pairs(hallLocationsByPlaceId) do
		if hallLocation == hallLocationIn then
			return placeId
		end
	end
	return nil
end

local function playerRequest_getPlaceIdFromHallLocation(player, hallLocation)
	return getPlaceIdFromHallLocation(hallLocation)
end


local function resetGuildHallServer()
	-- TODO: broadcast a message which boots everyone from guild hall in event of update, move, etc.
end

local function changeGuildHallLocation(player)
	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId."
	end
	local guid = guildId.Value

	local guildData = getGuildData(player, guid)
	if not guildData then
		return false, "No guildData."
	end

	local memberData = getGuildPlayerData(player, guid)
	if not memberData then
		return false, "No memberData."
	end

	if memberData.rank ~= "leader" then
		return false, "Not leader."
	end

	local hallLocation = getHallLocationFromPlaceId()
	if not hallLocation then
		return false, "No guild hall at this location."
	end

	local notice
	if guildData.hallLocation then
		notice = {Text = "The Guild Hall has been moved from "..properNamesByHallLocation[guildData.hallLocation].." to "..properNamesByHallLocation[hallLocation].."!"}
	else
		notice = {Text = "The Guild Hall has been established at "..properNamesByHallLocation[hallLocation].."!"}
	end
	notice.Font = "SourceSansBold"
	notice.Color = {r = 161, g = 132, b = 194}

	local hallServerId = TeleportService:ReserveServer(guildHallPlaceId)
	local serverIdSuccess, serverIdProblem = modifyGuildDataValue(player, guid, "set", "hallServerId", hallServerId, false)
	if not serverIdSuccess then
		return false, serverIdProblem
	end

	local success, reason = modifyGuildDataValue(player, guid, "set", "hallLocation", hallLocation, false, notice)
	if success then
		sendGuildMessage(guid, {
			messageType = "data_update",
			key = "hallLocation",
			value = hallLocation,
			sender = player.Name,
			senderId = player.userId,
			notice = notice,
		})

		resetGuildHallServer()

		return true, ""
	else
		return false, reason
	end
end

local function getGuildUpgradeCost(player)
	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return nil, "No guildId."
	end
	local guid = guildId.Value

	local guildData = getGuildData(player, guid)
	if not guildData then
		return nil, "No guildData."
	end

	local nextLevel = guildData.level + 1
	if guildPurchases.level[nextLevel] then
		return guildPurchases.level[nextLevel].cost, ""
	else
		return nil, "No next level."
	end
end

local function upgradeGuild(player)
	if (game.PlaceId ~= 2546689567) and (game.PlaceId ~= 2061558182) and (game.PlaceId ~= 3372071669) then
		return false, "Not in Port Fidelio."
	end

	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId."
	end
	local guid = guildId.Value

	local guildData = getGuildData(player, guid)
	if not guildData then
		return false, "No guildData."
	end

	local memberData = getGuildPlayerData(player, guid)
	if not memberData then
		return false, "No memberData."
	end

	if memberData.rank ~= "leader" then
		return false, "Not leader."
	end

	local upgradeCost, reason = getGuildUpgradeCost(player)
	if not upgradeCost then
		return false, reason
	end

	if guildData.bank < upgradeCost then
		return false, "Not enough funds in guild bank."
	end

	-- customized logic here since I don't want to do two separate update calls
	local guildDataStore = game:GetService("DataStoreService"):GetDataStore("guild", guid)
	local dataSuccess, dataError = pcall(function()
		guildDataStore:UpdateAsync("guildData", function(data)
			if not data then return end
			if not data.level then return end
			if not data.bank then return end

			if data.bank < upgradeCost then return end

			data.bank = data.bank - upgradeCost
			data.level = data.level + 1

			guildDataUpdated(guid, data)
			return data
		end)
	end)
	if not dataSuccess then
		network:invoke("reportError", player, "warning", "Failed to upgrade guild level: "..dataError)
		return false, "DataStore error"
	end

	return true, ""
end

local function donateToGuild(player, amount)
	if typeof(amount) ~= "number" then
		return false, "Trying to donate not a number."
	end
	amount = math.floor(amount)

	if amount < 0 then
		return false, "Trying to donate a negative number."
	end

	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId."
	end
	local guid = guildId.Value

	local guildData = getGuildData(player, guid)
	if not guildData then
		return false, "No guildData."
	end

	local playerData = network:invoke("getPlayerData", player)
	if not playerData then
		return false, "No playerData."
	end

	if playerData.gold < amount then
		return false, "Not enough gold."
	end

	playerData.nonSerializeData.incrementPlayerData("gold", -amount, "guild:donate")
	local success, reason = modifyGuildDataValue(player, guid, "increment", "bank", amount, true)
	if not success then
		playerData.nonSerializeData.incrementPlayerData("gold", amount, "guild:donateFailed")
		return false, reason
	end

	return true, ""
end

local function teleportPlayersToGuildHall(players, guid)
	local leadPlayer = players[1]
	local guildData = getGuildData(leadPlayer, guid)
	if not guildData then
		return false, "No guildData."
	end

	local hallServerId = guildData.hallServerId
	if not hallServerId then
		return false, "No hallServerId."
	end

	network:invoke("teleportPlayersToReserveServer", players, guildHallPlaceId, guid, nil, nil, hallServerId)

	return true, ""
end

local function playerRequest_teleportToGuildHall(player)
	local guildId = player:FindFirstChild("guildId")
	if not guildId then
		return false, "No guildId."
	end

	local guid = guildId.Value
	if guid == "" then
		return false, "No guild."
	end

	local partyData = network:invoke("getPartyDataByPlayer", player)
	if partyData then
		-- teleport the party
		local players = {}

		local leader
		for _, memberInfo in pairs(partyData.members) do
			local member = memberInfo.player
			if memberInfo.isLeader then
				leader = member
			else
				table.insert(players, member)
			end
		end

		if player ~= leader then
			return false, "Only the party leader may teleport everyone to a guild hall."
		end

		table.insert(players, 1, leader)
		teleportPlayersToGuildHall(players, guid)
	else
		-- teleport the individual
		teleportPlayersToGuildHall({player}, guid)
	end
end


local function expelPlayerHelper(player, target)
	network:fireAllClients("signal_alertChatMessage", {
		Text = target.Name.." has been expelled by "..player.Name,
		Font = Enum.Font.SourceSansBold,
		Color = Color3.fromRGB(255, 127, 127),
	})
	network:invoke("teleportPlayer", target, game.ReplicatedStorage.lastLocationOverride.Value, "guildHall")
end
local function expelPlayer(player, target)
	if (game.PlaceId ~= guildHallPlaceId) and (game.PlaceId ~= 2061558182) then
		return false, "This command can only be used in the guild hall."
	end

	local guildId = game.ReplicatedStorage:FindFirstChild("guildId")
	if guildId then
		guildId = guildId.Value
	else
		if game.PlaceId == 2061558182 then
			guildId = "73370A17-4486-4E7D-AD49-4597D93C52B0"
		else
			return false, "Couldn't find guildId."
		end
	end

	local playerGuildId = player:FindFirstChild("guildId")
	local targetGuildId = target:FindFirstChild("guildId")
	if (not playerGuildId) then
		return false, "You are not a member of a guild."
	else
		if playerGuildId.Value ~= guildId then
			return false, "You are not a member of this guild."
		end

		if (not targetGuildId) then
			expelPlayerHelper(player, target)
			return true, ""
		else
			if targetGuildId.Value ~= guildId then
				expelPlayerHelper(player, target)
				return true, ""
			else
				local playerData = getGuildPlayerData(player, guildId)
				local targetData = getGuildPlayerData(target, guildId)

				if (not playerData) or (not targetData) or (not playerData.rank) or (not targetData.rank) then
					return false, "There was an issue with player data."
				end

				local playerRank = getRankNumberFromRank(playerData.rank)
				local targetRank = getRankNumberFromRank(targetData.rank)
				if playerRank <= targetRank then
					return false, "You must be a higher rank than your target in order to expel them."
				else
					expelPlayerHelper(player, target)
					return true, ""
				end
			end
		end
	end
end

local function leaveGuildHall(player)
	network:invoke("teleportPlayer", player, game.ReplicatedStorage.lastLocationOverride.Value, "guildHall")
end

function module.init(Modules)
	network = Modules.network

	network:connect("playerDataLoaded", "Event", onPlayerLoaded)

	network:create("signal_guildDataUpdated", "RemoteEvent")
	network:create("sendGuildMessage", "BindableFunction", "OnInvoke", sendGuildMessage)
	network:create("sendGuildChat", "BindableFunction", "OnInvoke", sendGuildChat)
	network:create("getGuildData", "BindableFunction", "OnInvoke", getGuildData)
	network:create("playerRequest_getGuildData", "RemoteFunction", "OnServerInvoke", playerRequest_getGuildData)
	network:create("getGuildMemberData", "BindableFunction", "OnInvoke", getGuildPlayerData)
	network:create("playerRequest_getGuildMemberData", "RemoteFunction", "OnServerInvoke", playerRequest_getGuildMemberData)
	network:create("playerRequest_createGuild", "RemoteFunction", "OnServerInvoke", playerRequest_createGuild)
	network:create("serverPrompt_playerInvitedToServer", "RemoteFunction")
	network:create("playerRequest_invitePlayerToGuild", "RemoteFunction", "OnServerInvoke", playerRequest_invitePlayerToGuild)
	network:create("playerRequest_exileUserIdFromGuild","RemoteFunction","OnServerInvoke", playerRequest_exileUserIdFromGuild)
	network:create("playerRequest_leaveMyGuild","RemoteFunction","OnServerInvoke",playerRequest_leaveMyGuild)
	network:create("playerRequest_changeUserIdRankValue", "RemoteFunction", "OnServerInvoke", playerRequest_changeUserIdRankValue)
	network:create("playerRequest_getHallLocationFromPlaceId", "RemoteFunction", "OnServerInvoke", getHallLocationFromPlaceId)
	network:create("playerRequest_getPlaceIdFromHallLocation", "RemoteFunction", "OnServerInvoke", playerRequest_getPlaceIdFromHallLocation)
	network:create("getPlaceIdFromHallLocation", "BindableFunction", "OnInvoke", getPlaceIdFromHallLocation)
	network:create("playerRequest_changeGuildHallLocation", "RemoteFunction", "OnServerInvoke", changeGuildHallLocation)
	network:create("playerRequest_getGuildUpgradeCost", "RemoteFunction", "OnServerInvoke", getGuildUpgradeCost)
	network:create("playerRequest_upgradeGuild", "RemoteFunction", "OnServerInvoke", upgradeGuild)
	network:create("playerRequest_donateToGuild", "RemoteFunction", "OnServerInvoke", donateToGuild)
	network:create("teleportPlayersToGuildHall", "BindableFunction", "OnInvoke", teleportPlayersToGuildHall)
	network:create("playerRequest_teleportToGuildHall", "RemoteFunction", "OnServerInvoke", playerRequest_teleportToGuildHall)
	network:create("playerRequest_expelPlayer", "RemoteFunction", "OnServerInvoke", expelPlayer)
	network:create("playerRequest_leaveGuildHall", "RemoteFunction", "OnServerInvoke", leaveGuildHall)
	network:create("getRankNumberFromRank", "BindableFunction", "OnInvoke", getRankNumberFromRank)
end

return module