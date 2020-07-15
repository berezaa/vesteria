
local b={baseEXP=11,level=3,baseMoney=10,baseHealth=1,baseDamage=0.85,attackRange=3.5,baseSpeed=17,attackSpeed=2.5,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},variations={poisoned={specialName="Poisoned Shroom",dye={r=160,g=255,b=160},level=6,bonusXPMulti=2.5,bonusLootMulti=4,healthMulti=2,scale=1.25,specialAttackHealth=1,specialAttackCap=10},enraged={specialName="Enraged Shroom",dye={r=255,g=122,b=122},level=6,bonusXPMulti=2.5,bonusLootMulti=4,healthMulti=2,scale=1.1}},damageHitboxCollection={{partName="LeftLeg",castType="sphere",radius=3,originOffset=CFrame.new(0,
-0.3,0.4)}},cameraOffset=CFrame.new(0,
-0.5,0.2),monsterBookPage=1,lootDrops={{id=1,spawnChance=0.8},{itemName="mushroom mini",spawnChance=0.8},{itemName="mushroom mini",spawnChance=0.2},{itemName="health potion",spawnChance=
1 /10},{itemName="mana potion",spawnChance=1 /15},{itemName="wooden sword",spawnChance=1 /30},{itemName="leather tunic",spawnChance=
1 /45}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b