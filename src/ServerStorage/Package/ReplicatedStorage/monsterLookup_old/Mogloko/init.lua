
local b={attackRange=48,baseSpeed=0,followSpeed=0,attackSpeed=2,baseHealth=0.8,baseDamage=1.1,baseEXP=10,level=34,baseMoney=10,aggressionRange=48,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="spear",castType="sphere",radius=1.5,originOffset=CFrame.new(0,2.5,0)}},cameraOffset=CFrame.new(0,
-0.25,-0.2),monsterBookPage=3,lootDrops={{id=1,spawnChance=0.9},{itemName="mogomelon",spawnChance=0.8},{itemName="mogomelon",spawnChance=0.4},{itemName="mana potion 3",spawnChance=
1 /40},{itemName="moglo mask fragment fractured",spawnChance=1 /64},{itemName="100% headgear defense scroll",spawnChance=
1 /96},{itemName="moglo mask fragment shattered",spawnChance=1 /128},{itemName="mogloko mask",spawnChance=
1 /4000}},animationDamageStart=.45,animationDamageEnd=.75,module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b