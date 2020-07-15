local bb=game:GetService("ReplicatedStorage")
local cb=require(bb.modules)local db=cb.load("pathfinding")local _c=cb.load("utilities")
local ac=cb.load("detection")local bc=cb.load("network")local cc=cb.load("projectile")
local dc=cb.load("placeSetup")local _d=dc.awaitPlaceFolder("entityManifestCollection")
local ad=dc.awaitPlaceFolder("entityRenderCollection")local bd=1
return
{default="idling",states={["sleeping"]={animationEquivalent="idling",transitionLevel=1,step=function(cd,dd)return"idling"end},["idling"]={lockTimeForPreventStateTransition=5,transitionLevel=2,execute=function(cd,dd,__a,a_a)
if
a_a and a_a:FindFirstChild("entity")then
local b_a=a_a.entity:FindFirstChild("staff").skulleyes
a_a:FindFirstChild("entity").dancing.Value=false;b_a.Color=Color3.fromRGB(0,0,0)
b_a.PointLight.Enabled=false;b_a.Material=Enum.Material.SmoothPlastic
b_a.ParticleEmitter.Enabled=false end end,step=function(cd,dd)
cd.manifest.BodyVelocity.Velocity=Vector3.new()cd.updateforstate=tick()
if dd then
if cd.__LAST_ROAM_TIME and
tick()-cd.__LAST_ROAM_TIME<5 then return"dancing"end;local __a=cd:getRoamPositionInSpawnRegion()
local a_a=__a-cd.manifest.Position;local b_a=Ray.new(cd.manifest.Position,a_a)
local c_a=cc.raycastForProjectile(b_a,{cd.manifest,workspace.placeFolders:FindFirstChild("entityManifestCollection")})
if not c_a then
cd.path={{Position=cd.manifest.Position},{Position=__a}}cd.currentNode=1;cd.__directRoamGoal=__a;cd.__blockConfidence=0
cd.__LAST_ROAM_TIME=tick()cd.__PATH_FIND_NODE_START=tick()local d_a=math.random(1,2)if d_a==1 then
return"roaming"else if not cd.updateforstate then cd.updateforstate=tick()end;return
"dancing"end end;cd.__LAST_ROAM_TIME=tick()-4 else end end},["dancing"]={lockTimeForPreventStateTransition=9,transitionLevel=2,timeBetweenUpdates=5,execute=function(cd,dd,__a,a_a)
if
a_a and a_a:FindFirstChild("entity")then
local b_a=a_a.entity:FindFirstChild("staff").skulleyes
a_a:FindFirstChild("entity").dancing.Value=false;b_a.Color=Color3.fromRGB(0,255,255)
b_a.PointLight.Enabled=true;b_a.Material=Enum.Material.Neon
b_a.ParticleEmitter.Enabled=true end end,step=function(cd,dd)
cd.manifest.BodyVelocity.Velocity=Vector3.new()
if tick()-cd.updateforstate>1 then
for __a,a_a in
pairs(cd.manifest.Parent:GetChildren())do
if a_a.Name=="Goblin"then
if
(a_a.Position-cd.manifest.Position).magnitude<14 then local b_a=Instance.new("BoolValue")
b_a.Name="boosted"b_a.Value=true;b_a.Parent=a_a;game.Debris:AddItem(b_a,4)end end end;cd.updateforstate=tick()end;if dd then return"idling"else end end},["wait-roaming"]={animationEquivalent="idling",transitionLevel=2,step=function(cd,dd)
if
not cd.__IS_WAITING_FOR_PATH_FINDING then
if cd.isProcessingPath then if not cd.updateforstate then
cd.updateforstate=tick()end;return"dancing"else if not cd.updateforstate then
cd.updateforstate=tick()end;return"dancing"end end end},["roaming"]={animationEquivalent="walking",transitionLevel=2,execute=function(cd,dd,__a,a_a)
if
a_a and a_a:FindFirstChild("entity")then
local b_a=a_a.entity:FindFirstChild("staff").skulleyes;b_a.Color=Color3.fromRGB(0,0,0)
b_a.PointLight.Enabled=false;b_a.Material=Enum.Material.SmoothPlastic
a_a:FindFirstChild("entity").dancing.Value=false;b_a.ParticleEmitter.Enabled=false end end,step=function(cd,dd)if
not cd.path then
if not cd.updateforstate then cd.updateforstate=tick()end;return"dancing"end
local __a=cd.path[cd.currentNode]local a_a=cd.path[cd.currentNode+1]
if __a and a_a then
if
db.isPastNextPathfindingNodeNode(__a.Position,cd.manifest.Position,a_a.Position)then cd.currentNode=cd.currentNode+1;cd.__PATH_FIND_NODE_START=tick()else
if
tick()-cd.__PATH_FIND_NODE_START<2 then
local b_a=Vector3.new(a_a.Position.X,cd.manifest.Position.Y,a_a.Position.Z)
cd.manifest.BodyGyro.CFrame=CFrame.new(cd.manifest.Position,b_a)cd.manifest.BodyVelocity.Velocity=
(b_a-cd.manifest.Position).unit*cd.baseSpeed else
cd:resetPathfinding()if not cd.updateforstate then cd.updateforstate=tick()end;return
"dancing"end end elseif __a and not a_a then
cd.manifest.BodyVelocity.Velocity=Vector3.new()cd:resetPathfinding()local b_a=math.random(1,5)if b_a==1 then
return"idling"else if not cd.updateforstate then cd.updateforstate=tick()end;return
"dancing"end end end},["fleeing"]={transitionLevel=3,animationEquivalent="walking",lockTimeForPreventStateTransition=2,execute=function(cd,dd,__a,a_a)
if
a_a and a_a:FindFirstChild("entity")then
local b_a=a_a.entity:FindFirstChild("staff").skulleyes;b_a.ParticleEmitter.Enabled=false
b_a.Color=Color3.fromRGB(0,0,0)b_a.PointLight.Enabled=false
b_a.Material=Enum.Material.SmoothPlastic
a_a:FindFirstChild("entity").dancing.Value=false end end,step=function(cd,dd)
if
cd.closestEntity then cd:setTargetEntity(cd.closestEntity)
if cd.targetEntity then
local __a=Vector3.new(cd.closestEntity.Position.X,cd.manifest.Position.Y,cd.closestEntity.Position.Z)local a_a=(__a-cd.manifest.Position)
cd.manifest.BodyGyro.CFrame=CFrame.new(cd.manifest.Position,
cd.manifest.Position-a_a)
cd.manifest.BodyVelocity.Velocity=-
(__a-cd.manifest.Position).unit*cd.baseSpeed;return"sleeping"else return"sleeping"end else return"sleeping"end end},["hurt"]={transitionLevel=4,lockTimeForLowerTransition=0.3,step=function(cd,dd)
if
cd.closestEntity then cd:setTargetEntity(cd.closestEntity)end;return
math.random(1,2)==1 and"attack-ready"or("fleeing")end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,execute=function(cd,dd,__a,a_a)
if
a_a and a_a:FindFirstChild("entity")then
local b_a=a_a.entity:FindFirstChild("staff").skulleyes;b_a.PointLight.Enabled=false
b_a.Color=Color3.fromRGB(0,0,0)b_a.Material=Enum.Material.SmoothPlastic
a_a:FindFirstChild("entity").dancing.Value=false;b_a.ParticleEmitter.Enabled=false end end,step=function(cd,dd)if
cd.targetEntity==nil then return"idling"end
local __a=cd.manifest.Position;local a_a=cd.targetEntity;local b_a=a_a.Position;local c_a=b_a;if
cd.manifest.BodyVelocity.MaxForce.Y<=0.1 then
c_a=Vector3.new(b_a.X,__a.Y,b_a.Z)end;if cd.targetingYOffsetMulti then
c_a=c_a+Vector3.new(0,
cd.manifest.Size.Y*cd.targetingYOffsetMulti,0)end
local d_a=ac.projection_Box(cd.manifest.CFrame,cd.manifest.Size,b_a)
local _aa=ac.projection_Box(cd.targetEntity.CFrame,cd.targetEntity.Size,cd.manifest.Position)local aaa=_c.magnitude(d_a-_aa)
if aaa<=cd.attackRange then
local baa=cd.manifest.Position;cd.manifest.BodyGyro.CFrame=CFrame.new(baa,c_a)
if
tick()-cd.__LAST_ATTACK_TIME>=cd.attackSpeed then
cd.__LAST_ATTACK_TIME=tick()return"attacking"else
cd.manifest.BodyVelocity.Velocity=Vector3.new()end else if not cd.updateforstate then cd.updateforstate=tick()end;return
"dancing"end end},["attacking"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=.6,execute=function(cd,dd,__a,a_a)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not __a.damageHitboxCollection then end;local b_a=false;local c_a=cd.Character.PrimaryPart
local d_a=a_a.clientHitboxToServerHitboxReference.Value;if a_a:FindFirstChild("entity")and
a_a.entity.PrimaryPart:FindFirstChild("attacking")then
a_a.entity.PrimaryPart.attacking:Play()end;local _aa=dd.Length* (
__a.animationDamageStart or 0.3)
wait(_aa)
local aaa=dd.Length* (__a.animationDamageEnd or 0.7)local baa=aaa-_aa;local caa=baa/10
for i=0,baa,caa do
if dd.IsPlaying and not b_a and
a_a:FindFirstChild("entity")then
for daa,_ba in pairs(__a.damageHitboxCollection)do
if
a_a.entity:FindFirstChild(_ba.partName)and not b_a then
if _ba.castType=="sphere"then
local aba=(
a_a.entity[_ba.partName].CFrame*_ba.originOffset).p;local bba=ac.projection_Box(c_a.CFrame,c_a.Size,aba)if
ac.spherecast_singleTarget(aba,_ba.radius,bba)then b_a=true
bc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",d_a,bba,"monster")end elseif
_ba.castType=="box"then
local aba=a_a.entity[_ba.partName].CFrame*_ba.originOffset;local bba=ac.projection_Box(c_a.CFrame,c_a.Size,aba.p)
if
ac.boxcast_singleTarget(aba,
a_a.entity[_ba.partName].Size* (_ba.hitboxSizeMultiplier or Vector3.new(1,1,1)),bba)then b_a=true
bc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",d_a,bba,"monster")end end end end;wait(caa)else break end end end,step=function(cd,dd)if
cd.targetEntity==nil then
if not cd.updateforstate then cd.updateforstate=tick()end;return"dancing"end
local __a=cd.manifest.Position;local a_a=cd.targetEntity;local b_a=a_a.Position;local c_a=b_a;if
cd.manifest.BodyVelocity.MaxForce.Y<=0.1 then
c_a=Vector3.new(b_a.X,__a.Y,b_a.Z)end;if cd.targetingYOffsetMulti then
c_a=c_a+Vector3.new(0,
cd.manifest.Size.Y*cd.targetingYOffsetMulti,0)end
c_a=c_a+a_a.Velocity*0.1;local d_a=_c.magnitude(__a-c_a)local _aa=(c_a-__a).unit;local aaa=c_a-_aa*
(cd.attackRange)
if
_c.magnitude(a_a.Velocity)>3 then local daa=(c_a-__a).unit
local _ba=c_a-daa* (cd.attackRange)
cd.manifest.BodyVelocity.Velocity=daa* (cd.baseSpeed*0.7)else cd.manifest.BodyVelocity.Velocity=Vector3.new()end
local baa=game.Players:GetPlayerFromCharacter(cd.targetEntity.Parent)
if not baa then
delay(0.25,function()
bc:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",nil,cd.targetEntity,{damage=cd.damage,sourceType="monster",sourceId=nil,damageCategory="direct",damageType="physical"})end)end;local caa=math.random(1,3)
if caa==1 then return"attack-ready"else
local daa=math.random(1,3)if daa==1 then return"fleeing"else
if not cd.updateforstate then cd.updateforstate=tick()end;return"dancing"end end end}}}