
local b={attackRange=10,baseSpeed=20,attackSpeed=2,baseHealth=0.5,baseDamage=0.01,baseEXP=10,level=49,baseMoney=10,aggressionRange=200,damageHitboxCollection={{partName="UpperTeeth",castType="box",originOffset=CFrame.new()},{partName="LowerTeeth",castType="box",originOffset=CFrame.new()},{partName="TailFour",castType="box",originOffset=CFrame.new()}},monsterBookPage=99,idolDropMulti=2,resilient=true,monsterSpawnRegions={[script.Name]=1,[
script.Name.."2"]=1,[script.Name.."3"]=1},bonusLootMulti=32,goldMulti=8,lootDrops={{id=1,spawnChance=1}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b