local dc=game:GetService("PhysicsService")
local _d=game:GetService("ReplicatedStorage")local ad=game:GetService("RunService")
local bd=require(_d.modules)local cd=bd.load("pathfinding")local dd=bd.load("utilities")
local __a=bd.load("detection")local a_a=bd.load("network")local b_a=bd.load("tween")
local c_a=bd.load("placeSetup")local d_a=bd.load("projectile")local _aa=1;local aaa={}local baa
local caa=Random.new()
local function daa(bba,cba)local dba=#bba;bba[cba]=bba[dba]bba[dba]=nil end
local function _ba(bba)local cba,dba=nil,0
if not cba and bba.closestEntity then
if
(bba.closestEntity.Position-
bba.manifest.Position).magnitude<=bba.aggressionRange then cba=bba.closestEntity end end
for _ca,aca in pairs(aaa)do
if
aca>dba and _ca.Character and _ca.Character.PrimaryPart then
if

(_ca.Character.PrimaryPart.Position-bba.manifest.Position).magnitude<=bba.aggressionRange and

_ca.Character.PrimaryPart.Position.Y-bba.manifest.Position.Y<20 then cba=_ca.Character.PrimaryPart;dba=aca end end end;aaa={}return cba end;local function aba(bba,cba,dba)end
return
{getClosestEntities=function(bba)local cba=dd.getEntities()
for dba,_ca in pairs(cba)do if
(_ca.Name=="Spider"or
_ca.Name=="Spiderling"or _ca.Name=="Spider Queen")or _ca==bba.manifest then
daa(cba,dba)end end;return cba end,default="setup",states={["setup"]={transitionLevel=0,step=function(bba)
local cba=bd.load("physics")local dba=bba.manifest
dba.CustomPhysicalProperties=PhysicalProperties.new(1000,1,0)if dba:FindFirstChild("BodyForce")then
game.Debris:AddItem(dba.BodyForce,1)end
delay(1,function()
if
workspace:FindFirstChild("spiderQueenMusic")then workspace.spiderQueenMusic:Play()end end)dd.playSound("spiderQueenSpawn",dba)
local _ca=cba:getCollisionGroup("spiderQueen")
if _ca then cba:setWholeCollisionGroup(dba,"spiderQueen")
local aca=dc:GetCollisionGroupName(_ca)
if aca then local bca={"characters","items","monsters","npcs"}
for cca,dca in pairs(bca)do
local _da,ada=pcall(function()
dc:CollisionGroupSetCollidable(aca,dca,false)end)if not _da then
warn("Failed to make Spider Queen not collide with group",dca)end end end end;return"sleeping"end},["sleeping"]={timeBetweenUpdates=5,transitionLevel=1,step=function(bba,cba)if
bba.closestEntity then return"idling"end end},["idling"]={lockTimeForPreventStateTransition=5,transitionLevel=2,execute=function(bba,cba,dba,_ca)
baa=false
if
_ca:FindFirstChild("entity")and _ca.entity:FindFirstChild("Eyes")then if _ca.entity.Eyes.Transparency<=0.01 then
b_a(_ca.entity.Eyes,{"Transparency"},0.9,0.5)end
for aca,bca in
pairs(_ca.entity:GetDescendants())do if bca.Name=="Flames"then bca.Enabled=false end end end end,step=function(bba,cba)
bba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)
if
bba.closestEntity and
(bba.closestEntity.Position-bba.manifest.Position).magnitude<=bba.aggressionRange then if cba then bba.__ROTATE_INIT=false;return"rotating"else end else
return"sleeping"end end},["rotating"]={animationEquivalent="walking",transitionLevel=4,lockTimeForPreventStateTransition=0.5,execute=function(bba,cba,dba,_ca)
baa=true
if not _ca or
not _ca:FindFirstChild("clientHitboxToServerHitboxReference")then return end
if
_ca:FindFirstChild("entity")and _ca.entity:FindFirstChild("Eyes")then if _ca.entity.Eyes.Transparency>=0.01 then
b_a(_ca.entity.Eyes,{"Transparency"},0,0.5)end
for dda,__b in
pairs(_ca.entity:GetDescendants())do if __b.Name=="Flames"then end end end;local aca=_ca.clientHitboxToServerHitboxReference.Value
if not
ad:IsClient()then
warn("attacking::execute can only be called on client")return elseif not aca then return elseif not aca:FindFirstChild("stateData")then return elseif
not bba.Character or not bba.Character.PrimaryPart then return elseif not
_ca:FindFirstChild("entity")or
not _ca.entity:FindFirstChild("Mandible")then return end;local bca=bba.Character.PrimaryPart
local cca=_ca.clientHitboxToServerHitboxReference.Value;dd.playSound("spiderQueenRotating",cca)local dca=0.1
wait(dca)
if not cca.Parent then return elseif not cca:FindFirstChild("stateData")then return elseif not
bba.Character or not bba.Character.PrimaryPart then return elseif not
_ca:FindFirstChild("entity")or
not _ca.entity:FindFirstChild("Mandible")then return end;local _da=0.5;local ada=_da-dca;local bda=tick()local cda=false
while cba.IsPlaying and
(tick()-bda<=ada)and not cda do
if _ca:FindFirstChild("entity")then
for dda,__b in
pairs(_ca.entity:GetChildren())do
if __b:IsA("BasePart")and not cda then local a_b=__b.CFrame
local b_b=__a.projection_Box(bca.CFrame,bca.Size,a_b.p)
if __a.boxcast_singleTarget(a_b,__b.Size,b_b)then
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cca,b_b,"monster",
nil,"trample")
local c_b=( (bca.Position-cca.Position)*Vector3.new(1,0,1)).unit
a_a:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(c_b*90))cda=true end end end;wait(0.1)else break end end end,step=function(bba,cba)
if
not bba.__ROTATE_INIT then local cca=_ba(bba)
if cca then bba:setTargetEntity(cca)
local dca=Vector3.new(cca.Position.X,bba.manifest.Position.Y,cca.Position.Z)
bba.__DEGREES_TO_TURN=math.acos(dca:Dot(bba.manifest.Position))
local _da=bba.manifest.Position+bba.manifest.CFrame.lookVector*
bba.manifest.Size.X/2.1;bba.__TARGET_DIST_FROM_HEAD=(dca-_da).magnitude else
warn("Rotate had no target. Resetting")return"idling"end;bba.__ROTATE_INIT=true end;if not bba.targetEntity then return"idling"end
local dba=bba.targetEntity;local _ca=bba.health/bba.maxHealth
local aca=(dba.Position-bba.manifest.Position).magnitude;local bca=bba.__TARGET_DIST_FROM_HEAD
if dba then
local cca=Vector3.new(dba.Position.X,bba.manifest.Position.Y,dba.Position.Z)
local dca=math.acos(cca:Dot(bba.manifest.Position))
if dca>math.rad(3)then
local _da=math.sign(cca:Cross(bba.manifest.Position):Dot(Vector3.new(0,1,0)))
bba.manifest.BodyGyro.CFrame=bba.manifest.BodyGyro.CFrame*CFrame.Angles(0,
math.min(dca,math.rad(0.25))*_da,0)else
local _da=(dba.Position-bba.manifest.Position).magnitude;bba.__TARGET_POSITION_FOR_MONSTER=cca
bba.manifest.BodyGyro.CFrame=CFrame.new(bba.manifest.Position,cca)bba.__START_ABILITY_TIME=tick()
bba.__RAMPAGE_STREAK=bba.__RAMPAGE_STREAK or 0;local ada
if caa:NextNumber()<=0.4 * (1 -_ca*0.7)then
ada="venomspray"elseif caa:NextNumber()<=0.4 * (1 -_ca*1.4)then ada="screeching"elseif aca>=
45 then
if
bba.__RAMPAGE_STREAK<=2 and caa:NextInteger(1,4)>1 then ada="rampage"else ada="venomspray"end elseif bca>=12 then ada="jabbing"else ada="bite"end;warn(ada,bba.__RAMPAGE_STREAK)
if ada then
if ada=="rampage"then bba.__RAMPAGE_STREAK=(
bba.__RAMPAGE_STREAK or 0)+1 else
warn("RESET RAMPAGE STREAK")bba.__RAMPAGE_STREAK=0 end;return ada end end else return"idling"end end},["rampage"]={animationEquivalent="walking",transitionLevel=5,lockTimeForPreventStateTransition=3,execute=function(bba,cba,dba,_ca)
if
not _ca or
not _ca:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local aca=_ca.clientHitboxToServerHitboxReference.Value
if not
ad:IsClient()then
warn("attacking::execute can only be called on client")return elseif not aca then return elseif not aca:FindFirstChild("stateData")then return elseif
not bba.Character or not bba.Character.PrimaryPart then return elseif not
_ca:FindFirstChild("entity")or
not _ca.entity:FindFirstChild("Mandible")then return end;if _ca:FindFirstChild("entity")then
for dda,__b in
pairs(_ca.entity:GetDescendants())do if __b.Name=="Flames"then end end end
dd.playSound("spiderQueenAbilityUse",aca)local bca=bba.Character.PrimaryPart
local cca=_ca.clientHitboxToServerHitboxReference.Value;local dca=cba.Length*0.3;wait(dca)
if not cca.Parent then return elseif not
cca:FindFirstChild("stateData")then return elseif
not bba.Character or not bba.Character.PrimaryPart then return elseif not _ca:FindFirstChild("entity")or not
_ca.entity:FindFirstChild("Mandible")then return end
local _da=cba.Length* (dba.animationDamageEnd or 0.67)local ada=_da-dca;local bda=tick()local cda=false
while cba.IsPlaying and not cda do
if
_ca:FindFirstChild("entity")then
for dda,__b in pairs(_ca.entity:GetChildren())do
if
__b:IsA("BasePart")and not cda then local a_b=__b.CFrame
local b_b=__a.projection_Box(bca.CFrame,bca.Size,a_b.p)
if __a.boxcast_singleTarget(a_b,__b.Size,b_b)then
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cca,b_b,"monster",
nil,"trample")cda=true end end end;wait(0.1)else break end end end,step=function(bba,cba)
if
bba.closestEntity then
if tick()-bba.__START_ABILITY_TIME<=4 then
if not bba.targetEntity or not
bba.targetEntity then return"idling"end;local dba=bba.targetEntity;local _ca=bba.__TARGET_POSITION_FOR_MONSTER;if dba then
_ca=dba.Position end
if
_ca.Y>bba.manifest.Position.Y+10 then warn("y too high escape")bba.__ROTATE_INIT=false;return"rotating"end
local aca=bba.manifest.BodyVelocity.Velocity.magnitude;local bca=bba.manifest.Velocity.magnitude;bba.__BLOCKEDCONFIDENCE=
bba.__BLOCKEDCONFIDENCE or 0
if bca<=aca*0.2 then bba.__BLOCKEDCONFIDENCE=
bba.__BLOCKEDCONFIDENCE+1
if bba.__BLOCKEDCONFIDENCE>=3 then
warn("blocked escape")bba.__BLOCKEDCONFIDENCE=0;bba.__ROTATE_INIT=false;return"rotating"end else bba.__BLOCKEDCONFIDENCE=0 end
if(_ca-bba.manifest.Position).magnitude>=45 then
bba.manifest.BodyVelocity.Velocity=(
_ca-bba.manifest.Position).unit*bba.baseSpeed
bba.manifest.BodyGyro.CFrame=CFrame.new(bba.manifest.Position,Vector3.new(_ca.X,bba.manifest.Position.Y,_ca.Z))else bba.__ROTATE_INIT=false;return"rotating"end else bba.__ROTATE_INIT=false;return"rotating"end else return"idling"end end},["bite"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=1,execute=function(bba,cba,dba,_ca)
if
not ad:IsClient()then
warn("bite::execute can only be called on client")return elseif not dba.damageHitboxCollection then end;if _ca:FindFirstChild("entity")then
for cda,dda in
pairs(_ca.entity:GetDescendants())do if dda.Name=="Flames"then dda.Enabled=false end end end
local aca=false;local bca=bba.Character.PrimaryPart
local cca=_ca.clientHitboxToServerHitboxReference.Value
local dca=cba.Length* (dba.animationDamageStart or 0.3)dd.playSound("spiderQueenAbilityUse",cca)wait(dca)
local _da=
cba.Length* (dba.animationDamageEnd or 0.7)local ada=_da-dca;local bda=ada/10
for i=0,ada,bda do
if cba.IsPlaying and not aca and
_ca:FindFirstChild("entity")then
local cda=(_ca.entity.Mandible.CFrame*
CFrame.new(0,0,3)).p;local dda=__a.projection_Box(bca.CFrame,bca.Size,cda)if
__a.spherecast_singleTarget(cda,6,dda)then aca=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cca,dda,"monster",nil,"bite")end
wait(bda)else break end end end,step=function(bba,cba)if
bba.targetEntity==nil then return"idling"end
local dba=bba.manifest.Position;local _ca=bba.targetEntity;local aca=_ca.Position
local bca=Vector3.new(aca.X,dba.Y,aca.Z)local cca=dd.magnitude(dba-bca)local dca=(bca-dba).unit;local _da=bca-dca*
(bba.attackRange)
bba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["jabbing"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=1.5,execute=function(bba,cba,dba,_ca)
if
not ad:IsClient()then
warn("jabbing::execute can only be called on client")return elseif not dba.damageHitboxCollection then end;if _ca:FindFirstChild("entity")then
for b_b,c_b in
pairs(_ca.entity:GetDescendants())do if c_b.Name=="Flames"then c_b.Enabled=false end end end
local aca=false;local bca=bba.Character.PrimaryPart
local cca=_ca.clientHitboxToServerHitboxReference.Value
local dca=cba.Length* (dba.animationDamageStart or 0.3)dd.playSound("spiderQueenAbilityUse",cca)wait(dca)
_ca.entity:FindFirstChild("1LLEG2").Trail.Enabled=true
_ca.entity:FindFirstChild("1RLEG2").Trail.Enabled=true;local _da=cba.Length*0.63;local ada=_da-dca;local bda=ada/10;local cda={}
local dda=c_a.getPlaceFolder("entityRenderCollection")local __b={}local a_b
for i=0,ada,bda do
if
cba.IsPlaying and not aca and _ca:FindFirstChild("entity")then
for b_b,c_b in pairs({"1LLEG2","1RLEG2"})do
local d_b=_ca.entity:FindFirstChild(c_b)
if d_b and not aca then
if not cda[c_b]then
local _ab=(d_b.CFrame*
CFrame.new(0,-d_b.Size.Y/2,0)).p-d_b.CFrame.p;local aab=Ray.new(d_b.CFrame.p,_ab)
local bab,cab,dab=workspace:FindPartOnRayWithIgnoreList(aab,{workspace.placeFolders})
if bab then cda[c_b]=true;__b[c_b]=cab
local _bb=script.spiderQueenJabImpact:Clone()_bb.Parent=cca;_bb.Anchored=true;_bb.CFrame=CFrame.new(cab)*
CFrame.Angles(0,0,math.rad(90))
_bb.Fire:Emit(50)_bb.Sound:Play()
b_a(_bb,{"Transparency"},1,5)game.Debris:AddItem(_bb,5)end end
if __b[c_b]then
local _ab=__a.projection_Box(bca.CFrame,bca.Size,__b[c_b])if __a.spherecast_singleTarget(__b[c_b],5,_ab)then aca=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cca,_ab,"monster",
nil,"jab")end
if not
aca and not a_b then local aab=18;local bab
for cab,dab in pairs(__b)do
local _bb=(dab-bca.Position).magnitude;if _bb<aab then aab=_bb;bab=dab end end
if bab then a_b=true;local cab=(bca.Position-bab).unit
a_a:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(
cab+Vector3.new(0,1.25,0))* (30 -aab)*6)
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",cca,_ab,"monster",nil,"trample")end end end end end;wait(bda)else break end end
_ca.entity:FindFirstChild("1LLEG2").Trail.Enabled=false
_ca.entity:FindFirstChild("1RLEG2").Trail.Enabled=false end,step=function(bba,cba)
if
bba.targetEntity==nil or bba.targetEntity==nil then return"idling"end;local dba=bba.manifest.Position;local _ca=bba.targetEntity
local aca=bba.targetEntity;local bca=aca.Position;local cca=Vector3.new(bca.X,dba.Y,bca.Z)local dca=dd.magnitude(
dba-cca)local _da=(cca-dba).unit;local ada=cca-
_da* (bba.attackRange)
bba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["screeching"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=4,execute=function(bba,cba,dba,_ca)
if
_ca:FindFirstChild("entity")then for cca,dca in pairs(_ca.entity:GetDescendants())do if dca.Name=="Flames"then
dca.Enabled=false end end end;wait(1.4)
local aca=_ca.clientHitboxToServerHitboxReference.Value;dd.playSound("spiderQueenScreech",aca)
local bca=script.Screech:Clone()bca.Parent=_ca.entity.Mandible;bca.Enabled=true
spawn(function()wait(3)
bca.Enabled=false;game.Debris:AddItem(bca,3)end)end,execute_server=function(bba)
wait(1)
local cba=workspace.placeFolders.spawnRegionCollections:FindFirstChild("Spider-0")
if cba==nil then cba=Instance.new("Folder")cba.Name="Spider-0"
local dba=Instance.new("Part")dba.Transparency=1;dba.Anchored=true;dba.CanCollide=false;dba.Parent=cba
cba.Parent=workspace.placeFolders.spawnRegionCollections end
for i=1,20 do
local dba=bba.manifest.CFrame*
Vector3.new(math.rngom(-10,10),0,
-bba.manifest.Size.Z/2 -math.rngom(5,10))local _ca=caa:NextInteger(1,15)==7
local aca={targetEntity=bba.targetEntity,targetEntity=bba.targetEntity,giant=_ca}local bca
if game.PlaceId==3207211233 then
bca=a_a:invoke("spawnSpiderling",dba,aca)else
bca=a_a:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Spiderling",dba,cba,aca)end
if bca and bca.manifest then
bca.manifest.Velocity=bca.manifest.CFrame.lookVector*30
if bca.manifest:FindFirstChild("BodyVelocity")then bca.manifest.BodyVelocity.Velocity=
bca.manifest.CFrame.lookVector*30 end;local cca=script.SpiderlingParticle:Clone()
cca.Parent=bca.manifest
spawn(function()wait(4)if cca then cca.Enabled=false
game.Debris:AddItem(cca,3)end end)end;wait(0.1)end end,step=function(bba,cba)
if
bba.targetEntity==nil or bba.targetEntity==nil then return"idling"end;local dba=bba.manifest.Position;local _ca=bba.targetEntity
local aca=bba.targetEntity;local bca=aca.Position;local cca=Vector3.new(bca.X,dba.Y,bca.Z)local dca=dd.magnitude(
dba-cca)local _da=(cca-dba).unit;local ada=cca-
_da* (bba.attackRange)
bba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["venomspray"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=4,execute=function(bba,cba,dba,_ca)
if
not _ca or
not _ca:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local aca=_ca.clientHitboxToServerHitboxReference.Value
if not
ad:IsClient()then
warn("attacking::execute can only be called on client")return elseif not aca then return elseif not aca:FindFirstChild("stateData")then return elseif
not bba.Character or not bba.Character.PrimaryPart then return elseif not
_ca:FindFirstChild("entity")or
not _ca.entity:FindFirstChild("Mandible")then return end;if _ca:FindFirstChild("entity")then
for c_b,d_b in
pairs(_ca.entity:GetDescendants())do if d_b.Name=="Flames"then d_b.Enabled=false end end end
local bca=_ca.clientHitboxToServerHitboxReference.Value;local cca=cba.Length*0.3
dd.playSound("spiderQueenAbilityUse",bca)wait(cca)
if not bca.Parent then return elseif
not bca:FindFirstChild("stateData")then return elseif
not bba.Character or not bba.Character.PrimaryPart then return elseif not _ca:FindFirstChild("entity")or not
_ca.entity:FindFirstChild("Mandible")then return end
local dca=cba.Length* (dba.animationDamageEnd or 0.67)local _da=dca-cca
local ada,bda=dd.safeJSONDecode(bca.stateData.Value)local cda=ada and bda.shots or 20
local dda=c_a.getPlaceFolder("entityRenderCollection")local __b=c_a.getPlaceFolder("entityManifestCollection")
local a_b=script.Foam:Clone()a_b.Parent=_ca.entity.Mandible;a_b.Enabled=true;local b_b={}
spawn(function()
while true do
if bba.Character and
bba.Character.PrimaryPart and
bba.Character.PrimaryPart.health.Value>0 then local c_b=false
local d_b=bba.Character.PrimaryPart
for _ab,aab in pairs(b_b)do
if aab.Parent==bca then
if not c_b then
local bab=aab.CFrame+Vector3.new(0,3,0)
local cab=__a.projection_Box(d_b.CFrame,d_b.Size,bab.p)
if
__a.boxcast_singleTarget(bab,aab.Size+Vector3.new(0,6,0),cab)then c_b=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",bca,cab,"monster",nil,"venom-puddle")end end else table.remove(b_b,_ab)if#b_b==0 then return end end end end;wait(0.2)end end)
for i=1,cda do local c_b=script.spiderQueenVenomBall:Clone()
c_b.Parent=bca;local d_b=60;local _ab=bca.targetEntity.Value
if _ab then
local cab=_ca.entity.Mandible.Position
local dab=Vector3.new(_ab.Position.x,bca.Position.y-bca.Size.y/2,_ab.Position.z)local _bb=d_a.GRAVITY.y;local abb=cab.y-dab.y
local bbb=(
Vector3.new(cab.x,0,cab.z)-Vector3.new(dab.x,0,dab.z)).magnitude;local cbb=math.sqrt((-2)* (abb/_bb))d_b=bbb/cbb+
caa:NextInteger(-10,10)end;local aab=_ca.entity.Mandible.CFrame.lookVector
local bab=Vector3.new(aab.x,0,aab.z).unit
d_a.createProjectile(_ca.entity.Mandible.Position,bab,d_b,c_b,function(cab,dab,_bb)
c_b.Impact:Play()c_b.Transparency=1;c_b.CanCollide=false;c_b.Anchored=true
c_b.Explode:Emit(100)c_b.Fire.Enabled=false
game:GetService("Debris"):AddItem(c_b,5)
if cab then
if bba.Character and bba.Character.PrimaryPart then
local bbb=bba.Character.PrimaryPart;local cbb=__a.projection_Box(bbb.CFrame,bbb.Size,dab)if
__a.spherecast_singleTarget(dab,6,cbb)then
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",bca,cbb,"monster",nil,"venom-impact")end end
local abb=script.spiderQueenVenomPuddle:Clone()abb.Parent=bca;abb.CFrame=CFrame.new(dab)*
CFrame.Angles(0,0,math.rad(90))
abb.Bubbles:Play()table.insert(b_b,abb)wait(10)abb.Fire.Enabled=false
b_a(abb,{"Transparency"},1,1)game.Debris:AddItem(abb,1)end end,
nil,{_ca,bca,dda,__b})c_b.Cast:Play()wait(_da/cda)end;a_b.Enabled=false;game.Debris:AddItem(a_b,5)end,step=function(bba,cba)
bba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)if bba.targetEntity==nil or bba.targetEntity==nil then
return"idling"end;return"idling"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(bba,cba)bba.specialsUsed=
bba.specialsUsed+1;if bba.__STATE_OVERRIDES["special-attacking"]then
bba.__STATE_OVERRIDES["special-attacking"](bba)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(bba,cba)return
"idling"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(bba,cba)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(bba,cba)
if
workspace:FindFirstChild("spiderQueenMusic")then workspace.spiderQueenMusic:Stop()end;return nil end}},processDamageRequest=function(bba,cba)
if
bba=="venom-puddle"then return math.ceil(cba*0.25),"magical","dot"elseif
bba=="jab"then return math.ceil(cba*2.5),"physical","direct"elseif bba=="bite"then return
math.ceil(cba*1.8),"physical","direct"elseif bba=="venom-impact"then return math.ceil(cba*0.7),
"magical","projectile"elseif bba=="trample"then
return math.ceil(cba*0.1),"physical","direct"end;return cba,"physical","direct"end,processDamageRequestToMonster=function(bba,cba)
end,onDamageReceived=function(bba,cba,dba,_ca)
if cba=="player"then if not aaa[dba]then aaa[dba]=_ca else
aaa[dba]=aaa[dba]+_ca end end end,processDamageRequestToMonster=function(bba,cba)if
bba.state=="idling"or bba.state=="sleeping"then
cba.damage=math.floor(cba.damage*0.5)cba.supressed=true end;return
cba end}