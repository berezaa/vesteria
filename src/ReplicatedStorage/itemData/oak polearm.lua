return {
	--> identifying information <--
	id 		= 13;

	--> generic information <--
	name = "Oak Polearm";
	rarity = "Common";
	--
	image = "rbxassetid://2528901964";
	description = "A sturdy polearm made from great oak. Great at felling large groups of monsters.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "greatsword";
	gripCFrame = CFrame.Angles(math.pi / 1, 0, math.pi) * CFrame.new(-.45, 0, 1.6) * CFrame.Angles(0, 0, math.pi / 2);
	minLevel = 6;
	
	--> stats information <--
	baseDamage = 11;
	attackSpeed = 2;
	bonusStats = {};
	
	--> shop information <--
	buyValue = 1500;
	sellValue = 450;		
	
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}