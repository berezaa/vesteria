
return {
	--> identifying information <--
	id = 87;

	--> generic information <--
	name = "Arrow";
	rarity = "Common";
	image = "rbxassetid://2744225103";
	description = "For shooting things.";

	--> handling information <--
	canStack = true;
	canBeBound = false;
	canAwaken = false;

	equipmentType = "arrow";
	equipmentPosition = 12;

	--> shop information <--
	buyValue = 10;
	sellValue = 3;
	stackSize = 999;

	--> crafting information <--
	recipe = {
		-- oak wood
		{id = 2, stacks = 1},
		-- stone
		{id = 600, stacks = 1},
		-- feather
		{id = 271, stacks = 1},
	};

	--> sorting information <--
	isImportant 	= false;
	category 		= "equipment";
}