
local b={attackRange=12,baseSpeed=6,attackSpeed=2,baseHealth=1,baseDamage=.9,baseEXP=10,level=13,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="horns",castType="sphere",radius=2,originOffset=CFrame.new(0,.5,.5)}},cameraOffset=CFrame.new(0,0,0.65),monsterBookPage=2,lootDrops={{id=1,spawnChance=1},{itemName="yeti fur",spawnChance=.7},{itemName="yeti fur",spawnChance=0.3},{itemName="yeti antler",spawnChance=
1 /10},{itemName="health potion 2",spawnChance=1 /12},{itemName="mana potion",spawnChance=1 /15},{itemName="rusty helmet",spawnChance=
1 /20},{itemName="bronze sword",spawnChance=1 /30},{itemName="dexterity potion",spawnChance=1 /40},{itemName="100% weapon attack scroll",spawnChance=
1 /50}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b