
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("projectile")local db=bb.load("placeSetup")
local _c=bb.load("client_utilities")local ac=bb.load("network")
local bc=db.awaitPlaceFolder("entityManifestCollection")local cc=game:GetService("HttpService")
local dc={cost=1,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(ad)
return ad.class=="Warrior"end}
local _d={id=8,metadata=dc,name="Combat Roll",image="rbxassetid://3736598336",description="Character dodges in movement direction.",damageType="physical",prerequisite={{id=26,rank=1}},layoutOrder=1,duration=1,animationName="combat_roll",windupTime=0.1,maxRank=5,cooldown=3,statistics={[1]={speed=70,cooldown=4,manaCost=5,duration=1},[2]={speed=80,cooldown=3.7,manaCost=6},[3]={speed=90,cooldown=3.4,manaCost=7},[4]={speed=100,cooldown=3.1,manaCost=8},[5]={cooldown=2.6,manaCost=9,tier=3},[6]={cooldown=2.1,manaCost=10},[7]={cooldown=1.6,manaCost=11},[8]={speed=120,cooldown=1,manaCost=15,tier=4}},dontDisableSprinting=true}function _d:execute_server(ad,bd,cd,dd,__a,a_a)if not cd then return end end
function _d.__serverValidateMovement(ad,bd,cd,dd)
local __a=ac:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",_d,ac:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",ad,_d.id))return(cd-bd).magnitude<=__a.speed*1.5 end
function _d:execute(ad,bd,cd,dd)
if not ad:FindFirstChild("entity")then return false end
local __a=ad.entity.AnimationController:LoadAnimation(ab[self.animationName])__a:Play()
if ad.PrimaryPart then local a_a=script.sound:Clone()
a_a.Parent=ad.PrimaryPart;if not cd then a_a.Volume=a_a.Volume*0.5 end
a_a:Play()game.Debris:AddItem(a_a,5)end
if cd then if not ad:FindFirstChild("entity")then return end
local a_a=ac:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")
if a_a then if not(a_a.magnitude>0)then
a_a=ad.PrimaryPart.CFrame.lookVector end
local b_a=game.Players.LocalPlayer.Character;if not b_a or not b_a.PrimaryPart then return false end
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)local c_a=a_a.unit;local d_a=b_a.PrimaryPart.hitboxGyro
local _aa=b_a.PrimaryPart.hitboxVelocity;d_a.CFrame=CFrame.new(Vector3.new(),c_a)
local aaa=bd["ability-statistics"].speed
ac:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",c_a*aaa)local baa=(__a.Length-self.windupTime)local caa=tick()
local daa=game:GetService("RunService").Heartbeat:connect(function()local _ba=(
tick()-caa)/baa
ac:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",c_a*aaa* (1 -_ba))end)
spawn(function()
wait((__a.Length*0.6)-self.windupTime)daa:disconnect()
ac:invoke("{C43ACD39-75B4-40F2-B91B-74FAD166EE59}",Vector3.new())
ac:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",c_a*aaa*0.5)
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)else return false end end;wait(0.5)return true end;return _d