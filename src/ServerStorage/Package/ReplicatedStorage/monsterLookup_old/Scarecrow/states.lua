local ca=game:GetService("ReplicatedStorage")
local da=require(ca.modules)local _b=da.load("pathfinding")local ab=da.load("detection")
local bb=da.load("network")local cb=da.load("tween")local db=1
return
{default="setup",states={["setup"]={animationEquivalent="idling-on-cross",transitionLevel=0,step=function(_c)return"idling-on-cross"end},["sleeping"]={timeBetweenUpdates=5,transitionLevel=1,animationEquivalent="idling",step=function(_c,ac)if
_c.closestEntity then return"idling"end end},["idling-on-cross"]={animationEquivalent="idling-on-cross",lockTimeForPreventStateTransition=0.5,transitionLevel=2,execute=function(_c,ac,bc,cc)
if


cc and cc:FindFirstChild("clientHitboxToServerHitboxReference")and cc.clientHitboxToServerHitboxReference.Value then local dc=script.cross:Clone()dc.Parent=cc
dc:SetPrimaryPartCFrame(
cc.clientHitboxToServerHitboxReference.Value.CFrame*CFrame.new(0,0,0.8)*
CFrame.Angles(0,math.rad(90),0)-Vector3.new(0,0.4,0))end end,step=function(_c,ac)
if
_c.randomSitOrientated==nil then _c.randomSitOrientated=true
_c.manifest.BodyGyro.CFrame=CFrame.new(_c.manifest.Position,
_c.manifest.Position+
Vector3.new(math.random(-20,20),0,math.random(-20,20)))end;_c.manifest.BodyVelocity.Velocity=Vector3.new()if
_c.IS_ELEVATED then end
if _c.closestEntity and _c.closestEntity then
local bc=(_c.closestEntity.Position-
_c.manifest.Position).magnitude
if bc<=_c.aggressionRange and
_c:isTargetEntityInLineOfSight(_c.aggressionRange,true)then
_c:setTargetEntity(_c.closestEntity)return"getting-down"end end end},["getting-down"]={lockTimeForLowerTransition=1,transitionLevel=10,execute=function(_c,ac,bc,cc)
local dc=cc:FindFirstChild("cross")
if dc then for _d,ad in pairs(dc:GetChildren())do
if ad:IsA("BasePart")then ad.Anchored=false
ad.CanCollide=true;cb(ad,{"Transparency"},1,2)end end
game.Debris:AddItem(dc,2)end
if cc:FindFirstChild("entity")then
local _d=cc.entity:FindFirstChild("eye1")local ad=cc.entity:FindFirstChild("eye2")
if _d and _d then
cb(_d,{"Transparency"},0,0.5)cb(ad,{"Transparency"},0,0.5)end end end,step=function(_c,ac)
_c.manifest.BodyVelocity.Velocity=Vector3.new()
if _c.closestEntity then return"walking"else _c:setTargetEntity(nil,nil)return"sleeping"end end},["idling"]={lockTimeForLowerTransition=0.5,transitionLevel=2,execute=function(_c,ac,bc,cc)
local dc=cc.entity:FindFirstChild("eye1")local _d=cc.entity:FindFirstChild("eye2")
if dc and dc then
cb(dc,{"Transparency"},1,0.5)cb(_d,{"Transparency"},1,0.5)end end,step=function(_c,ac)
_c.manifest.BodyVelocity.Velocity=Vector3.new()
if _c.closestEntity then
local bc=(_c.closestEntity.Position-_c.manifest.Position).magnitude
if bc<=_c.aggressionRange and
_c:isTargetEntityInLineOfSight(_c.aggressionRange,true)then
_c:setTargetEntity(_c.closestEntity)return"walking"end else _c:setTargetEntity(nil,nil)return"sleeping"end end},["running"]={animationEquivalent="following",transitionLevel=3,step=function(_c,ac)if
not _c.targetEntity then return"idling"end
local bc=_c.manifest.Position;local cc=_c.targetEntity;local dc=_c.targetEntity;local _d=dc.Position;local ad=
Vector3.new(_d.X,bc.Y,_d.Z)+dc.Velocity*0.35
local bd=(bc-ad).magnitude;local cd=(ad-bc).unit;local dd=ad-cd* (_c.attackRange)
if _c:isTargetEntityInLineOfSight(
nil,true)then
_c.manifest.BodyVelocity.Velocity=cd*_c.baseSpeed;_c.manifest.BodyGyro.CFrame=CFrame.new(bc,ad)
_c.__LAST_POSITION_SEEN=dd;_c.__LAST_MOVE_DIRECTION=cd*_c.baseSpeed else
_c.manifest.BodyVelocity.Velocity=Vector3.new()
if not _c.__LAST_POSITION_SEEN then _c:setTargetEntity(nil,nil)
_c.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif _c.__LAST_POSITION_SEEN then
local __a=Vector3.new(_c.__LAST_POSITION_SEEN.X,bc.Y,_c.__LAST_POSITION_SEEN.Z)
_c.manifest.BodyVelocity.Velocity=(__a-bc).unit*_c.baseSpeed
if bd<=_c.aggressionRange then if
(bc-_c.__LAST_POSITION_SEEN).magnitude<db then _c.__LAST_POSITION_SEEN=nil;_c:setTargetEntity(nil,nil)
return"idling"end else
_c:setTargetEntity(nil,nil)return"idling"end else _c:setTargetEntity(nil,nil)return"idling"end end
if(ad-bc).magnitude<=_c.attackRange*0.75 then return"assassinate"end end},["walking"]={transitionLevel=3,execute=function(_c,ac,bc,cc)if
not cc:FindFirstChild("entity")then return end
local dc=cc.entity:FindFirstChild("eye1")local _d=cc.entity:FindFirstChild("eye2")
if dc and dc then
cb(dc,{"Transparency"},0,0.5)cb(_d,{"Transparency"},0,0.5)end end,step=function(_c,ac)if
not _c.targetEntity then return"idling"end
local bc=_c.manifest.Position;local cc=_c.targetEntity;local dc=_c.targetEntity;local _d=dc.Position
local ad=Vector3.new(_d.X,bc.Y,_d.Z)local bd=(bc-ad).magnitude;local cd=(ad-bc).unit
local dd=ad-cd* (_c.attackRange)
if _c:isTargetEntityInLineOfSight(nil,true)then _c.manifest.BodyVelocity.Velocity=
cd*_c.baseSpeed
_c.manifest.BodyGyro.CFrame=CFrame.new(bc,ad)_c.__LAST_POSITION_SEEN=dd;_c.__LAST_MOVE_DIRECTION=cd*_c.baseSpeed
if
bd>=12 then
local __a=Ray.new(_c.origin.p,(bc-_c.origin.p))
local a_a=game.CollectionService:GetTagged("scarecrowRaycastPart")
local b_a,c_a,d_a=workspace:FindPartOnRayWithWhitelist(__a,a_a)if b_a then return"outside-pen-walk"end;return"running"end else
if not _c.__LAST_POSITION_SEEN and false then
_c:setTargetEntity(nil,nil)_c.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"elseif _c.__LAST_POSITION_SEEN then
local __a=Vector3.new(_c.__LAST_POSITION_SEEN.X,bc.Y,_c.__LAST_POSITION_SEEN.Z)
_c.manifest.BodyVelocity.Velocity=(__a-bc).unit*_c.baseSpeed
if bd<=_c.aggressionRange then if
(bc-_c.__LAST_POSITION_SEEN).magnitude<db then _c.__LAST_POSITION_SEEN=nil;_c:setTargetEntity(nil,nil)
return"idling"end else
_c:setTargetEntity(nil,nil)return"idling"end else _c:setTargetEntity(nil,nil)return"idling"end end
if(ad-bc).magnitude<=_c.attackRange then return"attack-ready"end end},["outside-pen-walk"]={transitionLevel=3,animationEquivalent="walking",execute=function(_c,ac,bc,cc)if
not cc:FindFirstChild("entity")then return end
local dc=cc.entity:FindFirstChild("eye1")local _d=cc.entity:FindFirstChild("eye2")
if dc and dc then
cb(dc,{"Transparency"},0,0.5)cb(_d,{"Transparency"},0,0.5)end end,step=function(_c,ac)if
not _c.targetEntity then return"idling"end
local bc=_c.manifest.Position;local cc=_c.targetEntity;local dc=_c.targetEntity;local _d=dc.Position
local ad=Vector3.new(_d.X,bc.Y,_d.Z)local bd=(bc-ad).magnitude;local cd=(ad-bc).unit
local dd=ad-cd* (_c.attackRange)
if _c:isTargetEntityInLineOfSight(nil,true)then _c.manifest.BodyVelocity.Velocity=
cd*_c.baseSpeed
_c.manifest.BodyGyro.CFrame=CFrame.new(bc,ad)_c.__LAST_POSITION_SEEN=dd;_c.__LAST_MOVE_DIRECTION=cd*_c.baseSpeed;if
bd<_c.attackRange then return"attack-ready"end
return"outside-pen-walk"else
if not _c.__LAST_POSITION_SEEN and false then
_c:setTargetEntity(nil,nil)_c.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"elseif _c.__LAST_POSITION_SEEN then
local __a=Vector3.new(_c.__LAST_POSITION_SEEN.X,bc.Y,_c.__LAST_POSITION_SEEN.Z)
_c.manifest.BodyVelocity.Velocity=(__a-bc).unit*_c.baseSpeed
if bd<=_c.aggressionRange then if
(bc-_c.__LAST_POSITION_SEEN).magnitude<db then _c.__LAST_POSITION_SEEN=nil;_c:setTargetEntity(nil,nil)
return"idling"end else
_c:setTargetEntity(nil,nil)return"idling"end else _c:setTargetEntity(nil,nil)return"idling"end end
if(ad-bc).magnitude<=_c.attackRange then return"attack-ready"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(_c,ac)if
not _c.targetEntity then return"idling"end
local bc=_c.manifest.Position;local cc=_c.targetEntity;local dc=_c.targetEntity;local _d=dc.Position
local ad=Vector3.new(_d.X,bc.Y,_d.Z)local bd=(bc-ad).magnitude;local cd=(ad-bc).unit
local dd=ad-cd* (_c.attackRange)
if bd<=_c.attackRange then local __a=_c.manifest.Position
_c.manifest.BodyGyro.CFrame=CFrame.new(__a,ad)
if tick()-_c.__LAST_ATTACK_TIME>=_c.attackSpeed then
_c.__LAST_ATTACK_TIME=tick()return"attacking"else
_c.manifest.BodyVelocity.Velocity=Vector3.new()_c.__LAST_UPDATE=tick()end else return"walking"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(_c,ac,bc,cc)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not bc.damageHitboxCollection then end;if cc:FindFirstChild("entity")and
cc.entity.PrimaryPart:FindFirstChild("attacking")then
cc.entity.PrimaryPart.attacking:Play()end;local dc=false
local _d=_c.Character.PrimaryPart;local ad=cc.clientHitboxToServerHitboxReference.Value;local bd=ac.Length* (
bc.animationDamageStart or 0.3)
wait(bd)
local cd=ac.Length* (bc.animationDamageEnd or 0.7)local dd=cd-bd;local __a=dd/10
for i=0,dd,__a do
if ac.IsPlaying and not dc and
cc:FindFirstChild("entity")then
for a_a,b_a in pairs(bc.damageHitboxCollection)do
if
cc.entity:FindFirstChild(b_a.partName)and not dc then
if b_a.castType=="sphere"then
local c_a=(
cc.entity[b_a.partName].CFrame*b_a.originOffset).p;local d_a=ab.projection_Box(_d.CFrame,_d.Size,c_a)if
ab.spherecast_singleTarget(c_a,b_a.radius,d_a)then dc=true
bb:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ad,d_a,"monster")end elseif
b_a.castType=="box"then
local c_a=cc.entity[b_a.partName].CFrame*b_a.originOffset;local d_a=ab.projection_Box(_d.CFrame,_d.Size,c_a.p)
if
ab.boxcast_singleTarget(c_a,cc.entity[b_a.partName].Size,d_a)then dc=true
bb:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ad,d_a,"monster")end end end end;wait(__a)else break end end end,verify=function(_c)if
not _c.targetEntity then return end
delay(0.5,function()
if not _c.targetEntity then return end;local ac=_c.manifest.CFrame
local bc=ab.projection_Box(_c.targetEntity.CFrame,_c.targetEntity.Size,ac.p)
if ab.boxcast_singleTarget(ac,_c.targetEntity.Size,bc)then
bb:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",
nil,_c.targetEntity,{damage=_c.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end end)end,step=function(_c,ac)
if
_c.targetEntity==nil or _c.targetEntity==nil then return"idling"end;local bc=_c.manifest.Position;local cc=_c.targetEntity;local dc=_c.targetEntity
local _d=dc.Position;local ad=Vector3.new(_d.X,bc.Y,_d.Z)
local bd=(bc-ad).magnitude;local cd=(ad-bc).unit;local dd=ad-cd* (_c.attackRange)
if
dc.Velocity.magnitude>3 then local __a=(ad-bc).unit
local a_a=ad-__a* (_c.attackRange)
_c.manifest.BodyVelocity.Velocity=__a* (_c.baseSpeed*0.5)_c.__LAST_UPDATE=tick()+0.125 else
_c.manifest.BodyVelocity.Velocity=Vector3.new()_c.__LAST_UPDATE=tick()end;return"running"end},["assassinate"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(_c,ac,bc,cc)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not bc.damageHitboxCollection then end;local dc=false;local _d=_c.Character.PrimaryPart
local ad=cc.clientHitboxToServerHitboxReference.Value
local bd=ac.Length* (bc.animationDamageStart or 0.3)if cc:FindFirstChild("entity")and
cc.entity.PrimaryPart:FindFirstChild("assassinate")then
cc.entity.PrimaryPart.assassinate:Play()end
wait(bd)
local cd=ac.Length* (bc.animationDamageEnd or 0.7)local dd=cd-bd;local __a=dd/10
for i=0,dd,__a do
if ac.IsPlaying and not dc and
cc:FindFirstChild("entity")then
for a_a,b_a in pairs(bc.damageHitboxCollection)do
if
cc.entity:FindFirstChild(b_a.partName)and not dc then
if b_a.castType=="sphere"then
local c_a=(
cc.entity[b_a.partName].CFrame*b_a.originOffset).p;local d_a=ab.projection_Box(_d.CFrame,_d.Size,c_a)if
ab.spherecast_singleTarget(c_a,b_a.radius,d_a)then dc=true
bb:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ad,d_a,"monster")end elseif
b_a.castType=="box"then
local c_a=cc.entity[b_a.partName].CFrame*b_a.originOffset;local d_a=ab.projection_Box(_d.CFrame,_d.Size,c_a.p)
if
ab.boxcast_singleTarget(c_a,cc.entity[b_a.partName].Size,d_a)then dc=true
bb:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ad,d_a,"monster")end end end end;wait(__a)else break end end end,verify=function(_c)if
not _c.targetEntity then return end
delay(0.5,function()
if not _c.targetEntity then return end;local ac=_c.manifest.CFrame
local bc=ab.projection_Box(_c.targetEntity.CFrame,_c.targetEntity.Size,ac.p)
if ab.boxcast_singleTarget(ac,_c.targetEntity.Size,bc)then
bb:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",
nil,_c.targetEntity,{damage=_c.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end end)end,step=function(_c,ac)
_c.manifest.BodyVelocity.Velocity=Vector3.new()
if _c.targetEntity==nil or _c.targetEntity==nil then return"idling"end;return"special-recovering"end},["special-attacking"]={transitionLevel=7,step=function(_c,ac)_c.specialsUsed=
_c.specialsUsed+1;if _c.__STATE_OVERRIDES["special-attacking"]then
_c.__STATE_OVERRIDES["special-attacking"](_c)end;return"special-recovering"end},["micro-sleeping"]={transitionLevel=8,lockTimeForLowerTransition=0.5,step=function(_c,ac)return
"attack-ready"end},["special-recovering"]={transitionLevel=9,lockTimeForLowerTransition=0.5,step=function(_c,ac)return
"attack-ready"end},["getting-up"]={lockTimeForLowerTransition=1,transitionLevel=10,step=function(_c,ac)
_c.manifest.BodyVelocity.Velocity=Vector3.new()if _c.closestEntity then _c.__HAS_ATTACKED_BEFORE=true;return"idling"else
_c:setTargetEntity(nil,nil)return"sleeping"end end},["dead"]={transitionLevel=math.huge,stopTransitions=false,step=function(_c,ac)return
nil end}},processDamageRequestToMonster=function(_c,ac)
if
_c.state=="idling-on-cross"then
ac.damage=math.floor(ac.damage*0.1)ac.supressed=true elseif

(_c.state=="idling"or _c.state=="sleeping")and(ac.equipmentType=="bow"or ac.category=="projectile")then ac.damage=math.floor(ac.damage*0.25)
ac.supressed=true end;return ac end}