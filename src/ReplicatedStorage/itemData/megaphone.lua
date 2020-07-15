-- prevents requiring the modules outside of runtime
-- a problem for future me to deal with

--local disallowedWhiteSpace = {"\n", "\r", "\t", "\v", "\f"}

--local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
--local network = modules.load("network")

item = {
	--> identifying information <--
	id 		= 135;
	
	--> generic information <--
	name 		= "Megaphone";
	nameColor	= Color3.fromRGB(237, 98, 255);
	rarity 		= "Legendary";
	image 		= "rbxassetid://3109212291";
	description = "Send a message to all online Vesteria players.";
--	soulbound = true;
	tier = 2;
	
	useSound 	= "potion";
	
	consumeTime = 0;
	
	playerInputFunction = function()
		local playerInput = {}
		playerInput.desiredName = network:invoke("textInputPrompt", {prompt = "Enter shout message..."})
		return playerInput
	end;	

	activationEffect = function(player, playerInput)
		if game.ReplicatedStorage:FindFirstChild("doNotSaveData") then
			return false, "No shouting in testing realms"
		end

		if not playerInput then
			return false, "No player input recieved"
		end

		local desiredName = playerInput.desiredName

		if not desiredName then
			return false, "Desired shout not provided"
		end
		
		if #desiredName > 100 then
			return false, "Shout cannot be longer than 100 characters."
		end

		-- eliminate white space				
		for i,whitespace in pairs(disallowedWhiteSpace) do
			if string.find(desiredName, whitespace) then
				return false, "Shout cannot contain whitespace characters."
			end
		end				
		
		if #desiredName < 3 then
			return false, "Shout must be at least 3 characters long."
		end				
		
		local filteredText
		
		local filterSuccess, filterError = pcall(function()
			filteredText = game.Chat:FilterStringForBroadcast(desiredName, player)
		end)
		
		if not filterSuccess then
			return false, "filter error: "..filterError
		end		
		
		if not filteredText or string.find(filteredText, "#") then
			return false, "Shout rejected by Roblox filter: \""..filteredText.."\""
		end
		
		-- if we've gotten this far, we must be good
		local messageSuccess, errMsg = pcall(function()
			game:GetService("MessagingService"):PublishAsync("megaphone", "["..player.Name.."'s shout] " .. filteredText)
			warn("MESSAGE SENT!!!")
		end)
		
		if not messageSuccess then
			return false, "MessagingService error: "..errMsg
		end

		return true, "Shout sent!"
				
	end;
	

	
	--> shop information <--
	buyValue = 2500;
	sellValue = 400;
	
	--> handling information <--
	canStack 	= true;
	canBeBound 	= true;
	canAwaken 	= false;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "consumable";
}

return item