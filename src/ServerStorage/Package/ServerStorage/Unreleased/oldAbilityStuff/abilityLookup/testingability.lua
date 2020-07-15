
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("damage")
local ad=_c.load("detection")
local bd=bc.awaitPlaceFolder("monsterManifestCollection")local cd=bc.getPlaceFolder("entities")
local dd=game:GetService("HttpService")
local __a={id=16,name="Ground Slam",image="rbxassetid://2574647455",description="Leap forward and down slash!",damageType="physical",windupTime=0.5,maxRank=10,cooldown=3,cost=10,speedMulti=1.5,statistics={[1]={damageMultiplier=2.50,radius=10,cooldown=14,manaCost=25},[2]={damageMultiplier=2.60},[3]={damageMultiplier=2.70},[4]={damageMultiplier=2.80},[5]={damageMultiplier=2.90,radius=12},[6]={damageMultiplier=3.00},[7]={damageMultiplier=3.10},[8]={damageMultiplier=3.20},[9]={damageMultiplier=3.30},[10]={damageMultiplier=3.50,radius=14}},securityData={playerHitMaxPerTag=1,isDamageContained=true},damage=30,maxRange=30,equipmentTypeNeeded="sword"}local function a_a()end
function __a:execute(b_a,c_a,d_a,_aa)
if not b_a:FindFirstChild("entity")then return end
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)local baa=aaa["1"]and aaa["1"].manifest
if not baa then return end
local caa=b_a.entity.AnimationController:LoadAnimation(db.warrior_forwardDownslash)if baa then local cca=script.cast:Clone()cca.Parent=baa;if not d_a then cca.Volume=
cca.Volume*0.7 end;cca:Play()
game.Debris:AddItem(cca,5)end
local daa;daa=caa.Stopped:connect(function()end)
local _ba=game.Players.LocalPlayer.Character
if d_a and _ba then while caa.Length==0 do wait(0)end
spawn(function()local cca={}
while true do
if caa.IsPlaying then
for dca,_da in
pairs(_d.getDamagableTargets(game.Players.LocalPlayer))do
if not cca[_da]then local ada=baa.CFrame
local bda=ad.projection_Box(_da.CFrame,_da.Size,ada.p)
if
ad.boxcast_singleTarget(ada,baa.Size*Vector3.new(4,1.5,2),bda)then cca[_da]=true
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_da,bda,"ability",self.id,nil,_aa)end end end;wait(1 /20)else break end end end)end;caa:Play(0.1,1,self.speedMulti or 1)wait(
caa.Length*0.06 /caa.Speed)
if d_a then
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)local cca=(_ba.PrimaryPart.CFrame.lookVector)
local dca=_ba.PrimaryPart.hitboxGyro;local _da=_ba.PrimaryPart.hitboxVelocity
dca.CFrame=CFrame.new(Vector3.new(),cca)cca=cca+Vector3.new(0,1,0)
dc:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",
cca*23 *caa.Speed)end;wait(caa.Length*0.355 /caa.Speed)if not
b_a:FindFirstChild("entity")then return end
dc:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())local aba=30;local bba=tick()local cba=caa.TimePosition;local dba,_ca,aca
local bca=game:GetService("RunService")caa:AdjustSpeed(0)
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)
repeat
local cca=Ray.new(
baa.Position+ (b_a.PrimaryPart.CFrame.lookVector*2)+Vector3.new(0,2.5,0),Vector3.new(0,-9,0))
dba,_ca,aca=workspace:FindPartOnRayWithIgnoreList(cca,{b_a,baa})wait()until dba or tick()-bba>=aba
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)caa:AdjustSpeed(self.speedMulti)
spawn(function()
if not dba then return false end
local cca=game.ReplicatedStorage.shockwaveEntity:Clone()
local dca=game.ReplicatedStorage.shockwaveEntity:Clone()cca.Parent=cd;dca.Parent=cd
local _da=c_a["ability-statistics"].radius;local ada=script.dustPart:Clone()
ada.Parent=workspace.CurrentCamera;ada.CFrame=CFrame.new(_ca)ada.Dust.Speed=NumberRange.new(30 * (_da/10),
50 * (_da/10))
ada.Dust:Emit(100)game.Debris:AddItem(ada,6)
local bda=script.impact:Clone()if not d_a then bda.Volume=bda.Volume*0.7 end
bda.Parent=ada;bda:Play()
if d_a then
for d_b,_ab in
pairs(_d.getDamagableTargets(game.Players.LocalPlayer))do if(_ab.Position-_ca).magnitude<=_da then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,_ca,"ability",self.id,
nil,_aa)end end end;local cda=tick()local dda=CFrame.new(_ca,_ca+aca)*
CFrame.Angles(math.pi/2,0,0)local __b=Vector3.new(_da*1.7,0,
_da*1.7)
local a_b=Vector3.new(0.25,0.1,0.25)local b_b=0.8
local c_b=game:GetService("RunService").RenderStepped:connect(function()local d_b=(
tick()-cda)/b_b;cca.Size=a_b+__b* (d_b^3)dca.Size=
a_b+__b* (d_b^2)
cca.Transparency=math.clamp(d_b^1.5,0,1)dca.Transparency=math.clamp(d_b,0,1)cca.CFrame=dda
dca.CFrame=dda end)wait(1)cca:Destroy()dca:Destroy()c_b:disconnect()end)wait(caa.Length*0.5 /caa.Speed)
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)return true end;return __a