return {
	--> identifying information <--
	id = 5;
	
	--> generic information <--
	name = "Stick";
	rarity = "Common";
	image = "rbxassetid://2528902878";
	description = "A particularly crisp stick.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "sword";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 1;
	
	--> stats information <--
	baseDamage = 1;
	attackSpeed = 3;
	bonusStats = {};
	
	buyValue = 100;
	sellValue = 20;
	
	--> handling information <--
	canStack 	= false;
	canBeBound 	= false;
	canAwaken 	= true;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "equipment";
}