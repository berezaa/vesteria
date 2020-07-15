
local b={baseEXP=650,level=27,baseMoney=10,baseHealth=600,baseDamage=10,attackRange=30,baseSpeed=12,attackSpeed=2,doNotLure=true,floats=true,flies=true,aggressionRange=900,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="LowerJaw",castType="box",hitboxSizeMultiplier=Vector3.new(1.3,2,1.3),originOffset=CFrame.new()}},goldMulti=10,monsterBookPage=99,bonusLootMulti=30,lootDrops={{id=1,spawnChance=1}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b