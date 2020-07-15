return {
	--> combat stats <--
	attackRange = 2;
	baseSpeed 	= 6;
	baseHealth 	= 10;

--	healthMulti = 10000;

	doNotLure = true;

	attackSpeed = 2;
	baseDamage 	= 10;
	
	--> death reward stuff <--
	baseEXP 	= 10;
	level 		= 2;
	baseMoney 	= 10;

	--> monster damage <--
	damageHitboxCollection = {};
	
	--> loot drop stuff <--
	lootDrops 	= {
		{id = 270; spawnChance = 0.5};
		{id = 271; spawnChance = 1};
		{id = 277; spawnChance = 0.7};
	};
	
	--> ease of access <--
	module 	= script;
	id 		= "chicken";
}