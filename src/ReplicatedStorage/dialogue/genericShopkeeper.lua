local replicatedStorage = game:GetService("ReplicatedStorage")
local modules = require(replicatedStorage.modules)
local network = modules.load("network")

return {
	id = "startTalkingToShopkeeper";
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