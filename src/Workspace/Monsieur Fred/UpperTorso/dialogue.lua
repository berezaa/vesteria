local money = 0

local animController = script.Parent.Parent:WaitForChild("AnimationController")


local dialogue = {
	sound 		= "npc_male_eh";
	id 			= "startTalkingTo";
	canExit 	= true;
	dialogue 	= {{text = "Hon hon hon, what might Monsieur Fred do for you?"}};
	options 	= {
		{
			response = "Have anything for me?";
			dialogue = function(util)
				local success, status = util.network:invokeServer("playerRequest_claimGifts")
				if success then
					return {{text = "Why in fact I do! Here you go!"}};
				elseif status then
					return {{text = status}};
				else
					return {{text = "Afraid not! hon hon hon hon hon!"}};
				end
				
			end;
										
		};
		{
			response = "Premium Shop";
			responseButtonColor = Color3.fromRGB(234, 174, 53);
			dialogue = function(util)
				util.network:invoke("openShop", script.Parent)
				return {{text = "But of course!"}};
			end;
										
		};
	};
		
}
return dialogue

