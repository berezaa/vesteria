return {
	id = 289,
	
	name = "Hog Tusk Dagger",
	rarity = "Rare",
	image = "rbxassetid://4899155150",
	description = "Not in a hog's face, but still used for stabbing.",
	
	--> equipment information <--
	isEquippable = true;
	equipmentSlot = 1;
	equipmentType = "dagger";
	gripCFrame = CFrame.Angles(math.pi / 2, 0, 0) * CFrame.new(-0.15, 0, 0.83) * CFrame.Angles(0, math.pi, -math.pi/2);
	minLevel = 6;
	
	--> stats information <--
	baseDamage = 4;
	attackSpeed = 5;
	modifierData = {{criticalStrikeChance = 0.07}};
	customTag = {text = "Inflicts Bleeding"; font = Enum.Font.SourceSans; textSize = 19; textColor3 = Color3.fromRGB(212, 95, 91); textTransparency = 0} ;
	--> shop information <--
	buyValue = 800;
	sellValue = 160;
		
	--> handling information <--
	canStack = false;
	canBeBound = false;
	canAwaken = false;
	
	--> sorting information <--
	isImportant = false;
	category = "equipment";
}