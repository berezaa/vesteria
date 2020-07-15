
local d_a={cost=2,upgradeCost=2,maxRank=8,requirement=function(bab)return true end,variants={rockThrow={default=true,cost=0,requirement=function(bab)return true end},magicMissile={cost=1,requirement=function(bab)return
bab.nonSerializeData.statistics_final.int>=10 end},leechSeed={cost=1,requirement=function(bab)return
bab.nonSerializeData.statistics_final.vit>=10 end}}}local _aa=game:GetService("Debris")
local aaa=game:GetService("RunService")local baa=game:GetService("HttpService")
local caa=game:GetService("ReplicatedStorage")local daa=caa:WaitForChild("abilityAnimations")
local _ba=require(caa:WaitForChild("modules"))local aba=_ba.load("projectile")
local bba=_ba.load("placeSetup")local cba=_ba.load("client_utilities")
local dba=_ba.load("network")local _ca=_ba.load("damage")local aca=_ba.load("tween")
local bca=_ba.load("ability_utilities")local cca=_ba.load("effects")local dca=_ba.load("detection")
local _da=bba.awaitPlaceFolder("entities")local ada=bba.getPlaceFolder("spawnRegionCollections")
local bda=bba.getPlaceFolder("entityManifestCollection")local cda=bba.getPlaceFolder("entityRenderCollection")
local dda=bba.getPlaceFolder("items")local __b=bba.getPlaceFolder("foilage")
local a_b={ada,bda,cda,dda,_da,__b}local b_b=34;local c_b={id=b_b,metadata=d_a}
local d_b={id=b_b,metadata=d_a,manaCost=15,name="Rock Throw",image="rbxassetid://2528902271",description="Throw a rock at an enemy.",damageType="physical",castingAnimation=daa.rock_throw_upper_loop,animationName={"rock_throw_upper","rock_throw_lower"},windupTime=0.2,cooldown=2,projectileSpeed=45,statistics={[1]={damageMultiplier=1.5,manaCost=3,cooldown=5},[2]={damageMultiplier=1.8,manaCost=4},[3]={damageMultiplier=2.1,manaCost=5},[4]={damageMultiplier=2.4,manaCost=6},[5]={damageMultiplier=3.0,manaCost=8,tier=3},[6]={damageMultiplier=3.6,manaCost=10},[7]={damageMultiplier=4.2,manaCost=12},[8]={damageMultiplier=5,manaCost=15,tier=4}},securityData={maxHitLockout=1,projectileOrigin="character"},targetingData={targetingType="projectile",projectileSpeed="projectileSpeed",projectileGravity=1,onStarted=function(bab,cab)
local dab=bab.entity.AnimationController:LoadAnimation(daa.rock_throw_upper_loop)dab:Play()local _bb=caa.rockToThrow:Clone()
_bb.Trail:Destroy()_bb.Anchored=false;_bb.Parent=_da;local abb=Instance.new("Weld")
abb.Part1=bab.entity.RightHand;abb.Part0=_bb;abb.C0=CFrame.new(0,0.25,0)abb.Parent=_bb
local bbb=dba:invoke("{B3E10A46-3111-43EB-844A-FCB82CEFDE54}",bab.entity)return{track=dab,showWeapons=bbb,rock=_bb}end,onEnded=function(bab,cab,dab)
dab.track:Stop()
delay(0.4,function()dab.rock:Destroy()dab.showWeapons()end)end},_serverProcessDamageRequest=function(bab,cab)if
bab=="rock-hit"then return cab,"physical","projectile"end end,execute=function(bab,cab,dab,_bb,abb)if
not cab:FindFirstChild("entity")then return end
for bcb,ccb in
pairs(bab.animationName)do
local dcb=cab.entity.AnimationController:LoadAnimation(daa[ccb])dcb:Play()
if cab.PrimaryPart then local _db=script.sound:Clone()
_db.Parent=cab.PrimaryPart;_db:Play()game.Debris:AddItem(_db,5)end end;wait(bab.windupTime)if not cab:FindFirstChild("entity")then
return end
local bbb=game.ReplicatedStorage.rockToThrow:Clone()bbb.Parent=bba.getPlaceFolder("entities")
local cbb=cab.entity["RightHand"].Position
local dbb,_cb=aba.getUnitVelocityToImpact_predictive(cbb,bab.projectileSpeed,dab["mouse-target-position"],Vector3.new())
local acb=1 + (
dab["ability-statistics"]["damageMultiplier"]/1.5 -1)*2;bbb.Size=bbb.Size*acb
aba.createProjectile(cbb,dbb or
(dab["mouse-target-position"]-cbb).Unit,bab.projectileSpeed,bbb,function(bcb,ccb)game:GetService("Debris"):AddItem(bbb,
2 /30)
if _bb then
if bcb then
local dcb,_db=_ca.canPlayerDamageTarget(game.Players.LocalPlayer,bcb)if dcb and _db then
dba:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_db,ccb,"ability",bab.id,"rock-hit",abb)end end end end,
nil,{cab.clientHitboxToServerHitboxReference.Value})end}
local _ab={id=b_b,metadata=d_a,name="Magic Missile",image="rbxassetid://3736638029",description="Call upon your innate magic ability to send out a homing energy missile.",statistics={[1]={cooldown=1,manaCost=10,bolts=1,damageMultiplier=1.2},[2]={damageMultiplier=1.3,manaCost=14},[3]={damageMultiplier=1.3,bolts=2,manaCost=28},[4]={damageMultiplier=1.4,manaCost=36},[5]={damageMultiplier=1.4,bolts=3,manaCost=54,tier=3},[6]={damageMultiplier=1.5,manaCost=66},[7]={damageMultiplier=1.5,bolts=4,manaCost=88},[8]={damageMultiplier=1.6,bolts=5,manaCost=130,tier=4}},windupTime=0.35,securityData={playerHitMaxPerTag=10,isDamageContained=true,projectileOrigin="character"},targetingData={targetingType="directSphere",radius=3,range=128,onStarted=function(bab,cab)
local dab=bab.entity.AnimationController:LoadAnimation(daa.rock_throw_upper_loop)dab:Play()return{track=dab}end,onEnded=function(bab,cab,dab)
dab.track:Stop()end},_serverProcessDamageRequest=function(bab,cab)if
bab=="strike"then return cab,"magical","aoe"elseif bab=="twilight"then
return cab*1.25,"magical","aoe"end end,execute_server=function(bab,cab,dab,_bb,abb)
dba:fireAllClientsExcludingPlayer("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",cab,dab,bab.id,abb)end,_abilityExecutionDataCallback=function(bab,cab)
cab["twilight"]=
bab and
bab.nonSerializeData.statistics_final.activePerks["twilight"]end,execute=function(bab,cab,dab,_bb,abb)local bbb=cab.PrimaryPart;if not
bbb then return end;local cbb=cab:FindFirstChild("entity")
if not cbb then return end;local dbb=cbb:FindFirstChild("RightHand")if not dbb then return end
local _cb=cab.entity.AnimationController:LoadAnimation(daa["rock_throw_upper"])_cb:Play()wait(bab.windupTime)for b_c,c_c in
pairs{script.throw,script.magic}do local d_c=c_c:Clone()d_c.Parent=bbb;d_c:Play()
_aa:AddItem(d_c,d_c.TimeLength)end
local acb=dab["ability-statistics"]["bolts"]local bcb="normal"if dab["twilight"]then acb=acb+4;bcb="star"end
local ccb=dbb.Position
local dcb=CFrame.new(bbb.Position,dab["mouse-world-position"])dcb=dcb+ (ccb-dcb.Position)
local _db,adb,bdb,cdb,ddb,__c=acb,dcb,game.Players.LocalPlayer,abb,true,bcb
local function a_c(b_c,c_c,d_c,_ac,aac)local bac=50;local cac=3 ^2;local dac=24 ^2;local _bc=0.2;local abc=script.missile;if aac=="star"then
abc=script.star;bac=bac*1.5 end;local bbc=abc:Clone()bbc.CFrame=b_c*
bbc.alignAttachment.CFrame:Inverse()local cbc=bbc.mover
local dbc=bbc.orientationAttachment;local _cc=bbc.trail;dbc.CFrame=b_c;dbc.Parent=workspace.Terrain
bbc.Parent=_da
local acc={speed=12,missile=bbc,target=nil,startTime=tick(),driftCFrame=CFrame.Angles(math.pi*2 *math.random(),0,math.pi*2 *
math.random())}local bcc
local function ccc(bdc)bcc:Disconnect()dbc:Destroy()bbc.Anchored=true
bbc.Transparency=1;_cc.Enabled=false
game.Debris:AddItem(bbc,_cc.Lifetime)
if bdc and _ac then local cdc="strike"if aac=="star"then cdc="twilight"end
dba:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",acc.target,acc.target.Position,"ability",b_b,cdc,d_c)end end
local function dcc()local bdc=acc.missile;local cdc=bdc.Position
local ddc=bdc.CFrame.LookVector/2;local __d=Ray.new(cdc,ddc)
local a_d=workspace:FindPartOnRayWithIgnoreList(__d,a_b,false,true)return a_d~=nil and a_d.CanCollide end
local function _dc()local bdc=_ca.getDamagableTargets(c_c)
local cdc=acc.missile.Position;local ddc=nil;local __d=dac
for a_d,b_d in pairs(bdc)do
local c_d=dca.projection_Box(b_d.CFrame,b_d.Size,cdc)local d_d=c_d-cdc
local _ad=d_d.X*d_d.X+d_d.Y*d_d.Y+d_d.Z*d_d.Z;if(_ad<=__d)then ddc=b_d;__d=_ad end end;acc.target=ddc end
local function adc(bdc)cbc.Velocity=
(bbc.CFrame*bbc.alignAttachment.CFrame).LookVector*acc.speed
if
acc.target then
local cdc=CFrame.new(bbc.Position,acc.target.Position)dbc.CFrame=cdc
local ddc=acc.target.Position-bbc.Position
local __d=ddc.X*ddc.X+ddc.Y*ddc.Y+ddc.Z*ddc.Z;local a_d=acc.target.Size/2;local b_d=a_d.X*a_d.X+a_d.Y*a_d.Y+
a_d.Z*a_d.Z;if
__d<=math.max(cac,b_d)then ccc(true)end else local cdc=tick()
local ddc=cdc-acc.startTime;if ddc>=_bc then acc.speed=bac;_dc()else
cbc.Velocity=acc.driftCFrame.LookVector*acc.speed end end;if dcc()then ccc(false)end end;adc()bcc=aaa.Heartbeat:Connect(adc)
delay(1.4,function()ccc(false)end)return acc end
for boltNumber=1,_db do a_c(adb,bdb,cdb,ddb,__c)if __c=="normal"then wait(0.1)elseif __c=="star"then
wait(0.05)end end end}
local aab={id=b_b,metadata=d_a,name="Leech Seed",image="rbxassetid://4834447253",description="Hurl a dark bolt which steals health from its victim.",maxRank=8,statistics={[1]={cooldown=2,manaCost=15,damageMultiplier=1.6,healing=30,tier=1},[2]={manaCost=19,damageMultiplier=1.8,healing=50,tier=2},[3]={manaCost=23,damageMultiplier=2.0,healing=70},[4]={manaCost=27,damageMultiplier=2.2,healing=90},[5]={manaCost=35,damageMultiplier=2.6,healing=130,tier=3},[6]={manaCost=43,damageMultiplier=3.0,healing=170},[7]={manaCost=51,damageMultiplier=3.4,healing=210},[8]={manaCost=64,damageMultiplier=4.0,healing=300,tier=4}},windupTime=0.55,securityData={playerHitMaxPerTag=4,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true,targetingData={targetingType="projectile",projectileSpeed=50,projectileGravity=0.0001,onStarted=function(bab,cab)
local dab=bab.entity.AnimationController:LoadAnimation(daa.left_hand_targeting_sequence)dab:Play()local _bb=bab.entity.LeftHand
return{track=dab,projectionPart=_bb}end,onEnded=function(bab,cab,dab)
dab.track:Stop()end},_serverProcessDamageRequest=function(bab,cab)if
bab=="bolt"then return cab,"magical","projectile"end end,execute_server=function(bab,cab,dab,_bb)if
not _bb then return end;local abb=1
local bbb=Instance.new("RemoteEvent")bbb.Name="PillageVitalityTemporarySecureRemote"
bbb.OnServerEvent:Connect(function(cbb,dbb)
if
cbb.Character and cbb.Character.PrimaryPart then
local _cb=dbb["ability-statistics"]["healing"]
cbb.Character.PrimaryPart.health.Value=math.min(
cbb.Character.PrimaryPart.health.Value+_cb,cbb.Character.PrimaryPart.maxHealth.Value)end;abb=abb-1;if abb<=0 then bbb:Destroy()end end)bbb.Parent=game.ReplicatedStorage;_aa:AddItem(bbb,30)return bbb end,execute=function(bab,cab,dab,_bb,abb)
local bbb=cab.PrimaryPart;if not bbb then return end;local cbb=cab:FindFirstChild("entity")if not cbb then
return end;local dbb=cbb:FindFirstChild("LeftHand")
if not dbb then return end;local _cb=cbb:FindFirstChild("UpperTorso")if not _cb then return end
local acb=
dab["target-position"]or dab["mouse-world-position"]local bcb=bca.getCastingPlayer(dab)
local ccb=dab["ability-statistics"].tier
local function dcb()if not _bb then return end
local _db=dba:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",b_b,dab)_db["ability-state"]="update"_db["ability-guid"]=abb
dba:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_b,"update",_db,abb)end
if dab["ability-state"]=="begin"then
local _db=cab.entity.AnimationController:LoadAnimation(daa["mage_cast_left_hand_top"])_db:Play()local adb=Instance.new("Attachment")
adb.Name="PillageVitalityEmitterAttachment"adb.Parent=dbb;local bdb=script.darkEmitter:Clone()
bdb.Parent=adb;local cdb=script.charge:Clone()cdb.Parent=dbb
cdb:Play()
delay(bab.windupTime-bdb.Lifetime.Max,function()bdb.Enabled=false end)wait(bab.windupTime)cdb:Stop()cdb:Destroy()dcb()elseif
dab["ability-state"]=="update"then local _db=script.cast:Clone()
_db.Parent=dbb;_db:Play()_aa:AddItem(_db,_db.TimeLength)
local function adb(bdb)local cdb;if _bb then
cdb=dba:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",dab,bab.id)end
local ddb=script.bolt:Clone()ddb.Size=ddb.Size* (0.7 +ccb)/2;ddb.Parent=_da
local __c=aba.makeIgnoreList{cab,cab.clientHitboxToServerHitboxReference.Value}
local function a_c(aac,bac,cac)local dac=1;local _bc=16;local abc=script.blood:Clone()local bbc=abc.trail
abc.CFrame=aac.CFrame;abc.Parent=_da
local cbc=CFrame.Angles(0,0,cac)*CFrame.new(0,_bc,0)
local dbc=CFrame.Angles(0,0,-cac)*CFrame.new(0,_bc,0)
cca.onHeartbeatFor(dac,function(_cc,acc,bcc)
local ccc=CFrame.new(aac.Position,bac.Position)local dcc=CFrame.new(bac.Position,aac.Position)
local _dc=ccc.Position;local adc=(ccc*cbc).Position;local bdc=(dcc*dbc).Position
local cdc=dcc.Position;local ddc=_dc+ (adc-_dc)*bcc
local __d=bdc+ (cdc-bdc)*bcc;local a_d=ddc+ (__d-ddc)*bcc
abc.CFrame=CFrame.new(a_d)end)
delay(dac,function()abc.Transparency=1;bbc.Enabled=false
_aa:AddItem(abc,bbc.Lifetime)end)end
local function b_c(aac)
for blood=1,ccb do local bac=(blood-2)* (math.pi/3)a_c(aac,_cb,bac)end
delay(1,function()local bac=script.restore:Clone()bac.Parent=bbb
bac:Play()_aa:AddItem(bac,bac.TimeLength)local cac=1
local dac=Instance.new("Part")dac.Anchored=true;dac.CanCollide=false
dac.TopSurface=Enum.SurfaceType.Smooth;dac.BottomSurface=Enum.SurfaceType.Smooth;local _bc=dac
_bc.Shape=Enum.PartType.Ball;_bc.Color=script.blood.Color
_bc.Material=Enum.Material.Neon;_bc.Size=Vector3.new()
_bc.CFrame=CFrame.new(_cb.Position)_bc.Parent=_da
aca(_bc,{"Size","Transparency"},{
Vector3.new(6,6,6)* (1 +ccb)/2,1},cac)
cca.onHeartbeatFor(cac,function()_bc.CFrame=CFrame.new(_cb.Position)end)_aa:AddItem(_bc,cac)
if _bb then cdb:FireServer(dab)end end)end;local c_c=50;local d_c=dab["mouse-target-position"]
local _ac=(d_c-bdb).Unit
aba.createProjectile(bdb,_ac,c_c,ddb,function(aac)ddb.Transparency=1
ddb.emitterAttachment.emitter.Enabled=false
_aa:AddItem(ddb,ddb.emitterAttachment.emitter.Lifetime.Max)local bac,cac=_ca.canPlayerDamageTarget(bcb,aac)
if bac then
local dac=script.hit:Clone()dac.Parent=cac;dac:Play()
_aa:AddItem(dac,dac.TimeLength)b_c(cac)if _bb then
dba:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",cac,ddb.Position,"ability",bab.id,"bolt",abb)end end end,function(aac)return CFrame.Angles(0,math.pi,
math.pi*2 *aac)end,__c,true,0)end;adb(dbb.Position)
if _bb then
if dab["times-updated"]<1 then dcb()else
dba:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
dba:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_b,"end")end end end end}
function generateAbilityData(bab,cab)cab=cab or{}if bab then local dab;for _bb,abb in pairs(bab.abilities)do if abb.id==b_b then
dab=abb.variant end end
cab.variant=dab or"rockThrow"end
if cab.variant==
"rockThrow"then return d_b elseif cab.variant=="magicMissile"then return _ab elseif
cab.variant=="leechSeed"then return aab end;return c_b end;return generateAbilityData