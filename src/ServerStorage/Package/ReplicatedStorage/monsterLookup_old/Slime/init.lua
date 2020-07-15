
local b={attackRange=5,baseSpeed=9,followSpeed=13,attackSpeed=2,baseHealth=0.8,baseDamage=1.1,baseEXP=10,level=45,baseMoney=10,aggressionRange=20,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="OuterLayer",castType="box",originOffset=CFrame.new(
-3,0,0),hitboxSizeMultiplier=0.8}},lootDrops={{id=1,spawnChance=0.9}},animationDamageStart=.45,animationDamageEnd=.75,module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b