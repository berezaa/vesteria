local _b=game:GetService("ReplicatedStorage")
local ab=require(_b.modules)local bb=ab.load("pathfinding")local cb=ab.load("utilities")
local db=ab.load("detection")local _c=ab.load("network")local ac=1;local bc=Random.new()local cc
return
{processDamageRequest=function(dc,_d)return _d,"physical",
"direct"end,default="idling",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(dc)end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(dc,_d)if
dc.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(dc,_d)
dc.manifest.BodyVelocity.Velocity=Vector3.new()if cc==nil then cc=0 end
if dc.closestEntity then
local ad=cb.magnitude(dc.closestEntity.Position-
dc.manifest.Position)
local bd=cb.magnitude(Vector3.new(0,(dc.manifest.Position-dc.closestEntity.Position).Y,0))
if ad<=dc.aggressionRange and bd<14 then dc.__providedDirectRoamTheta=nil
dc:setTargetEntity(dc.closestEntity)return"following"else
if _d or dc.__providedDirectRoamTheta then
if(dc.__LAST_ROAM_TIME and
tick()-dc.__LAST_ROAM_TIME<5)and
(dc.__providedDirectRoamTheta==nil)then
dc:setTargetEntity(nil,nil)return"idling"end;local cd=Vector3.new(1,0,1)local dd=bc:NextInteger(1,360)
if
dc.__providedDirectRoamTheta then dd=dc.__providedDirectRoamTheta;dc.__providedDirectRoamTheta=nil end;local __a=math.rad(dd)local a_a=dc.manifest.Position*cd
local b_a=a_a+

Vector3.new(math.cos(__a),0,math.sin(__a))*bc:NextInteger(30,dc.maxRoamDistance or 50)local c_a=b_a-a_a;local d_a=dc.manifest.Position+
Vector3.new(0,dc.manifest.Size.Y,0)local _aa=c_a-
Vector3.new(0,dc.manifest.Size.Y,0)local aaa=Ray.new(d_a,_aa)
local baa,caa=workspace:FindPartOnRayWithIgnoreList(aaa,{dc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local daa=(dc.manifest.Size.X+dc.manifest.Size.Z)/2;local _ba=(caa-dc.manifest.Position).magnitude
local aba=true;local bba=(caa-c_a*daa/2)*cd
local cba=(dc.origin and dc.origin.p or
dc.manifest.Position)*cd;local dba=(bba-cba).magnitude;local _ca=(a_a-cba).magnitude
if _ca<dba then
if
dba>=200 then if bc:NextNumber()<1 then aba=false end elseif dba>=150 then if bc:NextNumber()<
0.8 then aba=false end elseif dba>=100 then if bc:NextNumber()<0.6 then
aba=false end elseif dba>=75 then
if bc:NextNumber()<0.4 then aba=false end elseif dba>=50 then if bc:NextNumber()<0.3 then aba=false end elseif dba>=25 then if
bc:NextNumber()<0.2 then aba=false end end end
if _ba>=daa and aba then dc.__directRoamGoal=bba;dc.__directRoamOrigin=a_a
dc.__directRoamTheta=dd;dc.__blockConfidence=0;dc.__LAST_ROAM_TIME=tick()return"direct-roam"end;dc.__LAST_ROAM_TIME=tick()-4.5;return end end else return"sleeping"end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=3,step=function(dc,_d)
if
not dc.__IS_WAITING_FOR_PATH_FINDING then
if dc.isProcessingPath then return"roaming"else
dc:setTargetEntity(nil,nil)dc:setTargetEntity(nil,nil)end end
if
dc.__PATHFIND_QUEUE_TIME and tick()-dc.__PATHFIND_QUEUE_TIME>5 then dc:resetPathfinding()dc:setTargetEntity(nil,nil)return
"idling"end end},["direct-roam"]={animationEquivalent="walking",transitionLevel=3,step=function(dc,_d)
if
dc.closestEntity and _d then
local cd=cb.magnitude(dc.closestEntity.Position-dc.manifest.Position)
local dd=cb.magnitude(Vector3.new(0,(dc.manifest.Position-dc.closestEntity.Position).Y,0))if cd<=dc.aggressionRange and dd<14 then
dc:setTargetEntity(dc.closestEntity)return"following"end end;local ad,bd=dc.__directRoamOrigin,dc.__directRoamGoal
if ad and bd then
local cd=Vector3.new(1,0,1)local dd=cb.magnitude(bd*cd-ad*cd)
local __a=cb.magnitude(dc.manifest.Position*
cd-ad*cd)local a_a=(bd*cd-ad*cd).unit;dc.manifest.BodyVelocity.Velocity=a_a*
dc.baseSpeed;dc.manifest.BodyGyro.CFrame=CFrame.new(ad*cd,
bd*cd)
if __a>=dd then
if dc.__directRoamTheta and bc:NextNumber()>
0.5 then dc.__providedDirectRoamTheta=dc.__directRoamTheta+
bc:NextInteger(-35,35)
dc:setTargetEntity(nil,nil)return"idling"end;dc.__providedDirectRoamTheta=nil
dc.manifest.BodyVelocity.Velocity=Vector3.new()dc:setTargetEntity(nil,nil)return"idling"end;local b_a=dc.manifest.BodyVelocity.Velocity
local c_a=dc.manifest.Velocity;local d_a=dc.manifest.BodyVelocity.Velocity
local _aa=dc.manifest.Velocity
local aaa=Ray.new(dc.manifest.Position,Vector3.new(0,-50,0))
local baa=Ray.new(dc.manifest.Position+ (a_a*dc.baseSpeed*0.15),Vector3.new(0,
-50,0))
local caa,daa=workspace:FindPartOnRayWithIgnoreList(aaa,{dc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})
local _ba,aba=workspace:FindPartOnRayWithIgnoreList(baa,{dc.manifest,workspace.placeFolders:FindFirstChild("entityRenderCollection"),workspace.placeFolders:FindFirstChild("foilage")})local bba=aba.Y-daa.Y
if-bba>=dc.manifest.Size.Y/6 then dc.__blockConfidence=
dc.__blockConfidence+1
if
-bba>=dc.manifest.Size.Y/1.5 then dc.__blockConfidence=dc.__blockConfidence+2 elseif-bba>=
dc.manifest.Size.Y/3 then
dc.__blockConfidence=dc.__blockConfidence+1 end
if dc.__blockConfidence>=3 then
dc.manifest.BodyVelocity.Velocity=Vector3.new()dc:setTargetEntity(nil,nil)return"idling"end elseif(bba>=dc.manifest.Size.Y/2)or
(
_aa.magnitude<d_a.magnitude and cb.magnitude(d_a-_aa)>dc.baseSpeed*0.9)then
dc.__blockConfidence=dc.__blockConfidence+1
if dc.__blockConfidence>=4 then
dc.manifest.BodyVelocity.Velocity=Vector3.new()dc:setTargetEntity(nil,nil)return"idling"end elseif dc.__blockConfidence and dc.__blockConfidence>0 then dc.__blockConfidence=
dc.__blockConfidence-1 end;return end;dc:setTargetEntity(nil,nil)return"idling"end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(dc,_d)
if
dc.closestEntity then
if not dc.path then dc:setTargetEntity(nil,nil)return"idling"end
local ad=cb.magnitude(dc.closestEntity.Position-dc.manifest.Position)local bd=dc.path[dc.currentNode]
local cd=dc.path[dc.currentNode+1]
if bd and cd then
if
bb.isPastNextPathfindingNodeNode(bd.Position,dc.manifest.Position,cd.Position)then dc.currentNode=dc.currentNode+1;dc.__PATH_FIND_NODE_START=tick()
local dd=cb.magnitude(Vector3.new(0,(
dc.manifest.Position-dc.closestEntity.Position).Y,0))if ad<=dc.aggressionRange and dd<14 then dc:resetPathfinding()
dc:setTargetEntity(dc.closestEntity)return"following"end else
if
tick()-dc.__PATH_FIND_NODE_START<2 then
local dd=Vector3.new(cd.Position.X,dc.manifest.Position.Y,cd.Position.Z)
dc.manifest.BodyGyro.CFrame=CFrame.new(dc.manifest.Position,dd)dc.manifest.BodyVelocity.Velocity=
(dd-dc.manifest.Position).unit*dc.baseSpeed else
dc.manifest.BodyVelocity.Velocity=Vector3.new()dc:resetPathfinding()dc:setTargetEntity(nil,nil)return
"idling"end end elseif bd and not cd then
dc.manifest.BodyVelocity.Velocity=Vector3.new()dc:resetPathfinding()dc:setTargetEntity(nil,nil)return
"idling"end end end},["following"]={animationEquivalent="chasing",transitionLevel=4,step=function(dc,_d)if
not dc.targetEntity then return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=bd.Position;local dd=cd
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then dd=Vector3.new(cd.X,ad.Y,cd.Z)end
if dc.targetingYOffsetMulti then dd=dd+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;dd=dd+bd.Velocity*0.1;local __a=cb.magnitude(ad-dd)
local a_a=Vector3.new((
dd-ad).X,cc,(dd-ad).Z).unit;local b_a=dd-a_a* (dc.attackRange)dc.manifest.BodyVelocity.Velocity=
a_a*dc.baseSpeed*3
dc.manifest.BodyGyro.CFrame=CFrame.new(ad,Vector3.new(dd.X,ad.Y,dd.Z))dc.__LAST_POSITION_SEEN=b_a
dc.__LAST_MOVE_DIRECTION=a_a*dc.baseSpeed*3;local c_a=math.abs(ad.Y-cd.Y)if c_a>14 then
dc:setTargetEntity(nil,nil)return"idling"end;if
cb.magnitude(dd-ad)<=dc.attackRange then return"attack-ready"end end},["attack-ready"]={transitionLevel=5,step=function(dc,_d)if
dc.targetEntity==nil or dc.targetEntity==nil then
dc:setTargetEntity(nil,nil)return"idling"end
local ad=dc.manifest.Position;local bd=dc.targetEntity;local cd=dc.targetEntity;local dd=cd.Position;local __a=dd;local a_a=math.abs(ad.Y-
dd.Y)
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then __a=Vector3.new(dd.X,ad.Y,dd.Z)end
if dc.targetingYOffsetMulti then __a=__a+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;local b_a=cb.magnitude(ad-__a)
local c_a=Vector3.new((__a-ad).X,cc,(__a-ad).Z).unit;local d_a=__a-c_a* (dc.attackRange)
if b_a<=dc.attackRange and
a_a<14 then local _aa=dc.manifest.Position
if
tick()-dc.__LAST_ATTACK_TIME>=dc.attackSpeed then dc.__LAST_ATTACK_TIME=tick()return"attacking"else
dc.manifest.BodyVelocity.Velocity=Vector3.new()end else dc:setTargetEntity(nil,nil)return"idling"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(dc,_d,ad,bd)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not ad.damageHitboxCollection then end;local cd=false;local dd=dc.Character.PrimaryPart
local __a=bd.clientHitboxToServerHitboxReference.Value;if bd:FindFirstChild("entity")and
bd.entity.PrimaryPart:FindFirstChild("attacking")then
bd.entity.PrimaryPart.attacking:Play()end;local a_a=_d.Length* (
ad.animationDamageStart or 0.3)
wait(a_a)
local b_a=_d.Length* (ad.animationDamageEnd or 0.7)local c_a=b_a-a_a;local d_a=c_a/10
for i=0,c_a,d_a do
if _d.IsPlaying and not cd and
bd:FindFirstChild("entity")then
for _aa,aaa in pairs(ad.damageHitboxCollection)do
if
bd.entity:FindFirstChild(aaa.partName)and not cd then
if aaa.castType=="sphere"then
local baa=(
bd.entity[aaa.partName].CFrame*aaa.originOffset).p;local caa=db.projection_Box(dd.CFrame,dd.Size,baa)
if
db.spherecast_singleTarget(baa,aaa.radius,caa)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster")
local daa=( (dd.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*70 +Vector3.new(0,40,0)))end elseif aaa.castType=="box"then
local baa=bd.entity[aaa.partName].CFrame*aaa.originOffset;local caa=db.projection_Box(dd.CFrame,dd.Size,baa.p)
if
db.boxcast_singleTarget(baa,
bd.entity[aaa.partName].Size* (aaa.hitboxSizeMultiplier or Vector3.new(1,1,1)),caa)then cd=true
_c:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",__a,caa,"monster")
local daa=( (dd.Position-__a.Position)*Vector3.new(1,0,1)).unit
_c:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(daa*70 +Vector3.new(0,40,0)))end end end end;wait(d_a)else break end end end,step=function(dc,_d)if
dc.targetEntity==nil or dc.targetEntity==nil then
dc:setTargetEntity(nil,nil)return"idling"end;local ad,bd
local cd=dc.aggressionRange
if _d then
for baa,caa in pairs(game.Players:GetPlayers())do
if caa and caa.Character and
caa.Character.PrimaryPart then
local daa=(dc.manifest.Position-
caa.Character.PrimaryPart.Position).magnitude;if daa<=cd and
math.abs(dc.manifest.Position.Y-
caa.Character.PrimaryPart.Position.Y)<=14 then cd=daa;ad=caa
bd=caa.Character.PrimaryPart end end end end;if ad then dc:setTargetEntity(ad)return"following"end
local dd=dc.manifest.Position;local __a=dc.targetEntity;local a_a=dc.targetEntity;local b_a=a_a.Position;local c_a=b_a
if
dc.manifest.BodyVelocity.MaxForce.Y<=0.1 then c_a=Vector3.new(b_a.X,dd.Y,b_a.Z)end
if dc.targetingYOffsetMulti then c_a=c_a+
Vector3.new(0,dc.manifest.Size.Y*dc.targetingYOffsetMulti,0)end;c_a=c_a+a_a.Velocity*0.1
local d_a=cb.magnitude(dd-c_a)
local _aa=Vector3.new((c_a-dd).X,cc,(c_a-dd).Z).unit;local aaa=c_a-_aa* (dc.attackRange)
if
cb.magnitude(a_a.Velocity)>3 then local baa=(c_a-dd).unit
local caa=c_a-baa* (dc.attackRange)
dc.manifest.BodyVelocity.Velocity=baa* (dc.baseSpeed*0.7)else dc.manifest.BodyVelocity.Velocity=Vector3.new()end;return"micro-sleeping"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(dc,_d)dc.specialsUsed=
dc.specialsUsed+1;if dc.__STATE_OVERRIDES["special-attacking"]then
dc.__STATE_OVERRIDES["special-attacking"](dc)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(dc,_d)return
"attack-ready"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(dc,_d)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(dc,_d)return
nil end,execute=function()return nil end},["attacked-by-player"]={transitionLevel=1,step=function(dc)
if
dc.closestEntity and dc.entityMonsterWasAttackedBy then
local _d=cb.magnitude(
dc.entityMonsterWasAttackedBy.Position-dc.manifest.Position)dc:setTargetEntity(dc.entityMonsterWasAttackedBy)return
"following"end;return"idling"end}}}