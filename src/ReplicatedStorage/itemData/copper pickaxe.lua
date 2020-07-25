return {
	--> identifying information <--
	id = 503;

	--> generic information <--
	name = "Copper Pickaxe";
	rarity = "Common";
	image = "rbxassetid://5344159326";
	description = "A smelted bronze pickaxe with a smoothed frame.";

	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "pickaxe";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 5;

	--> stats information <--
	baseDamage = 6;
	modifierData = {{mining = 7}};

	--> crafting information <--
	recipe = {
		-- oak wood
		{id = 2, stacks = 20},
		-- copper
		{id = 601, stacks = 20}
	};

	--> shop information <--
	buyValue = 2000;
	sellValue = 700;

	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;

	--> sorting information <--
	isImportant = false;
	category = "equipment";
}