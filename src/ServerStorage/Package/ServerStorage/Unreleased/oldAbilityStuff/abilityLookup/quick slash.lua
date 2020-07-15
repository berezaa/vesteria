
local ac=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("projectile")local dc=bc.load("placeSetup")
local _d=bc.load("client_utilities")local ad=bc.load("network")local bd=bc.load("damage")
local cd=bc.load("detection")local dd=bc.load("ability_utilities")
local __a=bc.load("utilities")local a_a=dc.getPlaceFolder("entities")
local b_a=game:GetService("HttpService")
local c_a={id=26,name="Quick Slash",image="rbxassetid://3736598536",description="Leap forward and knock enemies up.",damageType="physical",layoutOrder=0,windupTime=0.1,maxRank=10,cooldown=3,cost=10,statistics={[1]={damageMultiplier=2.0,range=10,cooldown=3,manaCost=8},[2]={damageMultiplier=2.1,manaCost=9},[3]={damageMultiplier=2.15,manaCost=10,cooldown=2.5},[4]={damageMultiplier=2.2,manaCost=11},[5]={damageMultiplier=2.25,manaCost=12},[6]={damageMultiplier=2.3,manaCost=13,cooldown=2},[7]={damageMultiplier=2.35,manaCost=14},[8]={damageMultiplier=2.4,manaCost=15},[9]={damageMultiplier=2.45,cooldown=1.5,manaCost=16},[10]={damageMultiplier=2.5,manaCost=17}},damage=30,maxRange=30,equipmentTypeNeeded="sword"}function c_a._serverProcessDamageRequest(aaa,baa)
if aaa=="uppercut"then return baa,"physical","direct"end end
function c_a.__serverValidateMovement(aaa,baa,caa)
local daa=ad:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",c_a,ad:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",aaa,c_a.id))return(caa-baa).magnitude<=daa.range*2 end;local function d_a()end;function c_a._abilityExecutionDataCallback(aaa,baa)
baa["bounceback"]=aaa and
aaa.nonSerializeData.statistics_final.activePerks["bounceback"]end
local function _aa(aaa)return
aaa["bounceback"]and 15000 or 1000 end
function c_a:execute_server(aaa,baa,caa,daa,_ba,aba)if not caa then return end;if baa["bounceback"]then
__a.playSound("bounce",_ba)end
dd.knockbackMonster(_ba,daa,aba,0.2)end
function c_a:doKnockback(aaa,baa,caa,daa)
if baa:FindFirstChild("entityType")and
baa.entityType.Value=="monster"then
ad:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",aaa,self.id,caa,baa,daa)end;local _ba=game.Players.LocalPlayer;local aba=_ba.Character
if not aba then return end;local bba=aba.PrimaryPart;if not bba then return end;if baa==bba then
dd.knockbackLocalPlayer(caa,daa)end end
function c_a:execute(aaa,baa,caa,daa)
if not aaa:FindFirstChild("entity")then return end
local _ba=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local aba=_ba["1"]and _ba["1"].manifest
if not aba then return end;local bba
if aba then local _ca=aba:FindFirstChild("bottomAttachment")
local aca=aba:FindFirstChild("topAttachment")
if _ca and aca then bba=script.Trail:Clone()
bba.Name="groundSlamTrail"bba.Parent=aba;bba.Attachment0=_ca;bba.Attachment1=aca;bba.Enabled=true end end
if caa then
local _ca=ad:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")
ad:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())
ad:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)local aca=game.Players.LocalPlayer.Character;if _ca then
ad:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",(
_ca+Vector3.new(0,7,0)*3))end end
local cba=aaa.entity.AnimationController:LoadAnimation(script.quickSlashAnimation)cba:Play()cba:AdjustSpeed(3)
local dba=cba.Length/cba.Speed
if caa then
spawn(function()local _ca={}
while true do
if cba.IsPlaying then
for aca,bca in
pairs(bd.getDamagableTargets(game.Players.LocalPlayer))do
if not _ca[bca]then local cca=aba.CFrame
local dca=cd.projection_Box(bca.CFrame,bca.Size,cca.p)
if
cd.boxcast_singleTarget(cca,aba.Size*Vector3.new(3,1.5,3),dca)then _ca[bca]=true
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",bca,dca,"ability",self.id,"uppercut",daa)self:doKnockback(baa,bca,dca,_aa(baa))end end end;wait(1 /20)else break end end end)end;wait(dba)if bba then bba:Destroy()end;return true end;return c_a