local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{default="setup",states={["setup"]={transitionLevel=0,step=function(bc)bc.targetingYOffsetMulti=
ac:NextInteger(40,60)/100;return"sleeping"end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;local cd=bb.magnitude(dc-bd)local dd=(bd-dc).unit;local __a=bd-
dd* (bc.attackRange)
if cd<=bc.attackRange then
local a_a=bc.manifest.Position;if tick()-bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()return"attacking"else end else
return"following"end end}},processDamageRequestToMonster=function(bc,cc)
if
bc.state=="attacking"and
(cc.damageType=="physical"and cc.category~="projectile")then
cc.damage=math.floor(cc.damage*0.35)cc.supressed=true end;return cc end}