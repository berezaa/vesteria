local bc=game:GetService("ReplicatedStorage")
local cc=require(bc.modules)local dc=cc.load("pathfinding")local _d=cc.load("utilities")
local ad=cc.load("detection")local bd=cc.load("network")local cd=cc.load("tween")
local dd=cc.load("placeSetup")local __a=cc.load("projectile")
local a_a=game:GetService("RunService")local b_a=1;local c_a=Random.new()
local d_a=game:GetService("PhysicsService")local _aa=game:GetService("TweenService")
local aaa=dd.getPlaceFolder("entityRenderCollection")local baa="idling"
return
{default="setup",states={["setup"]={animationEquivalent="dormant",transitionLevel=0,step=function(caa)return"sleeping"end},["sleeping"]={animationEquivalent="dormant",transitionLevel=1,lockTimeForPreventStateTransition=2,step=function(caa,daa)
if
caa.closestEntity then
local _ba=_d.magnitude(caa.closestEntity.Position-caa.manifest.Position)if _ba<=caa.awakenRange then return"awaken"end end end},["idling"]={animationEquivalent="idling",transitionLevel=1,step=function(caa,daa)
if
caa.closestEntity then
local _ba=_d.magnitude(caa.closestEntity.Position-caa.manifest.Position)
if
_ba<=caa.aggressionRange and caa:isTargetEntityInLineOfSight(nil,true)then caa.__providedDirectRoamTheta=nil
caa:setTargetEntity(caa.closestEntity)local aba=caa.manifest.Position;local bba=caa.closestEntity
local cba=caa.targetEntity;local dba=cba.Position;local _ca=Vector3.new(dba.X,aba.Y,dba.Z)local aca=_d.magnitude(
aba-_ca)local bca=(_ca-aba).unit;local cca=_ca-
bca* (caa.attackRange)
local dca=_ca+cba.Velocity*0.2
caa.manifest.BodyGyro.CFrame=CFrame.new(aba,Vector3.new(dca.X,_ca.Y,dca.Z))return"attack-ready"end end end},["awaken"]={doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=2.7,transitionLevel=2,execute=function(caa,daa,_ba,aba)if
not aba or not aba.PrimaryPart then return end
local bba=script.awaken:Clone()bba.Parent=aba.PrimaryPart;bba:Play()end,step=function(caa,daa)
if
caa.closestEntity then
local _ba=_d.magnitude(caa.closestEntity.Position-caa.manifest.Position)
if _ba<=caa.aggressionRange then caa.__providedDirectRoamTheta=nil
caa:setTargetEntity(caa.closestEntity)local aba=caa.manifest.Position;local bba=caa.targetEntity;local cba=bba.Position
local dba=Vector3.new(cba.X,aba.Y,cba.Z)local _ca=_d.magnitude(aba-dba)local aca=(dba-aba).unit;local bca=dba-aca*
(caa.attackRange)
local cca=dba+bba.Velocity*0.2
caa.manifest.BodyGyro.CFrame=CFrame.new(aba,Vector3.new(cca.X,dba.Y,cca.Z))return"attack-ready"end end
if daa then caa:setTargetEntity(nil,nil)return"idling"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=3.5,execute=function(caa,daa,_ba,aba)
if
not aba or
not aba:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local bba=aba.clientHitboxToServerHitboxReference.Value
if not
game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not _ba.damageHitboxCollection then return elseif not bba then return elseif not
bba:FindFirstChild("targetEntity")then return elseif not bba.targetEntity.Value then return elseif not caa.Character or not
caa.Character.PrimaryPart then return elseif

not aba:FindFirstChild("entity")or not aba.entity:FindFirstChild("LeftLowerArm")then return end;local cba=false;local dba=caa.Character.PrimaryPart;local _ca=false;local aca=false
local bca=script.largeRockProjectile:Clone()bca.Trail.Enabled=false;local cca;local dca;local _da;local ada=bca.Size.X
local bda=bca.Size.Y;local cda=bca.Size.Z
bca.Size=Vector3.new(ada/10,bda/10,cda/10)bca.Anchored=false;bca.CanCollide=false
local dda=daa:GetMarkerReachedSignal("pickup"):Connect(function(dab)
_ca=true;local _bb=Instance.new("Weld")
bca.Parent=aba.entity.LeftLowerArm;local abb=aba.entity.LeftLowerArm;_bb.Parent=abb;_bb.Part0=abb
_bb.Part1=bca;_bb.C0=CFrame.new(0,
- (abb.Size.Y/2 +bca.Size.Y/2)+.1,0)
_aa:Create(bca,TweenInfo.new(2,Enum.EasingStyle.Quad),{Size=Vector3.new(ada,bda,cda)}):Play()
_aa:Create(_bb,TweenInfo.new(2,Enum.EasingStyle.Quad),{C0=CFrame.new(0,- (
abb.Size.Y/2 +bda/2)+.1,0)}):Play()local bbb=Instance.new("Part")bbb.Transparency=1;bbb.Anchored=true
bbb.CanCollide=false
bbb.CFrame=CFrame.new(abb.Position-Vector3.new(0,1,0))local cbb=script.pickup:Clone()cbb.Parent=bbb
bbb.Parent=workspace.CurrentCamera;cbb:Play()game.Debris:AddItem(bbb,10)end)
local __b=daa:GetMarkerReachedSignal("throw"):Connect(function(dab)
if bca.Parent then
cca=bca.Position;dca=bca.Orientation;_da=bca.CFrame
spawn(function()
if bca.Parent then bca:Destroy()end end)local _bb=aba:FindFirstChild("throw")if _bb==nil then
_bb=script.throw:Clone()_bb.Parent=aba.PrimaryPart end
_bb:Play()aca=true end end)local a_b=tick()repeat wait()until aca or tick()>a_b+20
dda:disconnect()__b:disconnect()if tick()>a_b+20 then return end
if not bba.Parent then
return elseif not bba:FindFirstChild("targetEntity")then return elseif not
bba.targetEntity.Value then return elseif
not caa.Character or not caa.Character.PrimaryPart then return elseif not aba:FindFirstChild("entity")or not
aba.entity:FindFirstChild("LeftLowerArm")then return end;local b_b=script.largeRockProjectile:Clone()
b_b.Orientation=dca;b_b.Position=cca;b_b.Parent=dd.getPlaceFolder("entities")
local c_b=75;local d_b=bba.targetEntity.Value.Velocity;d_b=Vector3.new(d_b.x*.5,0,
d_b.z*.5)local _ab=cca
local aab,bab=__a.getUnitVelocityToImpact_predictive(_ab,c_b,bba.targetEntity.Value.Position,d_b,
nil)local cab=_da-_da.p
__a.createProjectile(_ab,aab,c_b,b_b,function(dab,_bb)game:GetService("Debris"):AddItem(b_b,
2 /30)
if dab then
if caa.Character and
caa.Character.PrimaryPart then local cbb=b_b:Clone()cbb.Anchored=true
cbb.CanCollide=false;cbb.Transparency=1;cbb.Position=_bb;cbb.Parent=workspace
cbb.impact:Emit(30)
game:GetService("Debris"):AddItem(cbb,.6)local dbb=caa.Character.PrimaryPart
local _cb=ad.projection_Box(dbb.CFrame,dbb.Size,_bb)
if ad.spherecast_singleTarget(_bb,1.8,_cb)then cba=true
bd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",bba,_cb,"monster","rock-throw")
local acb=( (dbb.Position-bba.Position)*Vector3.new(1,0,1)).unit
bd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(acb*30))end end end;local abb=Instance.new("Part")abb.Transparency=1;abb.Anchored=true
abb.CanCollide=false;abb.Size=Vector3.new(0.1,0.1,0.1)
abb.CFrame=CFrame.new(_bb)local bbb=script.crash:Clone()bbb.Parent=abb
abb.Parent=workspace.CurrentCamera;bbb:Play()game.Debris:AddItem(abb,10)end,function(dab)return

cab*CFrame.Angles((math.sin(dab)+1)*-20,0,0)end,{aba,bba,aaa})end,step=function(caa,daa)if

caa.targetEntity==nil or caa.targetEntity==nil and daa then return baa end
if caa.closestEntity and daa then
local ada=_d.magnitude(
caa.closestEntity.Position-caa.manifest.Position)if ada<=caa.aggressionRange and
caa:isTargetEntityInLineOfSight(caa.aggressionRange,true)then
caa:setTargetEntity(caa.closestEntity)end end;local _ba=caa.manifest.Position;local aba=caa.targetEntity
local bba=caa.targetEntity;local cba=bba.Position;local dba=Vector3.new(cba.X,_ba.Y,cba.Z)local _ca=_d.magnitude(
_ba-dba)local aca=(dba-_ba).unit;local bca=dba-
aca* (caa.attackRange)
local cca=dba+bba.Velocity*0.2;local dca=(cca-_ba).unit
local _da=cca-dca* (caa.attackRange)
caa.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)
caa.manifest.BodyGyro.CFrame=CFrame.new(_ba,Vector3.new(cca.X,dba.Y,cca.Z))if daa then return"micro-sleeping"end end},["following"]={animationEquivalent="idling",transitionLevel=4,step=function(caa,daa)if
not caa.targetEntity then return baa end
local _ba=caa.manifest.Position;local aba=caa.targetEntity;local bba=caa.targetEntity;local cba=bba.Position;local dba=cba;if
caa.manifest.BodyVelocity.MaxForce.Y<=0.1 then
dba=Vector3.new(cba.X,_ba.Y,cba.Z)end;if caa.targetingYOffsetMulti then
dba=dba+Vector3.new(0,
caa.manifest.Size.Y*caa.targetingYOffsetMulti,0)end
dba=dba+bba.Velocity*0.1;local _ca=_d.magnitude(_ba-dba)local aca=(dba-_ba).unit;local bca=dba-aca*
(caa.attackRange)
if
caa:isTargetEntityInLineOfSight(nil,true)then
caa.manifest.BodyVelocity.Velocity=aca*caa.baseSpeed
caa.manifest.BodyGyro.CFrame=CFrame.new(_ba,dba)caa.__LAST_POSITION_SEEN=bca
caa.__LAST_MOVE_DIRECTION=aca*caa.baseSpeed;if _ca>caa.loseAggroDistance then caa:setTargetEntity(nil,nil)
caa.manifest.BodyVelocity.Velocity=Vector3.new()return baa end;if _ca<=
caa.aggressionRange then return"attacking"end else
if
not caa.__LAST_POSITION_SEEN and false then caa:setTargetEntity(nil,nil)
caa.manifest.BodyVelocity.Velocity=Vector3.new()return baa elseif caa.__LAST_POSITION_SEEN then
local cca=Vector3.new(caa.__LAST_POSITION_SEEN.X,_ba.Y,caa.__LAST_POSITION_SEEN.Z)
caa.manifest.BodyVelocity.Velocity=(cca-_ba).unit*caa.baseSpeed
if _ca<=caa.aggressionRange then if
_d.magnitude(_ba-caa.__LAST_POSITION_SEEN)<b_a then caa.__LAST_POSITION_SEEN=nil
caa:setTargetEntity(nil,nil)return baa end else caa:setTargetEntity(
nil,nil)return baa end else caa:setTargetEntity(nil,nil)return baa end end;if _d.magnitude(dba-_ba)<=caa.attackRange then
return"attack-ready-after-moving"end end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(caa,daa)
end,execute=function(caa,daa,_ba,aba)
if aba and aba.Parent and aba.entity then
if
aba.entity:FindFirstChild("LeftLowerArm")and
aba.entity.LeftLowerArm:FindFirstChild("largeRockProjectile")then
aba.entity.LeftLowerArm.largeRockProjectile.Transparency=1
aba.entity.LeftLowerArm.largeRockProjectile.CanCollide=false end
if aba.entity:FindFirstChild("Torso")then
aba.entity.Torso.charging.Enabled=true;wait(1.7)
aba.entity.Torso.charging.Enabled=false;aba.entity.Torso.spread:Emit(150)
aba.entity.Torso.steady:Emit(80)aba.entity.Torso.boom:Play()
local bba=caa.Character.PrimaryPart;local cba=aba.clientHitboxToServerHitboxReference.Value
local dba=
daa.Length* (_ba.animationDamageEnd or 0.7)local _ca=.1;local aca=false;local bca=_ca/10
for i=0,_ca,bca do
if daa.IsPlaying and not aca and
aba:FindFirstChild("entity")then
local cca=(aba.entity.Torso.CFrame*CFrame.new(0,0,3)).p;local dca=ad.projection_Box(bba.CFrame,bba.Size,cca)
if
ad.spherecast_singleTarget(cca,7,dca)then aca=true
bd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cba,dca,"monster","explode")
local _da=( (bba.Position-cba.Position)*Vector3.new(1,0,1)).unit
bd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(_da*50))end;wait(bca)else break end end end end end},["retreat"]={animationEquivalent="walking",transitionLevel=5,step=function(caa,daa)
if
caa.targetEntity==nil or caa.targetEntity==nil then return baa end;local _ba=caa.manifest.Position;local aba=caa.targetEntity
local bba=caa.targetEntity;local cba=bba.Position;local dba=cba;if
caa.manifest.BodyVelocity.MaxForce.Y<=0.1 then
dba=Vector3.new(cba.X,_ba.Y,cba.Z)end;if caa.targetingYOffsetMulti then
dba=dba+Vector3.new(0,
caa.manifest.Size.Y*caa.targetingYOffsetMulti,0)end
local _ca=_d.magnitude(_ba-dba)local aca=(dba-_ba).unit
local bca=dba-aca* (caa.attackRange)
if _ca<=caa.retreatDistance then local cca=caa.manifest.Position
caa.manifest.BodyGyro.CFrame=CFrame.new(cca,dba)
if tick()-caa.__LAST_ATTACK_TIME>=caa.attackSpeed*2 then
caa.__LAST_ATTACK_TIME=tick()return"attacking"else
caa.manifest.BodyVelocity.Velocity=-aca*caa.baseSpeed end else if tick()-caa.__LAST_ATTACK_TIME>=caa.attackSpeed+2 then return
"following"end end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(caa,daa)
if
caa.targetEntity==nil or caa.targetEntity==nil then return baa end;local _ba=caa.manifest.Position;local aba=caa.targetEntity
local bba=caa.targetEntity;local cba=bba.Position;local dba=cba;if
caa.manifest.BodyVelocity.MaxForce.Y<=0.1 then
dba=Vector3.new(cba.X,_ba.Y,cba.Z)end;if caa.targetingYOffsetMulti then
dba=dba+Vector3.new(0,
caa.manifest.Size.Y*caa.targetingYOffsetMulti,0)end
local _ca=_d.magnitude(_ba-dba)local aca=(dba-_ba).unit
local bca=dba-aca* (caa.attackRange)
if _ca<=caa.retreatDistance and
tick()-caa.__LAST_ATTACK_TIME<=caa.attackSpeed+2 then end
if
_ca<=caa.attackRange and caa:isTargetEntityInLineOfSight(nil,true)then local cca=caa.manifest.Position
caa.manifest.BodyGyro.CFrame=CFrame.new(cca,dba)if tick()-caa.__LAST_ATTACK_TIME>=caa.attackSpeed then
caa.__LAST_ATTACK_TIME=tick()return"attacking"else end else caa:setTargetEntity(
nil,nil)return"idling"end end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,step=function(caa,daa)return
"attack-ready"end},["attack-ready-after-moving"]={animationEquivalent="walking",transitionLevel=5,step=function(caa,daa)
if
caa.targetEntity==nil or caa.targetEntity==nil then return baa end;local _ba=caa.manifest.Position;local aba=caa.targetEntity
local bba=caa.targetEntity;local cba=bba.Position;local dba=cba;if
caa.manifest.BodyVelocity.MaxForce.Y<=0.1 then
dba=Vector3.new(cba.X,_ba.Y,cba.Z)end;if caa.targetingYOffsetMulti then
dba=dba+Vector3.new(0,
caa.manifest.Size.Y*caa.targetingYOffsetMulti,0)end
local _ca=_d.magnitude(_ba-dba)local aca=(dba-_ba).unit
local bca=dba-aca* (caa.attackRange)if _ca<=caa.retreatDistance then end
if _ca<=caa.attackRange then
local cca=caa.manifest.Position
caa.manifest.BodyGyro.CFrame=CFrame.new(cca,dba)if tick()-caa.__LAST_ATTACK_TIME>=caa.attackSpeed then
caa.__LAST_ATTACK_TIME=tick()return"attacking"else end else
return"following"end end}},processDamageRequest=function(caa,daa)if
caa=="explode"then return daa*2,"physical","direct"end;return
daa*1.7,"physical","projectile"end,processDamageRequestToMonster=function(caa,daa)
if
caa.state=="sleeping"or caa.state=="awaken"then daa.damage=0 end;return daa end}