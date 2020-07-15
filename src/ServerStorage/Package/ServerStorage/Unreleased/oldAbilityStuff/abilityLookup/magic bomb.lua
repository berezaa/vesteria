
local ac=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("projectile")local dc=bc.load("placeSetup")
local _d=bc.load("client_utilities")local ad=bc.load("network")local bd=bc.load("damage")
local cd=bc.load("tween")local dd=bc.load("detection")local __a=bc.load("utilities")
local a_a=game:GetService("HttpService")local b_a;local c_a=4
local d_a={cost=2,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(aaa)return aaa.class=="Mage"end,variants={manaBomb={default=true,cost=0,requirement=function(aaa)return true end},sonicBomb={cost=1,requirement=function(aaa)return
aaa.nonSerializeData.statistics_final.str>=30 end},multiBomb={cost=1,requirement=function(aaa)return
aaa.nonSerializeData.statistics_final.dex>=30 end}}}
local function _aa(aaa,baa)baa=baa or{}if aaa then local daa;for _ba,aba in pairs(aaa.abilities)do
if aba.id==c_a then daa=aba.variant end end
baa.variant=daa or"rockThrow"end
local caa=__a.copyTable(b_a)
if baa.variant=="sonicBomb"then caa.name="Sonic Bomb"
caa.image="rbxassetid://4730231087"
caa.description="Channel STR to launch a mana torpedo with faster speed and lower cooldown."caa.projectileGravityMultipler=0.025;baa.bombColor={255,158,119}
for daa,_ba in
pairs(caa.statistics)do
if daa>=7 then _ba.piercing=4;_ba.speed=2.25;_ba.manaCost=_ba.manaCost+9 elseif
daa>=5 then _ba.piercing=3;_ba.speed=2;_ba.manaCost=_ba.manaCost+6 elseif daa>=3 then
_ba.piercing=2;_ba.speed=1.75;_ba.manaCost=_ba.manaCost+3 else _ba.speed=1.5
_ba.piercing=1 end;if _ba.cooldown then _ba.cooldown=_ba.cooldown-2 end end elseif baa.variant=="multiBomb"then caa.name="Multi Bomb"
caa.image="rbxassetid://4730231321"
caa.description="Spread out your mana with DEX to fire multiple bombs at a higher cost."caa.maxUpdateTimes=7;caa.projectileGravityMultipler=0.075
baa.bombColor={193,130,255}
for daa,_ba in pairs(caa.statistics)do
if daa>=7 then _ba.bolts=5
_ba.manaCost=_ba.manaCost+60 elseif daa>=5 then _ba.bolts=4;_ba.manaCost=_ba.manaCost+45 elseif daa>=3 then _ba.bolts=3;_ba.manaCost=
_ba.manaCost+30 else _ba.bolts=2;_ba.manaCost=_ba.manaCost+15 end;_ba.radius=12 end else caa.name="Mana Bomb"caa.image="rbxassetid://4730231375"
caa.description="Unleash the purest form of mana upon your foes."
for daa,_ba in pairs(caa.statistics)do
if daa>=7 then _ba.radius=_ba.radius+16
_ba.manaCost=_ba.manaCost+8 elseif daa>=5 then _ba.radius=_ba.radius+12;_ba.manaCost=_ba.manaCost+6 elseif daa>=
3 then _ba.radius=_ba.radius+8;_ba.manaCost=_ba.manaCost+4 else _ba.radius=
_ba.radius+4;_ba.manaCost=_ba.manaCost+2 end
if daa>=8 then _ba.damageMultiplier=_ba.damageMultiplier+0.2;_ba.manaCost=
_ba.manaCost+12 elseif daa>=6 then
_ba.damageMultiplier=_ba.damageMultiplier+0.15;_ba.manaCost=_ba.manaCost+9 elseif daa>=4 then
_ba.damageMultiplier=_ba.damageMultiplier+0.1;_ba.manaCost=_ba.manaCost+6 elseif daa>=2 then
_ba.damageMultiplier=_ba.damageMultiplier+0.05;_ba.manaCost=_ba.manaCost+3 end end end;return caa end
b_a={id=c_a,book="mage",metadata=d_a,name="Mana Bomb",image="rbxassetid://4730231375",description="Unleash the purest form of mana upon your foes.",description_key="abilityDescription_magic_bomb",mastery="Bigger explosion.",layoutOrder=1,damageType="magical",animationName={"rock_throw_upper","rock_throw_lower"},windupTime=0.36,maxRank=10,maxUpdateTimes=3,cooldown=6,projectileSpeed=40,projectileGravityMultipler=0.05,layoutOrder=1,statistics={[1]={damageMultiplier=3,radius=15,cooldown=6,manaCost=23,range=160},[2]={damageMultiplier=3.05,radius=17,manaCost=26},[3]={damageMultiplier=3.1,radius=17,manaCost=28},[4]={damageMultiplier=3.15,radius=17,manaCost=30},[5]={damageMultiplier=3.2,radius=19,manaCost=33},[6]={damageMultiplier=3.25,radius=19,manaCost=35},[7]={damageMultiplier=3.3,radius=19,manaCost=37},[8]={damageMultiplier=3.35,radius=21,manaCost=40},[9]={damageMultiplier=3.4,radius=21,manaCost=42},[10]={damageMultiplier=3.45,radius=21,manaCost=44}},securityData={playerHitMaxPerTag=
nil,maxHitLockout=nil,isDamageContained=true,projectileOrigin="character"},targetingData={targetingType="directSphere",radius=function(aaa)return
aaa["ability-statistics"]["radius"]/2 end,range="range",onStarted=function(aaa,baa)
local caa=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)["1"].manifest.magic
local daa=script.magicBombEntity.t1:Clone()daa.Lifetime=NumberRange.new(0.5)daa.Parent=caa
local _ba=Instance.new("PointLight")
_ba.Color=BrickColor.new("Electric blue").Color;_ba.Parent=caa
if baa["holymagic"]then
daa.Color=ColorSequence.new(BrickColor.new("Daisy orange").Color,BrickColor.new("White").Color)
_ba.Color=BrickColor.new("Daisy orange").Color end;return{emitter=daa,light=_ba,projectionPart=caa}end,onEnded=function(aaa,baa,caa)
caa.emitter.Enabled=false
game:GetService("Debris"):AddItem(caa.emitter,caa.emitter.Lifetime.Max)caa.light:Destroy()end},equipmentTypeNeeded="staff",disableAutoaim=true,abilityDecidesEnd=true}
function b_a._doEnhanceAbility(aaa)return not
not aaa.nonSerializeData.statistics_final.VENOM_BOMB end
function b_a._abilityExecutionDataCallback(aaa,baa)local caa=aaa and
aaa.nonSerializeData.statistics_final.activePerks["holymagic"]
baa["holymagic"]=caa end
function b_a._serverProcessDamageRequest(aaa,baa,caa,daa,_ba)
local aba=ad:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ba)local bba=1
if aba and
aba.nonSerializeData.statistics_final.activePerks["holymagic"]then bba=bba*1.1 end;baa=baa*bba
if

aaa=="explosion1"or aaa=="explosion2"or
aaa=="explosion3"or aaa=="explosion4"or aaa=="explosion5"or
aaa=="explosion6"or aaa=="explosion7"then return baa,"magical","aoe"elseif aaa=="impact"then return baa,"magical","projectile"elseif
aaa=="venom-puddle"then return baa*0.1,"magical","dot"end end
function b_a:onCastingBegan__client(aaa)
if
not aaa or not aaa:FindFirstChild("entity")or
not aaa.entity:FindFirstChild("AnimationController")then return end
local baa=aaa.entity.AnimationController:LoadAnimation(self.castingAnimation)baa:Play()return aaa.entity["RightHand"]end
function b_a:onCastingEnded__client(aaa)
if
not aaa or not aaa:FindFirstChild("entity")or
not aaa.entity:FindFirstChild("AnimationController")then return end;for baa,caa in
pairs(aaa.entity.AnimationController:GetPlayingAnimationTracks())do
if caa.Animation==self.castingAnimation then caa:Stop()end end end
function b_a:execute(aaa,baa,caa,daa)
if not aaa:FindFirstChild("entity")then return end;local _ba=baa["mouse-inrange"]warn("$",_ba)if not _ba then return end;if not
aaa:FindFirstChild("clientHitboxToServerHitboxReference")then return end
local aba=aaa.clientHitboxToServerHitboxReference.Value;if not aba then return end
local bba=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local cba=bba["1"]and bba["1"].manifest;if not cba or not
cba:FindFirstChild("magic")then return end
if
baa["ability-state"]=="end"then if caa then
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end
cba.magic.castEffect.Enabled=false elseif baa["ability-state"]=="begin"then if caa then
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end
cba.magic.castEffect.Enabled=true end;local dba=baa["bombColor"]or{85,253,255}
local _ca=Color3.fromRGB(unpack(dba))
if baa["holymagic"]then _ca=Color3.fromRGB(255,234,110)end;if baa.IS_ENHANCED then
_ca=Color3.new(math.max(_ca.r*0.3,1),_ca.g*0.1,math.max(_ca.b*0.7,1))end;local aca=
baa["ability-statistics"]["bolts"]or 1
local function bca()if not cba then return end
local cca=cba:FindFirstChild("magic")if not cca then return end
if not aaa:FindFirstChild("entity")then return end;local dca=script.magicBombEntity:Clone()
if _ca then
dca.Color=_ca
for bbb,cbb in pairs(dca:GetChildren())do if cbb:IsA("ParticleEmitter")then local dbb=Color3.new(_ca.r*0.5,
_ca.g*0.4,_ca.b*0.5)
cbb.Color=ColorSequence.new(_ca,dbb)end end end
local _da=ad:invoke("{037FE164-CCF7-41A0-87B1-D384E9A16236}")local ada=cca.WorldPosition
local bda=baa["ability-statistics"]["speed"]or 1
local cda=cc.getUnitVelocityToImpact_predictive(ada,self.projectileSpeed*bda,_ba,Vector3.new(),self.projectileGravityMultipler)
local function dda(bbb)
local cbb=script:FindFirstChild("ring"):Clone()cbb.Color=_ca
local dbb=CFrame.new(dca.Position,dca.Position+cda)
cbb.CFrame=dbb:ToWorldSpace(CFrame.Angles(math.rad(90),0,0))cbb.Parent=workspace.CurrentCamera
cd(cbb,{"Size"},{Vector3.new(4,0.5,4)*bbb},
bbb^ (1 /2),Enum.EasingStyle.Quint)
cd(cbb,{"Transparency"},{1},bbb^ (1 /2),Enum.EasingStyle.Linear)
game:GetService("Debris"):AddItem(cbb,bbb*1.15)end;if not cda then return false end
local __b=dc.getPlaceFolder("entities")dca.Parent=__b;local a_b=
(baa["ability-statistics"]["piercing"]or 0)+1;local b_b=a_b;local c_b=0
local d_b=dc.awaitPlaceFolder("entityRenderCollection")local _ab=baa["ability-statistics"]["radius"]if
baa["holymagic"]then _ab=_ab*1.2 end
dca.t1.Rate=(_ab/15)^ (1 /2)*30
dca.t1.Size=NumberSequence.new(0.312 * (_ab/15),0)dca.t1.Enabled=true
local aab=baa["ability-statistics"]["tier"]or 1
local bab=dc.awaitPlaceFolder("entityManifestCollection")local cab={aaa,aba,__b,bab}local dab
local _bb=script.fireLoop:Clone()_bb.Parent=dca;_bb:Play()dca.CFrame=CFrame.new(ada)if bda>1 then dda(bda^
1.5)end;local abb=0.25
cc.createProjectile(ada,cda,self.projectileSpeed*bda,dca,function(bbb,cbb,dbb,_cb,acb)if
bbb then
for ccb,dcb in pairs(cab)do if bbb:IsDescendantOf(dcb)then return true end end end;c_b=c_b+1;local bcb=
(_ab/ (c_b^ (1 /2)))* (1 +acb*abb)
do local ccb=dca:Clone()
ccb.Size=Vector3.new(1,1,1)ccb.CFrame=CFrame.new(cbb)ccb.Anchored=true;ccb.Parent=__b
local dcb=script.magicBombRing:Clone()dcb.Parent=ccb;local _db=script.magicBombRing:Clone()
_db.Parent=ccb;local adb=script.magicBombRing:Clone()adb.Parent=ccb
if
_ca then local dac=Color3.new(_ca.r/4,_ca.g/3,_ca.b/2)
dcb.Color=dac;_db.Color=dac;adb.Color=dac end
local bdb=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*math.random())
local cdb=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*math.random())
local ddb=CFrame.Angles(2 *math.pi*math.random(),0,2 *math.pi*math.random())
local __c=((ccb.Mesh.Scale*0.2 *bcb/10))+Vector3.new(5,5,5)local a_c=script.boom:Clone()a_c.Parent=ccb;a_c.Volume=math.clamp(
__c.magnitude/3,0.2,0.6)a_c.MaxDistance=a_c.MaxDistance*
a_c.Volume
a_c.EmitterSize=a_c.EmitterSize*a_c.Volume;if not caa then a_c.Volume=a_c.Volume*0.5 end
a_c:Play()local b_c=math.clamp(__c.magnitude/2,0.3,1)
delay(0.05 *b_c,function()
ccb.explosionParticles.Drag=(
1.7 * (__c.X*8 -0 -160 *1.5))/ (1.5 *1.5)ccb.explosionParticles:Emit(60)end)local c_c=0;local d_c=Vector3.new(bcb,bcb,bcb)
ccb.Mesh.Scale=Vector3.new(1,1,1)dcb.Size=d_c*Vector3.new(0.5,0.1,0.5)
dcb.CFrame=
ccb.CFrame*bdb*CFrame.Angles(0,0,math.pi* (c_c^0.5))_db.Size=d_c*Vector3.new(0.5,0.1,0.5)
_db.CFrame=
ccb.CFrame*cdb*CFrame.Angles(0,0,math.pi* (c_c^0.5))adb.Size=d_c*Vector3.new(0.5,0.1,0.5)
adb.CFrame=
ccb.CFrame*ddb*CFrame.Angles(0,0,math.pi* (c_c^0.5))ccb.Transparency=0;dcb.Transparency=0.4;_db.Transparency=0.4
adb.Transparency=0.4
local _ac=2 *Vector3.new(bcb,bcb,bcb)* (1 /3)
for dac,_bc in pairs(ccb:GetChildren())do if _bc:IsA("ParticleEmitter")then
_bc.Enabled=false end end;local aac=1 *b_c
cd(dcb,{"Size","CFrame","Transparency"},{_ac*
Vector3.new(1.75,0.35,1.75),ccb.CFrame*bdb*CFrame.Angles(0,0,math.pi),1},
1.5 *aac,Enum.EasingStyle.Quint)
cd(_db,{"Size","CFrame","Transparency"},{_ac*Vector3.new(2,0.4,2),ccb.CFrame*
cdb*CFrame.Angles(0,0,math.pi),1},
1.5 *aac,Enum.EasingStyle.Quint)
cd(adb,{"Size","CFrame","Transparency"},{_ac*Vector3.new(1.75,0.35,1.75),
ccb.CFrame*ddb*CFrame.Angles(0,0,math.pi),1},
1.5 *aac,Enum.EasingStyle.Quint)local bac=ccb.spread;bac.Parent=ccb;local cac=(_ac.X+_ac.Z)/2;bac.Size=NumberSequence.new(
cac/10,0.1)
bac.Speed=NumberRange.new(cac*0.7,cac*0.9)bac:Emit(50)
if cbb and caa then
for dac,_bc in
pairs(bd.getDamagableTargets(game.Players.LocalPlayer))do
local abc=(_bc.Size.X+_bc.Size.Y+_bc.Size.Z)/3
if
(_bc.Position-cbb).magnitude<=_ac.X/2 +abc/2.5 then
spawn(function()wait(0.1)
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_bc,cbb,"ability",self.id,"explosion"..tostring(c_b),daa)end)end end end
cd(ccb,{"Transparency"},{1},aac,Enum.EasingStyle.Linear)
cd(ccb.Mesh,{"Scale"},{_ac*1.25},aac,Enum.EasingStyle.Quint)
game:GetService("Debris"):AddItem(ccb,3 *b_c)
spawn(function()wait(0.5 *b_c)wait(1 *b_c)dcb.Transparency=1
_db.Transparency=1;adb.Transparency=1 end)end
if bbb and c_b<b_b then
if bbb:IsDescendantOf(d_b)then local ccb
for dcb,_db in
pairs(d_b:GetChildren())do if bbb:IsDescendantOf(_db)then ccb=_db;break end end
if ccb then table.insert(cab,ccb)
if

ccb:FindFirstChild("clientHitboxToServerHitboxReference")and ccb.clientHitboxToServerHitboxReference.Value then
table.insert(cab,ccb.clientHitboxToServerHitboxReference.Value)end;dda(1 +b_b-c_b)return true end end end;dca:Destroy()
if
baa.IS_ENHANCED and
math.acos(dbb:Dot(Vector3.new(0,1,0)))<=math.rad(50)then local ccb=script.venomPuddle:Clone()
ccb.Parent=workspace.CurrentCamera
ccb.CFrame=CFrame.new(cbb)*CFrame.Angles(0,0,math.rad(90))ccb.Bubbles:Play()
ccb.Size=Vector3.new(ccb.Size.X,bcb*0.8,bcb*0.8)
if caa then
spawn(function()
while ccb.Parent==workspace.CurrentCamera do
for dcb,_db in
pairs(bd.getDamagableTargets(game.Players.LocalPlayer))do local adb=ccb.CFrame+Vector3.new(0,3,0)
local bdb=dd.projection_Box(_db.CFrame,_db.Size,adb.p)
if
dd.boxcast_singleTarget(adb,ccb.Size+Vector3.new(1,0,0),bdb)then local cdb=(cbb+_db.Position)/2
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_db,cdb,"ability",self.id,"venom-puddle",daa)end end;wait(0.33)end end)end;wait(7)ccb.Fire.Enabled=false
cd(ccb,{"Transparency"},1,1)game.Debris:AddItem(ccb,1)end end,function(bbb)
dca.Size=
Vector3.new(1,1,1)* (1 +bbb*abb)* (_ab/15)end,cab,nil,self.projectileGravityMultipler)end
if
baa["ability-state"]=="begin"or baa["ability-state"]=="update"then
if baa["ability-state"]=="begin"then
local cca=aaa.entity.AnimationController:LoadAnimation(ac.mage_zapbomb)cca.Looped=true;cca:AdjustSpeed(0.8)
spawn(function()
wait(
0.1 +self.windupTime/2.2 + (aca-1)* (0.1 +self.windupTime/2.8))cca:Stop(0.5)end)cca:Play()wait(self.windupTime/2.2)else
local cca=script.cast:Clone()cca.Parent=cba;cca:Play()
local dca=script.sparks:Clone()dca.Anchored=true;dca.CanCollide=false;dca.Transparency=1
dca.CFrame=CFrame.new(cba.magic.WorldPosition)dca.Parent=workspace.CurrentCamera;if _ca then dca.Color=_ca
dca.Fire.Color=ColorSequence.new(_ca)end;dca.Fire:Emit(15)
local _da=script.zippity:Clone()_da.Parent=dca;_da:Play()local ada=cba.magic.WorldPosition;bca()wait(
self.windupTime/2.4)end
if caa then
if(baa["times-updated"]or 0)<aca then
local cca=ad:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",b_a.id,baa)cca["ability-state"]="update"cca["ability-guid"]=daa
ad:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"update",cca,daa)else
ad:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
ad:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"end",nil,daa)end end end end;return _aa