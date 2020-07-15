return {
	--> identifying information <--
	id = 27;
	
	--> generic information <--
	name = "Rusty Dagger";
	rarity = "Common";
	image = "rbxassetid://2528902431";
	description = "Give your enemies little tetanus kisses.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "dagger";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(-0.15, 0, 0.83) * CFrame.Angles(0, math.pi, -math.pi/2);
	minLevel = 6;
	
	--> stats information <--
	baseDamage = 4;
	attackSpeed = 5;
	modifierData = {{criticalStrikeChance = 0.08}};
	--> shop information <--
	buyValue = 1500;
	sellValue = 600;
		
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = false;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}
