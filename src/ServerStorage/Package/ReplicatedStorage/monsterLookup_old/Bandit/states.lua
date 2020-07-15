local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)if cc==nil then return cc,"physical",
"direct"end;if bc=="charge"then return math.ceil(cc*2.2),
"physical","direct"end
return cc,"physical","direct"end,getClosestEntities=function(bc)
local cc=bb.getEntities()
for i=#cc,1,-1 do local dc=cc[i]
if




(dc.Name=="Bandit")or(dc.Name=="Bandit Skirmisher")or(dc.Name=="Hitbox")or(dc.Name=="Scarab")or(dc.Name=="Stingtail")or(dc.Name=="Deathsting")or dc==bc.manifest then table.remove(cc,i)end end;return cc end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)
if
bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(bc,cc)if
bc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
_d.entity.LeftFoot.smoke.Enabled=false;_d.entity.RightFoot.smoke.Enabled=false end end,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;if bc.targetEntity then return"following"end
if bc.closestEntity then
local dc=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)
if dc<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then bc.__providedDirectRoamTheta=nil
bc:setTargetEntity(bc.closestEntity)return"following"else
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
bc.__directRoamTheta=ad;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;bc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(bc,cc)
if
not bc.__IS_WAITING_FOR_PATH_FINDING then if bc.isProcessingPath then return"roaming"else
bc:setTargetEntity(nil,nil)return"idling"end end
if
bc.__PATHFIND_QUEUE_TIME and tick()-bc.__PATHFIND_QUEUE_TIME>5 then bc:resetPathfinding()return"idling"end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)if
bc.moveGoal then bc.moveGoal=nil;bc.__strictMovement=true end;if
bc.targetEntity then return"following"end
if bc.closestEntity and cc then
local ad=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)
if ad<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity,bc.closestEntity)return"following"end end;local dc,_d=bc.__directRoamOrigin,bc.__directRoamGoal
if dc and _d then
local ad=Vector3.new(1,0,1)local bd=bb.magnitude(_d*ad-dc*ad)
local cd=bb.magnitude(bc.manifest.Position*
ad-dc*ad)local dd=(_d*ad-dc*ad).unit;bc.manifest.BodyVelocity.Velocity=dd*
bc.baseSpeed;bc.manifest.BodyGyro.CFrame=CFrame.new(dc*ad,
_d*ad)
if cd>=bd then bc.__strictMovement=false
if
bc.__directRoamTheta and ac:NextNumber()>0.5 then bc.__providedDirectRoamTheta=bc.__directRoamTheta+ac:NextInteger(
-35,35)return
"idling"end;bc.__providedDirectRoamTheta=nil
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end;local __a=bc.manifest.BodyVelocity.Velocity
local a_a=bc.manifest.Velocity;local b_a=bc.manifest.BodyVelocity.Velocity
local c_a=bc.manifest.Velocity
local d_a=Ray.new(bc.manifest.Position,Vector3.new(0,-50,0))
local _aa=Ray.new(bc.manifest.Position+ (dd*bc.baseSpeed*0.15),Vector3.new(0,
-50,0))
local aaa,baa=workspace:FindPartOnRayWithIgnoreList(d_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local caa,daa=workspace:FindPartOnRayWithIgnoreList(_aa,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})local _ba=daa.Y-baa.Y
if not bc.__strictMovement then
if-_ba>=
bc.manifest.Size.Y/6 then bc.__blockConfidence=bc.__blockConfidence+1
if-_ba>=
bc.manifest.Size.Y/1.5 then
bc.__blockConfidence=bc.__blockConfidence+2 elseif-_ba>=bc.manifest.Size.Y/3 then
bc.__blockConfidence=bc.__blockConfidence+1 end;if bc.__blockConfidence>=3 then
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end elseif
(_ba>=
bc.manifest.Size.Y/2)or(c_a.magnitude<b_a.magnitude and
bb.magnitude(b_a-c_a)>bc.baseSpeed*0.9)then bc.__blockConfidence=bc.__blockConfidence+1;if
bc.__blockConfidence>=4 then bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"end elseif bc.__blockConfidence and
bc.__blockConfidence>0 then
bc.__blockConfidence=bc.__blockConfidence-1 end end;return end;return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)
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
bc:setTargetEntity(bc.closestEntity,bc.closestEntity)return"following"end else
if tick()-bc.__PATH_FIND_NODE_START<2 then
local bd=Vector3.new(ad.Position.X,bc.manifest.Position.Y,ad.Position.Z)
bc.manifest.BodyGyro.CFrame=CFrame.new(bc.manifest.Position,bd)bc.manifest.BodyVelocity.Velocity=
(bd-bc.manifest.Position).unit*bc.baseSpeed else
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end elseif _d and not ad then
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end end},["following"]={animationEquivalent="running",transitionLevel=4,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
_d.entity.LeftFoot.smoke.Enabled=true;_d.entity.RightFoot.smoke.Enabled=true end end,step=function(bc,cc)if not
bc.targetEntity then return"idling"end;local dc=bc.manifest.Position
local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
if
bc:isTargetEntityInLineOfSight(
bc.targetEntitySetSource and 999,not bc.targetEntitySetSource)then
bc.manifest.BodyVelocity.Velocity=dd*bc.baseSpeed*8
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(bd.X,dc.Y,bd.Z))bc.__LAST_POSITION_SEEN=__a
bc.__LAST_MOVE_DIRECTION=dd*bc.baseSpeed*8 else
if not bc.__LAST_POSITION_SEEN and false then
bc:setTargetEntity(nil,nil)bc.manifest.BodyVelocity.Velocity=Vector3.new()return
"idling"elseif bc.__LAST_POSITION_SEEN then
local a_a=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(a_a-dc).unit*bc.baseSpeed*8
if cd<=bc.aggressionRange then if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)>_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil)return"idling"end else
if
bc.targetEntitySetSource==nil then bc:setTargetEntity(nil)return"idling"end end else bc:setTargetEntity(nil)return"idling"end end
if bb.magnitude(bd-dc)<=bc.attackRange then return"attack-ready"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
_d.entity.LeftFoot.smoke.Enabled=false;_d.entity.RightFoot.smoke.Enabled=false end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;local cd=bb.magnitude(dc-bd)local dd=(bd-dc).unit;local __a=bd-
dd* (bc.attackRange)
if cd<=bc.attackRange then
local a_a=bc.manifest.Position
if tick()-bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()bc.manifest.BodyVelocity.Velocity=Vector3.new()
bc.manifest.BodyGyro.CFrame=CFrame.new(a_a,Vector3.new(bd.X,a_a.Y,bd.Z))bc.specialsUsed=0;return"attacking"else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"following"end end},["attack-ready-close"]={animationEquivalent="crouch-transition",transitionLevel=5,execute=function(bc,cc,dc,_d)
if
_d and _d:FindFirstChild("entity")then
_d.entity.LeftFoot.smoke.Enabled=false;_d.entity.RightFoot.smoke.Enabled=false end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;local cd=bb.magnitude(dc-bd)local dd=(bd-dc).unit;local __a=bd-
dd* (bc.attackRange)
if cd<=bc.attackRange+6 then
local a_a=bc.manifest.Position
if tick()-bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()
bc.manifest.BodyGyro.CFrame=CFrame.new(a_a,Vector3.new(bd.X,a_a.Y,bd.Z))
if bb.magnitude(bd-a_a)>bc.attackRange then local b_a=(bd-a_a).unit;bc.manifest.BodyVelocity.Velocity=
b_a* (bc.baseSpeed*2)else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"double-slash"else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"following"end end},["attacking"]={transitionLevel=9,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value;if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then
_d.entity.PrimaryPart.attacking:Play()end;local dd=.05
wait(dd)local __a=.16;local a_a=__a-dd;local b_a=a_a/10
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
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster","charge")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,.7,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end elseif d_a.castType=="box"then
local _aa=_d.entity[d_a.partName].CFrame*d_a.originOffset;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa.p)
if
cb.boxcast_singleTarget(_aa,
_d.entity[d_a.partName].Size* (d_a.hitboxSizeMultiplier or Vector3.new(1,1,1)),aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster","charge")
local baa=( (bd.Position-cd.Position)*Vector3.new(1,.7,1)).unit
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(baa*30))end end end end;wait(b_a)else break end end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
if bc.closestEntity and cc then
local a_a=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)
if a_a<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"micro-sleeping"end end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
if bb.magnitude(_d.Velocity)>
3 then local a_a=(bd-dc).unit
local b_a=bd-a_a* (bc.attackRange)bc.manifest.BodyVelocity.Velocity=Vector3.new()else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"micro-sleeping"end},["double-slash"]={transitionLevel=9,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,lockTimeForLowerTransition=.7,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value;local dd=.25;wait(dd)local __a=.375;local a_a=__a-dd;local b_a=a_a/10
for i=0,a_a,b_a do
if
cc.IsPlaying and not ad and _d:FindFirstChild("entity")then
for caa,daa in
pairs(dc.damageHitboxCollection)do
if _d.entity:FindFirstChild(daa.partName)and not ad then
if
daa.castType=="sphere"then
local _ba=(_d.entity[daa.partName].CFrame*daa.originOffset).p;local aba=cb.projection_Box(bd.CFrame,bd.Size,_ba)if
cb.spherecast_singleTarget(_ba,daa.radius,aba)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aba,"monster")end elseif
daa.castType=="box"then
local _ba=_d.entity[daa.partName].CFrame*daa.originOffset;local aba=cb.projection_Box(bd.CFrame,bd.Size,_ba.p)
if
cb.boxcast_singleTarget(_ba,
_d.entity[daa.partName].Size* (daa.hitboxSizeMultiplier or Vector3.new(1,1,1)),aba)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aba,"monster")end end end end;wait(b_a)else end end;wait(.205)local c_a=0;wait(c_a)local d_a=false;local _aa=.1;local aaa=_aa-c_a
local baa=aaa/10
for i=0,aaa,baa do
if
cc.IsPlaying and not d_a and _d:FindFirstChild("entity")then
for caa,daa in pairs(dc.damageHitboxCollection)do
if
_d.entity:FindFirstChild(daa.partName)and not d_a then
if daa.castType=="sphere"then
local _ba=(
_d.entity[daa.partName].CFrame*daa.originOffset).p;local aba=cb.projection_Box(bd.CFrame,bd.Size,_ba)if
cb.spherecast_singleTarget(_ba,daa.radius,aba)then d_a=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aba,"monster")end elseif
daa.castType=="box"then
local _ba=_d.entity[daa.partName].CFrame*daa.originOffset;local aba=cb.projection_Box(bd.CFrame,bd.Size,_ba.p)
if
cb.boxcast_singleTarget(_ba,
_d.entity[daa.partName].Size* (daa.hitboxSizeMultiplier or Vector3.new(1,1,1)),aba)then d_a=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aba,"monster")end end end end;wait(baa)else break end end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
if bc.closestEntity and cc then
local a_a=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)
if a_a<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then
bc:setTargetEntity(bc.closestEntity)return"attack-ready-close"end end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
if bb.magnitude(_d.Velocity)>
3 then local a_a=(bd-dc).unit
local b_a=bd-a_a* (bc.attackRange)
bc.manifest.BodyVelocity.Velocity=a_a* (bc.baseSpeed*1)else bc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"attack-ready-close"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(bc,cc)bc.specialsUsed=
bc.specialsUsed+1;if bc.__STATE_OVERRIDES["special-attacking"]then
bc.__STATE_OVERRIDES["special-attacking"](bc)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="crouch-transition",transitionLevel=8,step=function(bc,cc)if
not bc.targetEntity then return"idling"end;return"attack-ready-close"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(bc,cc)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bc,cc)return
nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=1,step=function(bc)
if
bc.closestEntity and(bc.targetEntityLockType or 0)<=1 and
bc.entityMonsterWasAttackedBy then
local cc=bb.magnitude(
bc.entityMonsterWasAttackedBy.Position-bc.manifest.Position)
if bc:isTargetEntityInLineOfSight(nil,false,bc.entityMonsterWasAttackedBy)then
bc:setTargetEntity(bc.entityMonsterWasAttackedBy)return"following"end end;return"idling"end}},processDamageRequestToMonster=function(bc,cc)
if
bc.state=="following"and
(cc.equipmentType=="bow"or cc.category=="projectile")then
cc.damage=math.floor(cc.damage*0.35)cc.supressed=true end;return cc end}