return {
	--> identifying information <--
	id = 501;

	--> generic information <--
	name = "Oak Pickaxe";
	rarity = "Common";
	image = "rbxassetid://5344159105";
	description = "A shoddy wooden pickaxe that still gets the job done.";

	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "pickaxe";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 1;

	--> stats information <--
	baseDamage = 2;

	modifierData = {{mining = 3}};

	--> crafting information <--
	recipe = {
		-- oak wood
		{id = 2, stacks = 10}
	};

	--> shop information <--
	buyValue = 200;
	sellValue = 150;

	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;

	--> sorting information <--
	isImportant = false;
	category = "equipment";
}