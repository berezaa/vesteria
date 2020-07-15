
local b={attackRange=3,baseSpeed=14,attackSpeed=0.9,baseHealth=0.7,baseDamage=0.7,baseEXP=10,level=9,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},animationDamageEnd=1,damageHitboxCollection={{partName="Club",castType="box",hitboxSizeMultiplier=Vector3.new(1.6,1.05,1.6),originOffset=CFrame.new(0,0,0)}},monsterBookPage=1,lootDrops={{id=1,spawnChance=0.9},{itemName="goblin ear",spawnChance=0.8},{itemName="goblin ear",spawnChance=0.6},{itemName="goblin necklace",spawnChance=0.4},{itemName="wooden club",spawnChance=
1 /10},{itemName="health potion",spawnChance=1 /10},{itemName="mana potion",spawnChance=1 /15},{itemName="training staff",spawnChance=
1 /25},{itemName="intelligence potion",spawnChance=1 /40},{itemName="100% weapon attack scroll",spawnChance=
1 /50}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b