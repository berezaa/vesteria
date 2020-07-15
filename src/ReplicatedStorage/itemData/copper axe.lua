return {
	--> identifying information <--
	id = 403;
	
	--> generic information <--
	name = "Copper Axe";
	rarity = "Common";
	image = "rbxassetid://5344159593";
	description = "A smelted bronze axe with a smoothed frame.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "axe";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 5;
	
	--> stats information <--
	baseDamage = 0;
	resourceDamageModifier = {
		woodcutting = 5;
	};
	
	--> shop information <--
	buyValue = 800;
	sellValue = 450;		
	
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}