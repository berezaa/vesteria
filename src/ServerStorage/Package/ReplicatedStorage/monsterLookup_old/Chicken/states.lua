local ba=game:GetService("ReplicatedStorage")
local ca=require(ba.modules)local da=ca.load("pathfinding")local _b=ca.load("utilities")
local ab=ca.load("projectile")local bb=1
return
{onDamageReceived=function(cb,db,_c,ac)if db=="player"then end end,default="idling",states={["sleeping"]={animationEquivalent="idling",transitionLevel=1,step=function(cb,db)
return"idling"end},["idling"]={lockTimeForPreventStateTransition=5,transitionLevel=2,step=function(cb,db)
cb.manifest.BodyVelocity.Velocity=Vector3.new()
if db then if not cb.__FLIP then cb.__FLIP=tick()end;if
tick()-cb.__FLIP>10 then cb.__FLIP=tick()
if math.random(1,30)==1 then return"flip"end end
if cb.__LAST_ROAM_TIME and
tick()-cb.__LAST_ROAM_TIME<5 then return"idling"end;local _c=cb:getRoamPositionInSpawnRegion()
local ac=_c-cb.manifest.Position;local bc=Ray.new(cb.manifest.Position,ac)
local cc=ab.raycastForProjectile(bc,{cb.manifest,workspace.placeFolders:FindFirstChild("entityManifestCollection")})
if not cc then
cb.path={{Position=cb.manifest.Position},{Position=_c}}cb.currentNode=1;cb.__directRoamGoal=_c;cb.__blockConfidence=0
cb.__LAST_ROAM_TIME=tick()cb.__PATH_FIND_NODE_START=tick()return"roaming"end;cb.__LAST_ROAM_TIME=tick()-4 else end end},["pecking"]={lockTimeForPreventStateTransition=5,transitionLevel=2,step=function(cb,db)
cb.manifest.BodyVelocity.Velocity=Vector3.new()if db then return"idling"else end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=2,step=function(cb,db)if
not cb.__IS_WAITING_FOR_PATH_FINDING then
if cb.isProcessingPath then return"roaming"else return"idling"end end end},["roaming"]={animationEquivalent="walking",transitionLevel=2,step=function(cb,db)if
not cb.path then return"idling"end
local _c=cb.path[cb.currentNode]local ac=cb.path[cb.currentNode+1]
if _c and ac then
if
da.isPastNextPathfindingNodeNode(_c.Position,cb.manifest.Position,ac.Position)then cb.currentNode=cb.currentNode+1;cb.__PATH_FIND_NODE_START=tick()else
if
tick()-cb.__PATH_FIND_NODE_START<2 then
local bc=Vector3.new(ac.Position.X,cb.manifest.Position.Y,ac.Position.Z)
cb.manifest.BodyGyro.CFrame=CFrame.new(cb.manifest.Position,bc)cb.manifest.BodyVelocity.Velocity=
(bc-cb.manifest.Position).unit*cb.baseSpeed else
cb:resetPathfinding()return"idling"end end elseif _c and not ac then
cb.manifest.BodyVelocity.Velocity=Vector3.new()cb:resetPathfinding()return
math.random(1,2)==1 and"idling"or"pecking"end end},["fleeing"]={transitionLevel=3,step=function(cb,db)
if
cb.closestEntity then cb:setTargetEntity(cb.closestEntity)
if cb.targetEntity then
local _c=Vector3.new(cb.closestEntity.Position.X,cb.manifest.Position.Y,cb.closestEntity.Position.Z)local ac=(_c-cb.manifest.Position)
cb.manifest.BodyGyro.CFrame=CFrame.new(cb.manifest.Position,
cb.manifest.Position-ac)
cb.manifest.BodyVelocity.Velocity=-
(_c-cb.manifest.Position).unit*cb.baseSpeed;if ac.magnitude>25 then return"sleeping"end else return"sleeping"end else return"sleeping"end end},["hurt"]={transitionLevel=4,step=function(cb,db)for i=1,math.random(0,2)
do
cb:dropItem({lootDropData={id=271},dropPosition=cb.manifest.Position,itemOwners=nil},nil,3)end;if
not cb.LAST_TIME_DROP_EGG then cb.LAST_TIME_DROP_EGG=0 end
if
tick()-cb.LAST_TIME_DROP_EGG>3 and math.random()<0.2 then
cb.LAST_TIME_DROP_EGG=tick()
cb:dropItem({lootDropData={id=270},dropPosition=cb.manifest.Position,itemOwners=nil},nil,3)end;return"fleeing"end},["flip"]={lockTimeForPreventStateTransition=1,transitionLevel=5,step=function(cb,db)
cb.hasFlipped=true;return"idling"end},["dead"]={lockTimeForPreventStateTransition=1,transitionLevel=1235,step=function(cb,db)
if
cb.hasFlipped and tick()-cb.__FLIP>10 then cb.hasFlipped=false end;if cb.hasFlipped then
cb:dropItem({lootDropData={id=277},dropPosition=cb.manifest.Position,itemOwners=nil},nil,3)end end}}}