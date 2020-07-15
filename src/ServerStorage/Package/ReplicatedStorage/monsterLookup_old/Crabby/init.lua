
local b={attackRange=6,baseSpeed=13,attackSpeed=2,baseHealth=0.8,baseDamage=1.1,baseEXP=10,level=9,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="claw_R",castType="sphere",radius=2,originOffset=CFrame.new(0,0,.5)},{partName="claw_L",castType="sphere",radius=2,originOffset=CFrame.new(0,0,.5)}},cameraOffset=CFrame.new(0,
-0.25,-0.2),monsterBookPage=1,lootDrops={{id=1,spawnChance=0.8},{itemName="crabby claw",spawnChance=0.8},{itemName="crabby claw",spawnChance=0.6},{itemName="health potion",spawnChance=
1 /10},{itemName="mana potion",spawnChance=1 /15},{itemName="wooden dagger",spawnChance=1 /25},{itemName="strength potion",spawnChance=
1 /40},{itemName="100% armor defense scroll",spawnChance=1 /50},{itemName="crabby armor",spawnChance=
1 /250}},animationDamageStart=.2,animationDamageEnd=.3,module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b