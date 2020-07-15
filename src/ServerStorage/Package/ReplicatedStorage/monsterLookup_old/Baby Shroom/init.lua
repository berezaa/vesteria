
local b={attackRange=2.5,baseSpeed=12,attackSpeed=2,baseHealth=0.8,baseDamage=0.7,baseEXP=12,level=1,baseMoney=10,variations={tough={specialName="Tough Baby Shroom",dye={r=248,g=226,b=53},level=2,bonusXPMulti=1,bonusLootMulti=2,healthMulti=1.5,scale=1.2,attackSpeed=1.5}},monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Cap",castType="box",originOffset=CFrame.new(0,0.5,0)}},monsterBookPage=1,idolDropMulti=2,lootDrops={{id=1,spawnChance=0.7},{itemName="mushroom spore",spawnChance=0.7},{itemName="mushroom spore",spawnChance=0.4},{itemName="health potion",spawnChance=
1 /10},{itemName="wooden club",spawnChance=1 /20},{itemName="straw hat",spawnChance=1 /50}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b