return {
	name 					= "Sorcerer";
	description				= "The gold-lined elemantlist tome of the sorcerer contains many types of powerful spells.";		
	pointsGainPerLevel 		= 1;
	startingPoints 			= 1;
	lockPointsOnClassChange = true;
	minLevel 				= 30;
	maxLevel				= 50;	
	
	-- visual attributes
	layoutOrder				= 3;
	bookColor				= Color3.fromRGB(24, 93, 166);
	
	bookBackgroundImage		= "rbxassetid://4149214600";
	thumbnail = "rbxassetid://3559734054";
	
	abilities = {
		{
			id 				= 49;
			prerequisiteId 	= nil;
		};
		{
			id 				= 52;
			prerequisiteId 	= nil;
		};
		{
			id 				= 37;
			prerequisiteId 	= nil;
		};
	};
}