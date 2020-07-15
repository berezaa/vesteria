
local b={baseEXP=10,level=30,baseMoney=10,baseHealth=50,baseDamage=5,attackRange=3.5,baseSpeed=17,attackSpeed=2.5,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="LeftLeg",castType="sphere",radius=3,originOffset=CFrame.new(0,
-0.3,0.4)}},lootDrops={{id=1,spawnChance=1},{id="trickster jester cap",spawnChance=0.1}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b