local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)if bc=="slam"then return math.ceil(
cc*2),"physical","direct"end;return cc,
"physical","direct"end,getClosestEntities=function(bc)
local cc=bb.getEntities()
for i=#cc,1,-1 do local dc=cc[i]if
(
dc.Name=="Elder Shroom"or dc.Name=="Shroom"or dc.Name=="Baby Shroom"or dc.Name=="Chad")or dc==bc.manifest then
table.remove(cc,i)end end;return cc end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)
if
bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(bc,cc)if
bc.closestEntity then return"idling"end end},["following"]={animationEquivalent="walking",transitionLevel=4,step=function(bc,cc)if
not bc.targetEntity then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
if
bc:isTargetEntityInLineOfSight(
bc.targetEntitySetSource and 999,not bc.targetEntitySetSource)then bc.manifest.BodyVelocity.Velocity=dd*bc.baseSpeed
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(bd.X,dc.Y,bd.Z))bc.__LAST_POSITION_SEEN=__a
bc.__LAST_MOVE_DIRECTION=dd*bc.baseSpeed else
if not bc.__LAST_POSITION_SEEN and false then
bc:setTargetEntity(nil,nil)bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"elseif bc.__LAST_POSITION_SEEN then
local d_a=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(d_a-dc).unit*bc.baseSpeed
if cd<=bc.aggressionRange then if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)>_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil)return"idling"end else
if
bc.targetEntitySetSource==nil then bc:setTargetEntity(nil)return"idling"end end else bc:setTargetEntity(nil)return"idling"end end;local a_a=bc.manifest.Position
local b_a=cb.projection_Box(bc.targetEntity.CFrame,bc.targetEntity.Size,bc.manifest.Position)local c_a=bb.magnitude(a_a-b_a)if c_a<=bc.attackRange then
return"attack-ready"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(bc,cc)
if
bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;local dd=bb.magnitude(dc-cd)local __a=(cd-dc).unit;local a_a=cd-
__a* (bc.attackRange)local b_a=bc.manifest.Position
if tick()-
bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()bc.specialsUsed=bc.specialsUsed+1;if bc.specialsUsed%3 ==0 then
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"slam-attack"end
return"attacking"else bc.manifest.BodyVelocity.Velocity=Vector3.new()end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value;if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then
_d.entity.PrimaryPart.attacking:Play()end;local dd=cc.Length* (
dc.animationDamageStart or 0.3)
wait(dd)
local __a=cc.Length* (dc.animationDamageEnd or 0.7)local a_a=__a-dd;local b_a=a_a/10
for i=0,a_a,b_a do
if cc.IsPlaying and not ad and
_d:FindFirstChild("entity")then
for c_a,d_a in pairs(dc.damageHitboxCollection)do
if
_d.entity:FindFirstChild(d_a.partName)and not ad then
if d_a.castType=="sphere"then
local _aa=(
_d.entity[d_a.partName].CFrame*d_a.originOffset).p;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa)
if
cb.spherecast_singleTarget(_aa,d_a.radius,aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)+
Vector3.new(0,2,0)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end elseif d_a.castType=="box"then
local _aa=_d.entity[d_a.partName].CFrame*d_a.originOffset;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa.p)
if
cb.boxcast_singleTarget(_aa,
_d.entity[d_a.partName].Size* (d_a.hitboxSizeMultiplier or Vector3.new(1,1,1)),aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)+
Vector3.new(0,2,0)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end end end end;wait(b_a)else break end end end,step=function(bc,cc)
if
bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end
if bc.closestEntity and cc then
local b_a=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if b_a<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"following"end end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
if
bb.magnitude(ad.Velocity)>3 then local b_a=(cd-dc).unit
local c_a=cd-b_a* (bc.attackRange)
bc.manifest.BodyVelocity.Velocity=b_a* (bc.baseSpeed*0.7)else bc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"micro-sleeping"end},["slam-attack"]={transitionLevel=9,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForLowerTransition=4,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value;if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then
_d.entity.PrimaryPart.attacking:Play()end;local dd=.9
wait(dd)local __a=script.slampart:Clone()local a_a=1
if
_d.clientHitboxToServerHitboxReference.Value:FindFirstChild("monsterScale")then
a_a=_d.clientHitboxToServerHitboxReference.Value:FindFirstChild("monsterScale").Value;if a_a>=2 then a_a=a_a*1.2 elseif a_a>2 then a_a=a_a*1.7 end else end
__a.Position=_d.entity["Torso"].Position+ (
dc.damageHitboxCollection2[1].originOffset.p*a_a)
__a.Size=Vector3.new(.5 *a_a,
dc.damageHitboxCollection2[1].radius*2 *a_a,
dc.damageHitboxCollection2[1].radius*2 *a_a)if
cc.IsPlaying and not ad and _d:FindFirstChild("entity")then __a.Parent=workspace;__a.impact:Emit(100 *a_a)
game.Debris:AddItem(__a,2)end
local b_a=1;local c_a=b_a-dd;local d_a=c_a/10
for i=0,c_a,d_a do
if cc.IsPlaying and not ad and
_d:FindFirstChild("entity")then local _aa=CFrame.new(__a.Position)
local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa.p)
if
cb.boxcast_singleTarget(_aa,Vector3.new(
dc.damageHitboxCollection2[1].radius*2 *a_a,2,
dc.damageHitboxCollection2[1].radius*2 *a_a),aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster","slam")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)+
Vector3.new(0,8,0)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa* (100 *a_a)))end;wait(d_a)end end end,step=function(bc,cc)if
bc.targetEntity==nil or bc.targetEntity==nil and cc then return
"idling"end
if bc.closestEntity and cc then
local b_a=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)if b_a<=bc.aggressionRange then
bc:setTargetEntity(bc.closestEntity)return"following"end end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
if
bb.magnitude(ad.Velocity)>3 then local b_a=(cd-dc).unit
local c_a=cd-b_a* (bc.attackRange)else bc.manifest.BodyVelocity.Velocity=Vector3.new()end;bc.manifest.BodyVelocity.Velocity=Vector3.new()if cc then return
"micro-sleeping"end end}}}