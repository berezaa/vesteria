local ab=game:GetService("ReplicatedStorage")
local bb=require(ab.modules)local cb=bb.load("pathfinding")local db=bb.load("utilities")
local _c=bb.load("detection")local ac=bb.load("network")local bc=bb.load("placeSetup")
local cc=bb.load("projectile")local dc=Vector3.new(1,0,1)local _d=50
return
{processDamageRequest=function(ad,bd)if ad=="rock-throw"then
return bd,"physical","projectile"end;return bd,"physical","direct"end,default="idling",states={["setup"]={transitionLevel=0,step=function(ad)
end},["sleeping"]={timeBetweenUpdates=5,transitionLevel=1,step=function(ad,bd)
if ad.closestEntity then return"idling"end end},["idling"]={lockTimeForLowerTransition=3,transitionLevel=2,step=function(ad,bd)
ad.manifest.BodyVelocity.Velocity=Vector3.new()
if bd then local cd=ad.origin.p;local dd=0
local __a=CFrame.new(ad.manifest.Position*dc)local a_a=CFrame.new(cd*dc)local b_a=(a_a.p-__a.p).unit
local c_a=0
do
if b_a.magnitude>0 then local daa=__a.lookVector;local _ba=b_a:Dot(daa)
local aba=b_a:Cross(daa)c_a=math.acos(_ba)
if aba.Y>0 then c_a=2 *math.pi-c_a end end end;local d_a=(__a.p-a_a.p).magnitude
local _aa=2 *math.random()-1;local aaa=2 *math.pi* (_aa)*
(1 -math.clamp(d_a/_d,0,1)^0.75)local baa=(c_a+ (aaa))%
(2 *math.pi)local caa=math.random(30,60)
ad.__MOVEMENT_ANGLE=baa;ad.__MOVEMENT_DISTANCE=caa;ad.__MOVEMENT_START=__a.p;return"roaming"end end},["roaming"]={animationEquivalent="walking",transitionLevel=3,step=function(ad,bd)
if
(
ad.manifest.Position*dc-ad.__MOVEMENT_START*dc).magnitude<ad.__MOVEMENT_DISTANCE then
local cd=
CFrame.new(ad.manifest.Position)*CFrame.Angles(0,ad.__MOVEMENT_ANGLE,0)local dd=cd.lookVector*ad.baseSpeed
local __a=ad.manifest.Velocity
local a_a,b_a=cc.raycastForProjectile(Ray.new(ad.manifest.Position+cd.lookVector*
math.max(ad.manifest.Size.X,ad.manifest.Size.Z)/2,
cd.lookVector*ad.baseSpeed* (1 /10)),{ad.manifest})
if not a_a then
ad.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),cd.lookVector)
ad.manifest.BodyVelocity.Velocity=cd.lookVector*ad.baseSpeed else return"idling"end else return"idling"end end}}}