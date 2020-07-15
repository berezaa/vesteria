
local b={baseEXP=10,level=13,baseMoney=10,baseHealth=0.8,baseDamage=1.2,attackRange=4,baseSpeed=22,attackSpeed=2,floats=true,flies=true,aggressionRange=50,targetingYOffsetMulti=0.5,hitboxDilution=0.6,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Stinger",castType="sphere",radius=2,originOffset=CFrame.new(0,0,0)}},cameraOffset=CFrame.new(0.25,
-0.2,-3),monsterBookPage=2,lootDrops={{id=1,spawnChance=0.8},{itemName="rubee stinger",spawnChance=0.8},{itemName="rubee eye",spawnChance=1 /10},{itemName="arrow",spawnChance=
1 /3},{itemName="health potion 2",spawnChance=1 /12},{itemName="mana potion 2",spawnChance=1 /17},{itemName="wooden bow",spawnChance=
1 /25},{itemName="hunter bandit mask",spawnChance=1 /40},{itemName="the stinger",spawnChance=1 /300}},renderOffset=CFrame.new(0,1,0),module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b