local monsterData = {
	level = 1;
	
	--> combat stats <--
	attackRange = 2.5;
	baseSpeed = 12;
	attackSpeed = 4;
	maxHealth = 6;
	damage = 2;
	defense = 0;
	
	--> death reward stuff <--
	EXP = 3;
	gold = 5;

	--> monster damage <--
	damageHitboxCollection = {
		{partName = "Cap"; castType = "box"; originOffset = CFrame.new(0, 0.5, 0)};
	};
	
	--> loot drop stuff <--
	lootDrops 	= {
		{id = 1; spawnChance = 3/4};
		{itemName = "mushroom spore"; spawnChance = 1};
		{itemName = "mushroom spore"; spawnChance = 1/7};
		{itemName = "health potion"; spawnChance = 1/12};
		{itemName = "wooden club"; spawnChance = 1/40};
	};
	
	--> ease of access <--
	module 	= script;
	id 		= "monster";
}


return monsterData