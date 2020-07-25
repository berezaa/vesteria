return {
	--> identifying information <--
	id = 401;

	--> generic information <--
	name = "Oak Axe";
	rarity = "Common";
	image = "rbxassetid://5344158782";
	description = "A shoddy wooden axe that still gets the job done.";

	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "axe";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 1;

	--> stats information <--
	baseDamage = 2;

	modifierData = {{woodcutting = 3}};

	--> crafting information <--
	recipe = {
		-- oak wood
		{id = 2, quantity = 10}
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