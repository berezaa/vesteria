
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ac=game:GetService("Debris")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("network")local dc=bc.load("damage")
local _d=bc.load("placeSetup")local ad=bc.load("tween")local bd=bc.load("utilities")
local cd=bc.load("ability_utilities")local dd=_d.awaitPlaceFolder("entities")
local __a={id=36,name="Hail of Arrows",image="rbxassetid://4079577793",description="Rain arrows down upon a targeted area. (Requires bow.)",mastery="Longer duration.",layoutOrder=0,maxRank=10,statistics=cd.calculateStats{maxRank=10,static={cooldown=15,radius=16},staggered={radius={first=12,final=20,levels={4,7,10}},duration={first=4,final=8,levels={3,6,9}},damageMultiplier={first=2,final=4,levels={2,5,8}}},pattern={manaCost={base=5,pattern={2,3,4}}}},windupTime=0.4,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},equipmentTypeNeeded="bow",disableAutoaim=true,targetingData={targetingType="directCylinder",radius="radius",range=35,onStarted=function(d_a)
local _aa=d_a.entity.AnimationController:LoadAnimation(_c.bow_targeting_sequence)_aa:Play()return{track=_aa}end,onEnded=function(d_a,_aa,aaa)
aaa.track:Stop()end}}local a_a=64;local b_a=1
function createEffectPart()local d_a=Instance.new("Part")
d_a.Anchored=true;d_a.CanCollide=false;d_a.TopSurface=Enum.SurfaceType.Smooth
d_a.BottomSurface=Enum.SurfaceType.Smooth;return d_a end
local function c_a(d_a)local _aa=script.arrow:Clone()local aaa=_aa.mover;local baa=_aa.Trail;local caa=
b_a/2;local daa=a_a/caa
_aa.CFrame=CFrame.new(d_a)*CFrame.Angles(0,math.pi*2 *
math.random(),0)aaa.Velocity=Vector3.new(0,-daa,0)_aa.Parent=dd
ac:AddItem(_aa,b_a)end;function __a._serverProcessDamageRequest(d_a,_aa)
if d_a=="quarterSecondDamage"then return _aa/4,"physical","aoe"end end
function __a:execute(d_a,_aa,aaa,baa)
local caa=d_a.PrimaryPart;if not caa then return end
local daa=cc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local _ba=daa["1"]and daa["1"].manifest
if not _ba then return end;local aba=_ba:FindFirstChild("AnimationController")
if not aba then return end;local bba=_aa["mouse-world-position"]
local cba=_aa["ability-statistics"]["radius"]
local dba=game.Players:GetPlayerByUserId(_aa["cast-player-userId"])if(not bba)or(not dba)then return end
local _ca=d_a.entity.AnimationController:LoadAnimation(_c["bow_skyshot"])local aca=aba:LoadAnimation(_c["bow_tripleshot"])
local bca=script.animationArrow:Clone()bca.Parent=dd;local cca=_ba.slackRopeRepresentation.arrowHolder;cca.C0=CFrame.Angles(
-math.pi/2,0,0)*
CFrame.new(0,-bca.Size.Y/2 -0.2,0)
cca.Part1=bca
delay(0.45,function()bca:Destroy()end)_ca:Play()aca:Play()bd.playSound("bowDraw",caa)if aaa then
cc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)
bd.playSound("bowFire",caa)if aaa then
cc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end
local dca=_aa["ability-statistics"]["duration"]
do local _da=Instance.new("Part")_da.Size=Vector3.new()
_da.Anchored=true;_da.CanCollide=false;_da.Transparency=1;_da.Position=bba
local ada=script.rain:Clone()ada.Parent=_da;ada:Play()_da.Parent=dd;ac:AddItem(_da,dca)end
spawn(function()local _da=16;local ada=1 /_da;local bda=dca*_da
for _=1,bda do
local cda=math.pi*2 *math.random()local dda=cba*math.random()local __b=math.cos(cda)*dda
local a_b=a_a;local b_b=math.sin(cda)*dda
c_a(bba+Vector3.new(__b,a_b,b_b))wait(ada)end end)wait(0.5)
if aaa then local _da=dca*4;local ada=cba*cba
spawn(function()
for _=1,_da do
local bda=dc.getDamagableTargets(dba)
for cda,dda in pairs(bda)do local __b=(dda.Position-bba)
local a_b=__b.X*__b.X+__b.Z*__b.Z;if a_b<=ada then
cc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dda,dda.position,"ability",self.id,"quarterSecondDamage",baa)end end;wait(0.25)end end)end end;return __a