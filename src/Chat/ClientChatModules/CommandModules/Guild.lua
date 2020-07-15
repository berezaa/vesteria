--	// FileName: Guild.lua
--	// Written by: Partixel/TheGamer101
--	// Description: Guild chat bar manipulation.

local PlayersService = game:GetService("Players")

local GUILD_COMMANDS = {"/guild ", "/g "}

function IsGuildCommand(message)
	for i = 1, #GUILD_COMMANDS do
		local guildCommand = GUILD_COMMANDS[i]
		if string.sub(message, 1, guildCommand:len()):lower() == guildCommand then
			return true
		end
	end
	return false
end

local guildStateMethods = {}
guildStateMethods.__index = guildStateMethods

local util = require(script.Parent:WaitForChild("Util"))

local GuildCustomState = {}

function guildStateMethods:EnterGuildChat()
	self.GuildChatEntered = true
	self.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)
	self.MessageModeButton.Text = "[Guild]"
	self.MessageModeButton.TextColor3 = self:GetGuildChatColor()

	local xSize = self.MessageModeButton.TextBounds.X
	self.MessageModeButton.Size = UDim2.new(0, xSize, 1, 0)
	self.TextBox.Size = UDim2.new(1, -xSize, 1, 0)
	self.TextBox.Position = UDim2.new(0, xSize, 0, 0)
	self.OriginalGuildText = self.TextBox.Text
	self.TextBox.Text = " "
end

function guildStateMethods:TextUpdated()
	local newText = self.TextBox.Text
	if not self.GuildChatEntered then
		if IsGuildCommand(newText) then
			self:EnterGuildChat()
		end
	else
		if newText == "" then
			self.MessageModeButton.Text = ""
			self.MessageModeButton.Size = UDim2.new(0, 0, 0, 0)
			self.TextBox.Size = UDim2.new(1, 0, 1, 0)
			self.TextBox.Position = UDim2.new(0, 0, 0, 0)
			self.TextBox.Text = ""
			---Implement this when setting cursor positon is a thing.
			---self.TextBox.Text = self.OriginalGuildText
			self.GuildChatEntered = false
			---Temporary until setting cursor position...
			self.ChatBar:ResetCustomState()
			self.ChatBar:CaptureFocus()
		end
	end
end

function guildStateMethods:GetMessage()
	if self.GuildChatEntered then
		return "/g " ..self.TextBox.Text
	end
	return self.TextBox.Text
end

function guildStateMethods:ProcessCompletedMessage()
	return false
end

function guildStateMethods:Destroy()
	self.MessageModeConnection:disconnect()
	self.Destroyed = true
end

function guildStateMethods:GetGuildChatColor()

	return Color3.fromRGB(145, 71, 255)
end

function GuildCustomState.new(ChatWindow, ChatBar, ChatSettings)
	local obj = setmetatable({}, guildStateMethods)
	obj.Destroyed = false
	obj.ChatWindow = ChatWindow
	obj.ChatBar = ChatBar
	obj.ChatSettings = ChatSettings
	obj.TextBox = ChatBar:GetTextBox()
	obj.MessageModeButton = ChatBar:GetMessageModeTextButton()
	obj.OriginalGuildText = ""
	obj.GuildChatEntered = false

	obj.MessageModeConnection = obj.MessageModeButton.MouseButton1Click:connect(function()
		local chatBarText = obj.TextBox.Text
		if string.sub(chatBarText, 1, 1) == " " then
			chatBarText = string.sub(chatBarText, 2)
		end
		obj.ChatBar:ResetCustomState()
		obj.ChatBar:SetTextBoxText(chatBarText)
		obj.ChatBar:CaptureFocus()
	end)

	obj:EnterGuildChat()

	return obj
end

function ProcessMessage(message, ChatWindow, ChatBar, ChatSettings)
	if ChatBar.TargetChannel == "Guild" then
		return
	end

	if IsGuildCommand(message) then
		return GuildCustomState.new(ChatWindow, ChatBar, ChatSettings)
	end
	return nil
end

return {
	[util.KEY_COMMAND_PROCESSOR_TYPE] = util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}
