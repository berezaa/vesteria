--[[--	// FileName: Toggle.lua
--	// Written by: Nicholas_Foreman
--	// Description: Allows for toggling chat tags/chat color.

local Chat = game:GetService("Chat")
local ReplicatedModules = Chat:WaitForChild("ClientChatModules")
local ChatSettings = require(ReplicatedModules:WaitForChild("ChatSettings"))
local ChatConstants = require(ReplicatedModules:WaitForChild("ChatConstants"))

local ChatLocalization = nil
pcall(function() ChatLocalization = require(game:GetService("Chat").ClientChatModules.ChatLocalization) end)
if ChatLocalization == nil then ChatLocalization = { Get = function(key,default) return default end } end

local cache = {}

local function Run(ChatService)
	local function ProcessCommandsFunction(fromSpeaker, message, channel)
		local speaker = ChatService:GetSpeaker(fromSpeaker)
		if string.sub(message, 1, 7) == "/toggle" then
			if not cache[fromSpeaker] then
				cache[fromSpeaker] = {
					Active = true,
					Tags = speaker:GetExtraData("Tags"),
					Color = speaker:GetExtraData("ChatColor")
				}
			end
			if message:lower() == "/toggle" then
				speaker:SendSystemMessage(ChatLocalization:Get("ToggleSuccess","/toggle <tags/color> : toggles chat tags or chat color."), channel)
				return true
			elseif message:lower() == "/toggle tags" then
				if cache[fromSpeaker]["Active"] then
					
				end
				speaker:SendSystemMessage(ChatLocalization:Get("ToggleTagsSuccess","Successfully toggled chat tags."), channel)
				return true
			elseif message:lower() == "/toggle color" then
				speaker:SendSystemMessage(ChatLocalization:Get("ToggleChatSuccess","Successfully toggled chat tags."), channel)
				return true
			end
		end
		return false
	end

	ChatService:RegisterProcessCommandsFunction("chat_toggler", ProcessCommandsFunction, ChatConstants.StandardPriority)
end

return Run]]
	
local function Run(ChatService)
	
end
return Run;