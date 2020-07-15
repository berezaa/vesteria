local cb=game:GetService("ReplicatedStorage")
local db=require(cb.modules)local _c=db.load("pathfinding")local ac=db.load("utilities")
local bc=db.load("detection")local cc=db.load("network")local dc=db.load("projectile")
local _d=db.load("placeSetup")local ad=_d.getPlaceFolder("entities")local bd;local cd=1
local dd=Random.new()
return
{processDamageRequest=function(__a,a_a)return a_a,"physical","direct"end,getClosestEntities=function(__a)
local a_a=ac.getEntities()
for i=#a_a,1,-1 do local b_a=a_a[i]
if

b_a.Name=="Mo Ko Tu Aa"or b_a.Name==__a.monsterName or b_a==__a.manifest or b_a.Name=="Moglo"then table.remove(a_a,i)end end;return a_a end,default="idling",states={["idling"]={transitionLevel=2,step=function(__a)local a_a=
__a.__lastRotate or 0;local b_a=tick()-a_a;if b_a>=2 then
__a.__lastRotate=tick()
__a.manifest.BodyGyro.CFrame=CFrame.Angles(0,math.pi*2 *math.random(),0)end;local c_a=__a.targetEntity or
__a.closestEntity
if c_a then local d_a=ac.magnitude(c_a.Position-
__a.manifest.Position)local _aa=
__a.aggressionLockRange or __a.aggressionRange
if d_a<=_aa and
__a:isTargetEntityInLineOfSight(_aa,true)then __a:setTargetEntity(c_a)
return"attacking"else __a:setTargetEntity(nil)end end end},["attacking"]={transitionLevel=6,animationEquivalent="throw",animationPriority=Enum.AnimationPriority.Action,doNotStopAnimation=true,doNotLoopAnimation=true,step=function(__a)if
not __a.targetEntity then return"reloading"end
__a.manifest.BodyVelocity.Velocity=Vector3.new()
__a.manifest.BodyGyro.CFrame=CFrame.new(__a.manifest.Position,Vector3.new(__a.targetEntity.Position.X,__a.manifest.Position.Y,__a.targetEntity.Position.Z))return"attack-resting"end,execute=function(__a,a_a,b_a,c_a)
local d_a=c_a.clientHitboxToServerHitboxReference.Value;if not d_a then return end;if not d_a:FindFirstChild("targetEntity")then
return end;local _aa=d_a.targetEntity.Value
if not _aa then return end;local aaa=game.Players.LocalPlayer.Character
if not aaa then return end;local baa=_aa.Position;local caa=_aa.Velocity;local daa
do
daa=a_a.KeyframeReached:Connect(function(_ba)
if
_ba=="threwSpear"then daa:Disconnect()c_a.entity.Spear.Transparency=1
local aba=c_a.entity.Spear:Clone()aba.Transparency=0;aba.weld:Destroy()aba.Anchored=true
aba.CanCollide=false;aba.trail.Enabled=true;aba.Parent=ad
game:GetService("Debris"):AddItem(aba,15)local bba=48;local cba=aba.Position
local dba,_ca=dc.getUnitVelocityToImpact_predictive(cba,bba,baa,caa)if not dba then return end
dc.createProjectile(cba,dba,bba,aba,function(aca,bca)aba.Anchored=false
aba.trail.Enabled=false
game:GetService("Debris"):AddItem(aba,1)
if aca then local cca=Instance.new("WeldConstraint")cca.Part0=aca
cca.Part1=aba;cca.Parent=aba;if aca==aaa.PrimaryPart then
cc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",d_a,bca,"monster","rock-throw")end end end,function()return CFrame.Angles(
-math.pi/2,0,0)end,dc.makeIgnoreList{d_a,c_a},true)end end)end end},["attack-resting"]={transitionLevel=8,lockTimeForLowerTransition=0.5,animationEquivalent="idling",step=function(__a)return
"reloading"end},["reloading"]={transitionLevel=7,lockTimeForLowerTransition=0.8,animationEquivalent="reload",animationPriority=Enum.AnimationPriority.Action,doNotStopAnimation=true,doNotLoopAnimation=true,step=function(__a)return
"idling"end,execute=function(__a,a_a,b_a,c_a)local d_a;do
d_a=a_a.KeyframeReached:Connect(function(_aa)
if _aa=="grabbedNewSpear"then
d_a:Disconnect()c_a.entity.Spear.Transparency=0 end end)end end}}}