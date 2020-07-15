local _c=game:GetService("Debris")
local ac=game:GetService("ReplicatedStorage")local bc=require(ac.modules)local cc=bc.load("utilities")
local dc=bc.load("detection")local _d=bc.load("network")local ad=bc.load("placeSetup")
local bd=bc.load("projectile")local cd=bc.load("placeSetup")local dd=bc.load("tween")
local __a=bc.load("effects")local a_a=cd.getPlaceFolder("entities")local b_a=Random.new()
local function c_a(d_a,_aa)
local aaa=(
_aa.Position-d_a.manifest.Position).Magnitude;local baa=d_a.aggressionLockRange or d_a.aggressionRange;return
(
aaa<=baa)and d_a:isTargetEntityInLineOfSight(aaa,false,_aa)end
return
{processDamageRequest=function(d_a,_aa)return _aa,"physical","direct"end,getClosestEntities=function(d_a)
local _aa=cc.getEntities()
for i=#_aa,1,-1 do local aaa=_aa[i]if
(aaa.Name=="Deathsting")or(aaa.Name=="Dustwurm")or(aaa.Name=="Stingtail")or
aaa==d_a.manifest then
table.remove(_aa,i)end end;return _aa end,onDamageReceived=function(d_a,_aa,aaa,baa)
if
_aa=="player"then if not aaa.Character then return end
local caa=aaa.Character.PrimaryPart;if not caa then return end;d_a:setTargetEntity(caa,caa)end end,default="settingUp",states={["settingUp"]={animationEquivalent="idling",transitionLevel=0,step=function(d_a)
d_a.origin=d_a.manifest.Position;d_a.spitLast=0;d_a.spitTime=6;return"idling"end},["idling"]={transitionLevel=0,step=function(d_a)if
d_a.closestEntity and c_a(d_a,d_a.closestEntity)then
d_a:setTargetEntity(d_a.closestEntity,d_a.closestEntity)end;if d_a.targetEntity then
return"aiming"end end},["aiming"]={transitionLevel=0,animationEquivalent="idling",step=function(d_a)
local _aa=d_a.targetEntity
if _aa then
local aaa=(_aa.Position-d_a.manifest.Position)*Vector3.new(1,0,1)
d_a.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),aaa)
if aaa.magnitude<10 then return"attacking"elseif(aaa.magnitude>d_a.attackRange)or
(not c_a(d_a,_aa))then d_a:setTargetEntity(nil,nil)
return"idling"else local baa=tick()-d_a.spitLast;if baa>d_a.spitTime then
d_a.spitLast=tick()return"spitting"end end else return"idling"end end},["spitting"]={doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,transitionLevel=0,lockTimeForPreventStateTransition=2.8,step=function(d_a,_aa)if
_aa then return"aiming"end
local aaa=d_a.targetEntity or d_a.closestEntity;if aaa then
local baa=(aaa.Position-d_a.manifest.Position)*Vector3.new(1,0,1)
d_a.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),baa)end end,execute=function(d_a,_aa,aaa,baa)
local caa=baa:FindFirstChild("entity")if not caa then return end;local daa=caa:FindFirstChild("Head")
if not daa then return end
local _ba=baa:FindFirstChild("clientHitboxToServerHitboxReference")if not _ba then return end;local aba=_ba.Value;if not aba then return end
local bba=caa:FindFirstChild("HumanoidRootPart")if not bba then return end;local cba=bba:FindFirstChild("spitting")if
not cba then return end
local function dba(bca,cca,dca)if dca==nil then dca=64 end;cba:Play()
local _da=script.spitPart:Clone()local ada=_da.impact;_da.CFrame=CFrame.new(bca)_da.Parent=a_a
local bda,cda=bd.getUnitVelocityToImpact_predictive(bca,dca,cca,Vector3.new())
bd.createProjectile(bca,bda,dca,_da,function()local dda=6;local __b=0.25
dd(_da,{"Size","Transparency"},{Vector3.new(2,2,2)*
dda,1},__b)ada:Play()
_c:AddItem(_da,ada.TimeLength/ada.PlaybackSpeed)
local a_b=game:GetService("Players").LocalPlayer.Character
if a_b and a_b.PrimaryPart then local b_b=a_b.PrimaryPart
local c_b=(b_b.Position-_da.Position).Magnitude;if c_b<=dda then
_d:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aba,b_b.Position,"monster","spit")end end end,
nil,bd.makeIgnoreList{aba,baa},true)end;local _ca
local function aca()_ca:Disconnect()_ca=nil
local bca=aba:FindFirstChild("targetEntity")if not bca then return end;local cca=bca.Value;if not cca then return end
local dca=daa.Position;local _da=cca.Position;dba(dca,_da,64)end
_ca=_aa:GetMarkerReachedSignal("spit"):Connect(aca)end},["digging"]={transitionLevel=0,animationEquivalent="idling",step=function(d_a,_aa)local aaa=
math.pi*2 *math.random()
local baa=32 *math.random()
local caa=Vector3.new(math.cos(aaa)*baa,0,math.sin(aaa)*baa)local daa=d_a.origin+caa;local _ba=512
local aba=Ray.new(daa+Vector3.new(0,_ba/2,0),Vector3.new(0,
-_ba,0))
local bba,cba=workspace:FindPartOnRayWithIgnoreList(aba,bd.makeIgnoreList{cd.getPlaceFolder("entityManifestCollection")})
d_a.manifest.CFrame=CFrame.new(cba+
Vector3.new(0,d_a.manifest.Size.Y/2,0))return"aiming"end},["attacking"]={transitionLevel=0,lockTimeForPreventStateTransition=1.8,doNotLoopAnimation=true,doNotStopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=function(d_a,_aa,aaa,baa)
local caa=baa:FindFirstChild("entity")if not caa then return end;local daa=caa:FindFirstChild("Head")
if not daa then return end
local _ba=baa:FindFirstChild("clientHitboxToServerHitboxReference")if not _ba then return end;local aba=_ba.Value;if not aba then return end
local bba=d_a.Character;if not bba then return end;local cba=bba.PrimaryPart;if not cba then return end;while
not _aa.IsPlaying do wait()end;local dba=false
while _aa.IsPlaying and(not dba)do
local _ca=dc.projection_Box(cba.CFrame,cba.Size,daa.Position)if dc.boxcast_singleTarget(daa.CFrame,daa.Size*2,_ca)then dba=true
_d:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",aba,_ca,"monster","lash")end
wait(0.05)end end,step=function(d_a,_aa)if
_aa then return"digging"end end}}}