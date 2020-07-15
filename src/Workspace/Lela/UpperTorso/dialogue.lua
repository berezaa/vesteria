local money = 0

local animController = script.Parent.Parent:WaitForChild("AnimationController")


local dialogue = {
--	sound 		= "npc_female_hmm3";
	id 			= "startTalkingTo";
	canExit 	= true;
	dialogue 	= {{text = "Why hello there! The name's Lela. May I interest you in some of my wares? Perhaps armor to protect yourself, or potions to keep you going on a long adventure!"}};
	options 	= {

		{
			response = "Lela's Traveling Goods";
			responseButtonColor = Color3.fromRGB(234, 174, 53);
			dialogue = function()
				local proxy = require(game.StarterPlayer.StarterPlayerScripts.modules.proxy)
				proxy.openShop(script.Parent)
				return {{text = "Let me know if something catches your eye!"}};
			end;
										
		};
	};
		
}
return dialogue

