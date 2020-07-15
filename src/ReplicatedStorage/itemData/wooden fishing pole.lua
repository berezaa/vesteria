return {
	--> identifying information <--
	id 		= 37;
	
	--> generic information <--
	name 		= "Old Fishing Rod";
	rarity 		= "Common";
	image 		= "rbxassetid://2544830441";
	description = "An ancient rod once used to catch fish.";
	
	--> equipment information <--
	isEquippable 	= true;
	equipmentSlot 	= 1;
	equipmentType 	= "fishingrod";
	gripCFrame 		= CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(-0.25, 0, 2.25) * CFrame.Angles(0, 0, math.pi / 2);
	gripType 		= 2;
	minLevel		= 3;
	
	--> stats information <--
	baseDamage 		= 26;
	bonusStats 		= {};

	--> shop information <--	
	buyValue = 400;
	sellValue = 150;		
	
	--> handling information <--
	canStack 	= false;
	canBeBound 	= false;
	canAwaken 	= true;
	
	--> sorting information <--
	isImportant 	= false;
	category 		= "equipment";
}