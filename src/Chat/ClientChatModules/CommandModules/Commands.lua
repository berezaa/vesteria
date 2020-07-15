-- Custom Vesteria chat commands
-- by berezaa

local util = require(script.Parent:WaitForChild("Util"))
 
local customState = {}
customState.__index = customState

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 			= modules.load("network")
	local configuration 	= modules.load("configuration")
 
function matches(newText, pattern)
	newText = string.lower(newText)
	pattern = string.lower(pattern)
	if string.sub(newText, 1, pattern:len()) == pattern then
		return true
	end
end

function isCommand(newText)
	if matches(newText, "/invite ") or  matches(newText, "/i ") then
		return "invite"
	elseif matches(newText, "/duel ") or  matches(newText, "/d ") then
		return "duel"
	elseif matches(newText, "/trade ") or  matches(newText, "/t ") then
		return "trade"
	elseif matches(newText, "/e ") then
		return "emote", true
	elseif matches(newText, "/expel ") then
		return "expel"
	end
end

local commandText = {
	invite = "Invite player to party:";
	duel = "Challenge player to duel:";
	trade = "Request trade with player:";
	emote = "Perform emote:";
	expel = "Expel player from Guild Hall:",
}

function customState:TrimWhiteSpace(text)
	local newText = string.gsub(text, "%s+", "")
	local wasWhitespaceTrimmed = text[#text] == " "
	return newText, wasWhitespaceTrimmed
end

function customState:AutoComplete(enteredText)
	enteredText = enteredText:lower()
	local trimmedText = enteredText
--	local trimmedText = self:TrimWhisperCommand(enteredText)
	if trimmedText then
		local possiblePlayerName, whitespaceTrimmed = self:TrimWhiteSpace(trimmedText)
		
		local possibleMatches = {}
		local players = game.Players:GetPlayers()
		for i = 1, #players do
			if players[i] ~= game.Players.LocalPlayer then
				local lowerPlayerName = players[i].Name:lower()
				if string.sub(lowerPlayerName, 1, string.len(possiblePlayerName)) == possiblePlayerName then
					possibleMatches[players[i]] = players[i].Name:lower()
				end
			end
		end
		local matchCount = 0
		local lastMatch = nil
		local lastMatchName = nil
		for player, playerName in pairs(possibleMatches) do
			matchCount = matchCount + 1
			lastMatch = player
			lastMatchName = playerName
			if playerName == possiblePlayerName and whitespaceTrimmed then
				return player
			end
		end
		if matchCount == 1 then
			return lastMatch
		end
	end
	return nil
end

function customState:enterFocus(command)
	
	command = command or isCommand(self:GetMessage())
	if command then
		
		self.currentCommand = command
	
		self.MessageModeButton.Size = UDim2.new(0, 1000, 1, 0)
		self.MessageModeButton.Text = commandText[command] or command .. ":"
		self.MessageModeButton.TextColor3 = Color3.fromRGB(0, 12, 255)
	
		local xSize = self.MessageModeButton.TextBounds.X
		self.MessageModeButton.Size = UDim2.new(0, xSize, 1, 0)
		self.TextBox.Size = UDim2.new(1, -xSize, 1, 0)
		self.TextBox.Position = UDim2.new(0, xSize, 0, 0)
		self.OriginalPartyText = self.TextBox.Text
		self.TextBox.Text = " "		
	
	end
end

function customState:TextUpdated()
	local newText = self.TextBox.Text
	if not self.currentCommand then
		local command = isCommand(newText)
		if command then
			self:enterFocus(command)	
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
			self.currentCommand = nil
			---Temporary until setting cursor position...
			self.ChatBar:ResetCustomState()
			self.ChatBar:CaptureFocus()
		elseif self.doAutoComplete then
			-- try to autocomplete
			local targetPlayer = self:AutoComplete(newText)
			if targetPlayer then
				self.TextBox.Text = " "..targetPlayer.Name
			end	
			self.ChatBar:CaptureFocus()
			self.doAutoComplete = false
		end		
	end

end
 
function customState:GetMessage()
	local currentCommand = self.currentCommand
	if currentCommand then
		return "/"..currentCommand..self.TextBox.Text
	end
	return self.TextBox.Text
end

local starterGui = game:GetService("StarterGui")
 
local MSG_COLOR = Color3.new(0.7,0.7,0.7)
local ERR_COLOR = Color3.new(1,0.6,0.6)

--welcome msg
if game.gameId ==712031239 then
	starterGui:SetCore("ChatMakeSystemMessage", {
		Text = "Welcome to Free to Play Vesteria! This game is still in early development and may be reset. Say '/help' for a list of commands."; 
		Color = Color3.fromRGB(0, 255, 149)
	})
else
	starterGui:SetCore("ChatMakeSystemMessage", {Text = "Welcome to Vesteria! Say '/help' for a list of commands."; Color = Color3.fromRGB(0, 255, 149)})
end





function customState:ProcessCompletedMessage()
	
	local message = self:GetMessage()
	
	local command = self.currentCommand
	if command then
		
		if command == "emote" then
			local targetEmote = string.gsub(self:GetMessage(), "^[^%s]+ ", "")
			
			local success, reason = false, "invalid emote"
			success, reason = network:invoke("playerRequest_performEmote", targetEmote)
			if not success then
				starterGui:SetCore("ChatMakeSystemMessage", {Text = reason; Color = ERR_COLOR})
			end
			
		else
			-- commands that involve players
			local targetPlayerName = string.gsub(self:GetMessage(), "^[^%s]+ ", "")
			local targetPlayer = game.Players:FindFirstChild(targetPlayerName)
			
			-- idk in case spaces in usernames ever become a thing
			if targetPlayer == nil then
				targetPlayer = game.Players:FindFirstChild(string.gsub(targetPlayerName, " ", ""))
			end
			
			if targetPlayer then
				local success, reason = false, "invalid command"
				if command == "invite" then
					success, reason = network:invokeServer("playerRequest_invitePlayerToMyParty", targetPlayer)
					if success then
						starterGui:SetCore("ChatMakeSystemMessage", {Text = "Sent a party invite to " .. targetPlayerName; Color = MSG_COLOR})
					else
						starterGui:SetCore("ChatMakeSystemMessage", {Text = reason; Color = ERR_COLOR})
					end
				elseif command == "duel" then
					success, reason = network:invokeServer("playerRequest_requestChallenge", targetPlayer)
					if success then
						starterGui:SetCore("ChatMakeSystemMessage", {Text = "Sent a duel challenge to " .. targetPlayerName; Color = MSG_COLOR})
					else
						starterGui:SetCore("ChatMakeSystemMessage", {Text = reason; Color = ERR_COLOR})
					end
				elseif command == "expel" then
					success, reason = network:invokeServer("playerRequest_expelPlayer", targetPlayer)
					if success then
						starterGui:SetCore("ChatMakeSystemMessage", {Text = "Expelling "..targetPlayerName.."...", Color = MSG_COLOR})
					end
				elseif command == "trade" then
					
					success, reason = false, "Trading is temporarily disabled."
			
					if configuration.getConfigurationValue("isTradingEnabled") then
						success, reason = network:invokeServer("playerRequest_requestTrade", targetPlayer)
					end				
					
					
					if success then
						starterGui:SetCore("ChatMakeSystemMessage", {Text = "Sent a trade request to " .. targetPlayerName; Color = MSG_COLOR})
					end					
				end
				if not success then
					starterGui:SetCore("ChatMakeSystemMessage", {Text = reason; Color = ERR_COLOR})
				end
				
			else
				starterGui:SetCore("ChatMakeSystemMessage", {Text = "Invalid player"; Color = ERR_COLOR})		
			end
		end
		
		
		
		
		return true	
	end
	
	-- help command		
	if (message:lower() == "/?" or message:lower() == "/help") then
		
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "Vesteria chat commands:"; Color = MSG_COLOR})

		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /me <text> :: roleplaying command for doing actions."; Color = MSG_COLOR})	
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /whisper <player> (/w) :: whisper a private message to a player."; Color = MSG_COLOR})	
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /mute <player> :: stop seeing chats from a player."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /unmute <player> :: unmute a muted player."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /party <text> (/p) :: send a message to party members."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /invite <player> (/i) :: invite a player to your party."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /duel <player> (/d) :: challenge a player to a duel."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /trade <player> (/t) :: request a trade with a player."; Color = MSG_COLOR})
		starterGui:SetCore("ChatMakeSystemMessage", {Text = "  /e <emote> (/t) :: perform emote."; Color = MSG_COLOR})

		return true
	end			
			
	return false
end
 
function customState:Destroy()
	print("destroy custom state")
	self.Destroyed = true
end
 
function customState.new(ChatWindow, ChatBar, ChatSettings, overrideAutoComplete)
	
	local obj = {}
	setmetatable(obj, customState)
 
	obj.Destroyed = false
	obj.ChatWindow = ChatWindow
	obj.ChatBar = ChatBar
	obj.ChatSettings = ChatSettings
	obj.TextBox = ChatBar:GetTextBox()
	obj.MessageModeButton = ChatBar:GetMessageModeTextButton()
	obj.MessageModeLabel = ChatBar:GetMessageModeTextLabel()	
	
	if overrideAutoComplete then
		obj.doAutoComplete = false
		--print("overrided autocomplete")
	else
		obj.doAutoComplete = true
	end
	
	
	obj.MessageModeConnection = obj.MessageModeButton.MouseButton1Click:connect(function()
		local chatBarText = obj.TextBox.Text
		if string.sub(chatBarText, 1, 1) == " " then
			chatBarText = string.sub(chatBarText, 2)
		end
		obj.ChatBar:ResetCustomState()
		obj.ChatBar:SetTextBoxText(chatBarText)
		obj.ChatBar:CaptureFocus()
	end)	
	
	obj:enterFocus()	
 
	return obj
end

local function ProcessMessage(message, ChatWindow, ChatBar, ChatSettings)
	-- overrideAutoComplete is nil or true
	local command, overrideAutoComplete = isCommand(message)
	
	if command or message:lower() == "/?" or message:lower() == "/help" then
		return customState.new(ChatWindow, ChatBar, ChatSettings, overrideAutoComplete)
	end
end
 
return {
	[util.KEY_COMMAND_PROCESSOR_TYPE] = util.IN_PROGRESS_MESSAGE_PROCESSOR,
	[util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}