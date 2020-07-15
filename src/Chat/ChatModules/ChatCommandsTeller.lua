--	// FileName: ChatCommandsTeller.lua
--	// Written by: Xsitsu
--	// Description: Module that provides information on default chat commands to players.

local Chat = game:GetService("Chat")
local ReplicatedModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ReplicatedModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ReplicatedModules:WaitForChild("ChatConstants"))

local ChatLocalization = nil
pcall(function() ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization) end)
if ChatLocalization == nil then ChatLocalization = { Get = function(key,default) return default end } end

local function Run(ChatService)

	local function ShowJoinAndLeaveCommands()
		if ChatSettings.ShowJoinAndLeaveHelpText ~= nil then
			return ChatSettings.ShowJoinAndLeaveHelpText
		end
		return false
	end

	local function ProcessCommandsFunction(fromSpeaker, message, channel)
		if (message:lower() == "/?" or message:lower() == "/help") then
			local speaker = ChatService:GetSpeaker(fromSpeaker)
			--[[
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_Desc","Vesteria chat commands:"), channel)
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_MeCommand","/me <text> : roleplaying command for doing actions."), channel)
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_WhisperCommand","/whisper <speaker> or /w <speaker> : open private message channel with speaker."), channel)
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_MuteCommand","/mute <speaker> : mute a speaker."), channel)
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_UnMuteCommand","/unmute <speaker> : unmute a speaker."), channel)
			speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_ToggleCommand","/toggle <tags/color> : toggles chat tags or chat color."), channel)
			]]
			
			speaker:SendSystemMessage("Vesteria chat commands:", channel)
			speaker:SendSystemMessage("    /me <text> :: roleplaying command for doing actions.", channel)	
			speaker:SendSystemMessage("    /whisper <player> (/w) :: whisper a private message to a player.", channel)	
			speaker:SendSystemMessage("    /mute <player> :: stop seeing chats from a player.", channel)
			speaker:SendSystemMessage("    /unmute <player> :: unmute a muted player.", channel)
			speaker:SendSystemMessage("    /party <text> (/p) :: send a message to party members.", channel)
			speaker:SendSystemMessage("    /invite <player> (/i) :: invite a player to your party.", channel)
			speaker:SendSystemMessage("    /duel <player> (/d) :: challenge a player to a duel.", channel)
			speaker:SendSystemMessage("    /trade <player> (/i) :: request a trade with a player.", channel)
			
			
			local player = speaker:GetPlayer()
			if player and player.Team then
				speaker:SendSystemMessage(ChatLocalization:Get("GameChat_ChatCommandsTeller_TeamCommand","/team <message> or /t <message> : send a team chat to players on your team."), channel)
			end

			return true
		end

		return false
	end

	ChatService:RegisterProcessCommandsFunction("chat_commands_inquiry", ProcessCommandsFunction, ChatConstants.StandardPriority)

	if ChatSettings.GeneralChannelName then
		local allChannel = ChatService:GetChannel(ChatSettings.GeneralChannelName)
		if (allChannel) then
--			allChannel.WelcomeMessage = ""
		end
	end
end

return Run
