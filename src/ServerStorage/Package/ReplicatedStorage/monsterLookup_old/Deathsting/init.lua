
local b={attackRange=2.5,baseSpeed=12,attackSpeed=2,baseHealth=1,baseDamage=1,baseEXP=10,level=45,baseMoney=10,damageHitboxCollection={{partName="RightClaw",castType="box",originOffset=CFrame.new(),hitboxSizeMultiplier=60},{partName="LeftClaw",castType="box",originOffset=CFrame.new(),hitboxSizeMultiplier=60},{partName="Stinger",castType="box",originOffset=CFrame.new(),hitboxSizeMultiplier=60}},monsterBookPage=4,idolDropMulti=2,monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},lootDrops={{id=1,spawnChance=0.75},{id=257,spawnChance=1 /
32},{id=258,spawnChance=1 /128}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b