return {
	--> identifying information <--
	id = 502;
	
	--> generic information <--
	name = "Stone Pickaxe";
	rarity = "Common";
	image = "rbxassetid://5344159226";
	description = "A sharp stone pickaxe built on a sturdier oak frame.";
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	-- equipmentType = "pickaxe";
	equipmentType = "sword";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(0, -0.2, 2);
	minLevel = 3;
	
	--> stats information <--
	baseDamage = 0;
	resourceDamageModifier = {
		mining = 4;
	};
	
	--> shop information <--
	buyValue = 500;
	sellValue = 300;	
	
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = true;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}