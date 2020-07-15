
local bb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cb=game:GetService("Debris")
local db=game:GetService("RunService")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("ability_utilities")
local ad=cc.awaitPlaceFolder("entities")
local bd={id=37,name="Frostcall",image="rbxassetid://4079577683",description="Unleash a line of falling icicles before you, damaging enemies. (Requires staff.)",mastery="More icicles.",layoutOrder=0,maxRank=10,statistics=_d.calculateStats{maxRank=10,static={cooldown=2,manaCost=10,damageMultiplier=1.5},staggered={icicles={first=4,final=12,levels={3,5,7,9},integer=true},damageMultiplier={first=1.25,final=1.875,levels={2,4,6,8,10}}},pattern={manaCost={base=5,pattern={3,2}}}},windupTime=0.3,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},equipmentTypeNeeded="staff",disableAutoaim=true,targetingData={targetingType="line",width=function(cd)
local dd=8;local __a=cd["ability-statistics"]["icicles"]if __a<=6 then
return dd elseif __a<=10 then return dd*1.7 else return dd*1.9 end end,length=function(cd)
local dd=8;local __a=cd["ability-statistics"]["icicles"]
if __a<=6 then return
__a*dd elseif __a<=10 then return __a*dd*0.65 else return __a*dd*0.55 end end,onStarted=function(cd,dd)
local __a=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",cd.entity)["1"].manifest.magic;local a_a=script.icicle.emitter:Clone()
a_a.Lifetime=NumberRange.new(0.5)a_a.Parent=__a;local b_a=Instance.new("PointLight")
b_a.Color=BrickColor.new("Electric blue").Color;b_a.Parent=__a;return{emitter=a_a,light=b_a,projectionPart=__a}end,onEnded=function(cd,dd,__a)
__a.emitter.Enabled=false
game:GetService("Debris"):AddItem(__a.emitter,__a.emitter.Lifetime.Max)__a.light:Destroy()end}}
function createEffectPart()local cd=Instance.new("Part")cd.Anchored=true
cd.CanCollide=false;cd.TopSurface=Enum.SurfaceType.Smooth
cd.BottomSurface=Enum.SurfaceType.Smooth;return cd end;function bd._serverProcessDamageRequest(cd,dd)
if cd=="iceExplosion"then return dd,"magical","aoe"end end
function bd:execute(cd,dd,__a,a_a)
local b_a=cd.PrimaryPart;if not b_a then return end;local c_a=cd:FindFirstChild("entity")
if not c_a then return end;local d_a=c_a:FindFirstChild("AnimationController")
if not d_a then return end
local _aa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",cd.entity)local aaa=_aa["1"]and _aa["1"].manifest
if not aaa then return end;local baa=aaa:FindFirstChild("magic")if not baa then return end
local caa=baa:FindFirstChild("castEffect")if not caa then return end;caa.Enabled=true
for ada,bda in
pairs{"mage_thrust_top","mage_thrust_bot"}do local cda=d_a:LoadAnimation(bb[bda])cda:Play()end;wait(self.windupTime)
local daa=script.castSound:Clone()daa.Parent=b_a;daa:Play()
cb:AddItem(daa,daa.TimeLength/daa.PlaybackSpeed)caa.Enabled=false;local _ba=8;local aba=_ba*_ba
local function bba(ada)
if __a then
local bda=bc.getDamagableTargets(game.Players.LocalPlayer)
for cda,dda in pairs(bda)do local __b=(dda.Position-ada)
local a_b=__b.X*__b.X+__b.Z*__b.Z;if a_b<=aba then
ac:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dda,dda.position,"ability",self.id,"iceExplosion",a_a)end end end end
local function cba(ada)local bda=1;local cda=createEffectPart()
cda.Material=Enum.Material.Foil;cda.Color=Color3.fromRGB(184,240,255)
cda.CFrame=CFrame.new(ada)cda.Size=Vector3.new(0,0,0)
cda.Shape=Enum.PartType.Ball;cda.Parent=ad;local dda=script.shatterSound:Clone()
dda.Parent=cda;dda:Play()
dc(cda,{"Size","Transparency"},{Vector3.new(2,2,2)*_ba,1},bda)delay(bda,function()cda:Destroy()end)
bba(ada)end
local function dba(ada,bda,cda)local dda=script.icicle:Clone()
dda.emitter:Destroy()local __b=math.pi/4;local a_b=math.pi/3
dda.CFrame=CFrame.new(ada)*
CFrame.Angles(0,bda,0)*
CFrame.Angles(__b+ (a_b-__b)*math.random(),0,0)local b_b=dda.CFrame*CFrame.new(0,2,0)
local c_b=Vector3.new(
dda.Size.X*5,dda.Size.Y*2,dda.Size.Z*5)
dc(dda,{"CFrame","Size"},{b_b,c_b},1,Enum.EasingStyle.Linear)
dc(dda,{"Transparency"},1,cda,Enum.EasingStyle.Linear)cb:AddItem(dda,cda)dda.Parent=ad end
local function _ca(ada)local bda=128;local cda=32;local dda=cda/bda;local __b=dda*0.4
local a_b=

CFrame.new(ada)*CFrame.Angles(0,
math.pi*2 *math.random(),0)*CFrame.Angles(math.pi/8 *math.random(),0,0)*CFrame.new(0,cda,0)local b_b=script.icicle:Clone()local c_b=b_b.emitter
b_b.CFrame=a_b;local d_b=tick()local _ab
do
local function bab(dab)local _bb=tick()-d_b;if _bb<__b then return end
_ab:Disconnect()c_b.Enabled=false;local abb=c_b.Lifetime.Max+1
dc(b_b,{"Transparency"},1,abb,Enum.EasingStyle.Linear)cb:AddItem(b_b,abb)local bbb=b_b.Position
local cbb=math.pi*2 *math.random()local dbb=3;for bonusIceNumber=1,dbb do local acb=math.pi*2 * (bonusIceNumber/dbb)dba(bbb,
cbb+acb,abb)end
local _cb=script[
"shatterSound"..math.random(1,5)]:Clone()_cb.Parent=b_b;_cb:Play()bba(b_b.Position)end
local function cab(dab)local _bb=b_b.Position
local abb=-b_b.CFrame.UpVector*bda*dab;local bbb,cbb=_d.raycastMap(Ray.new(_bb,abb))
b_b.Position=cbb;if bbb then bab()end end;_ab=db.Heartbeat:Connect(cab)end;b_b.Parent=ad
local aab=Vector3.new(b_b.Size.X*8,b_b.Size.Y*3,b_b.Size.Z*8)
dc(b_b,{"Size"},aab,1,Enum.EasingStyle.Linear)end;local aca=b_a.Position+Vector3.new(0,-2.5,0)
local bca=dd["mouse-world-position"]bca=Vector3.new(bca.X,aca.Y,bca.Z)
local cca=(bca-aca).Unit;local dca=dd["ability-statistics"]["icicles"]
local _da=CFrame.new(Vector3.new(),cca)
for icicleNumber=1,dca do local ada
if dca<=6 then ada=cca*icicleNumber*_ba elseif dca<=10 then local bda=
(icicleNumber%2 ==0)and-1 or 1
ada=_da*CFrame.new(bda*_ba*0.35,0,
-icicleNumber*_ba*0.65)ada=ada.Position else local bda=(icicleNumber%3)-1
ada=_da*CFrame.new(bda*_ba*0.45,0,
-icicleNumber*_ba*0.55)ada=ada.Position end;_ca(aca+ada)wait(0.1)end end;return bd