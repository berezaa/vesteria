local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{default="setup",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)
local cc=bc.manifest
spawn(function()wait(1)bb.playSound("theYetiSpawn",cc)end)return"sleeping"end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(bc,cc)if
bc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
local ad=_d.entity:FindFirstChild("Eyes")local bd=_d.entity:FindFirstChild("Eyes2")end end,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.closestEntity then bc:setTargetEntity(bc.closestEntity)
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity;local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
local b_a=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)if b_a<=bc.aggressionRange then
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(cd.X,dc.Y,cd.Z))end
if

b_a<=bc.aggressionRange and bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then bc.__providedDirectRoamTheta=nil
bc:setTargetEntity(bc.closestEntity)return"following"else
if cc or bc.__providedDirectRoamTheta then
if(bc.__LAST_ROAM_TIME and
tick()-bc.__LAST_ROAM_TIME<5)and
(bc.__providedDirectRoamTheta==nil)then return"idling"end;local c_a=Vector3.new(1,0,1)local d_a=ac:NextInteger(1,360)
if
bc.__providedDirectRoamTheta then d_a=bc.__providedDirectRoamTheta;bc.__providedDirectRoamTheta=nil end;local _aa=math.rad(d_a)local aaa=bc.manifest.Position*c_a
local baa=aaa+

Vector3.new(math.cos(_aa),0,math.sin(_aa))*ac:NextInteger(10,bc.maxRoamDistance or 20)local caa=baa-aaa;local daa=bc.manifest.Position+
Vector3.new(0,bc.manifest.Size.Y,0)local _ba=caa-
Vector3.new(0,bc.manifest.Size.Y,0)local aba=Ray.new(daa,_ba)
local bba,cba=workspace:FindPartOnRayWithIgnoreList(aba,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local dba=(bc.manifest.Size.X+bc.manifest.Size.Z)/2;local _ca=(cba-bc.manifest.Position).magnitude
local aca=true;local bca=(cba-caa*dba/2)*c_a
local cca=(bc.origin and bc.origin.p or
bc.manifest.Position)*c_a;local dca=(bca-cca).magnitude;local _da=(aaa-cca).magnitude
if _da<dca then
if
dca>=200 then if ac:NextNumber()<1 then aca=false end elseif dca>=150 then if
ac:NextNumber()<1 then aca=false end elseif dca>=100 then
if ac:NextNumber()<0.6 then aca=false end elseif dca>=75 then if ac:NextNumber()<0.4 then aca=false end elseif dca>=50 then if
ac:NextNumber()<0.3 then aca=false end elseif dca>=25 then if ac:NextNumber()<0.2 then
aca=false end end end
if _ca>=dba and aca then bc.__directRoamGoal=bca;bc.__directRoamOrigin=aaa
bc.__directRoamTheta=d_a;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;bc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(bc,cc)
if
not bc.__IS_WAITING_FOR_PATH_FINDING then if bc.isProcessingPath then return"roaming"else
bc:setTargetEntity(nil,nil)return"idling"end end
if
bc.__PATHFIND_QUEUE_TIME and tick()-bc.__PATHFIND_QUEUE_TIME>5 then bc:resetPathfinding()return"idling"end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)
if
bc.closestEntity and cc then
local ad=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if ad<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"following"end end;local dc,_d=bc.__directRoamOrigin,bc.__directRoamGoal
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
bc:setTargetEntity(bc.closestEntity)return"following"end else
if tick()-bc.__PATH_FIND_NODE_START<2 then
local bd=Vector3.new(ad.Position.X,bc.manifest.Position.Y,ad.Position.Z)
bc.manifest.BodyGyro.CFrame=CFrame.new(bc.manifest.Position,bd)bc.manifest.BodyVelocity.Velocity=
(bd-bc.manifest.Position).unit*bc.baseSpeed else
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end elseif _d and not ad then
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end end},["following"]={animationEquivalent="walking",transitionLevel=4,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
local ad=_d.entity:FindFirstChild("Eyes")local bd=_d.entity:FindFirstChild("Eyes2")
bd.Transparency=0;ad.Transparency=1 end end,step=function(bc,cc)if
not bc.targetEntity then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity;local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
if
bc:isTargetEntityInLineOfSight(nil,true)then if dd>bc.attackRange then
bc.manifest.BodyVelocity.Velocity=__a*bc.baseSpeed end
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(cd.X,dc.Y,cd.Z))bc.__LAST_POSITION_SEEN=a_a
bc.__LAST_MOVE_DIRECTION=__a*bc.baseSpeed else
if not bc.__LAST_POSITION_SEEN and false then
bc:setTargetEntity(nil,nil)bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"elseif bc.__LAST_POSITION_SEEN then
local b_a=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(b_a-dc).unit*bc.baseSpeed
if dd<=bc.aggressionRange then if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)<_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil,nil)return"idling"end else bc:setTargetEntity(
nil,nil)return"idling"end else bc:setTargetEntity(nil,nil)return"idling"end end
if bb.magnitude(cd-dc)<=bc.attackRange then
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(cd.X,dc.Y,cd.Z))return"attack-ready"end end},["attack-ready"]={animationEquivalent="doodoo",transitionLevel=5,step=function(bc,cc)
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
bc.__LAST_ATTACK_TIME=tick()local c_a=math.random(3)if c_a==1 then return"hornattack"else
bc.manifest.BodyGyro.CFrame=CFrame.new(b_a,cd)return"attacking"end
bc.manifest.BodyGyro.CFrame=CFrame.new(b_a,cd)return"attacking"else
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end else return"following"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForLowerTransition=3,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then end;local dd=1.12;if _d and _d.Parent and _d:FindFirstChild("entity")then
_d.entity.PrimaryPart.attack_small:Play()end;wait(dd)if
_d and _d.Parent and _d:FindFirstChild("entity")then
_d.entity.PrimaryPart.attack_slam:Play()end
local __a=script.yetislampart:Clone()__a.Position=_d.entity["RightHand"].Position
__a.Parent=workspace;__a.impact:Emit(100)
local a_a=script.yetislampart:Clone()a_a.Position=_d.entity["LeftHand"].Position
a_a.Parent=workspace;a_a.impact:Emit(100)
game.Debris:AddItem(__a,2)game.Debris:AddItem(a_a,2)local b_a=1.1;local c_a=b_a-dd
local d_a=c_a/10
for i=0,c_a,d_a do
if
cc.IsPlaying and not ad and _d:FindFirstChild("entity")then
for _aa,aaa in pairs(dc.damageHitboxCollection)do
if
_d.entity:FindFirstChild(aaa.partName)and not ad then
if aaa.castType=="sphere"then
local baa=(
_d.entity[aaa.partName].CFrame*aaa.originOffset).p;local caa=cb.projection_Box(bd.CFrame,bd.Size,baa)
if
cb.spherecast_singleTarget(baa,aaa.radius,caa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,caa,"monster","normal")
local daa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*70 +Vector3.new(0,40,0)))end elseif aaa.castType=="box"then
local baa=_d.entity[aaa.partName].CFrame*aaa.originOffset;local caa=cb.projection_Box(bd.CFrame,bd.Size,baa.p)
if
cb.boxcast_singleTarget(baa,
_d.entity[aaa.partName].Size* (aaa.hitboxSizeMultiplier or Vector3.new(1,1,1)),caa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,caa,"monster","normal")
local daa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*70 +Vector3.new(0,40,0)))end end end end;wait(d_a)else break end end end,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end
if bc.closestEntity and cc then
local b_a=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)if b_a<=bc.aggressionRange then
bc:setTargetEntity(bc.closestEntity)return"attack-ready"end end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end},["hornattack"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForLowerTransition=3,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection2 then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("hornattack")then end;local dd=1.16;if _d and _d.Parent and _d:FindFirstChild("entity")then
_d.entity.PrimaryPart.attack_small:Play()end;wait(dd)
local __a=script.yetislampart:Clone()
__a.Position=_d.entity["Head"].Position-Vector3.new(0,8,0)__a.Parent=workspace;__a.impact:Emit(100)if _d and _d.Parent and
_d:FindFirstChild("entity")then
_d.entity.PrimaryPart.attack_large:Play()end;local a_a=1.46;local b_a=a_a-dd
local c_a=b_a/10
for i=0,b_a,c_a do
if
cc.IsPlaying and not ad and _d:FindFirstChild("entity")then
for d_a,_aa in pairs(dc.damageHitboxCollection2)do
if
_d.entity:FindFirstChild(_aa.partName)and not ad then
if _aa.castType=="sphere"then
local aaa=(
_d.entity[_aa.partName].CFrame*_aa.originOffset).p;local baa=cb.projection_Box(bd.CFrame,bd.Size,aaa)if
cb.spherecast_singleTarget(aaa,_aa.radius,baa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,baa,"monster","horns")end elseif
_aa.castType=="box"then
local aaa=_d.entity[_aa.partName].CFrame*_aa.originOffset;local baa=cb.projection_Box(bd.CFrame,bd.Size,aaa.p)
if
cb.boxcast_singleTarget(aaa,
_d.entity[_aa.partName].Size* (_aa.hitboxSizeMultiplier or Vector3.new(1,1,1)),baa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,baa,"monster","horns")
local caa=( (bd.Position-cd.Position)*Vector3.new(1,0,1)+
Vector3.new(0,10,0)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(caa*160))end end end end;wait(c_a)else break end end end,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=bc.targetEntity
local bd=ad.Position;local cd=bd
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then cd=Vector3.new(bd.X,dc.Y,bd.Z)end
if bc.targetingYOffsetMulti then cd=cd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end
if bc.targetEntity==nil or bc.targetEntity==nil then return"idling"end
if bc.closestEntity and cc then
local b_a=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if b_a<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"following"end end;cd=cd+ad.Velocity*0.1;local dd=bb.magnitude(dc-cd)
local __a=(cd-dc).unit;local a_a=cd-__a* (bc.attackRange)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(bc,cc)bc.specialsUsed=
bc.specialsUsed+1;if bc.__STATE_OVERRIDES["special-attacking"]then
bc.__STATE_OVERRIDES["special-attacking"](bc)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(bc,cc)return
"attack-ready"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(bc,cc)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bc,cc)return
nil end},["attacked-by-player"]={transitionLevel=1,step=function(bc)
if
bc.closestEntity then
local cc=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)if cc<=bc.aggressionRange then
bc:setTargetEntity(bc.closestEntity)return"following"end end;return"idling"end}},processDamageRequest=function(bc,cc)
if
bc=="horns"then return math.ceil(cc*6.5),"physical","direct"end;return cc*4,"physical","direct"end,processDamageRequestToMonster=function(bc,cc)
if
bc.state~="attacking"and
(cc.damageType=="magical"or(cc.equipmentType=="bow"or cc.category==
"projectile"))then
cc.damage=math.floor(cc.damage*0.5)cc.supressed=true end;return cc end}