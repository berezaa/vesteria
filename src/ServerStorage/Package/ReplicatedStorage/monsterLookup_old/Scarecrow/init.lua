
local b={baseEXP=11,level=15,baseMoney=10,goldMulti=0.7,baseHealth=1,baseDamage=.8,velocityMaxForceMultiplier=5,attackRange=5,baseSpeed=10,dashSpeed=30,attackSpeed=2,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Sickle",castType="sphere",radius=2,originOffset=CFrame.new(0,
3.31 /3,0)}},monsterBookPage=2,lootDrops={{id=1,spawnChance=0.8},{itemName="hay",spawnChance=0.8},{itemName="hay",spawnChance=0.2},{itemName="arrow",spawnChance=
1 /10},{itemName="health potion 2",spawnChance=1 /12},{itemName="mana potion 2",spawnChance=1 /17},{itemName="100% weapon attack scroll",spawnChance=
1 /35},{itemName="70% armor defense scroll",spawnChance=1 /70},{itemName="willow staff",spawnChance=
1 /50},{itemName="bronze armor",spawnChance=1 /60},{itemName="mage hat 2",spawnChance=1 /70},{itemName="sickle",spawnChance=
1 /80}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)
function b.monsterEvents.onStateChanged(c,d,_a)
if _a=="running"then c.baseSpeed=30
c.damage=c.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(c.level)*1.5 elseif _a=="walking"or _a=="idling"or _a=="attacking"then
c.baseSpeed=10
c.damage=c.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(c.level)end end;return b