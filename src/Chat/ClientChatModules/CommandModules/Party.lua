--	// FileName: Party.lua
--	// Written by: Partixel/TheGamer101
--	// Description: Party chat bar manipulation.

local PlayersService = game:GetService("Players")

local PARTY_COMMANDS = {"/party ", "/p "}

function IsPartyCommand(message)
	for i = 1, #PARTY_COMMANDS do
		local partyCommand = PARTY_COMMANDS[i]
		if string.sub(message, 1, partyCommand:len()):lower() == partyCommand then
			return true
		end
	end
	return false
end

local partyStateMethods = {}
partyStateMethods.__index = partyStateMethods

local util = require(script.Parent:WaitForChild("Util"))

local PartyCustomState = {}

function partyStateMethods:EnterPartyChat()
	self.PartyChatEntered = true
	self.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)
	self.MessageModeButton.Text = "[Party]"
	self.MessageModeButton.TextColor3 = self:GetPartyChatColor()

	local xSize = self.MessageModeButton.TextBounds.X
	self.MessageModeButton.Size = UDim2.new(0, xSize, 1, 0)
	self.TextBox.Size = UDim2.new(1, -xSize, 1, 0)
	self.TextBox.Position = UDim2.new(0, xSize, 0, 0)
	self.OriginalPartyText = self.TextBox.Text
	self.TextBox.Text = " "
end

function partyStateMethods:TextUpdated()
	local newText = self.TextBox.Text
	if not self.PartyChatEntered then
		if IsPartyCommand(newText) then
			self:EnterPartyChat()
		end
	else
		if newText == "" then
			self.MessageModeButton.Text = ""
			self.MessageModeButton.Size = UDim2.new(0, 0, 0, 0)
			self.TextBox.Size = UDim2.new(1, 0, 1, 0)
			self.TextBox.Position = UDim2.new(0, 0, 0, 0)
			self.TextBox.Text = ""
			---Implement this when setting cursor positon is a thing.
			---self.TextBox.Text = self.OriginalPartyText
			self.PartyChatEntered = false
			---Temporary until setting cursor position...
			self.ChatBar:ResetCustomState()
			self.ChatBar:CaptureFocus()
		end
	end
end

function partyStateMethods:GetMessage()
	if self.PartyChatEntered then
		return "/p " ..self.TextBox.Text
	end
	return self.TextBox.Text
end

function partyStateMethods:ProcessCompletedMessage()
	return false
end

function partyStateMethods:Destroy()
	self.MessageModeConnection:disconnect()
	self.Destroyed = true
end

function partyStateMethods:GetPartyChatColor()

	return Color3.fromRGB(0, 240, 244)
end

function PartyCustomState.new(ChatWindow, ChatBar, ChatSettings)
	local obj = setmetatable({}, partyStateMethods)
	obj.Destroyed = false
	obj.ChatWindow = ChatWindow
	obj.ChatBar = ChatBar
	obj.ChatSettings = ChatSettings
	obj.TextBox = ChatBar:GetTextBox()
	obj.MessageModeButton = ChatBar:GetMessageModeTextButton()
	obj.OriginalPartyText = ""
	obj.PartyChatEntered = false

	obj.MessageModeConnection = obj.MessageModeButton.MouseButton1Click:connect(function()
		local chatBarText = obj.TextBox.Text
		if string.sub(chatBarText, 1, 1) == " " then
			chatBarText = string.sub(chatBarText, 2)
		end
		obj.ChatBar:ResetCustomState()
		obj.ChatBar:SetTextBoxText(chatBarText)
		obj.ChatBar:CaptureFocus()
	end)

	obj:EnterPartyChat()

	return obj
end

function ProcessMessage(message, ChatWindow, ChatBar, ChatSettings)
	if ChatBar.TargetChannel == "Party" then
		return
	end

	if IsPartyCommand(message) then
		return PartyCustomState.new(ChatWindow, ChatBar, ChatSettings)
	end
	return nil
end

return {
	[util.KEY_COMMAND_PROCESSOR_TYPE] = util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
