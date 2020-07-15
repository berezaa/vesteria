--	// FileName: PartyChat.lua
--	// Written by: Xsitsu
--	// Description: Module that handles all party chat.

local Chat = game:GetService("Chat")
local ReplicatedModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ReplicatedModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ReplicatedModules:WaitForChild("ChatConstants"))

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network		= modules.load("network")

local ChatLocalization = nil
pcall(function() ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization) end)
if ChatLocalization == nil then ChatLocalization = {} function ChatLocalization:Get(key,default) return default end end

local errorTextColor = ChatSettings.ErrorMessageTextColor or Color3.fromRGB(245, 50, 50)
local errorExtraData = {ChatColor = errorTextColor}

local function Run(ChatService)

	local Players = game:GetService("Players")

	local channel = ChatService:AddChannel("Party")
	channel.Joinable = false
	channel.Leavable = false
	channel.AutoJoin = false
	channel.Private = true

	local function PartyChatReplicationFunction(fromSpeaker, message, channelName)
		local speakerObj = ChatService:GetSpeaker(fromSpeaker)
		local channelObj = ChatService:GetChannel(channelName)
		
		if channelName == "Party" then
		
			if (speakerObj and channelObj) then
				local player = speakerObj:GetPlayer()
				if (player) then
					
					local speakerParty = network:invoke("getPartyDataByPlayer", player)
					if speakerParty and speakerParty.members and #speakerParty.members > 0 then
	
						for i, partyMember in pairs(speakerParty.members) do
							if partyMember and partyMember.player then
								local speakerName = partyMember.player.Name
								local otherSpeaker = ChatService:GetSpeaker(speakerName)
								if (otherSpeaker) then
									local otherPlayer = otherSpeaker:GetPlayer()
									if (otherPlayer) then
			
		
										local extraData = {
											ChannelColor = Color3.fromRGB(0, 240, 244);
											ChatColor = Color3.fromRGB(0, 240, 244)
										}
										otherSpeaker:SendMessage(message, channelName, fromSpeaker, extraData)
						
			
									end
								end
							end
						end
					end
	
				end
			end
	
			return true
		end
	end

	channel:RegisterProcessCommandsFunction("replication_function_party", PartyChatReplicationFunction, ChatConstants.LowPriority)

	local function DoPartyCommand(fromSpeaker, message, channel)
		if message == nil then
			message = ""
		end

		local speaker = ChatService:GetSpeaker(fromSpeaker)
		if speaker then
			local player = speaker:GetPlayer()

			if player then
				
				local speakerParty = network:invoke("getPartyDataByPlayer", player)
				
				if speakerParty == nil or speakerParty.members == nil then
					speaker:SendSystemMessage(ChatLocalization:Get("GameChat_PartyChat_CannotPartyChatIfNotInParty","You cannot party chat if you are not on a party!"), channel, errorExtraData)
					return
				end

				local channelObj = ChatService:GetChannel("Party")
				if channelObj then
					if not speaker:IsInChannel(channelObj.Name) then
						speaker:JoinChannel(channelObj.Name)
					end
					if message and string.len(message) > 0 then
						speaker:SayMessage(message, channelObj.Name)
					end
					speaker:SetMainChannel(channelObj.Name)
				end
			end
		end
	end

	local function PartyCommandsFunction(fromSpeaker, message, channel)
		local processedCommand = false

		if message == nil then
			error("Message is nil")
		end

		if channel == "Party" then
			return false
		end

		if string.sub(message, 1, 6):lower() == "/party " or message:lower() == "/party" then
			DoPartyCommand(fromSpeaker, string.sub(message, 7), channel)
			processedCommand = true
		elseif string.sub(message, 1, 3):lower() == "/p " or message:lower() == "/p" then
			DoPartyCommand(fromSpeaker, string.sub(message, 4), channel)
			processedCommand = true

		end

		return processedCommand
	end

	ChatService:RegisterProcessCommandsFunction("party_commands", PartyCommandsFunction, ChatConstants.StandardPriority)

	local function GetDefaultChannelNameColor()
		return Color3.fromRGB(0, 240, 244)
	end

	local function PutSpeakerInCorrectPartyChatState(speakerObj, playerObj)

		speakerObj:UpdateChannelNameColor(channel.Name, GetDefaultChannelNameColor())

		if not speakerObj:IsInChannel(channel.Name) then
			speakerObj:JoinChannel(channel.Name)
		end
	
	end

	ChatService.SpeakerAdded:connect(function(speakerName)
		local speakerObj = ChatService:GetSpeaker(speakerName)
		if speakerObj then
			local player = speakerObj:GetPlayer()
			if player then
				PutSpeakerInCorrectPartyChatState(speakerObj, player)
			end
		end
	end)

	local PlayerChangedConnections = {}
	network:connect("playerDataLoaded", "Event", function(player)
		local speakerObj = ChatService:GetSpeaker(player.Name)
		if speakerObj then
			PutSpeakerInCorrectPartyChatState(speakerObj, player)
		end


		PlayerChangedConnections[player] = nil
	end)

	Players.PlayerRemoving:connect(function(player)
		local changedConn = PlayerChangedConnections[player]
		if changedConn then
			changedConn:Disconnect()
		end
		PlayerChangedConnections[player] = nil
	end)
end

return Run
