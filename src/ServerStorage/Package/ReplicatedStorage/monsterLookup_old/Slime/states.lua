local ab=game:GetService("ReplicatedStorage")
local bb=require(ab.modules)local cb=bb.load("utilities")local db=bb.load("detection")
local _c=bb.load("network")local ac=bb.load("placeSetup")local bc=bb.load("tween")
local cc=bb.load("projectile")local dc=ac.awaitPlaceFolder("entities")
local _d=require(script.Parent.Parent.Parent.defaultMonsterState)
return
{processDamageRequest=function(ad,bd)
if ad=="splash"then return bd,"magical","aoe"else return bd,"physical","direct"end end,getClosestEntities=function(ad)
local bd=cb.getEntities()
for i=#bd,1,-1 do local cd=bd[i]if
cd.Name==ad.monsterName or cd==ad.manifest then table.remove(bd,i)end end;return bd end,default="setup",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(ad)
if
ad.moveGoal then ad.__directRoamGoal=ad.moveGoal
ad.__directRoamOrigin=ad.manifest.Position;ad.__blockConfidence=0;ad.__LAST_ROAM_TIME=tick()return"direct-roam"end;return"idling"end},["attack-ready"]={animationEquivalent="idling",transitionLevel=5,step=function(ad)if
math.random(1,4)==1 then return"special-attacking"else return
_d.states["attack-ready"].step(ad)end end},["special-attacking"]={animationEquivalent="bouncing",transitionLevel=6,animationPriority=Enum.AnimationPriority.Action,doNotLoopAnimation=true,doNotStopAnimation=true,lockTimeForPreventStateTransition=3.5,step=function(ad,bd)
if
ad.targetEntity then local cd=(ad.targetEntity.Position-ad.manifest.Position)*
Vector3.new(1,0,1)
ad.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),cd)end
ad.manifest.BodyVelocity.Velocity=ad.manifest.CFrame.LookVector*6;if bd then return"idling"end end,execute=function(ad,bd,cd,dd)
local __a=dd:FindFirstChild("entity")if not __a then return end;local a_a=__a.PrimaryPart;if not a_a then return end
local b_a=dd:FindFirstChild("clientHitboxToServerHitboxReference")if not b_a then return end;local c_a=b_a.Value;if not c_a then return end
a_a.bouncing:Play()local d_a=6
local function _aa()
local caa=Ray.new(a_a.Position,Vector3.new(0,-16,0))
local daa,_ba=workspace:FindPartOnRayWithIgnoreList(caa,cc.makeIgnoreList{dd})local aba=script.slime:Clone()aba.CFrame=CFrame.new(_ba)*CFrame.Angles(0,0,
math.pi/2)
aba.Size=Vector3.new(0.1,1,1)aba.Parent=dc;local bba=d_a*2
bc(aba,{"Size"},{Vector3.new(0.1,bba,bba)},0.25)local cba=5
delay(cba-aba.emitter.Lifetime.Max,function()
aba.emitter.Enabled=false end)
bc(aba,{"Transparency"},{1},cba).Completed:Connect(function()
aba:Destroy()end)d_a=d_a+2;local dba=ad.Character;local _ca=dba.PrimaryPart
local aca=_ca.Position-_ba;local bca=math.abs(aca.Y)
local cca=math.sqrt(aca.X^2 +aca.Z^2)
if cca<=d_a and bca<4 then
_c:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",c_a,a_a.Position,"monster","splash")_ca.stamina.Value=-1 end end;local aaa,baa;do
aaa=bd:GetMarkerReachedSignal("slam"):Connect(_aa)
baa=bd.Stopped:Connect(function()aaa:Disconnect()baa:Disconnect()end)end end}}}