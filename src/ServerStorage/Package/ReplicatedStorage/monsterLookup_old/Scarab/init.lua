
local b={attackRange=2.5,baseSpeed=12,attackSpeed=2,baseHealth=128,baseDamage=1,baseEXP=10,level=45,baseMoney=10,aggressionRange=200,damageHitboxCollection={{partName="Tongue",castType="box",originOffset=CFrame.new()},{partName="CenterMouth",castType="box",originOffset=CFrame.new()},{partName="TopJaw",castType="box",originOffset=CFrame.new()}},monsterBookPage=99,idolDropMulti=2,resilient=true,monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},bonusLootMulti=32,goldMulti=8,lootDrops={{id=1,spawnChance=1},{id=257,spawnChance=1 /16},{id=258,spawnChance=
1 /128},{id=274,spawnChance=1 /256},{id=275,spawnChance=1 /320},{id=296,spawnChance=1 /3200}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b