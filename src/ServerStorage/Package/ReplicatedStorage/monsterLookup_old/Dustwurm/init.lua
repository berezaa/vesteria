
local b={attackRange=192,aggressionRange=192,baseSpeed=12,attackSpeed=2,baseHealth=1,baseDamage=1,baseEXP=10,level=40,baseMoney=10,scale=0.6,damageHitboxCollection={{partName="Tongue",castType="box",originOffset=CFrame.new()},{partName="CenterMouth",castType="box",originOffset=CFrame.new()},{partName="TopJaw",castType="box",originOffset=CFrame.new()}},monsterBookPage=4,idolDropMulti=2,monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},lootDrops={{id=1,spawnChance=0.8},{itemName="dustwurm cudgel",spawnChance=
1 /256},{itemName="dustwurm longbow",spawnChance=1 /256},{id=257,spawnChance=1 /128},{id=258,spawnChance=
1 /256}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b