local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")

-- quest 1
local dialogue = {
	onSelected = function()
	
	end;

	id 	= "startTalkingToShopkeeper";
	dialogue = {{text = "Hey, you! I'm a test NPC for Dialogue. How are you?"}};
	options = {
		["Gross, don't talk to me."] = {
			dialogue = {{text = "That's not very nice.. :("}};
			dialogue2 = {{text = "Get out of here whippersnapper!"}};
		};
			
		["That's cool!"] = {
			dialogue = {{text = "I know."}};
		};
		
		["Give me a sick quest."] = {
			onSelected = function()

			end;
			
			dialogue = {{text = "Don't worry, I got you."}};
		}
	};
}

local dialogue2 = {
	dialogue = {{text = "Greetings Adventurer!"}};
	options = {
		{
			response = "Today is such a beautiful day!";
			dialogue = {{text = "No it isn't, my wife is sick."}};
		};
		{
			questId = 2;
		}
	};
}

return dialogue2