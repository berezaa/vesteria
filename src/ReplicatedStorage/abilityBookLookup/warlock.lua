return {
	name 					= "Warlock";
	description				= "An ancient tome of powerful cursed magic. But at what cost?";		
	pointsGainPerLevel 		= 1;
	startingPoints 			= 1;
	lockPointsOnClassChange = true;
	minLevel 				= 30;
	maxLevel				= 50;	
	
	-- visual attributes
	layoutOrder				= 3;
	bookColor				= Color3.fromRGB(76, 9, 153);
	
	bookBackgroundImage		= "rbxassetid://4149214475";
	thumbnail = "rbxassetid://3559734054";
	
	abilities = {
		{
			id 				= 39;
			prerequisiteId 	= nil;
		};
		{
			id 				= 40;
			prerequisiteId 	= nil;
		};
		{
			id = 57,
			prerequisiteId = nil
		},
		{
			id = 59,
		},
	};
}