local bb=game:GetService("ReplicatedStorage")
local cb=require(bb.modules)local db=cb.load("pathfinding")local _c=cb.load("utilities")
local ac=cb.load("detection")local bc=cb.load("network")local cc=cb.load("projectile")
local dc=Vector3.new(1,0,1)local _d=100
local function ad(cd)
if cd.manifest.entityType.Value=="monster"then
local dd=game.Players:GetPlayers()[math.random(
#game.Players:GetPlayers())]
if dd and dd.Character and dd.Character.PrimaryPart then
local __a=cd.manifest.CFrame;cd.manifest.Size=Vector3.new(3,5,1)
cd.manifest.CFrame=__a
for a_a,b_a in
pairs(game.StarterPlayer.StarterCharacter.PrimaryPart:GetChildren())do
if b_a:IsA("ValueBase")and
not cd.manifest:FindFirstChild(b_a.Name)then b_a:Clone().Parent=cd.manifest end end
cd.manifest.mirrorValue.Value=dd.Character.PrimaryPart
cd.manifest.appearance.Value=dd.Character.PrimaryPart.appearance.Value;cd.manifest.entityType.Value="character"
cd.isTransformed=true;cd.hasTransformed=true end end end
local function bd(cd)cd.manifest.mirrorValue.Value=nil end
return
{default="setup",states={["setup"]={step=function(cd)cd.defaultHitboxSize=cd.manifest.Size
local dd=Instance.new("BodyPosition")dd.Parent=cd.manifest;dd.MaxForce=Vector3.new()
local __a=Instance.new("ObjectValue")__a.Parent=cd.manifest;__a.Name="mirrorValue"return"sleeping"end},["sleeping"]={step=function(cd)if
cd.closestEntity then return"idling"end end},["idling"]={lockTimeForPreventStateTransition=5,step=function(cd,dd)
cd.manifest.BodyVelocity.Velocity=Vector3.new()
if cd.closestEntity and dd then
local __a=_c.magnitude(cd.closestEntity.Position-cd.manifest.Position)
if not cd.hasTransformed then if dd and not cd.isTransformed then ad(cd)
return"disguised-idling"end end else return"sleeping"end end},["disguised-idling"]={animationEquivalent="idling",lockTimeForPreventStateTransition=1,step=function(cd,dd)
cd.manifest.BodyVelocity.Velocity=Vector3.new()
if dd then local __a=cd.origin.p;local a_a=0
local b_a=CFrame.new(cd.manifest.Position*dc)local c_a=CFrame.new(__a*dc)local d_a=(c_a.p-b_a.p).unit
local _aa=0
do
if d_a.magnitude>0 then local aba=b_a.lookVector;local bba=d_a:Dot(aba)
local cba=d_a:Cross(aba)_aa=math.acos(bba)
if cba.Y>0 then _aa=2 *math.pi-_aa end end end;local aaa=(b_a.p-c_a.p).magnitude
local baa=2 *math.random()-1;local caa=2 *math.pi* (baa)*
(1 -math.clamp(aaa/_d,0,1)^0.75)local daa=(_aa+ (caa))%
(2 *math.pi)local _ba=math.random(30,60)
cd.__MOVEMENT_ANGLE=daa;cd.__MOVEMENT_DISTANCE=_ba;cd.__MOVEMENT_START=b_a.p
return"disguised-roaming"end end},["disguised-roaming"]={animationEquivalent="walking",step=function(cd)
if
(
cd.manifest.Position*dc-cd.__MOVEMENT_START*dc).magnitude<cd.__MOVEMENT_DISTANCE then
local dd=
CFrame.new(cd.manifest.Position)*CFrame.Angles(0,cd.__MOVEMENT_ANGLE,0)local __a=dd.lookVector*cd.baseSpeed
local a_a=cd.manifest.Velocity
local b_a,c_a=cc.raycastForProjectile(Ray.new(cd.manifest.Position+dd.lookVector*
math.max(cd.manifest.Size.X,cd.manifest.Size.Z)/2,
dd.lookVector*cd.baseSpeed* (1 /10)),{cd.manifest})
if not b_a then
cd.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),dd.lookVector)
cd.manifest.BodyVelocity.Velocity=dd.lookVector*cd.baseSpeed else warn("back to idling")return"disguised-idling"end else return"disguised-idling"end end},["roaming"]={step=function(cd)
end},["transform-to-character"]={step=function(cd)cd.isTransformed=true end},["transform-back-to-monster"]={step=function(cd)
cd.isTransformed=false end},["attacking"]={step=function(cd)end},["lick"]={step=function(cd)end},["force-punch"]={animationEquivalent="forcepunch",lockTimeForPreventStateTransition=0.8,step=function(cd,dd)if
dd then return"idling"end end,execute=function(cd,dd,__a,a_a)
wait(dd.Length*0.5)local b_a=a_a.clientHitboxToServerHitboxReference.Value
local c_a=a_a.entity.LeftHand.Position;local d_a=a_a.entity.LeftHand.Size;local _aa=0.4;local aaa=0.6
a_a.entity.LeftHand.Transparency=1;local baa=a_a.entity.LeftHand:Clone()
baa.Transparency=aaa;baa.Anchored=true;baa.CanCollide=false
baa.Parent=workspace.CurrentCamera
cc.createProjectile(c_a,b_a.CFrame.lookVector,100,baa,function(caa,daa)game:GetService("Debris"):AddItem(baa,
2 /30)
if caa then
if
game.Players.LocalPlayer.Character and
caa==game.Players.LocalPlayer.Character.PrimaryPart then
bc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",b_a,daa,"monster",
nil,"rock-throw")end end;a_a.entity.LeftHand.Transparency=0 end,function(caa)baa.Transparency=
aaa* (1 -caa/_aa)^2;baa.Size=d_a+
d_a*7 * (caa/_aa)
return CFrame.Angles(math.rad(20),0,0)end,{a_a,workspace.CurrentCamera},
nil,0.0001,_aa)end},["taunt"]={step=function(cd)
end},["laugh"]={step=function(cd)end},["clap"]={step=function(cd)end},["teleport-enter"]={animationEquivalent="teleportExit",lockTimeForPreventStateTransition=1.3,step=function(cd,dd)
if
dd then
cd.manifest.CFrame=CFrame.new(cd.manifest.Position)+ (
Vector3.new(2 *
math.random()-1,0,2 *math.random()-1)*50)return"teleport-exit"end end,execute=function(cd,dd,__a,a_a)wait(
dd.Length*0.2)
local b_a=a_a.clientHitboxToServerHitboxReference.Value
local c_a=CFrame.new(b_a.Position)*
CFrame.new(0,0,- (b_a.Size.Z/2 +4))-
Vector3.new(0,b_a.Size.Y/2 -0.1,0)local d_a=script.jesterPortal:Clone()
d_a.Size=Vector3.new(0.2,0.1,0.2)d_a.CFrame=c_a;d_a.Parent=workspace.CurrentCamera
local _aa=dd.Length*0.4;local aaa=_aa/ (1 /30)
for i=1,aaa do
local baa=0.2 +

(script.jesterPortal.Size.X-0.2)* (1 -math.cos((i/aaa)*math.pi/2))
local caa=0.2 + (script.jesterPortal.Size.Z-0.2)*math.sin(
(i/aaa)*math.pi/2)d_a.Size=Vector3.new(baa,0.1,caa)d_a.CFrame=c_a
wait(1 /30)end;wait(dd.Length*0.3)wait(dd.Length*0.1)
d_a:Destroy()end},["teleport-exit"]={animationEquivalent="teleportEnter",lockTimeForPreventStateTransition=0.96,doNotStopAnimation=true,doNotLoopAnimation=true,step=function(cd,dd)if
dd then return"idling"end end,execute=function(cd,dd,__a,a_a)
local b_a=a_a.clientHitboxToServerHitboxReference.Value;local c_a=CFrame.new(b_a.Position)-
Vector3.new(0,b_a.Size.Y/2 -0.1,0)
local d_a=script.jesterPortal:Clone()d_a.Size=Vector3.new(0.2,0.1,0.2)d_a.CFrame=c_a
d_a.Parent=workspace.CurrentCamera;local _aa=0.15;local aaa=_aa/ (1 /30)
for i=1,aaa do
local baa=0.2 +

(script.jesterPortal.Size.X-0.2)* (1 -math.cos((i/aaa)*math.pi/2))
local caa=0.2 + (script.jesterPortal.Size.Z-0.2)*math.sin(
(i/aaa)*math.pi/2)d_a.Size=Vector3.new(baa,0.1,caa)d_a.CFrame=c_a
wait(1 /30)end;wait(0.4)d_a:Destroy()end}},processDamageRequestToMonster=function(cd,dd)
if

cd.state=="disguised-idling"or cd.state=="disguised-roaming"then warn("nullified damage due to disguise")dd.damage=0 end;return dd end,processDamageRequest=function(cd,dd)
if
cd=="venom-puddle"then return math.ceil(dd*0.25),"magical","dot"end;return dd,"physical","direct"end}