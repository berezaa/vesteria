local monsterData = {
	--> combat stats <--
	attackRange = 0;
	baseSpeed 	= 0;
	attackSpeed = 0;

	baseHealth  = 1e9;
	baseDamage 	= 0;
	maxHealth = 1e9;
	damage = 0;

	--> gameplay flags <--
	resilient = true;

	--> death reward stuff <--
	baseEXP 	= 1;
	level 		= 1;
	baseMoney 	= 0;

	--> spawn region stuff <--
	monsterSpawnRegions = {
		[script.Name] = 1;
		[script.Name.."2"] = 1;
		[script.Name.."3"] = 1;
	};

	animationDamageEnd 	= 1;
	dontScale 			= true;

	--> monster damage <--
	damageHitboxCollection = {

	};

	--> loot drop stuff <--
	lootDrops 	= {

	};

	--> ease of access <--
	module 	= script;
	id 		= "monster";
}

return monsterData