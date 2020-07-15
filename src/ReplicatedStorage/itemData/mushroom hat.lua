return {
	--> identifying information <--
	id 		= 43;
	
	--> generic information <--
	name 		= "Mushroom Hat";
	rarity 		= "Common";
	image 		= "rbxassetid://2539157198";
	description = "A unique mushroom-shaped hat found in the Mushroom Forest.";
	
	itemType = "hat";
	
	--> equipment information <--
	isEquippable 	= true;
	equipmentSlot 	= 2;
	equipmentType 	= "hat";
	equipmentHairType = 2;
	
	minLevel		= 5;
	
	--> shop information <--	
	buyValue = 5000;
	sellValue = 1000;			
	
	--> stats information <--
	modifierData = {{jump = 10;}};

	statUpgrade = {
		jump = 1;
	};

	--> handling information <--
	canStack 	= false;
	canBeBound 	= false;
	canAwaken 	= true;
	clipsHair 	= true;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "equipment";
}