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
bc.closestEntity then return"idling"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(bc,cc)
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
return"attacking"else bc.manifest.BodyVelocity.Velocity=Vector3.new()end end},["slam-attack"]={transitionLevel=9,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForLowerTransition=4,execute=function(bc,cc,dc,_d)
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