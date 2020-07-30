-- connects NPC chat bubbles on the client from the server
-- Author: prisman

local player = game.Players.LocalPlayer
player:WaitForChild("dataLoaded", 60)



local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 			= modules.load("network")
	

local chatParts = {}

local placeChats = network:invokeServer("requestNPCChatInfo")
for i, tab in pairs(placeChats) do
	if workspace:FindFirstChild(tab[1]) then
		chatParts[tab[1]] = network:invoke("createChatTagPart", workspace:WaitForChild(tab[1]), tab[2], tab[3])
	end
end

local function doChat(name, chat, charName)
	if workspace:FindFirstChild(name) and chatParts[name] then
		network:invoke("displayChatMessageFromChatTagPart", chatParts[name], chat, charName)
	end
end

network:connect("syncedNPCChat", "OnClientEvent", doChat)
network:create("clientNPCChat", "BindableEvent", "Event", doChat)

local chatPartsByModel = {}

local function doChatByModel(model, message, name, offset, rangeMulti)
	local chatPart = chatPartsByModel[model]
	if not chatPart then
		chatPart = network:invoke("createChatTagPart", model, offset, rangeMulti)
		chatPartsByModel[model] = chatPart
	end
	
	network:invoke("displayChatMessageFromChatTagPart", chatPart, message, name)
end
network:connect("syncedNPCChatByModel", "OnClientEvent", doChatByModel)	