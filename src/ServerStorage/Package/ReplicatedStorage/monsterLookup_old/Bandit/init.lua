
local b={baseEXP=10,level=40,baseMoney=10,baseHealth=1,baseDamage=1,attackRange=4,baseSpeed=4,attackSpeed=.7,monsterSpawnRegions={[script.Name]=1,[script.Name.."2"]=1,[script.Name.."3"]=1},damageHitboxCollection={{partName="sword",castType="box",hitboxSizeMultiplier=Vector3.new(6,2,1.2),originOffset=CFrame.new(0,0,0)}},cameraOffset=CFrame.new(0,
-0.5,0.2),monsterBookPage=4,lootDrops={{id=1,spawnChance=0.75},{id=236,spawnChance=1 /256},{id=89,spawnChance=1 /32},{id=75,spawnChance=1 /128},{id="ancient weapon attack scroll str",spawnChance=
1 /96},{id=257,spawnChance=1 /128},{id=258,spawnChance=1 /256}},module=script,monsterEvents={}}
b.maxHealth=b.baseHealth*
require(game.ReplicatedStorage.modules.levels).getMonsterHealthForLevel(b.level)
b.damage=b.baseDamage*
require(game.ReplicatedStorage.modules.levels).getMonsterDamageForLevel(b.level)
function b.monsterEvents.onMonsterDamaged(c,d)
if c.health/c.maxHealth<=0.25 and
c.specialsUsed==0 then if c.stateMachine.currentState=="attack-ready"or
c.stateMachine.currentState=="attacking"then
c.stateMachine:forceStateChange("special-attacking")end end end;return b