
local b={attackRange=8,baseSpeed=6,attackSpeed=2,baseHealth=0.8,baseDamage=1.3,baseEXP=10,level=7,baseMoney=10,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="Head",castType="sphere",radius=2.4,originOffset=CFrame.new(0,0,2)}},cameraOffset=CFrame.new(0.5,
-0.2,-0.75),monsterBookPage=1,lootDrops={{id=1,spawnChance=.7},{itemName="hog meat",spawnChance=.2},{itemName="hog meat",spawnChance=.1},{itemName="mana potion",spawnChance=
1 /15},{itemName="100% weapon attack scroll",spawnChance=1 /40},{itemName="oak axe",spawnChance=
1 /50},{itemName="shoulder pads 2",spawnChance=1 /75},{itemName="hog tusk dagger",spawnChance=1 /250},{itemName="hog headdress",spawnChance=
1 /250},{itemName="bag of sugar",spawnChance=1 /10,questItem=true,dropCircumstance=function(c,d)local _a={}
for aa,ba in pairs(c.itemOwners)do
local ca=d.network:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba)
if ca then
for da,_b in pairs(ca.quests.active)do
if _b.id==13 then local ab=false;for bb,cb in pairs(ca.inventory)do if
cb.id==146 then ab=true end end;if not ab then
table.insert(_a,ba)end end end end end;c.itemOwners=_a;return c end}},module=script}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)return b