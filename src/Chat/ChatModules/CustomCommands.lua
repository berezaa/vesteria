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
	end
end


local function Run(ChatService)
	local function commandRecieved(speakerName, message, channelName)

		local speaker = ChatService:GetSpeaker(speakerName)	
		local player = speaker:GetPlayer()
		
		
		if isCommand(message) then
			local targetPlayerName = string.gsub(message, "^[^%s]+ ", "")

			
		end
		return false
	end
 
	ChatService:RegisterProcessCommandsFunction("customCommands", commandRecieved)
end
 
return Run