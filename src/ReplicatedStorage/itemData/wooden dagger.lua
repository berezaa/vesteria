return {
	--> identifying information <--
	id = 15;
	
	--> generic information <--
	name = "Oak Dagger";
	rarity = "Common";
	image = "rbxassetid://2528902839";
	description = "A small wooden blade that can be swung very quickly.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "dagger";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(-0.15, 0, 0.83) * CFrame.Angles(0, math.pi, -math.pi/2);
	minLevel = 4;
	
	--> stats information <--
	baseDamage = 3;
	attackSpeed = 5;
	modifierData = {{criticalStrikeChance = 0.05}};
	--> shop information <--
	buyValue = 700;
	sellValue = 160;
		
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = false;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}
