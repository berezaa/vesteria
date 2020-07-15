
local b={attackRange=2.5,baseSpeed=12,attackSpeed=2,baseHealth=1,baseDamage=1,baseEXP=10,level=35,baseMoney=10,damageHitboxCollection={{partName="RightClaw",castType="box",originOffset=CFrame.new()},{partName="LeftClaw",castType="box",originOffset=CFrame.new()},{partName="Stinger",castType="box",originOffset=CFrame.new()}},monsterBookPage=4,idolDropMulti=2,monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},lootDrops={{id=1,spawnChance=0.75},{id=268,spawnChance=1 /
6},{id=269,spawnChance=1 /3},{id=230,spawnChance=1 /256},{id=257,spawnChance=1 /128},{id=258,spawnChance=1 /
256}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b