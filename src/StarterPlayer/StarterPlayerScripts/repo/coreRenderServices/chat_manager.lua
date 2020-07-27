-- variables
local MAX_CHAT_BUBBLE_COUNT = 3

-- essentials
local replicatedStorage = game:GetService("ReplicatedStorage")
local playerScripts = game:GetService("StarterPlayerScripts")
local modules = require(replicatedStorage:WaitForChild("modules"))
local network = modules.load("network")

local runService = game:GetService("RunService")
local assetFolder = playerScripts:WaitForChild("assets")

local function getOldestChatBubble(chats)
	local oldest
	local lowestLayoutOrder = 99
	for _, chat in pairs(chats) do
		if chat:IsA("GuiObject") and chat.LayoutOrder < lowestLayoutOrder then
			oldest = chat
			lowestLayoutOrder = chat.LayoutOrder
		end
	end
	return oldest
end

local function setPrimaryChatBubble(chatBubble)
	if not chatBubble.titleFrame.Visible then
		if game.Players.LocalPlayer.Character and chatBubble:IsDescendantOf(game.Players.LocalPlayer.Character) then
			return false
		end
		local size = chatBubble.Size
		if chatBubble.titleFrame.title.Text ~= "" then
			chatBubble.titleFrame.Visible = true
			chatBubble.Size = size + UDim2.new(0, 0, 0, 10)
			chatBubble.contents.Position = chatBubble.contents.Position + UDim2.new(0, 0, 0, 5)
			local dif = (chatBubble.titleFrame.AbsoluteSize.X + 20) - chatBubble.AbsoluteSize.X
			if dif > 0 then
				chatBubble.Size = size + UDim2.new(0, dif, 0, 0 )
			end
		end

	end
end

local function getChatTagPartForEntity(entityContainer)
	for _, chatTagPart in pairs(game.CollectionService:GetTagged("chatTag")) do
		if chatTagPart.Parent == entityContainer then
			return chatTagPart
		end
	end
end



local function createChatTagPart(entityContainer, offset, rangeMulti)
	--[[
	local chatTag 	= entityContainer.PrimaryPart:FindFirstChilfd("ChatTag") or assetFolder.ChatTag:Clone()
	chatTag.Parent 	= entityContainer.PrimaryPart
	]]

	local chatTag = entityContainer:FindFirstChild("chatGui") or assetFolder.misc.chatGui:Clone()
	chatTag.Parent = entityContainer
	chatTag.Adornee = entityContainer.PrimaryPart
	chatTag.Enabled = true

	local rangeMultiTag = Instance.new("NumberValue")
	rangeMultiTag.Name = "rangeMulti"
	rangeMultiTag.Value = rangeMulti or 1
	rangeMultiTag.Parent = chatTag

	offset = offset or Vector3.new()
	local offsetTag = Instance.new("Vector3Value")
	offsetTag.Name = "offset"
	offsetTag.Value = offset
	offsetTag.Parent = chatTag

	chatTag.ExtentsOffsetWorldSpace = chatTag.ExtentsOffsetWorldSpace + offset

	game.CollectionService:AddTag(chatTag,"chatTag")
	return chatTag
end



local function displayChatMessageFromChatTagPart(chatTagPart, message, speakerName)
	--local chatTag = chatTagPart:FindFirstChild("SurfaceGui")
	local chatTag = chatTagPart
	if chatTag then
		local newChatBubble = chatTag.chatTemplate:clone()
		newChatBubble.titleFrame.title.Text = speakerName or ""
		local titleBounds = game.TextService:GetTextSize(newChatBubble.titleFrame.title.Text, newChatBubble.titleFrame.title.TextSize, newChatBubble.titleFrame.title.Font, Vector2.new()).X + 20
		newChatBubble.titleFrame.Size = UDim2.new(0,titleBounds,0,32)

		newChatBubble.titleFrame.Visible = false

		local existingChatBubbles = {}
		for i,chatBubble in pairs(chatTag.chat:GetChildren()) do
			if chatBubble:IsA("GuiObject") then
				chatBubble.LayoutOrder = chatBubble.LayoutOrder - 1
				table.insert(existingChatBubbles, chatBubble)
			end
		end

		if #existingChatBubbles >= MAX_CHAT_BUBBLE_COUNT then
			local oldest = getOldestChatBubble(existingChatBubbles)
			oldest:Destroy()
		end

		newChatBubble.LayoutOrder = 10
		newChatBubble.Parent = chatTag.chat

		local dialogueText, yOffset, xOffset = network:invoke("createTextFragmentLabels",newChatBubble.contents, {{text = message, textColor3 = Color3.fromRGB(200,200,200)}} )
		if yOffset < 18 then
			newChatBubble.Size = UDim2.new(0, xOffset + 20 , 0, yOffset + 26)
		else
			newChatBubble.Size = UDim2.new(1, 0, 0, yOffset + 26)
		end

		local newOldest = getOldestChatBubble(chatTag.chat:GetChildren())
		if newOldest then
			setPrimaryChatBubble(newOldest)
		end

		newChatBubble.Visible = true

		spawn(function()
			wait(15)
			if newChatBubble and newChatBubble.Parent then
				newChatBubble:Destroy()
				local newOldest = getOldestChatBubble(chatTag.chat:GetChildren())
				if newOldest then
					setPrimaryChatBubble(newOldest)
				end
			end
		end)
	end
end



game.ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents").OnMessageDoneFiltering.OnClientEvent:connect(function(messageInfo, rio)
	--  {"ExtraData":{"Tags":[],"ChatColor":null,"NameColor":null},"IsFiltered":true,"MessageType":"Message","IsFilterResult":true,
	--	"Time":1539139847,"ID":0,"FromSpeaker":"berezaa","Message":"## #### ##### #### #### ##","OriginalChannel":"All","SpeakerUserId":5000861,
	--  "MessageLength":26}
	local yeet = false

	if yeet == true then
	-- confirm
		if messageInfo.IsFilterResult or runService:IsStudio() then
			local player = game.Players:GetPlayerByUserId(messageInfo.SpeakerUserId)
			local message = messageInfo.Message

			if player and player.Character and player.Character.PrimaryPart and message then
				local renderEntityData = entitiesBeingRendered[player.Character.PrimaryPart]
				if not renderEntityData or not renderEntityData.entityContainer.PrimaryPart then return false end

				local chatTag = renderEntityData.entityContainer:FindFirstChild("chatGui")
				if chatTag then
					displayChatMessageFromChatTagPart(chatTag, message, player.Name)
				end
			end
		end
	end
end)



network:create("getChatTagPartForEntity", "BindableFunction", "OnInvoke", getChatTagPartForEntity)
network:create("createChatTagPart", "BindableFunction", "OnInvoke", createChatTagPart)
network:create("displayChatMessageFromChatTagPart", "BindableFunction", "OnInvoke", displayChatMessageFromChatTagPart)

return true