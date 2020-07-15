
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local bb=game:GetService("Debris")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("network")local _c=cb.load("damage")
local ac=cb.load("placeSetup")local bc=cb.load("tween")
local cc=ac.awaitPlaceFolder("entities")
local dc={cost=4,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(ad)return ad.class=="Mage"end}
local _d={id=12,metadata=dc,name="Thundercall",image="rbxassetid://2574315061",description="Strike nearby foes with a bout of lightning.",description_key="abilityDescription_thundercall",mastery="More bolts.",layoutOrder=3,maxRank=10,prerequisite={{id=4,rank=3}},statistics={[1]={damageMultiplier=2.0,range=20,bolts=4,cooldown=12,manaCost=17},[2]={damageMultiplier=2.2,manaCost=19},[3]={damageMultiplier=2.4,manaCost=21},[4]={damageMultiplier=2.6,manaCost=23},[5]={bolts=8,manaCost=30,tier=3},[6]={damageMultiplier=2.9,manaCost=33},[7]={damageMultiplier=3.2,manaCost=36},[8]={bolts=12,manaCost=43,tier=4}},windupTime=0.75,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},targetingData={range=70},equipmentTypeNeeded="staff",disableAutoaim=true}
function createEffectPart()local ad=Instance.new("Part")ad.Anchored=true
ad.CanCollide=false;ad.TopSurface=Enum.SurfaceType.Smooth
ad.BottomSurface=Enum.SurfaceType.Smooth;return ad end
function lightningSegment(ad,bd,cd)local dd=0.5;local __a=createEffectPart()__a.Color=cd
__a.Material=Enum.Material.Neon;local a_a=(bd-ad).magnitude;local b_a=(ad+bd)/2
__a.Size=Vector3.new(0.25,0.25,a_a)__a.CFrame=CFrame.new(b_a,bd)__a.Parent=cc
bc(__a,{"Transparency"},1,dd)bb:AddItem(__a,dd)end;function _d._abilityExecutionDataCallback(ad,bd)local cd=ad and
ad.nonSerializeData.statistics_final.activePerks["holymagic"]
bd["holymagic"]=cd end
function _d._serverProcessDamageRequest(ad,bd,cd,dd,__a)
local a_a=db:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",__a)local b_a=1
if a_a and
a_a.nonSerializeData.statistics_final.activePerks["holymagic"]then b_a=b_a*1.1 end;if ad=="strike"then return bd*b_a,"magical","aoe"end end
function _d:execute(ad,bd,cd,dd)local __a=ad.PrimaryPart;if not __a then return end
local a_a=bd["mouse-inrange"]warn("$",a_a)if not a_a then return end
local function b_a(bca,cca,dca,_da)local ada=14;local bda=4;local cda=4;local dda=0.5;_da=_da or
BrickColor.new("Electric blue").Color
for bolt=1,dca do
local __b=CFrame.new(bca)
if dca>1 then
local a_b=CFrame.Angles(0,math.pi*2 *math.random(),0)
local b_b=CFrame.Angles(math.pi/8 *math.random(),0,0)__b=__b*a_b*b_b end
for pointNumber=2,ada do local a_b=math.pi*2 *math.random()local b_b=
math.cos(a_b)*cda*math.random()
local c_b=(pointNumber-1)*bda;local d_b=math.sin(a_b)*cda*math.random()local _ab=
__b*CFrame.new(b_b,c_b,d_b)
lightningSegment(__b.Position,_ab.Position,_da)__b=_ab end end
if cca then local __b=createEffectPart()__b.Position=bca
__b.Material=Enum.Material.Neon;__b.Color=_da;__b.Size=Vector3.new(1,1,1)__b.Shape="Ball"
__b.Parent=cc;local a_b=script.hit:Clone()a_b.Parent=__b;a_b:Play()
bc(__b,{"Transparency","Size"},{1,Vector3.new(10,10,10)},dda)bb:AddItem(__b,5)local b_b=script.ring:Clone()b_b.Position=bca-
Vector3.new(0,2,0)b_b.Parent=cc;bc(b_b,{"Transparency","Size"},{1,b_b.size*8},
dda*0.7)
bb:AddItem(b_b,5)
if cd then
for c_b,d_b in
pairs(_c.getDamagableTargets(game.Players.LocalPlayer))do
local _ab=(d_b.Size.X+d_b.Size.Y+d_b.Size.Z)/3
if(d_b.Position-bca).magnitude<=5 then
spawn(function()wait(0.1)
db:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",d_b,d_b.Position,"ability",self.id,"strike",dd)end)end end end end end
local c_a=db:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local d_a=c_a["1"]and c_a["1"].manifest
if not d_a then return end;local _aa=d_a:FindFirstChild("magic")if not _aa then return end
local aaa=_aa:FindFirstChild("castEffect")if not aaa then return end;aaa.Enabled=true
local baa=ad.entity.AnimationController:LoadAnimation(ab["mage_holdInFront"])baa:Play()if cd then
db:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)if cd then
db:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;baa:Stop(0.25)aaa.Enabled=false
local caa=script.cast:Clone()caa.Parent=__a;caa:Play()
bb:AddItem(caa,caa.TimeLength)local daa={}local _ba=a_a
local aba=bd["ability-statistics"]["range"]
local bba=game.Players:GetPlayerByUserId(bd["cast-player-userId"])
if _ba and bba then local bca=_c.getDamagableTargets(bba)
for cca,dca in pairs(bca)do
local _da=(dca.Position-_ba)
local ada=math.sqrt(_da.X*_da.X+_da.Z*_da.Z)if(ada<=aba)and(math.abs(_da.Y)<=aba)then
table.insert(daa,{target=dca,distance=ada})end end end;local cba=bd["ability-statistics"]["bolts"]
local dba=math.floor(cba/2)local _ca
if bd["holymagic"]then _ca=Color3.fromRGB(255,234,110)end;b_a(_aa.WorldPosition,false,dba,_ca)wait(0.5)
table.sort(daa,function(bca,cca)return
bca.distance<cca.distance end)local aca=cba;aca=aca-1;b_a(a_a,true,dba,_ca)
for bca,cca in pairs(daa)do local dca=cca.target
delay(
bca/6,function()b_a(dca.position,true,dba,_ca)end)aca=aca-1;if aca<=0 then break end end end;return _d