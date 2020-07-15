local level
local class

local dialogue = {
	id = "hitChestTutorial";
	sound = "npc_male_grunt2";	
	dialogue = {{text = "This lock makes it awful hard to open this here chest... I just want the box. If you can open it, I'll let you keep what's inside! Try hitting it with that weapon you've got there!"}};
	options = {
		{
			response = "Is that a mask?";
			dialogue = {{text = "Nope."}};
		};
		{
			response = "That sounds like vandalism.";
			dialogue = {{text = "Ain't my fault someone left a perfectly good chest lying on the side of the road. Now, if you're not gonna help you can be on your way!"}};
		};
	}
		
}
return dialogue