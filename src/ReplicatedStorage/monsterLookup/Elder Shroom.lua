local monsterData = {
	level = 5;
	
	--> combat stats <--
	attackRange = 6;
	baseSpeed = 10;
	attackSpeed = 3.2;
	maxHealth = 30;
	damage = 8;
	defense = 1;
	
	--> death reward stuff <--
	EXP = 20;
	gold = 25;	
	
	--> monster damage <--
	damageHitboxCollection = {
		{partName = "RightFoot"; castType = "sphere"; radius = 3; originOffset = CFrame.new(0, 0.5, 1.5)};
	};
	-- only for effect rn 
	damageHitboxCollection2 = {
		{partName = "RightFoot"; castType = "sphere"; radius = 6; originOffset = CFrame.new(0, -2.5, 0)};
	};
	
	--> loot drop stuff <--
	lootDrops 	= {
		{id = 1; spawnChance = 3/4};
		{itemName = "mushroom beard"; spawnChance = 1};
		{itemName = "mushroom mini"; spawnChance = 1/7};
		{itemName = "mushroom spore"; spawnChance = 1/7};
		{itemName = "health potion"; spawnChance = 1/8};
		{itemName = "mana potion"; spawnChance = 1/12};
		{itemName = "100% weapon attack scroll"; spawnChance = 1/40};
		{itemName = "rune mushtown"; spawnChance = 1/120};
		{itemName = "shoulder pads 2"; spawnChance = 1/150};
		{itemName = "worn boots"; spawnChance = 1/200};
		
	};
	
	--> ease of access <--
	module = script;
	
	animationDamageStart = .3;
	animationDamageEnd = 1;
}

return monsterData