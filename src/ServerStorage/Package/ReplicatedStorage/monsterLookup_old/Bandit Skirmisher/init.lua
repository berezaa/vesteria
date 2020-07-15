
local b={attackRange=24,baseSpeed=13,attackSpeed=2,baseHealth=0.8,baseDamage=1.1,baseEXP=10,level=40,baseMoney=10,monsterBookPage=4,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={},lootDrops={{id=1,spawnChance=0.75},{id=248,spawnChance=
1 /256},{id=87,spawnChance=0.9},{id=87,spawnChance=0.8},{id=87,spawnChance=0.7},{id=87,spawnChance=0.6},{id=183,spawnChance=
1 /64},{id="ancient weapon attack scroll dex",spawnChance=1 /96},{id=257,spawnChance=1 /128},{id=258,spawnChance=
1 /256}},aggressionRange=100,animationDamageStart=.2,animationDamageEnd=.3,module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b