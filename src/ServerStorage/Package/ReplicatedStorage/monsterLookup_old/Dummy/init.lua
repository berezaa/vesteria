
local b={attackRange=0,baseSpeed=0,attackSpeed=0,baseHealth=1e9,baseDamage=0,resilient=true,baseEXP=1,level=1,baseMoney=0,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},animationDamageEnd=1,dontScale=true,damageHitboxCollection={},lootDrops={},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b