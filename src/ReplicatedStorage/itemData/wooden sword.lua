return {
	--> identifying information <--
	id = 3;
	
	--> generic information <--
	name = "Oak Sword";
	rarity = "Common";
	image = "rbxassetid://2528902907";
	description = "A wooden apprentice sword.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "sword";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0.35, 0, 2) * CFrame.Angles(0, 0, math.pi / 2);
	minLevel = 4;
	
	--> stats information <--
	baseDamage = 5;
	attackSpeed = 3;
	bonusStats = {};
	
	--> shop information <--
	buyValue = 800;
	sellValue = 160;	
	
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}