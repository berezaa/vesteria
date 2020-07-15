
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("projectile")local ac=db.load("placeSetup")
local bc=db.load("client_utilities")local cc=db.load("network")local dc=db.load("damage")
local _d=db.load("detection")local ad=ac.getPlaceFolder("entities")
local bd=game:GetService("HttpService")
local cd={id=11,name="Lunge Uppercut",image="rbxassetid://2574647455",description="Leap forward and knock enemies up.",damageType="physical",windupTime=0.1,maxRank=10,cooldown=3,cost=10,statistics={[1]={damageMultiplier=2.00,range=10,cooldown=3,manaCost=35},[2]={damageMultiplier=2.10},[3]={damageMultiplier=2.20},[4]={damageMultiplier=2.30},[5]={range=11,damageMultiplier=2.40},[6]={damageMultiplier=2.50},[7]={damageMultiplier=2.60},[8]={damageMultiplier=2.70},[9]={damageMultiplier=2.80},[10]={range=12,damageMultiplier=3.00}},damage=30,maxRange=30,equipmentTypeNeeded="sword"}function cd._serverProcessDamageRequest(__a,a_a)
if __a=="uppercut"then return a_a,"physical","direct"end end
function cd.__serverValidateMovement(__a,a_a,b_a)
local c_a=cc:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",cd,cc:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",__a,cd.id))return(b_a-a_a).magnitude<=c_a.range*2 end;local function dd()end
function cd:execute(__a,a_a,b_a,c_a)
if not __a:FindFirstChild("entity")then return end
local d_a=cc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)local _aa=d_a["1"]and d_a["1"].manifest
if not _aa then return end;local aaa=script.Glow:Clone()aaa.Parent=_aa
local baa=__a.entity.AnimationController:LoadAnimation(cb.warrior_uppercut)local caa
caa=baa.Stopped:connect(function()aaa.Enabled=false
game.Debris:AddItem(aaa,5)caa:disconnect()end)baa:Play()wait(self.windupTime)
if b_a then
local daa=cc:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")
if daa then
local aba=cc:invoke("{EAD6BA98-4037-456F-AB79-F30E6DD0D488}").isInAir;if not(daa.magnitude>0)then
daa=__a.PrimaryPart.CFrame.lookVector end
local bba=cc:invoke("{EAD6BA98-4037-456F-AB79-F30E6DD0D488}")
if not bba.isInAir and not bba.isSprinting then
cc:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",
daa.unit* (aba and 10 or 40))
delay(0.2,function()
cc:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",Vector3.new(0,40,0))end)else return false end else return false end;local _ba={}
while true do
if baa.IsPlaying then
for aba,bba in
pairs(dc.getDamagableTargets(game.Players.LocalPlayer))do
if not _ba[bba]then local cba=_aa.CFrame
local dba=_d.projection_Box(bba.CFrame,bba.Size,cba.p)
if
_d.boxcast_singleTarget(cba,_aa.Size*Vector3.new(3,1.5,3),dba)then _ba[bba]=true
cc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",bba,dba,"ability",self.id,"uppercut",c_a)end end end;wait(1 /20)else break end end;return true end end;return cd