
local b={attackRange=5,baseSpeed=7,followSpeed=12,attackSpeed=2,baseHealth=1,baseDamage=1,baseEXP=10,level=9,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="hand_r",castType="sphere",radius=2.2,originOffset=CFrame.new(0,0,0)},{partName="hand_l",castType="sphere",radius=2.2,originOffset=CFrame.new(0,0,0)},{partName="arm_r",castType="box",originOffset=CFrame.new(),hitboxSizeMultiplier=Vector3.new(1.1,1,1.1)},{partName="arm_l",castType="box",originOffset=CFrame.new(),hitboxSizeMultiplier=Vector3.new(1.1,1,1.1)}},cameraOffset=CFrame.new(0,
-0.25,-0.2),monsterBookPage=1,lootDrops={{id=1,spawnChance=0.8},{itemName="stick",spawnChance=1 /4},{itemName="health potion",spawnChance=1 /10},{itemName="mana potion",spawnChance=
1 /15},{itemName="warrior wooden sword",spawnChance=1 /25},{itemName="vitality potion",spawnChance=1 /
40},{itemName="100% armor defense scroll",spawnChance=1 /50}},animationDamageStart=.2,animationDamageEnd=.4,module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b