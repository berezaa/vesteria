
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("projectile")local ac=db.load("placeSetup")
local bc=db.load("client_utilities")local cc=db.load("network")local dc=db.load("damage")
local _d=db.load("detection")local ad=db.load("physics")
local bd=game:GetService("HttpService")
local cd=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
local dd={id=24,manaCost=15,name="Shadow Shots",image="http://www.roblox.com/asset/?id=1879548550",description="Send out pieces of darkness from your shadow.",animationName={},windupTime=0.2,maxRank=10,statistics={[1]={distance=20,cooldown=5,manaCost=10,damageMultiplier=1.50},[2]={damageMultiplier=1.55},[3]={damageMultiplier=1.60},[4]={damageMultiplier=1.65},[5]={distance=25,damageMultiplier=1.7},[6]={damageMultiplier=1.75},[7]={damageMultiplier=1.8},[8]={damageMultiplier=1.85},[9]={damageMultiplier=1.9},[10]={distance=30,damageMultiplier=2}},dontDisableSprinting=true}
function dd._serverProcessDamageRequest(__a,a_a)return a_a,"physical","direct"end
function dd.__serverValidateMovement(__a,a_a,b_a)
local c_a=cc:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",dd,cc:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",__a,dd.id))return(b_a-a_a).magnitude<=c_a.distance*2.5 end
function dd:execute(__a,a_a,b_a,c_a)
if not __a:FindFirstChild("entity")then return end
if __a.entity.PrimaryPart then local d_a=script.shadow:Clone()end end;return dd