--	// FileName: Toggle.lua
--	// Written by: Nicholas_Foreman
--	// Description: Allows for toggling chat tags/chat color.

local util = require(script.Parent:WaitForChild("Util"))
local ChatConstants = require(script.Parent.Parent:WaitForChild("ChatConstants"))

local event = game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("Toggle");
local function ProcessMessage(message, ChatWindow, _)
	if string.sub(message, 1,  7):lower() == "/toggle" then
		if message:lower() == "/toggle" then
			util:SendSystemMessageToSelf("Usage : /toggle <tags/color> : toggles chat tags or chat color.", ChatWindow:GetCurrentChannel(), {})
			return true
		elseif message:lower() == "/toggle tags" then
			event:FireServer("Tags")
			util:SendSystemMessageToSelf("Successfully toggled chat tags.", ChatWindow:GetCurrentChannel(), {})
			return true
		elseif message:lower() == "/toggle color" then
			event:FireServer("Color")
			util:SendSystemMessageToSelf("Successfully toggled chat color.", ChatWindow:GetCurrentChannel(), {})
			return true
		else
			util:SendSystemMessageToSelf("Usage : /toggle <tags/color> : toggles chat tags or chat color.", ChatWindow:GetCurrentChannel(), {})
			return true
		end
	end
	return false
end

return {
	[util.KEY_COMMAND_PROCESSOR_TYPE] = util.COMPLETED_MESSAGE_PROCESSOR,
	[util.KEY_PROCESSOR_FUNCTION] = ProcessMessage
}