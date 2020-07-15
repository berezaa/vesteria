
local b={baseEXP=2,level=15,goldMulti=0,baseHealth=0.25,baseDamage=2.5,attackRange=4,baseSpeed=26,attackSpeed=1.3,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Mandible",castType="sphere",radius=4,originOffset=CFrame.new()}},monsterBookPage=2,lootDrops={},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b