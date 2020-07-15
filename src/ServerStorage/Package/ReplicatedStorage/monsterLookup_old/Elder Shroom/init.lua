
local b={attackRange=6,baseSpeed=10,attackSpeed=3,baseHealth=1.8,baseDamage=1.05,baseEXP=20,level=5,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1,[script.Name.."0"]=1},damageHitboxCollection={{partName="RightFoot",castType="sphere",radius=3,originOffset=CFrame.new(0,0.5,1.5)}},damageHitboxCollection2={{partName="RightFoot",castType="sphere",radius=8,originOffset=CFrame.new(0,
-2.5,0)}},cameraOffset=CFrame.new(0,
-1,0.5),monsterBookPage=1,lootDrops={{id=1,spawnChance=0.7},{itemName="mushroom beard",spawnChance=1},{itemName="mushroom mini",spawnChance=0.3},{itemName="mushroom spore",spawnChance=0.3},{itemName="health potion",spawnChance=
1 /10},{itemName="mana potion",spawnChance=1 /15},{itemName="100% weapon attack scroll",spawnChance=1 /40},{itemName="rake",spawnChance=
1 /50}},module=script,animationDamageStart=.3,animationDamageEnd=1}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b