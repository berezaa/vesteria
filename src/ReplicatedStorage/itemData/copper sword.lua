return {
	--> identifying information <--
	id = 32;

	--> generic information <--
	name = "Copper Sword";
	rarity = "Common";
	image = "rbxassetid://2528903917";
	description = "A large sword forged from copper. It's not the strongest, but at least it's not falling apart.";

	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "sword";

	gripCFrame = CFrame.Angles(-math.pi / 2, 0, 0) * CFrame.new(0.1, 0, 2) * CFrame.Angles(0, 0, math.pi / 2);

	minLevel = 7;

	--> stats information <--
	baseDamage = 9;
	attackSpeed = 3;
    bonusStats = {};

	--> crafting information <--
	recipe = {
		-- copper
		{id = 601, stacks = 30}
	};

	--> shop information <--
	buyValue = 2000;
	sellValue = 1000;

	--> sorting information <--
	category = "equipment";
}