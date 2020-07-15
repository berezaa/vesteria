
local b={attackRange=5,baseSpeed=8,attackSpeed=1,baseHealth=1.2,baseDamage=0.7,baseEXP=10,level=8,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Hand_R",castType="sphere",radius=5,originOffset=CFrame.new(0,0.5,3)}},lootDrops={{id=1,spawnChance=1},{itemName="health potion 2",spawnChance=0.15},{itemName="mana potion",spawnChance=0.1},{itemName="rake",spawnChance=0.01},{itemName="oak axe",spawnChance=0.01},{itemName="70% weapon attack scroll",spawnChance=0.005},{itemName="ancient weapon attack scroll",spawnChance=0.005}},module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b