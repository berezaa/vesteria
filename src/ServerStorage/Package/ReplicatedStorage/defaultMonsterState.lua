local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
return cc,"physical","direct"end,getClosestEntities=function(bc)local cc=bb.getEntities()for i=#cc,1,-1 do local dc=cc[i]
if
dc.Name==
bc.monsterName or dc==bc.manifest or dc.health.Value<=0 then table.remove(cc,i)end end;return cc end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)
if
bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(bc,cc)if
bc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(bc,cc)
bc.manifest.BodyVelocity.Velocity=Vector3.new()
if bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;if bc.targetEntity then return"following"end
if bc.closestEntity and
bc.closestEntity.health.value>=0 then
local dc=bb.magnitude(bc.closestEntity.Position-
bc.manifest.Position)local _d=bc.aggressionLockRange or bc.aggressionRange
if
dc<=_d and bc:isTargetEntityInLineOfSight(_d,true)then bc.__providedDirectRoamTheta=
nil;bc:setTargetEntity(bc.closestEntity)return
"following"else
if cc or bc.__providedDirectRoamTheta then
if(bc.__LAST_ROAM_TIME and
tick()-bc.__LAST_ROAM_TIME<5)and
(bc.__providedDirectRoamTheta==nil)then return"idling"end;local ad=Vector3.new(1,0,1)local bd=ac:NextInteger(1,360)
if
bc.__providedDirectRoamTheta then bd=bc.__providedDirectRoamTheta;bc.__providedDirectRoamTheta=nil end;local cd=math.rad(bd)local dd=bc.manifest.Position*ad
local __a=dd+

Vector3.new(math.cos(cd),0,math.sin(cd))*ac:NextInteger(10,bc.maxRoamDistance or 50)local a_a=__a-dd;local b_a=bc.manifest.Position+
Vector3.new(0,bc.manifest.Size.Y/2,0)
local c_a=a_a-Vector3.new(0,
bc.manifest.Size.Y/2,0)local d_a=Ray.new(b_a,c_a)
local _aa,aaa=workspace:FindPartOnRayWithIgnoreList(d_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local baa=(bc.manifest.Size.X+bc.manifest.Size.Z)/2;local caa=(aaa-bc.manifest.Position).magnitude
local daa=true;local _ba=(aaa-a_a*baa/2)*ad
if caa>=baa and daa then
bc.__directRoamGoal=_ba;bc.__directRoamOrigin=dd;bc.__directRoamTheta=bd;bc.__blockConfidence=0
bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;bc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(bc,cc)
if
not bc.__IS_WAITING_FOR_PATH_FINDING then if bc.isProcessingPath then return"roaming"else
bc:setTargetEntity(nil,nil)return"idling"end end
if
bc.__PATHFIND_QUEUE_TIME and tick()-bc.__PATHFIND_QUEUE_TIME>5 then bc:resetPathfinding()return"idling"end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)if
bc.moveGoal then bc.moveGoal=nil;bc.__strictMovement=true end;if
bc.targetEntity then return"following"end
if bc.closestEntity and cc then
local ad=bb.magnitude(
bc.closestEntity.Position-bc.manifest.Position)local bd=bc.aggressionLockRange or bc.aggressionRange
if
ad<=bd and bc:isTargetEntityInLineOfSight(bd,true)then
bc:setTargetEntity(bc.closestEntity,bc.closestEntity)return"following"end end;local dc,_d=bc.__directRoamOrigin,bc.__directRoamGoal
if dc and _d then
local ad=Vector3.new(1,0,1)local bd=bb.magnitude((_d-dc)*ad)local cd=bb.magnitude(
(bc.manifest.Position-dc)*ad)
local dd=(_d*ad-dc*ad).unit;bc.manifest.BodyVelocity.Velocity=dd*bc.baseSpeed;bc.manifest.BodyGyro.CFrame=CFrame.new(
dc*ad,_d*ad)
if cd>=bd then
bc.__strictMovement=false
if bc.__directRoamTheta and ac:NextNumber()>0.5 then
bc.__providedDirectRoamTheta=
bc.__directRoamTheta+ac:NextInteger(-35,35)return"idling"end;bc.__providedDirectRoamTheta=nil
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end;local __a=bc.manifest.BodyVelocity.Velocity
local a_a=bc.manifest.Velocity
local b_a=Ray.new(bc.manifest.Position,Vector3.new(0,-50,0))
local c_a=Ray.new(bc.manifest.Position+ (dd*bc.baseSpeed/4),Vector3.new(0,
-50,0))
local d_a,_aa=workspace:FindPartOnRayWithIgnoreList(b_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local aaa,baa=workspace:FindPartOnRayWithIgnoreList(c_a,{bc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})local caa=baa.Y-_aa.Y
if not bc.__strictMovement then
if-caa>=
math.max(bc.manifest.Size.Y,6)then
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif tick()-bc.__LAST_ROAM_TIME>=1 and a_a.magnitude<=
__a.magnitude/10 then
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"end end;return end;return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(bc,cc)
if
bc.closestEntity then if not bc.path then return"idling"end
local dc=bb.magnitude(bc.closestEntity.Position-
bc.manifest.Position)local _d=bc.path[bc.currentNode]
local ad=bc.path[bc.currentNode+1]
if _d and ad then
if
ab.isPastNextPathfindingNodeNode(_d.Position,bc.manifest.Position,ad.Position)then bc.currentNode=bc.currentNode+1;bc.__PATH_FIND_NODE_START=tick()local bd=
bc.aggressionLockRange or bc.aggressionRange
if dc<=bd and
bc:isTargetEntityInLineOfSight(bd,true)then bc:resetPathfinding()
bc:setTargetEntity(bc.closestEntity,bc.closestEntity)return"following"end else
if tick()-bc.__PATH_FIND_NODE_START<2 then
local bd=Vector3.new(ad.Position.X,bc.manifest.Position.Y,ad.Position.Z)
bc.manifest.BodyGyro.CFrame=CFrame.new(bc.manifest.Position,bd)bc.manifest.BodyVelocity.Velocity=
(bd-bc.manifest.Position).unit*bc.baseSpeed else
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end elseif _d and not ad then
bc.manifest.BodyVelocity.Velocity=Vector3.new()bc:resetPathfinding()return"idling"end end end},["following"]={animationEquivalent="walking",transitionLevel=4,step=function(bc,cc)if
not bc.targetEntity then return"idling"end
if
bc.targetEntity.health.Value<=0 then bc:setTargetEntity(nil,nil)return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
local a_a=bc.followSpeed or bc.baseSpeed
if
bc:isTargetEntityInLineOfSight(bc.targetEntitySetSource and 999,not bc.targetEntitySetSource)then bc.manifest.BodyVelocity.Velocity=dd*a_a
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,Vector3.new(bd.X,dc.Y,bd.Z))bc.__LAST_POSITION_SEEN=__a;bc.__LAST_MOVE_DIRECTION=dd*a_a else
if
not bc.__LAST_POSITION_SEEN then bc:setTargetEntity(nil,nil)
bc.manifest.BodyVelocity.Velocity=Vector3.new()return"idling"elseif bc.__LAST_POSITION_SEEN then
local _aa=Vector3.new(bc.__LAST_POSITION_SEEN.X,dc.Y,bc.__LAST_POSITION_SEEN.Z)
bc.manifest.BodyVelocity.Velocity=(_aa-dc).unit*a_a;local aaa=bc.sightRange
if cd<=aaa then if
bb.magnitude(dc-bc.__LAST_POSITION_SEEN)>_c then bc.__LAST_POSITION_SEEN=nil
bc:setTargetEntity(nil)return"idling"end else
if
bc.targetEntitySetSource==nil then bc:setTargetEntity(nil)return"idling"end end else bc:setTargetEntity(nil)return"idling"end end
local b_a=cb.projection_Box(bc.manifest.CFrame,bc.manifest.Size,ad)
local c_a=cb.projection_Box(bc.targetEntity.CFrame,bc.targetEntity.Size,bc.manifest.Position)local d_a=bb.magnitude(b_a-c_a)if d_a<=bc.attackRange then
return"attack-ready"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
if
bc.targetEntity.health.Value<=0 then bc:setTargetEntity(nil,nil)return"idling"end;local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end
local cd=cb.projection_Box(bc.manifest.CFrame,bc.manifest.Size,ad)
local dd=cb.projection_Box(bc.targetEntity.CFrame,bc.targetEntity.Size,bc.manifest.Position)local __a=bb.magnitude(cd-dd)
if __a<=bc.attackRange then
local a_a=bc.manifest.Position
if tick()-bc.__LAST_ATTACK_TIME>=bc.attackSpeed then
bc.__LAST_ATTACK_TIME=tick()return"attacking"else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end else return"following"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(bc,cc,dc,_d)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dc.damageHitboxCollection then end;local ad=false;local bd=bc.Character.PrimaryPart
local cd=_d.clientHitboxToServerHitboxReference.Value
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking")then local c_a=1
if _d:FindFirstChild("entity")and
_d.entity.PrimaryPart:FindFirstChild("attacking2")then c_a=math.random(2)if c_a==2 then
_d.entity.PrimaryPart.attacking2:Play()end end;if c_a==1 then
_d.entity.PrimaryPart.attacking:Play()end end
local dd=cc.Length* (dc.animationDamageStart or 0.3)wait(dd)
local __a=cc.Length* (dc.animationDamageEnd or 0.7)local a_a=__a-dd;local b_a=a_a/10
for i=0,a_a,b_a do
if cc.IsPlaying and not ad and
_d:FindFirstChild("entity")then
for c_a,d_a in pairs(dc.damageHitboxCollection)do
if
_d.entity:FindFirstChild(d_a.partName)and not ad then
if d_a.castType=="sphere"then
local _aa=(
_d.entity[d_a.partName].CFrame*d_a.originOffset).p;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa)if
cb.spherecast_singleTarget(_aa,d_a.radius,aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster")end elseif
d_a.castType=="box"then
local _aa=_d.entity[d_a.partName].CFrame*d_a.originOffset;local aaa=cb.projection_Box(bd.CFrame,bd.Size,_aa.p)
if
cb.boxcast_singleTarget(_aa,
_d.entity[d_a.partName].Size* (d_a.hitboxSizeMultiplier or Vector3.new(1,1,1)),aaa)then ad=true
db:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cd,aaa,"monster")end end end end;wait(b_a)else break end end end,step=function(bc,cc)if
bc.targetEntity==nil then return"idling"end
local dc=bc.manifest.Position;local _d=bc.targetEntity;local ad=_d.Position;local bd=ad
if
bc.manifest.BodyVelocity.MaxForce.Y<=0.1 then bd=Vector3.new(ad.X,dc.Y,ad.Z)end
if bc.targetingYOffsetMulti then bd=bd+
Vector3.new(0,bc.manifest.Size.Y*bc.targetingYOffsetMulti,0)end;bd=bd+_d.Velocity*0.1;local cd=bb.magnitude(dc-bd)
local dd=(bd-dc).unit;local __a=bd-dd* (bc.attackRange)
bc.manifest.BodyGyro.CFrame=CFrame.new(dc,bd)
if bb.magnitude(_d.Velocity)>3 then local b_a=(bd-dc).unit;local c_a=bd-
b_a* (bc.attackRange)bc.manifest.BodyVelocity.Velocity=b_a*
(bc.baseSpeed*0.7)else
bc.manifest.BodyVelocity.Velocity=Vector3.new()end
local a_a=game.Players:GetPlayerFromCharacter(bc.targetEntity.Parent)
if not a_a then
delay(0.25,function()
db:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,bc.targetEntity,{damage=bc.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end)end;return"micro-sleeping"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(bc,cc)bc.specialsUsed=
bc.specialsUsed+1;if bc.__STATE_OVERRIDES["special-attacking"]then
bc.__STATE_OVERRIDES["special-attacking"](bc)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(bc,cc)return
"attack-ready"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(bc,cc)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bc,cc)return
nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=1,step=function(bc)
print("HELLO! :D",bc.closestEntity,bc.entityMonsterWasAttackedBy)
if
bc.closestEntity and(bc.targetEntityLockType or 0)<=1 and bc.entityMonsterWasAttackedBy then
local cc=bb.magnitude(
bc.entityMonsterWasAttackedBy.Position-bc.manifest.Position)
if bc:isTargetEntityInLineOfSight(nil,false,bc.entityMonsterWasAttackedBy)then
bc:setTargetEntity(bc.entityMonsterWasAttackedBy)return"following"end end;return"idling"end}}}