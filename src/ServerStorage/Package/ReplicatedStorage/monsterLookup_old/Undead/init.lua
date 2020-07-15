
local b={attackRange=3,baseSpeed=14,attackSpeed=0.9,baseHealth=1,baseDamage=0.7,baseEXP=10,level=9,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},animationDamageEnd=1,damageHitboxCollection={{partName="Club",castType="box",originOffset=CFrame.new(0,0,0)}},lootDrops={{id=1,spawnChance=1},{itemName="goblin necklace",spawnChance=0.5},{itemName="health potion",spawnChance=0.05},{itemName="fish",spawnChance=0.01},{itemName="mana potion",spawnChance=0.05},{itemName="ancient weapon attack scroll",spawnChance=0.00075},{itemName="wooden club",spawnChance=0.03}},module=script,id="monster"}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b