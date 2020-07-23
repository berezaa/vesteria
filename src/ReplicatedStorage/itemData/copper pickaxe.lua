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
	-- equipmentType = "pickaxe";
	equipmentType = "sword";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 5;
	
	--> stats information <--
	baseDamage = 0;
	resourceDamageModifier = {
		mining = 5;
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