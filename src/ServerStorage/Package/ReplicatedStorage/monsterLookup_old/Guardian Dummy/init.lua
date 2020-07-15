
local b={baseEXP=10,level=14,baseMoney=10,doNotLure=true,hitboxDilution=0.9,bonusXPMulti=10,baseHealth=1000,baseDamage=2.5,aggressionRange=80,loseAggroDistance=80,attackRange=80,awakenRange=50,baseSpeed=0,attackSpeed=3,retreatDistance=-999,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},monsterBookPage=2,damageHitboxCollection={},lootDrops={{id=1,spawnChance=1},{itemName="guardian core",spawnChance=1}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b