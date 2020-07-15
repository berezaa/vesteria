local ad=game:GetService("ReplicatedStorage")
local bd=require(ad.modules)local cd=bd.load("pathfinding")local dd=bd.load("utilities")
local __a=bd.load("detection")local a_a=bd.load("network")local b_a=bd.load("placeSetup")
local c_a=bd.load("tween")local d_a=b_a.getPlaceFolder("spawnRegionCollections")
local _aa=b_a.getPlaceFolder("entityManifestCollection")local aaa=b_a.getPlaceFolder("entityRenderCollection")
local baa=b_a.awaitPlaceFolder("items")local caa=b_a.getPlaceFolder("entities")
local daa=b_a.getPlaceFolder("foilage")local _ba=b_a.getPlaceFolder("activeMonsterLures")local aba=60
local bba=b_a.awaitPlaceFolder("entities")local cba=game:GetService("Debris")
function getCloseTargets(aca,bca)local cca={}
for dca,_da in
pairs(game.Players:GetPlayers())do
if _da.Character and _da.Character.PrimaryPart and
_da.Character.PrimaryPart.health.Value>0 then
if
(
_da.Character.PrimaryPart.Position-aca).magnitude<=bca then table.insert(cca,_da.Character.PrimaryPart)end end end;return cca end
function createEffectPart()local aca=Instance.new("Part")aca.Anchored=true
aca.CanCollide=false;aca.TopSurface=Enum.SurfaceType.Smooth
aca.BottomSurface=Enum.SurfaceType.Smooth;return aca end
function lightningSegment(aca,bca,cca)local dca=1;local _da=createEffectPart()_da.BrickColor=cca
_da.Material=Enum.Material.Neon;local ada=(bca-aca).magnitude;local bda=(aca+bca)/2
_da.Size=Vector3.new(0.25,0.25,ada)_da.CFrame=CFrame.new(bda,bca)_da.Parent=bba
c_a(_da,{"Transparency"},1,dca)cba:AddItem(_da,dca)end;local dba=1;local _ca=Random.new()
return
{processDamageRequest=function(aca,bca)
if aca=="laser"then
return math.ceil(bca*0.35),"physical","direct"elseif aca=="cry"then return math.ceil(bca*1.55),"physical","direct"elseif aca=="bolt"then return math.ceil(
bca*1.4),"physical","direct"elseif aca=="ring"then return math.ceil(bca),
"physical","direct"end;return bca,"physical","direct"end,getClosestEntities=function(aca)
local bca=dd.getEntities()
for i=#bca,1,-1 do local cca=bca[i]
if

cca.Name=="Moglo"or cca.Name==aca.monsterName or cca==aca.manifest or cca.Name=="Mogloko"then table.remove(bca,i)end end;return bca end,default="setup",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(aca)
if
workspace:FindFirstChild("tikiLaser")then workspace.tikiLaser.Parent=daa end;daa.tikiLaser.pewpew.Transparency=1
daa.tikiLaser.pewpew.bigouchie.ParticleEmitter.Enabled=false;aca.doingBolt=tick()aca.doingRing=tick()aca.doingCry=tick()
aca.doingLaser=tick()return"sleeping"end},["sleeping"]={animationEquivalent="idling",timeBetweenUpdates=5,transitionLevel=1,step=function(aca,bca)return
"idling"end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(aca,bca)
local cca=getCloseTargets(aca.manifest.Position,aba)if#cca>0 then return"attack-ready"end end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(aca,bca)
if
aca.closestEntity then aca:setTargetEntity(aca.closestEntity)end;local cca=9
if aca.health>aca.maxHealth*.85 then cca=8 elseif
aca.health>aca.maxHealth*.7 then cca=6 elseif aca.health>aca.maxHealth*.6 then cca=5 elseif
aca.health>aca.maxHealth*.5 then cca=4.5 elseif aca.health>aca.maxHealth*.4 then cca=4 elseif
aca.health>aca.maxHealth*.3 then cca=3.5 elseif aca.health>aca.maxHealth*.2 then cca=2.5 elseif
aca.health>aca.maxHealth*.1 then cca=1.5 end
if
aca.attackDelayedUntil==nil or tick()>aca.attackDelayedUntil then aca.__LAST_ATTACK_TIME=tick()local dca=math.random(4)
if dca==1 and tick()>
aca.doingBolt then aca.doingBolt=tick()+7
aca.attackDelayedUntil=tick()+cca;return"attacking-bolt"elseif dca==2 and tick()>aca.doingRing then aca.doingRing=
tick()+5.7;aca.attackDelayedUntil=tick()+cca
return"attacking-ring"elseif dca==3 and tick()>aca.doingCry then aca.doingCry=tick()+7;aca.attackDelayedUntil=
tick()+cca;return"attacking-cry"elseif tick()>aca.doingLaser then aca.doingLaser=
tick()+9;aca.attackDelayedUntil=tick()+cca
return"attacking-laser"end end end},["attacking-bolt"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(aca,bca,cca,dca)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not cca.damageHitboxCollection then end;local _da=false
local ada=dca.clientHitboxToServerHitboxReference.Value
workspace.TotemBoss.boltTotem.awaken:Play()
c_a(workspace.TotemBoss.boltEyes,{"Color"},{Color3.fromRGB(255,0,0)},2)wait(2)
spawn(function()
for i=1,8 do local _ab=.3125;if i==1 or i==8 then _ab=1.2 end
c_a(workspace.TotemBoss.boltTotem,{"CFrame"},{
workspace.TotemBoss.boltTotem.CFrame*CFrame.Angles(0,-math.pi/2,0)},_ab,( (
i==1 or i==8)and Enum.EasingStyle.Back)or
Enum.EasingStyle.Linear,
i==1 and Enum.EasingDirection.In or i==8 and Enum.EasingDirection.Out)wait(_ab)end end)wait(1)
local bda=bca.Length* (cca.animationDamageStart or 0.3)
local cda=bca.Length* (cca.animationDamageEnd or 0.7)local dda=cda-bda;local __b=dda/10;local a_b=14;local b_b=4;local c_b=4
local d_b=BrickColor.new("Really red")
for times=1,8 do
local _ab=CFrame.new(workspace.TotemBoss.boltTotem.Position)
if times==1 then _ab=_ab+Vector3.new(20,0,0)elseif times==2 then _ab=_ab+
Vector3.new(10,0,10)elseif times==3 then
_ab=_ab+Vector3.new(0,0,20)elseif times==4 then _ab=_ab+Vector3.new(-10,0,10)elseif times==5 then _ab=_ab+Vector3.new(
-20,0,0)elseif times==6 then _ab=_ab+
Vector3.new(-10,0,-10)elseif times==7 then
_ab=_ab+Vector3.new(0,0,-20)elseif times==8 then _ab=_ab+Vector3.new(10,0,-10)end
for casts=1,6 do local aab=_ab+
Vector3.new(math.random(-10,10),0,math.random(-10,10))local bab=Ray.new(aab.p,Vector3.new(0,
-100,0))
local cab={d_a,baa,daa,daa.tikiLaser,workspace.TotemBossSpawn,workspace.TotemBoss,dca,ada}
local dab,_bb=workspace:FindPartOnRayWithIgnoreList(bab,cab)
for bolt=1,1 do local abb=CFrame.new(_bb)local bbb=abb
local cbb=CFrame.Angles(0,math.pi*2 *math.random(),0)
local dbb=CFrame.Angles(math.pi/8 *math.random(),0,0)abb=abb*cbb*dbb
for pointNumber=2,a_b do
local dcb=math.pi*2 *math.random()local _db=math.cos(dcb)*c_b*math.random()local adb=(
pointNumber-1)*b_b
local bdb=math.sin(dcb)*c_b*math.random()local cdb=abb*CFrame.new(_db,adb,bdb)
lightningSegment(abb.Position,cdb.Position,d_b)abb=cdb end;local _cb=createEffectPart()_cb.Position=bbb.Position
_cb.Material=Enum.Material.Neon;_cb.BrickColor=d_b;_cb.Size=Vector3.new(1,1,1)_cb.Shape="Ball"
_cb.Parent=daa;local acb=bbb+Vector3.new(0,1,0)
local bcb=aca.Character.PrimaryPart
local ccb=__a.projection_Box(bcb.CFrame,bcb.Size,acb.p)if __a.boxcast_singleTarget(acb,_cb.Size*7,ccb)then _da=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ada,ccb,"monster","bolt")end
c_a(_cb,{"Transparency","Size"},{1,Vector3.new(10,10,10)},.5)cba:AddItem(_cb,.5)end;dd.playSound("lightning",ada)end;wait(.25)end
c_a(workspace.TotemBoss.boltEyes,{"Color"},{Color3.fromRGB(0,0,0)},2)end,step=function(aca,bca)return
"micro-sleeping"end},["attacking-ring"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(aca,bca,cca,dca)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not cca.damageHitboxCollection then end;local _da=false
local ada=dca.clientHitboxToServerHitboxReference.Value
workspace.TotemBoss.grassTotem.awaken:Play()
c_a(workspace.TotemBoss.grassEyes,{"Color"},{Color3.fromRGB(85,255,0)},2)wait(2)
spawn(function()
for i=1,6 do
c_a(workspace.TotemBoss.grassTotem,{"CFrame"},{
workspace.TotemBoss.grassTotem.CFrame*CFrame.Angles(0,-math.pi/4,0)},.2,Enum.EasingStyle.Quad,Enum.EasingDirection.In)wait(.25)end end)
for times=1,6 do local bda=script.ring:Clone()
bda.Position=workspace.TotemBoss.grassTotem.Position;bda.Parent=bba
workspace.TotemBoss.grassTotem["marimba"..times]:Play()
if aca.Character then local cda=aca.Character.PrimaryPart
local dda=workspace.TotemBoss.grassTotem.CFrame
local __b=__a.projection_Box(cda.CFrame,cda.Size,dda.p)
if __a.boxcast_singleTarget(dda,bda.Size*3,__b)then _da=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ada,__b,"monster","ring")
if times==6 then
local a_b=( (cda.Position-ada.Position)*Vector3.new(1,0,1)).unit
a_a:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(a_b*40 +Vector3.new(0,20,0)))end end end
c_a(bda,{"Transparency","Size"},{1,bda.size*5},.5)cba:AddItem(bda,.5)wait(.25)end
c_a(workspace.TotemBoss.grassEyes,{"Color"},{Color3.fromRGB(0,0,0)},2)end,step=function(aca,bca)return
"micro-sleeping"end},["attacking-laser"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(aca,bca,cca,dca)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not cca.damageHitboxCollection then end;local _da=false
local ada=dca.clientHitboxToServerHitboxReference.Value
c_a(workspace.TotemBoss.laserEyes,{"Color"},{Color3.fromRGB(255,0,191)},2)
workspace.TotemBoss.laserTotem.awaken:Play()wait(2)
local bda=getCloseTargets(workspace.TotemBoss.laserTotem.Position,aba+15)local cda
if#bda>0 then cda=bda[math.random(#bda)]end;local dda=false;local __b=workspace.TotemBoss.laserTotem
for times=1,50 do if dca==nil or dca.Parent==
nil then break end
if
cda and cda.Parent and
cda.health.Value>0 and
(cda.Position-
workspace.TotemBoss.laserTotem.Position).magnitude<aba+15 and
(cda.Position-
workspace.TotemBoss.grassTotem.Position).magnitude>10 then local a_b=cda.Position-Vector3.new(0,2,0)
daa.tikiLaser.pewpew.Transparency=0
daa.tikiLaser.pewpew.bigouchie.ParticleEmitter.Enabled=true
c_a(__b,{"CFrame"},{CFrame.new(__b.Position,Vector3.new(a_b.X,__b.Position.Y,a_b.Z))},.1,Enum.EasingStyle.Linear)
c_a(daa.tikiLaser,{"CFrame"},{CFrame.new(daa.tikiLaser.Position,Vector3.new(a_b.X,a_b.Y,a_b.Z))},.1,Enum.EasingStyle.Linear)if not dda then
workspace.TotemBoss.laserTotem.laserRay.TimePosition=1
workspace.TotemBoss.laserTotem.laserRay:Play()end;dda=true
local b_b=daa.tikiLaser.repositionLaser.Position
local c_b=Ray.new(b_b,daa.tikiLaser.repositionLaser.CFrame.LookVector*
(aba+15))
local d_b={d_a,baa,bba,daa,daa.tikiLaser,workspace.TotemBoss,workspace.TotemBossSpawn,aaa,dca,ada}
local _ab,aab=workspace:FindPartOnRayWithIgnoreList(c_b,d_b)local bab=(b_b-aab).magnitude
local cab=daa.tikiLaser.pewpew.Size.Z;local dab=bab-cab
daa.tikiLaser.pewpew.Position=
daa.tikiLaser.repositionLaser.Position+
daa.tikiLaser.pewpew.CFrame.LookVector*bab/2
daa.tikiLaser.pewpew.bigouchie.Position=b_b+

daa.tikiLaser.pewpew.CFrame.LookVector* (daa.tikiLaser.pewpew.Size.Z-.5)
daa.tikiLaser.pewpew.Size=Vector3.new(.6,.6,bab)local _bb=aca.Character.PrimaryPart
local abb=CFrame.new(daa.tikiLaser.pewpew.bigouchie.Position)
local bbb=__a.projection_Box(_bb.CFrame,_bb.Size,abb.p)
if not _da and
__a.boxcast_singleTarget(abb,daa.tikiLaser.pewpew.bigouchie.Size*2.5,bbb)then
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ada,bbb,"monster","laser")end else
workspace.TotemBoss.laserTotem.laserRay:Stop()dda=false;daa.tikiLaser.pewpew.Transparency=1
daa.tikiLaser.pewpew.bigouchie.ParticleEmitter.Enabled=false
local a_b=getCloseTargets(workspace.TotemBoss.laserTotem.Position,aba+15)if#a_b>0 then cda=a_b[math.random(#a_b)]end end;wait(.1)end
workspace.TotemBoss.laserTotem.laserRay:Stop()daa.tikiLaser.pewpew.Transparency=1
daa.tikiLaser.pewpew.bigouchie.ParticleEmitter.Enabled=false
c_a(workspace.TotemBoss.laserEyes,{"Color"},{Color3.fromRGB(0,0,0)},2)end,step=function(aca,bca)return
"micro-sleeping"end},["attacking-cry"]={transitionLevel=6,animationEquivalent="attacking",animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,execute=function(aca,bca,cca,dca)
if

not game:GetService("RunService"):IsClient()then
warn("attacking::execute can only be called on client")return elseif not cca.damageHitboxCollection then end;local _da=false
local ada=dca.clientHitboxToServerHitboxReference.Value
c_a(workspace.TotemBoss.cryEyes,{"Color"},{Color3.fromRGB(0,137,206)},2)
workspace.TotemBoss.cryTotem.awaken:Play()wait(2)
spawn(function()
for i=1,6 do
c_a(workspace.TotemBoss.cryTotem,{"CFrame"},{
i%2 ==1 and
workspace.TotemBoss.cryTotem.CFrame*CFrame.Angles(0,math.pi-.1,0)or workspace.TotemBoss.cryTotem.CFrame*
CFrame.Angles(0,-math.pi+.1,0)},.5,Enum.EasingStyle.Quad,Enum.EasingDirection.In)wait(.5)end end)local bda={}
local cda=getCloseTargets(workspace.TotemBoss.cryTotem.Position,aba)
local dda={d_a,baa,bba,daa,daa.tikiLaser,aaa,workspace.TotemBoss,workspace.TotemBossSpawn,dca,ada}local __b=3
for times=1,5 do
for a_b,b_b in pairs(cda)do
if

b_b and b_b.Parent and b_b.health.Value>0 and(b_b.Position-ada.Position).magnitude<aba then
spawn(function()wait(math.random()/2)
local c_b=script.tear:Clone()c_b.Position=b_b.Position+Vector3.new(0,30,0)
c_b.Parent=bba
c_a(c_b,{"Position"},{Vector3.new(b_b.Position.X,ada.Position.Y-30,b_b.Position.Z)},1,Enum.EasingStyle.Linear)cba:AddItem(c_b,2)local d_b=c_b.CFrame.p;local _ab=false;local aab=tick()
while
tick()<aab+1 do local bab=(c_b.CFrame.p-d_b).magnitude
local cab=Ray.new(d_b,(
c_b.CFrame.p-d_b).unit*bab)
local dab,_bb=workspace:FindPartOnRayWithIgnoreList(cab,dda)
if dab and not _ab then _ab=true;c_b.Transparency=1
local abb=script.drip:Clone()abb.Position=_bb;abb.Parent=bba
abb.ParticleEmitter:emit(40)cba:AddItem(abb,3)dd.playSound("splash",_bb)
local bbb=aca.Character.PrimaryPart
local cbb=CFrame.new(_bb-Vector3.new(0,c_b.Size.Y/2,0))
local dbb=__a.projection_Box(bbb.CFrame,bbb.Size,cbb.p)local _cb=false
if
not _cb and __a.boxcast_singleTarget(cbb,c_b.Size,dbb)then _cb=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ada,dbb,"monster","cry")end end;d_b=c_b.CFrame.p;wait(.05)end end)end end
if#cda==0 then
spawn(function()wait(math.random()/2)
local a_b=script.tear:Clone()
local b_b=workspace.TotemBoss.cryTotem.Position+Vector3.new(math.random(-20,20),25,math.random(
-20,20))a_b.Position=b_b;a_b.Parent=bba
c_a(a_b,{"Position"},{Vector3.new(b_b.X,ada.Position.Y-30,b_b.Z)},1,Enum.EasingStyle.Linear)cba:AddItem(a_b,2)local c_b=a_b.CFrame.p;local d_b=false;local _ab=tick()
while
tick()<_ab+1 do local aab=(a_b.CFrame.p-c_b).magnitude
local bab=Ray.new(c_b,(
a_b.CFrame.p-c_b).unit*aab)
local cab,dab=workspace:FindPartOnRayWithIgnoreList(bab,dda)
if cab and not d_b then d_b=true;a_b.Transparency=1
local _bb=script.drip:Clone()_bb.Position=dab;_bb.Parent=bba
_bb.ParticleEmitter:emit(40)cba:AddItem(_bb,3)dd.playSound("splash",dab)
local abb=aca.Character.PrimaryPart
local bbb=CFrame.new(dab-Vector3.new(0,a_b.Size.Y/2,0))
local cbb=__a.projection_Box(abb.CFrame,abb.Size,bbb.p)local dbb=false
if
not dbb and __a.boxcast_singleTarget(bbb,a_b.Size,cbb)then dbb=true
a_a:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",ada,cbb,"monster","cry")end end;c_b=a_b.CFrame.p;wait(.05)end end)end;wait(.5)end;wait(1)
c_a(workspace.TotemBoss.cryEyes,{"Color"},{Color3.fromRGB(0,0,0)},2)end,step=function(aca,bca)return
"micro-sleeping"end},["micro-sleeping"]={animationEquivalent="idling",transitionLevel=7,lockTimeForLowerTransition=0.2,step=function(aca,bca)return
"attack-ready"end},["attacked-by-player"]={transitionLevel=1,step=function(aca)
if
aca.closestEntity and(aca.targetEntityLockType or 0)<=1 and
aca.entityMonsterWasAttackedBy then
local bca=dd.magnitude(
aca.entityMonsterWasAttackedBy.Position-aca.manifest.Position)
if aca:isTargetEntityInLineOfSight(nil,false,aca.entityMonsterWasAttackedBy)then end end;return"idling"end}}}