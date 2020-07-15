
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local bb=game:GetService("Debris")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("network")local _c=cb.load("damage")
local ac=cb.load("placeSetup")local bc=cb.load("tween")local cc=cb.load("ability_utilities")
local dc=ac.awaitPlaceFolder("entities")
local _d={id=49,name="Meteor Strike",image="rbxassetid://3967026015",description="Call down a flaming ball of magic which explodes, igniting nearby enemies.",layoutOrder=0,maxRank=10,statistics=cc.calculateStats{maxRank=10,static={cooldown=8,range=100},staggered={damageMultiplier={first=1.5,final=2.5,levels={2,5,8}},percentHealthBurned={first=15,final=30,levels={3,6,9}},radius={first=40,final=62,levels={4,7,10}}},pattern={manaCost={base=25,pattern={2,3,2}}}},windupTime=0.75,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"},targetingData={targetingType="directSphere",range="range",radius="radius",onStarted=function(ad,bd)
local cd=db:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)["1"].manifest.magic;local dd=script.fireball.emitter:Clone()
dd.Lifetime=NumberRange.new(0.5)dd.Parent=cd;local __a=Instance.new("PointLight")
__a.Color=BrickColor.new("Bright orange").Color;__a.Parent=cd;return{emitter=dd,light=__a}end,onEnded=function(ad,bd,cd)
cd.emitter.Enabled=false
bb:AddItem(cd.emitter,cd.emitter.Lifetime.Max)cd.light:Destroy()end},equipmentTypeNeeded="staff",disableAutoaim=true}
function createEffectPart()local ad=Instance.new("Part")ad.Anchored=true
ad.CanCollide=false;ad.TopSurface=Enum.SurfaceType.Smooth
ad.BottomSurface=Enum.SurfaceType.Smooth;return ad end;function yeet()end;function _d._serverProcessDamageRequest(ad,bd)
if ad=="explosion"then return bd,"magical","aoe"end end
function _d:execute_server(ad,bd,cd)
if not cd then return end;local dd=ad.Character;if not dd then return end;local __a=dd.PrimaryPart
if not __a then return end;local a_a=Instance.new("RemoteEvent")
a_a.Name="FlamecallTemporarySecureRemote"
a_a.OnServerEvent:connect(function(b_a,c_a)
for d_a,_aa in pairs(c_a)do
db:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_aa,"ablaze",{duration=4,percent=
bd["ability-statistics"]["percentHealthBurned"]/100},__a,"ability",self.id)end;a_a:Destroy()end)a_a.Parent=game.ReplicatedStorage;return a_a end
function _d:execute(ad,bd,cd,dd)local __a=ad.PrimaryPart;if not __a then return end
local a_a=db:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ad.entity)local b_a=a_a["1"]and a_a["1"].manifest
if not b_a then return end;local c_a=b_a:FindFirstChild("magic")if not c_a then return end
local d_a=c_a:FindFirstChild("castEffect")if not d_a then return end;local _aa;if cd then
_aa=db:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",bd,self.id)end;d_a.Enabled=true
local aaa=ad.entity.AnimationController:LoadAnimation(ab["mage_holdInFront"])aaa:Play()if cd then
db:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)if cd then
db:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;aaa:Stop(0.25)d_a.Enabled=false
local baa=script.cast:Clone()baa.Parent=__a;baa:Play()
bb:AddItem(baa,baa.TimeLength)local caa=bd["ability-statistics"]["radius"]
local daa=bd["ability-statistics"]["range"]local _ba=bd["absolute-mouse-world-position"]
local aba=_ba-c_a.WorldPosition;if aba.magnitude>=daa then aba=aba.unit*daa end;_ba=
c_a.WorldPosition+aba;local bba=1.25
local function cba()
local dba=script.fireball:Clone()local _ca=dba.emitter;local aca=dba.Color;dba.CFrame=CFrame.new(c_a.WorldPosition)+
Vector3.new(0,30,0)
bc(dba,{"CFrame"},CFrame.new(_ba),bba,
nil,Enum.EasingDirection.In)
bc(dba,{"Size"},Vector3.new(1,1,1)*4,bba)
bc(dba,{"Color"},Color3.new(1,1,0.5),bba,Enum.EasingStyle.Linear)dba.Parent=dc
delay(bba,function()dba.hit:Play()
_ca.Rate=_ca.Rate*caa/5
bc(dba,{"Size","Transparency","Color"},{Vector3.new(1,1,1)*caa*2,1,aca},0.25)
delay(0.25,function()_ca.Enabled=false;wait(_ca.Lifetime.Max)
dba:Destroy()end)
if cd then local bca={}local cca=caa*caa
for dca,_da in
pairs(_c.getDamagableTargets(game.Players.LocalPlayer))do local ada=_da.Position-_ba;local bda=ada.X*ada.X+ada.Y*ada.Y+ada.Z*
ada.Z
if bda<cca then
db:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_da,_da.position,"ability",self.id,"explosion",dd)table.insert(bca,_da)end end;_aa:FireServer(bca)end end)end;cba()end;return _d