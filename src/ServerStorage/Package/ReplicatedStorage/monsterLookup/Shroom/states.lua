local _b=game:GetService("ReplicatedStorage")
local ab=require(_b.modules)local bb=ab.load("pathfinding")local cb=ab.load("utilities")
local db=ab.load("detection")local _c=ab.load("network")local ac=1;local bc=Random.new()local cc
return
{processDamageRequest=function(dc,_d)
if
dc=="poison"then return math.ceil(_d*0.2),"magical","aoe"end;return _d,"physical","direct"end,getClosestEntities=function(dc)
local _d=cb.getEntities()
for i=#_d,1,-1 do local ad=_d[i]if
(
ad.Name=="Elder Shroom"or ad.Name=="Shroom"or ad.Name=="Baby Shroom"or ad.Name=="Chad")or ad==dc.manifest then
table.remove(_d,i)end end;return _d end,default="idling",states={["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(dc,_d)if
dc.targetEntity==nil then return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;local __a=cb.magnitude(ad-dd)local a_a=(dd-ad).unit;local b_a=dd-
a_a* (dc.attackRange)
if __a<=dc.attackRange then
local c_a=dc.manifest.Position
if tick()-dc.__LAST_ATTACK_TIME>=dc.attackSpeed then
dc.__LAST_ATTACK_TIME=tick()local d_a=(dc.specialAttackHealth or 0.25)
local _aa=(dc.specialAttackCap or 1)dc.specialsUsed=dc.specialsUsed or 0
if
dc.health<=dc.maxHealth*d_a and dc.specialsUsed<_aa then
dc.specialsUsed=dc.specialsUsed+1;return"spore-attack"end;return"attacking"else
dc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"following"end end},["spore-attack"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value;bd.entity.Head.Smoke.Enabled=true
bd.entity.HumanoidRootPart["spore-attack"]:Play()wait(.5)bd.entity.Head.Smoke.Enabled=false
local a_a=script.LingeringSmokePart:Clone()local b_a=bd.clientHitboxToServerHitboxReference.Value;if ad.scale then a_a.Size=
a_a.Size*ad.scale end
a_a.Position=
bd.entity.Head.Position+ (b_a.CFrame.lookVector*b_a.Size.X)a_a.Parent=b_a;local c_a=true
spawn(function()wait(6)if a_a and a_a.Parent then
a_a.Smoke.Enabled=false;c_a=false end;wait(3)if a_a.Parent then
game:GetService("Debris"):AddItem(a_a,1)end end)
spawn(function()
while c_a do
if dc.Character and dc.Character.PrimaryPart and
dc.Character.PrimaryPart.health.Value>0 and
a_a.Parent==b_a then local d_a=false
local _aa=dc.Character.PrimaryPart
if not d_a then local aaa=a_a.CFrame
local baa=db.projection_Box(_aa.CFrame,_aa.Size,aaa.p)
if db.boxcast_singleTarget(aaa,a_a.Size,baa)then d_a=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",b_a,baa,"monster","poison")wait(0.2)end end end;wait(.2)end end)end,verify=function(dc)if
not dc.targetEntity then return end
delay(0.5,function()
if not dc.targetEntity then return end;local _d=dc.manifest.CFrame
local ad=db.projection_Box(dc.targetEntity.CFrame,dc.targetEntity.Size,_d.p)
if(dc.manifest.Position-ad).magnitude<=6 then
_c:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",
nil,dc.targetEntity,{damage=dc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end end)end,step=function(dc,_d)if
dc.targetEntity==nil then return"idling"end
if dc.closestEntity and _d then
local c_a=cb.magnitude(
dc.closestEntity.Position-dc.manifest.Position)
if c_a<=dc.aggressionRange and
dc:isTargetEntityInLineOfSight(dc.aggressionRange,true)then
dc:setTargetEntity(dc.closestEntity)return"following"end end;local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;dd=dd+bd.Velocity*0.1;local __a=cb.magnitude(ad-dd)
local a_a=(dd-ad).unit;local b_a=dd-a_a* (dc.attackRange)
if
cb.magnitude(bd.Velocity)>3 then local c_a=(dd-ad).unit
local d_a=dd-c_a* (dc.attackRange)
dc.manifest.BodyVelocity.Velocity=c_a* (dc.baseSpeed*0.7)else dc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"micro-sleeping"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(dc,_d)if
dc.__STATE_OVERRIDES["special-attacking"]then
dc.__STATE_OVERRIDES["special-attacking"](dc)end;return"special-recovering"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(dc,_d)return
"attack-ready"end}}}