local cc=game:GetService("ReplicatedStorage")
local dc=require(cc.modules)local _d=dc.load("pathfinding")local ad=dc.load("utilities")
local bd=dc.load("detection")local cd=dc.load("network")local dd=dc.load("tween")
local __a=dc.load("placeSetup")local a_a=dc.load("projectile")
local b_a=game:GetService("RunService")local c_a=1;local d_a={}
local function _aa(_ba)local aba,bba=nil,0
if not aba and _ba.closestEntity then
if(
_ba.closestEntity.Position-_ba.manifest.Position).magnitude<=
_ba.aggressionRange then aba=_ba.closestEntity end end
for cba,dba in pairs(d_a)do
if
dba>bba and cba.Character and cba.Character.PrimaryPart then
if

(cba.Character.PrimaryPart.Position-_ba.manifest.Position).magnitude<=_ba.aggressionRange and

cba.Character.PrimaryPart.Position.Y-_ba.manifest.Position.Y<20 then aba=cba.Character.PrimaryPart;bba=dba end end end;d_a={}return aba end;local aaa=Random.new()local function baa(_ba,aba,bba)end;local caa
local daa=game:GetService("PhysicsService")
return
{getClosestEntities=function(_ba)local aba=ad.getEntities()
for i=#aba,1,-1 do local bba=aba[i]if
(bba.Name=="Spider"or bba.Name==
"Spiderling"or bba.Name=="Spider Queen")or bba==_ba.manifest then
table.remove(aba,i)end end;return aba end,default="setup",states={["setup"]={transitionLevel=0,step=function(_ba)
local aba=dc.load("physics")local bba=_ba.manifest
bba.CustomPhysicalProperties=PhysicalProperties.new(1000,1,0)if bba:FindFirstChild("BodyForce")then
game.Debris:AddItem(bba.BodyForce,1)end
delay(1,function()
if
workspace:FindFirstChild("spiderQueenMusic")then workspace.spiderQueenMusic:Play()end end)ad.playSound("spiderQueenSpawn",bba)
local cba=aba:getCollisionGroup("spiderQueen")
if cba then aba:setWholeCollisionGroup(bba,"spiderQueen")
local dba=daa:GetCollisionGroupName(cba)
if dba then local _ca={"characters","items","monsters","npcs"}
for aca,bca in pairs(_ca)do
local cca,dca=pcall(function()
daa:CollisionGroupSetCollidable(dba,bca,false)end)if not cca then
warn("Failed to make Spider Queen not collide with group",bca)end end end end;return"sleeping"end},["sleeping"]={timeBetweenUpdates=5,transitionLevel=1,step=function(_ba,aba)if
_ba.closestEntity then return"idling"end end},["idling"]={lockTimeForPreventStateTransition=5,transitionLevel=2,execute=function(_ba,aba,bba,cba)
caa=false
if
cba:FindFirstChild("entity")and cba.entity:FindFirstChild("Eyes")then if cba.entity.Eyes.Transparency<=0.01 then
dd(cba.entity.Eyes,{"Transparency"},0.9,0.5)end
for dba,_ca in
pairs(cba.entity:GetDescendants())do if _ca.Name=="Flames"then _ca.Enabled=false end end end end,step=function(_ba,aba)
_ba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)
if
_ba.closestEntity and
(_ba.closestEntity.Position-_ba.manifest.Position).magnitude<=_ba.aggressionRange then if aba then _ba.__ROTATE_INIT=false;return"rotating"else end else
return"sleeping"end end},["rotating"]={animationEquivalent="walking",transitionLevel=4,lockTimeForPreventStateTransition=0.5,execute=function(_ba,aba,bba,cba)
caa=true
if not cba or
not cba:FindFirstChild("clientHitboxToServerHitboxReference")then return end
if
cba:FindFirstChild("entity")and cba.entity:FindFirstChild("Eyes")then if cba.entity.Eyes.Transparency>=0.01 then
dd(cba.entity.Eyes,{"Transparency"},0,0.5)end
for bda,cda in
pairs(cba.entity:GetDescendants())do if cda.Name=="Flames"then end end end;local dba=cba.clientHitboxToServerHitboxReference.Value
if not
game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dba then return elseif not dba:FindFirstChild("stateData")then return elseif
not _ba.Character or not _ba.Character.PrimaryPart then return elseif not
cba:FindFirstChild("entity")or
not cba.entity:FindFirstChild("Mandible")then return end;local _ca=_ba.Character.PrimaryPart
local aca=cba.clientHitboxToServerHitboxReference.Value;ad.playSound("spiderQueenRotating",aca)local bca=0.1
wait(bca)
if not aca.Parent then return elseif not aca:FindFirstChild("stateData")then return elseif not
_ba.Character or not _ba.Character.PrimaryPart then return elseif not
cba:FindFirstChild("entity")or
not cba.entity:FindFirstChild("Mandible")then return end;local cca=0.5;local dca=cca-bca;local _da=tick()local ada=false
while aba.IsPlaying and
(tick()-_da<=dca)and not ada do
if cba:FindFirstChild("entity")then
for bda,cda in
pairs(cba.entity:GetChildren())do
if cda:IsA("BasePart")and not ada then local dda=cda.CFrame
local __b=bd.projection_Box(_ca.CFrame,_ca.Size,dda.p)
if bd.boxcast_singleTarget(dda,cda.Size,__b)then
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aca,__b,"monster",
nil,"trample")
local a_b=( (_ca.Position-aca.Position)*Vector3.new(1,0,1)).unit
cd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(a_b*90))ada=true end end end;wait(0.1)else break end end end,step=function(_ba,aba)
if
not _ba.__ROTATE_INIT then local aca=_aa(_ba)
if aca then _ba:setTargetEntity(aca)
local bca=Vector3.new(aca.Position.X,_ba.manifest.Position.Y,aca.Position.Z)
_ba.__DEGREES_TO_TURN=math.acos(bca:Dot(_ba.manifest.Position))
local cca=_ba.manifest.Position+_ba.manifest.CFrame.lookVector*
_ba.manifest.Size.X/2.1;_ba.__TARGET_DIST_FROM_HEAD=(bca-cca).magnitude else
warn("Rotate had no target. Resetting")return"idling"end;_ba.__ROTATE_INIT=true end;if not _ba.targetEntity then return"idling"end
local bba=_ba.targetEntity;local cba=_ba.health/_ba.maxHealth
local dba=(bba.Position-_ba.manifest.Position).magnitude;local _ca=_ba.__TARGET_DIST_FROM_HEAD
if bba then
local aca=Vector3.new(bba.Position.X,_ba.manifest.Position.Y,bba.Position.Z)
local bca=math.acos(aca:Dot(_ba.manifest.Position))
if bca>math.rad(3)then
local cca=math.sign(aca:Cross(_ba.manifest.Position):Dot(Vector3.new(0,1,0)))
_ba.manifest.BodyGyro.CFrame=_ba.manifest.BodyGyro.CFrame*CFrame.Angles(0,
math.min(bca,math.rad(0.25))*cca,0)else
local cca=(bba.Position-_ba.manifest.Position).magnitude;_ba.__TARGET_POSITION_FOR_MONSTER=aca
_ba.manifest.BodyGyro.CFrame=CFrame.new(_ba.manifest.Position,aca)_ba.__START_ABILITY_TIME=tick()
_ba.__RAMPAGE_STREAK=_ba.__RAMPAGE_STREAK or 0;local dca
if aaa:NextNumber()<=0.4 * (1 -cba*0.7)then
dca="venomspray"elseif aaa:NextNumber()<=0.4 * (1 -cba*1.4)then dca="screeching"elseif dba>=
45 then
if
_ba.__RAMPAGE_STREAK<=2 and aaa:NextInteger(1,4)>1 then dca="rampage"else dca="venomspray"end elseif _ca>=12 then dca="jabbing"else dca="bite"end;warn(dca,_ba.__RAMPAGE_STREAK)
if dca then
if dca=="rampage"then _ba.__RAMPAGE_STREAK=(
_ba.__RAMPAGE_STREAK or 0)+1 else
warn("RESET RAMPAGE STREAK")_ba.__RAMPAGE_STREAK=0 end;return dca end end else return"idling"end end},["rampage"]={animationEquivalent="walking",transitionLevel=5,lockTimeForPreventStateTransition=3,execute=function(_ba,aba,bba,cba)
if
not cba or
not cba:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local dba=cba.clientHitboxToServerHitboxReference.Value
if not
game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dba then return elseif not dba:FindFirstChild("stateData")then return elseif
not _ba.Character or not _ba.Character.PrimaryPart then return elseif not
cba:FindFirstChild("entity")or
not cba.entity:FindFirstChild("Mandible")then return end;if cba:FindFirstChild("entity")then
for bda,cda in
pairs(cba.entity:GetDescendants())do if cda.Name=="Flames"then end end end
ad.playSound("spiderQueenAbilityUse",dba)local _ca=_ba.Character.PrimaryPart
local aca=cba.clientHitboxToServerHitboxReference.Value;local bca=aba.Length*0.3;wait(bca)
if not aca.Parent then return elseif not
aca:FindFirstChild("stateData")then return elseif
not _ba.Character or not _ba.Character.PrimaryPart then return elseif not cba:FindFirstChild("entity")or not
cba.entity:FindFirstChild("Mandible")then return end
local cca=aba.Length* (bba.animationDamageEnd or 0.67)local dca=cca-bca;local _da=tick()local ada=false
while aba.IsPlaying and not ada do
if
cba:FindFirstChild("entity")then
for bda,cda in pairs(cba.entity:GetChildren())do
if
cda:IsA("BasePart")and not ada then local dda=cda.CFrame
local __b=bd.projection_Box(_ca.CFrame,_ca.Size,dda.p)
if bd.boxcast_singleTarget(dda,cda.Size,__b)then
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aca,__b,"monster",
nil,"trample")ada=true end end end;wait(0.1)else break end end end,step=function(_ba,aba)
if
_ba.closestEntity then
if tick()-_ba.__START_ABILITY_TIME<=4 then
if not _ba.targetEntity or not
_ba.targetEntity then return"idling"end;local bba=_ba.targetEntity;local cba=_ba.__TARGET_POSITION_FOR_MONSTER;if bba then
cba=bba.Position end
if
cba.Y>_ba.manifest.Position.Y+10 then warn("y too high escape")_ba.__ROTATE_INIT=false;return"rotating"end
local dba=_ba.manifest.BodyVelocity.Velocity.magnitude;local _ca=_ba.manifest.Velocity.magnitude;_ba.__BLOCKEDCONFIDENCE=
_ba.__BLOCKEDCONFIDENCE or 0
if _ca<=dba*0.2 then _ba.__BLOCKEDCONFIDENCE=
_ba.__BLOCKEDCONFIDENCE+1
if _ba.__BLOCKEDCONFIDENCE>=3 then
warn("blocked escape")_ba.__BLOCKEDCONFIDENCE=0;_ba.__ROTATE_INIT=false;return"rotating"end else _ba.__BLOCKEDCONFIDENCE=0 end
if(cba-_ba.manifest.Position).magnitude>=45 then
_ba.manifest.BodyVelocity.Velocity=(
cba-_ba.manifest.Position).unit*_ba.baseSpeed
_ba.manifest.BodyGyro.CFrame=CFrame.new(_ba.manifest.Position,Vector3.new(cba.X,_ba.manifest.Position.Y,cba.Z))else _ba.__ROTATE_INIT=false;return"rotating"end else _ba.__ROTATE_INIT=false;return"rotating"end else return"idling"end end},["bite"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=1,execute=function(_ba,aba,bba,cba)
if

not game:GetService("RunService"):IsClient()then warn("bite::execute can only be called on client")
return elseif not bba.damageHitboxCollection then end;if cba:FindFirstChild("entity")then
for ada,bda in
pairs(cba.entity:GetDescendants())do if bda.Name=="Flames"then bda.Enabled=false end end end
local dba=false;local _ca=_ba.Character.PrimaryPart
local aca=cba.clientHitboxToServerHitboxReference.Value
local bca=aba.Length* (bba.animationDamageStart or 0.3)ad.playSound("spiderQueenAbilityUse",aca)wait(bca)
local cca=
aba.Length* (bba.animationDamageEnd or 0.7)local dca=cca-bca;local _da=dca/10
for i=0,dca,_da do
if aba.IsPlaying and not dba and
cba:FindFirstChild("entity")then
local ada=(cba.entity.Mandible.CFrame*
CFrame.new(0,0,3)).p;local bda=bd.projection_Box(_ca.CFrame,_ca.Size,ada)if
bd.spherecast_singleTarget(ada,6,bda)then dba=true
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aca,bda,"monster",nil,"bite")end
wait(_da)else break end end end,step=function(_ba,aba)if
_ba.targetEntity==nil then return"idling"end
local bba=_ba.manifest.Position;local cba=_ba.targetEntity;local dba=cba.Position
local _ca=Vector3.new(dba.X,bba.Y,dba.Z)local aca=ad.magnitude(bba-_ca)local bca=(_ca-bba).unit;local cca=_ca-bca*
(_ba.attackRange)
_ba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["jabbing"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=1.5,execute=function(_ba,aba,bba,cba)
if

not game:GetService("RunService"):IsClient()then
warn("jabbing::execute can only be called on client")return elseif not bba.damageHitboxCollection then end;if cba:FindFirstChild("entity")then
for __b,a_b in
pairs(cba.entity:GetDescendants())do if a_b.Name=="Flames"then a_b.Enabled=false end end end
local dba=false;local _ca=_ba.Character.PrimaryPart
local aca=cba.clientHitboxToServerHitboxReference.Value
local bca=aba.Length* (bba.animationDamageStart or 0.3)ad.playSound("spiderQueenAbilityUse",aca)wait(bca)
cba.entity:FindFirstChild("1LLEG2").Trail.Enabled=true
cba.entity:FindFirstChild("1RLEG2").Trail.Enabled=true;local cca=aba.Length*0.63;local dca=cca-bca;local _da=dca/10;local ada={}
local bda=__a.getPlaceFolder("entityRenderCollection")local cda={}local dda
for i=0,dca,_da do
if
aba.IsPlaying and not dba and cba:FindFirstChild("entity")then
for __b,a_b in pairs({"1LLEG2","1RLEG2"})do
local b_b=cba.entity:FindFirstChild(a_b)
if b_b and not dba then
if not ada[a_b]then
local c_b=(b_b.CFrame*
CFrame.new(0,-b_b.Size.Y/2,0)).p-b_b.CFrame.p;local d_b=Ray.new(b_b.CFrame.p,c_b)
local _ab,aab,bab=workspace:FindPartOnRayWithIgnoreList(d_b,{workspace.placeFolders})
if _ab then ada[a_b]=true;cda[a_b]=aab
local cab=script.spiderQueenJabImpact:Clone()cab.Parent=aca;cab.Anchored=true;cab.CFrame=CFrame.new(aab)*
CFrame.Angles(0,0,math.rad(90))
cab.Fire:Emit(50)cab.Sound:Play()
dd(cab,{"Transparency"},1,5)game.Debris:AddItem(cab,5)end end
if cda[a_b]then
local c_b=bd.projection_Box(_ca.CFrame,_ca.Size,cda[a_b])if bd.spherecast_singleTarget(cda[a_b],5,c_b)then dba=true
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aca,c_b,"monster",
nil,"jab")end
if
not dba and not dda then local d_b=18;local _ab
for aab,bab in pairs(cda)do
local cab=(bab-_ca.Position).magnitude;if cab<d_b then d_b=cab;_ab=bab end end
if _ab then dda=true;local aab=(_ca.Position-_ab).unit
cd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(
aab+Vector3.new(0,1.25,0))* (30 -d_b)*6)
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aca,c_b,"monster",nil,"trample")end end end end end;wait(_da)else break end end
cba.entity:FindFirstChild("1LLEG2").Trail.Enabled=false
cba.entity:FindFirstChild("1RLEG2").Trail.Enabled=false end,step=function(_ba,aba)
if
_ba.targetEntity==nil or _ba.targetEntity==nil then return"idling"end;local bba=_ba.manifest.Position;local cba=_ba.targetEntity
local dba=_ba.targetEntity;local _ca=dba.Position;local aca=Vector3.new(_ca.X,bba.Y,_ca.Z)local bca=ad.magnitude(
bba-aca)local cca=(aca-bba).unit;local dca=aca-
cca* (_ba.attackRange)
_ba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["screeching"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=4,execute=function(_ba,aba,bba,cba)
if
cba:FindFirstChild("entity")then for aca,bca in pairs(cba.entity:GetDescendants())do if bca.Name=="Flames"then
bca.Enabled=false end end end;wait(1.4)
local dba=cba.clientHitboxToServerHitboxReference.Value;ad.playSound("spiderQueenScreech",dba)
local _ca=script.Screech:Clone()_ca.Parent=cba.entity.Mandible;_ca.Enabled=true
spawn(function()wait(3)
_ca.Enabled=false;game.Debris:AddItem(_ca,3)end)end,execute_server=function(_ba)
wait(1)
local aba=workspace.placeFolders.spawnRegionCollections:FindFirstChild("Spider-0")
if aba==nil then aba=Instance.new("Folder")aba.Name="Spider-0"
local bba=Instance.new("Part")bba.Transparency=1;bba.Anchored=true;bba.CanCollide=false;bba.Parent=aba
aba.Parent=workspace.placeFolders.spawnRegionCollections end
for i=1,20 do
local bba=_ba.manifest.CFrame*
Vector3.new(math.random(-10,10),0,
-_ba.manifest.Size.Z/2 -math.random(5,10))local cba=aaa:NextInteger(1,15)==7
local dba={targetEntity=_ba.targetEntity,targetEntity=_ba.targetEntity,giant=cba}local _ca
if game.PlaceId==3207211233 then
_ca=cd:invoke("spawnSpiderling",bba,dba)else
_ca=cd:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Spiderling",bba,aba,dba)end
if _ca and _ca.manifest then
_ca.manifest.Velocity=_ca.manifest.CFrame.lookVector*30
if _ca.manifest:FindFirstChild("BodyVelocity")then _ca.manifest.BodyVelocity.Velocity=
_ca.manifest.CFrame.lookVector*30 end;local aca=script.SpiderlingParticle:Clone()
aca.Parent=_ca.manifest
spawn(function()wait(4)if aca then aca.Enabled=false
game.Debris:AddItem(aca,3)end end)end;wait(0.1)end end,step=function(_ba,aba)
if
_ba.targetEntity==nil or _ba.targetEntity==nil then return"idling"end;local bba=_ba.manifest.Position;local cba=_ba.targetEntity
local dba=_ba.targetEntity;local _ca=dba.Position;local aca=Vector3.new(_ca.X,bba.Y,_ca.Z)local bca=ad.magnitude(
bba-aca)local cca=(aca-bba).unit;local dca=aca-
cca* (_ba.attackRange)
_ba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)return"idling"end},["venomspray"]={transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=4,execute=function(_ba,aba,bba,cba)
if
not cba or
not cba:FindFirstChild("clientHitboxToServerHitboxReference")then return end;local dba=cba.clientHitboxToServerHitboxReference.Value
if not
game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not dba then return elseif not dba:FindFirstChild("stateData")then return elseif
not _ba.Character or not _ba.Character.PrimaryPart then return elseif not
cba:FindFirstChild("entity")or
not cba.entity:FindFirstChild("Mandible")then return end;if cba:FindFirstChild("entity")then
for a_b,b_b in
pairs(cba.entity:GetDescendants())do if b_b.Name=="Flames"then b_b.Enabled=false end end end
local _ca=cba.clientHitboxToServerHitboxReference.Value;local aca=aba.Length*0.3
ad.playSound("spiderQueenAbilityUse",_ca)wait(aca)
if not _ca.Parent then return elseif
not _ca:FindFirstChild("stateData")then return elseif
not _ba.Character or not _ba.Character.PrimaryPart then return elseif not cba:FindFirstChild("entity")or not
cba.entity:FindFirstChild("Mandible")then return end
local bca=aba.Length* (bba.animationDamageEnd or 0.67)local cca=bca-aca
local dca,_da=ad.safeJSONDecode(_ca.stateData.Value)local ada=dca and _da.shots or 20
local bda=__a.getPlaceFolder("entityRenderCollection")local cda=__a.getPlaceFolder("entityManifestCollection")
local dda=script.Foam:Clone()dda.Parent=cba.entity.Mandible;dda.Enabled=true;local __b={}
spawn(function()
while true do
if _ba.Character and
_ba.Character.PrimaryPart and
_ba.Character.PrimaryPart.health.Value>0 then local a_b=false
local b_b=_ba.Character.PrimaryPart
for c_b,d_b in pairs(__b)do
if d_b.Parent==_ca then
if not a_b then
local _ab=d_b.CFrame+Vector3.new(0,3,0)local aab=bd.projection_Box(b_b.CFrame,b_b.Size,_ab.p)
if bd.boxcast_singleTarget(_ab,
d_b.Size+Vector3.new(0,6,0),aab)then a_b=true
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_ca,aab,"monster",
nil,"venom-puddle")end end else table.remove(__b,c_b)if#__b==0 then return end end end end;wait(0.2)end end)
for i=1,ada do local a_b=script.spiderQueenVenomBall:Clone()
a_b.Parent=_ca;local b_b=60;local c_b=_ca.targetEntity.Value
if c_b then
local aab=cba.entity.Mandible.Position
local bab=Vector3.new(c_b.Position.x,_ca.Position.y-_ca.Size.y/2,c_b.Position.z)local cab=a_a.GRAVITY.y;local dab=aab.y-bab.y
local _bb=(
Vector3.new(aab.x,0,aab.z)-Vector3.new(bab.x,0,bab.z)).magnitude;local abb=math.sqrt((-2)* (dab/cab))b_b=_bb/abb+
aaa:NextInteger(-10,10)end;local d_b=cba.entity.Mandible.CFrame.lookVector
local _ab=Vector3.new(d_b.x,0,d_b.z).unit
a_a.createProjectile(cba.entity.Mandible.Position,_ab,b_b,a_b,function(aab,bab,cab)
a_b.Impact:Play()a_b.Transparency=1;a_b.CanCollide=false;a_b.Anchored=true
a_b.Explode:Emit(100)a_b.Fire.Enabled=false
game:GetService("Debris"):AddItem(a_b,5)
if aab then
if _ba.Character and _ba.Character.PrimaryPart then
local _bb=_ba.Character.PrimaryPart;local abb=bd.projection_Box(_bb.CFrame,_bb.Size,bab)if
bd.spherecast_singleTarget(bab,6,abb)then
cd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_ca,abb,"monster",nil,"venom-impact")end end
local dab=script.spiderQueenVenomPuddle:Clone()dab.Parent=_ca;dab.CFrame=CFrame.new(bab)*
CFrame.Angles(0,0,math.rad(90))
dab.Bubbles:Play()table.insert(__b,dab)wait(10)dab.Fire.Enabled=false
dd(dab,{"Transparency"},1,1)game.Debris:AddItem(dab,1)end end,
nil,{cba,_ca,bda,cda})a_b.Cast:Play()wait(cca/ada)end;dda.Enabled=false;game.Debris:AddItem(dda,5)end,step=function(_ba,aba)
_ba.manifest.BodyVelocity.Velocity=Vector3.new(0,0,0)if _ba.targetEntity==nil or _ba.targetEntity==nil then
return"idling"end;return"idling"end},["special-attacking"]={animationEquivalent="special-attack",transitionLevel=7,step=function(_ba,aba)_ba.specialsUsed=
_ba.specialsUsed+1;if _ba.__STATE_OVERRIDES["special-attacking"]then
_ba.__STATE_OVERRIDES["special-attacking"](_ba)end;return"special-recovering"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=8,lockTimeForLowerTransition=0.2,step=function(_ba,aba)return
"idling"end},["special-recovering"]={animationEquivalent="idling",transitionLevel=9,lockTimeForLowerTransition=0.75,step=function(_ba,aba)return
"attack-ready"end},["dead"]={animationEquivalent="death",transitionLevel=math.huge,stopTransitions=false,step=function(_ba,aba)
if
workspace:FindFirstChild("spiderQueenMusic")then workspace.spiderQueenMusic:Stop()end;return nil end}},processDamageRequest=function(_ba,aba)
if
_ba=="venom-puddle"then return math.ceil(aba*0.25),"magical","dot"elseif
_ba=="jab"then return math.ceil(aba*2.5),"physical","direct"elseif _ba=="bite"then return
math.ceil(aba*1.8),"physical","direct"elseif _ba=="venom-impact"then return math.ceil(aba*0.7),
"magical","projectile"elseif _ba=="trample"then
return math.ceil(aba*0.1),"physical","direct"end;return aba,"physical","direct"end,processDamageRequestToMonster=function(_ba,aba)
end,onDamageReceived=function(_ba,aba,bba,cba)
if aba=="player"then if not d_a[bba]then d_a[bba]=cba else
d_a[bba]=d_a[bba]+cba end end end,processDamageRequestToMonster=function(_ba,aba)if
_ba.state=="idling"or _ba.state=="sleeping"then
aba.damage=math.floor(aba.damage*0.5)aba.supressed=true end;return
aba end}