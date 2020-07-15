
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("projectile")local cc=ac.load("placeSetup")
local dc=ac.load("client_utilities")local _d=ac.load("utilities")local ad=ac.load("network")
local bd=ac.load("damage")local cd=ac.load("detection")local dd=ac.load("physics")
local __a=game:GetService("HttpService")
local a_a=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
local b_a={cost=3,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(d_a)return d_a.class=="Hunter"end}
local c_a={id=13,manaCost=15,metadata=b_a,name="Shunpo",image="rbxassetid://3736597862",description="Leap forward and slash them to pieces.",description_key="abilityDescription_shunpo",prerequisite={{id=6,rank=3}},layoutOrder=3,animationName={},windupTime=0.2,maxRank=10,statistics={[1]={distance=20,cooldown=7,manaCost=10,damageMultiplier=1.60},[2]={distance=22,manaCost=11,damageMultiplier=1.8},[3]={distance=24,manaCost=12,damageMultiplier=2.0},[4]={distance=26,manaCost=13,damageMultiplier=2.2},[5]={distance=30,manaCost=15,cooldown=5,tier=3},[6]={distance=32,manaCost=17,damageMultiplier=2.5},[7]={distance=34,manaCost=19,damageMultiplier=2.8},[8]={damageMultiplier=3.2,manaCost=24,cooldown=3,tier=4}},securityData={playerHitMaxPerTag=1,isDamageContained=true},dontDisableSprinting=true,equipmentTypeNeeded="dagger"}
function c_a._serverProcessDamageRequest(d_a,_aa,aaa)if d_a=="dash-through"then
_d.playSound("shunpoImpact",aaa)return _aa,"physical","direct"end end
function c_a.__serverValidateMovement(d_a,_aa,aaa)
local baa=ad:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",c_a,ad:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",d_a,c_a.id))return(aaa-_aa).magnitude<=baa.distance*2.5 end
function c_a._abilityExecutionDataCallback(d_a,_aa)if d_a then local aaa=d_a.nonSerializeData.statistics_final
_aa["battydagger"]=aaa.activePerks["battydagger"]end end
function c_a:execute_server(d_a,_aa,aaa)if not aaa then return end;if _aa["battydagger"]then
ad:invoke("{5517DD42-A175-4E6C-8DD5-842CB17CE9F3}",d_a,self.id)end end
function c_a:execute(d_a,_aa,aaa,baa)
if not d_a:FindFirstChild("entity")then return end
if d_a.entity.PrimaryPart then
local caa=d_a.entity.AnimationController:LoadAnimation(_c.shunpo_start)
_d.playSound("shunpoCast",d_a.entity.PrimaryPart)caa:Play(nil,nil,1.5)
spawn(function()
wait((self.windupTime/2)/caa.Speed)
if script:FindFirstChild("dustpart")then
local _ca=script.dustpart:Clone()_ca.Parent=workspace.CurrentCamera
_ca.CFrame=CFrame.new(
d_a.entity.PrimaryPart.Position-Vector3.new(0,2.8,0))_ca.Dust:Emit(50)game.Debris:AddItem(_ca,5)end end)wait(self.windupTime/caa.Speed)if not
d_a:FindFirstChild("entity")then return end
local daa=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local _ba=daa["1"]and daa["1"].manifest
if not _ba then return end;local aba=a_a[_aa["cast-weapon-id"]]
if not aba then return false end;local bba
if aba and aba.equipmentType=="dagger"then
if _ba then
if
script:FindFirstChild("cast")then local bca=script.cast:Clone()bca.Parent=_ba;if not aaa then bca.Volume=bca.Volume*
0.7 end;bca:Play()
game.Debris:AddItem(bca,5)end;local _ca=_ba:FindFirstChild("bottomAttachment")
local aca=_ba:FindFirstChild("topAttachment")
if _ca and aca then bba=script.Trail:Clone()
bba.Name="shadowStepTrail"bba.Parent=_ba;bba.Attachment0=_ca;bba.Attachment1=aca;bba.Enabled=true end end end;if not d_a:FindFirstChild("entity")then return end
local cba=d_a.entity.AnimationController:LoadAnimation(_c.shunpo_end)cba:Play(0.1,1,2)local dba
if aaa then
local _ca=game.Players.LocalPlayer.Character;if not _ca then return false end
dd:setWholeCollisionGroup(_ca,"passthrough")
dba=ad:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")
if dba and dba.magnitude>0 then dba=dba.unit
local aca=d_a.entity.PrimaryPart.Position
local bca=d_a.entity.PrimaryPart.Position+dba*
_aa["ability-statistics"].distance
if d_a:FindFirstChild("clientHitboxToServerHitboxReference")then
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
ad:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",dba*150 * (
(_aa["ability-statistics"].distance*1)/20))if _ca and _ca.PrimaryPart then
local cca=_ca.PrimaryPart:FindFirstChild("hitboxGyro")
if cca then cca.CFrame=CFrame.new(Vector3.new(),dba)end end
if aba and
aba.equipmentType=="dagger"then local cca=(bca-aca).magnitude
local dca=Vector3.new(6,6,cca)
local _da=CFrame.new(aca,bca)*CFrame.new(0,0,-cca*0.5)
local ada=bd.getDamagableTargets(game.Players.LocalPlayer)
for bda,cda in pairs(ada)do
local dda=cd.projection_Box(cda.CFrame,cda.Size,_da.p)if cd.boxcast_singleTarget(_da,dca,dda)then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",cda,dda,"ability",self.id,"dash-through",baa)end end end end end end;wait((cba.Length*0.35)/cba.Speed)
if aaa then
ad:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)local _ca=game.Players.LocalPlayer.Character;if _ca then
dd:setWholeCollisionGroup(_ca,"characters")end;if dba then
ad:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",dba*40)end end
if bba then bba.Enabled=false;game.Debris:AddItem(bba,1)end end;if aaa then
ad:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",_aa,self.id)end end;return c_a