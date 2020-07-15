local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
return cc,"physical","direct"end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(bc,cc)if
bc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(bc,cc)
if
bc.closestEntity then
local dc=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if dc<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then bc.__providedDirectRoamTheta=nil
bc:setTargetEntity(bc.closestEntity)return"aggro"else
if cc or bc.__providedDirectRoamTheta then
if(bc.__LAST_ROAM_TIME and
tick()-bc.__LAST_ROAM_TIME<5)and
(bc.__providedDirectRoamTheta==nil)then return"idling"end;local _d=Vector3.new(1,0,1)local ad=ac:NextInteger(1,360)
if
bc.__providedDirectRoamTheta then ad=bc.__providedDirectRoamTheta;bc.__providedDirectRoamTheta=nil end;local bd=math.rad(ad)local cd=bc.manifest.Position*_d
local dd=cd+

Vector3.new(math.cos(bd),0,math.sin(bd))*ac:NextInteger(30,bc.maxRoamDistance or 50)local __a=dd-cd;local a_a=bc.manifest.Position+
Vector3.new(0,bc.manifest.Size.Y,0)local b_a=__a-
Vector3.new(0,bc.manifest.Size.Y,0)local c_a=Ray.new(a_a,b_a)
local d_a,_aa=workspace:FindPartOnRayWithIgnoreList(c_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local aaa=(bc.manifest.Size.X+bc.manifest.Size.Z)/2;local baa=(_aa-bc.manifest.Position).magnitude
local caa=true;local daa=(_aa-__a*aaa/2)*_d
local _ba=(bc.origin and bc.origin.p or
bc.manifest.Position)*_d;local aba=(daa-_ba).magnitude;local bba=(cd-_ba).magnitude
if bba<aba then
if aba>=200 then if
ac:NextNumber()<1 then caa=false end elseif aba>=150 then if ac:NextNumber()<0.8 then
caa=false end elseif aba>=100 then
if ac:NextNumber()<0.6 then caa=false end elseif aba>=75 then if ac:NextNumber()<0.4 then caa=false end elseif aba>=50 then if
ac:NextNumber()<0.3 then caa=false end elseif aba>=25 then if ac:NextNumber()<0.2 then
caa=false end end end
if baa>=aaa and caa then bc.__directRoamGoal=daa;bc.__directRoamOrigin=cd
bc.__directRoamTheta=ad;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;bc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
local ad=_d.entity:FindFirstChild("eyes")local bd=_d.entity:FindFirstChild("eyes2")
bd.Transparency=1;ad.Transparency=0;if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then
_d.entity.PrimaryPart.running:Stop()end end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(bc,cc)
if
not bc.__IS_WAITING_FOR_PATH_FINDING then if bc.isProcessingPath then return"roaming"else
bc:setTargetEntity(nil,nil)return"idling"end end
if
bc.__PATHFIND_QUEUE_TIME and tick()-bc.__PATHFIND_QUEUE_TIME>5 then bc:resetPathfinding()return"idling"end end},["aggro"]={transitionLevel=3,lockTimeForPreventStateTransition=1,step=function(bc,cc)
local dc=bc.manifest.Position;local _d=bc.closestEntity;local ad=bc.targetEntity;local bd=ad.Position
local cd=Vector3.new(bd.X,dc.Y,bd.Z)local dd=bb.magnitude(dc-cd)local __a=(cd-dc).unit;local a_a=cd-
__a* (bc.attackRange)local b_a=cd+ad.Velocity*0.2
bc.manifest.BodyVelocity.Velocity=Vector3.new()
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(b_a.X,cd.Y,b_a.Z))return"running"end,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
local ad=_d.entity:FindFirstChild("eyes")local bd=_d.entity:FindFirstChild("eyes2")
bd.Transparency=0;ad.Transparency=1;if
_d and _d.Parent and _d:FindFirstChild("entity")then
_d.entity.HumanoidRootPart.aggro:Play()end end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)
if
bc.closestEntity and cc then
local ad=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if ad<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"aggro"end end;local dc,_d=bc.__directRoamOrigin,bc.__directRoamGoal
if dc and _d then
local ad=Vector3.new(1,0,1)local bd=bb.magnitude(_d*ad-dc*ad)
local cd=bb.magnitude(bc.manifest.Position*
ad-dc*ad)local dd=(_d*ad-dc*ad).unit;bc.manifest.BodyVelocity.Velocity=dd*
bc.baseSpeed;bc.manifest.BodyGyro.CFrame=CFrame.new(dc*ad,
_d*ad)
if cd>=bd then
if bc.__directRoamTheta and
ac:NextNumber()>0.5 then
bc.__providedDirectRoamTheta=bc.__directRoamTheta+ac:NextInteger(-35,35)return"idling"end;bc.__providedDirectRoamTheta=nil
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end;local __a=bc.manifest.BodyVelocity.Velocity
local a_a=bc.manifest.Velocity;local b_a=bc.manifest.BodyVelocity.Velocity
local c_a=bc.manifest.Velocity
local d_a=Ray.new(bc.manifest.Position,Vector3.new(0,-50,0))
local _aa=Ray.new(bc.manifest.Position+ (dd*bc.baseSpeed*0.15),Vector3.new(0,
-50,0))
local aaa,baa=workspace:FindPartOnRayWithIgnoreList(d_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local caa,daa=workspace:FindPartOnRayWithIgnoreList(_aa,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})local _ba=daa.Y-baa.Y
if-_ba>=bc.manifest.Size.Y/6 then bc.__blockConfidence=
bc.__blockConfidence+1
if
-_ba>=bc.manifest.Size.Y/1.5 then bc.__blockConfidence=bc.__blockConfidence+2 elseif-_ba>=
bc.manifest.Size.Y/3 then
bc.__blockConfidence=bc.__blockConfidence+1 end;if bc.__blockConfidence>=3 then
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end elseif
(_ba>=
bc.manifest.Size.Y/2)or(c_a.magnitude<b_a.magnitude and
bb.magnitude(b_a-c_a)>bc.baseSpeed*0.9)then bc.__blockConfidence=bc.__blockConfidence+1;if
bc.__blockConfidence>=4 then bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"end elseif bc.__blockConfidence and
bc.__blockConfidence>0 then
bc.__blockConfidence=bc.__blockConfidence-1 end;return end;return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)
if
bc.closestEntity then if not bc.path then return"idling"end
local dc=bb.magnitude(bc.closestEntity.Position-
bc.manifest.Position)local _d=bc.path[bc.currentNode]
local ad=bc.path[bc.currentNode+1]
if _d and ad then
if
ab.isPastNextPathfindingNodeNode(_d.Position,bc.manifest.Position,ad.Position)then bc.currentNode=bc.currentNode+1;bc.__PATH_FIND_NODE_START=tick()
if
dc<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then bc:resetPathfinding()
bc:setTargetEntity(bc.closestEntity)return"aggro"end else
if tick()-bc.__PATH_FIND_NODE_START<2 then
local bd=Vector3.new(ad.Position.X,bc.manifest.Position.Y,ad.Position.Z)
bc.manifest.BodyGyro.CFrame=CFrame.new(bc.manifest.Position,bd)bc.manifest.BodyVelocity.Velocity=
(bd-bc.manifest.Position).unit*bc.baseSpeed else
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end elseif _d and not ad then
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end end},["following"]={animationEquivalent="walking",transitionLevel=4,step=function(bc,cc)if
not bc.targetEntity then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity;local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
if
bc:isTargetEntityInLineOfSight(nil,true)then
bc.manifest.BodyVelocity.Velocity=__a*bc.baseSpeed;bc.manifest.BodyGyro.CFrame=CFrame.new(dc,cd)
bc.__LAST_POSITION_SEEN=a_a;bc.__LAST_MOVE_DIRECTION=__a*bc.baseSpeed else
if
not bc.__LAST_POSITION_SEEN and false then bc:setTargetEntity(nil,nil)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif bc.__LAST_POSITION_SEEN then
local b_a=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(b_a-dc).unit*bc.baseSpeed
if dd<=bc.aggressionRange then if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)<_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil,nil)return"idling"end else bc:setTargetEntity(
nil,nil)return"idling"end else bc:setTargetEntity(nil,nil)return"idling"end end
if bb.magnitude(cd-dc)<=bc.attackRange then return"attack-ready"end end},["running"]={animationEquivalent="walking",transitionLevel=4,execute=function(bc,cc,dc,_d)if
_d and _d.Parent and _d:FindFirstChild("entity")then
_d.entity.HumanoidRootPart.running:Play()end end,step=function(bc,cc)if
not bc.targetEntity then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity;local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
if
bc:isTargetEntityInLineOfSight(nil,true)then
bc.manifest.BodyVelocity.Velocity=__a*bc.baseSpeed*3;bc.manifest.BodyGyro.CFrame=CFrame.new(dc,cd)
bc.__LAST_POSITION_SEEN=a_a;bc.__LAST_MOVE_DIRECTION=__a*bc.baseSpeed*3 else
if
not bc.__LAST_POSITION_SEEN and false then bc:setTargetEntity(nil,nil)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif bc.__LAST_POSITION_SEEN then
local b_a=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(b_a-dc).unit*bc.baseSpeed*3
if dd<=bc.aggressionRange then
if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)<_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil,nil)bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"end else bc:setTargetEntity(nil,nil)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end else bc:setTargetEntity(nil,nil)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end end
if bb.magnitude(cd-dc)<=bc.attackRange then
if
bb.magnitude(ad.Velocity)>3 then
if bb.magnitude(cd-dc)<=bc.attackRange/3 then return"attack-ready"else end else return"attack-ready"end end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(bc,cc)
if
bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;local dd=bb.magnitude(dc-cd)local __a=(cd-dc).unit;local a_a=cd-
__a* (bc.attackRange)
if dd<=bc.attackRange then
local b_a=bc.manifest.Position
if tick()-bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()return"attacking"else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"running"end end},["dive"]={transitionLevel=7,step=function(bc,cc)if
cc then return"on-ground"end end},["on-ground"]={transitionLevel=7,lockTimeForLowerTransition=3,lockTimeForPreventStateTransition=1.5,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.closestEntity and cc then
local dc=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if dc<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
if not bc.targetEntity then return"idling"end;local _d=bc.manifest.Position;local ad=bc.targetEntity;local bd=bc.targetEntity
local cd=bd.Position;local dd=cd
bc.manifest.BodyGyro.CFrame=CFrame.new(_d,dd)return"running"end end;return"idling"end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;if _d:FindFirstChild("entity")then
_d.entity.PrimaryPart.running:Stop()
_d.entity.PrimaryPart.tackle:Play()end;local ad=false
local bd=bc.Character.PrimaryPart;local cd=_d.clientHitboxToServerHitboxReference.Value;local dd=cc.Length* (
dc.animationDamageStart or 0)wait(dd)local __a=
cc.Length* (dc.animationDamageEnd or 0.1)local a_a=
__a-dd;local b_a=a_a/10
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
local baa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end elseif d_a.castType=="box"then
local _aa=_d.entity[d_a.partName].CFrame*d_a.originOffset;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa.p)
if
cb.boxcast_singleTarget(_aa,
_d.entity[d_a.partName].Size* (d_a.hitboxSizeMultiplier or Vector3.new(1,1,1)),aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end end end end;wait(b_a)else break end end end,verify=function(bc)if
not bc.targetEntity then return end
delay(0.5,function()
if not bc.targetEntity then return end;local cc=bc.manifest.CFrame
local dc=cb.projection_Box(bc.targetEntity.CFrame,bc.targetEntity.Size,cc.p)
if cb.boxcast_singleTarget(cc,bc.targetEntity.Size,dc)then
db:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",
nil,bc.targetEntity,{damage=bc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end end)end,step=function(bc,cc)bc.manifest.BodyVelocity.Velocity=
bc.manifest.BodyVelocity.Velocity*1.65;return"dive"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(bc,cc)bc.specialsUsed=
bc.specialsUsed+1;if bc.__STATE_OVERRIDES["special-attacking"]then
bc.__STATE_OVERRIDES["special-attacking"](bc)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(bc,cc)return
"attack-ready"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(bc,cc)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bc,cc)return
nil end},["attacked-by-player"]={transitionLevel=1,step=function(bc)
if
bc.closestEntity then
local cc=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)if cc<=bc.aggressionRange then
bc:setTargetEntity(bc.closestEntity)return"running"end end;return"idling"end}},processDamageRequestToMonster=function(bc,cc)
if
cc.damageType=="magical"or
(cc.equipmentType=="bow"or cc.category=="projectile")then
cc.damage=math.floor(cc.damage*0.6)cc.supressed=true end;return cc end}