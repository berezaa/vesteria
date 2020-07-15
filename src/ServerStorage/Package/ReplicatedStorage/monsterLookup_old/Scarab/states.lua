local bc=game:GetService("Debris")
local cc=game:GetService("ReplicatedStorage")local dc=require(cc.modules)local _d=dc.load("utilities")
local ad=dc.load("detection")local bd=dc.load("network")local cd=dc.load("placeSetup")
local dd=dc.load("projectile")local __a=dc.load("placeSetup")local a_a=dc.load("tween")
local b_a=dc.load("effects")local c_a=__a.getPlaceFolder("entities")
local d_a=Random.new()
local function _aa(caa)local daa=140;local _ba=daa^2;local aba=nil;local bba=0
for cba,dba in
pairs(game:GetService("Players"):GetPlayers())do local _ca=dba.Character
if _ca then local aca=_ca.PrimaryPart;if aca then
local bca=aca.Position-caa.manifest.Position;local cca=bca.X^2 +bca.Z^2
if cca<=_ba and cca>bba then aba=aca;bba=cca end end end end;return aba end
local function aaa(caa,daa)
local _ba=(daa.Position-caa.manifest.Position).Magnitude;local aba=caa.aggressionRange;return(_ba<=aba)and
caa:isTargetEntityInLineOfSight(_ba,false,daa)end
local function baa(caa,daa,_ba)local aba=script.airBlastPart:Clone()
aba.CFrame=caa.CFrame*CFrame.new(0,
-caa.Size.Y*0.5,0)aba.Parent=c_a
a_a(aba,{"Size"},Vector3.new(2,2,2)*daa,0.25)a_a(aba,{"Transparency"},1,1)bc:AddItem(aba,1)local bba=
_ba.Position-aba.Position;local cba=bba.Magnitude;local dba=bba/cba
if cba<=
daa then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",caa,_ba.Position,"monster","airBlast")
bd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",dba*128)end end
return
{processDamageRequest=function(caa,daa)return daa,"physical","direct"end,getClosestEntities=function(caa)
local daa=_d.getEntities()
for i=#daa,1,-1 do local _ba=daa[i]if
(_ba.Name=="Scarab")or _ba==caa.manifest then table.remove(daa,i)end end;return daa end,onDamageReceived=function(caa,daa,_ba,aba)
if
daa=="player"then if caa.targetEntity then return end
if not _ba.Character then return end;local bba=_ba.Character.PrimaryPart;if not bba then return end
caa:setTargetEntity(bba,bba)end end,default="settingUp",states={["settingUp"]={animationEquivalent="idling",transitionLevel=0,step=function(caa)
caa.origin=caa.manifest.Position;caa.roamLast=tick()caa.roamTime=6;caa.roamRadius=32
caa.roamDestination=nil;caa.repositionRadius=64;caa.repositionSpeedModifier=3
caa.repositionDestination=nil;caa.attackCount=0;caa.launchThreshold={upper=0.7,lower=0.4}return"idling"end},["idling"]={transitionLevel=0,step=function(caa)if
caa.closestEntity and aaa(caa,caa.closestEntity)then
caa:setTargetEntity(caa.closestEntity,caa.closestEntity)end;if caa.targetEntity then
return"chasing"end;local daa=tick()-caa.roamLast;if daa>caa.roamTime then return
"roaming"end end},["launching"]={transitionLevel=0,lockTimeForPreventStateTransition=1.1,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(caa,daa)if
daa then return"repositioning"end end,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("entity")if not bba then return end
local cba=bba:FindFirstChild("CenterMouth")if not cba then return end
local dba=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not dba then return end;local _ca=dba.Value;if not _ca then return end
local aca=caa.Character;if not aca then return end;local bca=aca.PrimaryPart;if not bca then return end
local cca=bba:FindFirstChild("HumanoidRootPart")if not cca then return end;local dca=cca:FindFirstChild("launching")if
not dca then return end;dca:Play()
daa:GetMarkerReachedSignal("airBlast"):Wait()baa(_ca,24,bca)end},["landing"]={transitionLevel=0,lockTimeForPreventStateTransition=0.8,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(caa,daa)if
daa then return"chasing"end end,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not bba then return end;local cba=bba.Value;if not cba then return end
local dba=caa.Character;if not dba then return end;local _ca=dba.PrimaryPart;if not _ca then return end
daa:GetMarkerReachedSignal("airBlast"):Wait()baa(cba,24,_ca)end},["repositioning"]={animationEquivalent="flying",animationPriority=Enum.AnimationPriority.Action,transitionLevel=0,step=function(caa)local daa=
caa.health/caa.maxHealth;if
(daa>caa.launchThreshold.upper)or(daa<caa.launchThreshold.lower)then return
"landing"end
if
not caa.repositionDestination then local dba=math.pi*2 *d_a:NextNumber()local _ca=caa.repositionRadius*
d_a:NextNumber()local aca=Vector3.new(math.cos(dba)*_ca,0,
math.sin(dba)*_ca)caa.repositionDestination=
caa.origin+aca;caa.repositionStart=tick()end;local _ba=(caa.repositionDestination-caa.manifest.Position)*
Vector3.new(1,0,1)
local aba=_ba.Magnitude;local bba=_ba/aba
caa.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),_ba)
caa.manifest.BodyVelocity.Velocity=bba*caa.baseSpeed*caa.repositionSpeedModifier;local cba=tick()-caa.repositionStart
if(aba<2)or(cba>4)then
caa.manifest.BodyVelocity.Velocity=Vector3.new()caa.repositionDestination=nil;local dba=_aa(caa)
caa:setTargetEntity(dba,dba)return"spitting"end end},["spitting"]={doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,transitionLevel=0,lockTimeForPreventStateTransition=1.5,step=function(caa,daa)if
daa then return"repositioning"end
local _ba=caa.targetEntity or caa.closestEntity;if _ba then
local aba=(_ba.Position-caa.manifest.Position)*Vector3.new(1,0,1)
caa.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),aba)end end,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("entity")if not bba then return end
local cba=bba:FindFirstChild("CenterMouth")if not cba then return end
local dba=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not dba then return end;local _ca=dba.Value;if not _ca then return end
local aca=bba:FindFirstChild("HumanoidRootPart")if not aca then return end;local bca=aca:FindFirstChild("attacking2")if not
bca then return end;local cca=aca:FindFirstChild("spitImpact")if
not cca then return end;bca:Play()
local function dca(bda,cda,dda)if dda==nil then dda=64 end
local __b=script.spitPart:Clone()local a_b=cca:Clone()a_b.Parent=__b;__b.CFrame=CFrame.new(bda)
__b.Parent=c_a
local b_b,c_b=dd.getUnitVelocityToImpact_predictive(bda,dda,cda,Vector3.new())
dd.createProjectile(bda,b_b,dda,__b,function()local d_b=12;local _ab=0.25;a_b:Play()
a_a(__b,{"Size","Transparency"},{
Vector3.new(2,2,2)*d_b,1},_ab)bc:AddItem(__b,a_b.TimeLength)
local aab=game:GetService("Players").LocalPlayer.Character
if aab and aab.PrimaryPart then local bab=aab.PrimaryPart
local cab=(bab.Position-__b.Position).Magnitude;if cab<=d_b then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ca,bab.Position,"monster","spit")end end end,
nil,dd.makeIgnoreList{_ca,aba},true)end;local _da
local function ada()_da:Disconnect()_da=nil
local bda=_ca:FindFirstChild("targetEntity")if not bda then return end;local cda=bda.Value;if not cda then return end
local dda=_ca:FindFirstChild("health")if not dda then return end;local __b=_ca:FindFirstChild("maxHealth")if
not __b then return end;local a_b=dda.Value/__b.Value;local b_b=cba.Position
local c_b=cda.Position;local d_b=CFrame.new(b_b,c_b)
if a_b<0.5 then local _ab=96
local aab=d_b.RightVector*10;dca(b_b,c_b+aab,_ab)dca(b_b,c_b,_ab)
dca(b_b,c_b-aab,_ab)elseif a_b<0.6 then local _ab=80;local aab=d_b.RightVector*5
dca(b_b,c_b+aab,_ab)dca(b_b,c_b-aab,_ab)else dca(b_b,c_b,64)end end
_da=daa:GetMarkerReachedSignal("spit"):Connect(ada)end},["attacking"]={transitionLevel=0,lockTimeForPreventStateTransition=1.3,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("entity")if not bba then return end;local cba=bba:FindFirstChild("Tounge")if not cba then
return end
local dba=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not dba then return end;local _ca=dba.Value;if not _ca then return end
local aca=caa.Character;if not aca then return end;local bca=aca.PrimaryPart;if not bca then return end
local cca=bba:FindFirstChild("HumanoidRootPart")if not cca then return end
local dca={cca:FindFirstChild("attacking"),cca:FindFirstChild("attacking2")}if#dca<1 then return end
dca[math.random(1,#dca)]:Play()while not daa.IsPlaying do wait()end;local _da=false
while
daa.IsPlaying and(not _da)do
local ada=ad.projection_Box(bca.CFrame,bca.Size,cba.Position)
if
ad.boxcast_singleTarget(cba.CFrame,cba.Size*Vector3.new(2,4,4),ada)then _da=true
bd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_ca,ada,"monster","lash")end;wait(0.05)end end,step=function(caa,daa)if
daa then return"chasing"end end},["grabbing"]={transitionLevel=0,lockTimeForPreventStateTransition=0.5,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(caa,daa)
if
daa then local _ba={}
for dba,_ca in pairs(game.Players:GetPlayers())do
if _ca.Character then
local aca=_ca.Character.PrimaryPart
if aca then local bca=aca:FindFirstChild("state")if
bca and bca.Value~="dead"then table.insert(_ba,aca)end end end end
local aba=(caa.manifest.CFrame*CFrame.new(0,-caa.manifest.Size.Y/2,-
caa.manifest.Size.Z/2)).Position;local bba=6 ^2;local cba=nil
for dba,_ca in pairs(_ba)do local aca=_ca.Position-aba;local bca=aca.Y^2;local cca=
aca.X^2 +aca.Z^2
if(bca<=bba)and(cca<=bba)then bba=cca;cba=_ca end end
if cba then local dba=Instance.new("ObjectValue")dba.Name="devourTarget"
dba.Value=cba;dba.Parent=caa.manifest;return"devouring"else return"grabRecovering"end end end,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("entity")if not bba then return end
local cba=bba:FindFirstChild("HumanoidRootPart")if not cba then return end;local dba=cba:FindFirstChild("grabbing")if
not dba then return end;dba:Play()end},["devouring"]={transitionLevel=0,lockTimeForPreventStateTransition=2.7,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(caa,daa)
if
daa then
local _ba=caa.manifest:FindFirstChild("devourTarget")if _ba then _ba:Destroy()end;return"chasing"end end,execute=function(caa,daa,_ba,aba)
local bba=aba:FindFirstChild("entity")if not bba then return end
local cba=bba:FindFirstChild("CenterMouth")if not cba then return end
local dba=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not dba then return end;local _ca=dba.Value;if not _ca then return end
local aca=caa.Character;if not aca then return end;local bca=aca.PrimaryPart;if not bca then return end
local cca=_ca:FindFirstChild("devourTarget")if not cca then return end;local dca=cca.Value;if not dca then return end
local _da=bd:invoke("{D13D9151-7254-4ED9-8DEA-979E6B884458}",dca)if not _da then return end
local ada=bba:FindFirstChild("HumanoidRootPart")if not ada then return end;local bda=ada:FindFirstChild("devouring")if
not bda then return end;bda:Play()
b_a.onHeartbeatFor(2.1,function(cda,dda,__b)
dca.CFrame=
cba.CFrame*CFrame.new(2,0,0)*CFrame.Angles(math.pi/2,0,math.pi/2)dca.Velocity=Vector3.new()if(__b==1)and(bca==dca)then
bd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",
-dca.CFrame.UpVector*64)end end)
if bca==dca then local function cda()
bd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_ca,bca.Position,"monster","lash")end;local dda,__b
dda=daa:GetMarkerReachedSignal("munch"):Connect(cda)
__b=daa.Stopped:Connect(function()dda:Disconnect()__b:Disconnect()end)cda()end end},["grabRecovering"]={transitionLevel=0,lockTimeForPreventStateTransition=0.6,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(caa,daa)if
daa then return"chasing"end end},["chasing"]={animationEquivalent="walking",transitionLevel=0,step=function(caa)
local daa=caa.manifest.BodyVelocity;local _ba=caa.manifest.BodyGyro;if not caa.targetEntity then
daa.Velocity=Vector3.new()return"idling"end;if
not aaa(caa,caa.targetEntity)then daa.Velocity=Vector3.new()
caa:setTargetEntity(nil,nil)return"idling"end;local aba=caa.health/
caa.maxHealth;if(aba<caa.launchThreshold.upper)and(aba>
caa.launchThreshold.lower)then
daa.Velocity=Vector3.new()return"launching"end
local bba=(
caa.targetEntity.Position-caa.manifest.Position)*Vector3.new(1,0,1)local cba=bba.Unit
_ba.CFrame=CFrame.new(Vector3.new(),bba)daa.Velocity=cba*caa.baseSpeed
local dba=ad.projection_Box(caa.manifest.CFrame,caa.manifest.Size,caa.targetEntity.Position)
local _ca=ad.projection_Box(caa.targetEntity.CFrame,caa.targetEntity.Size,caa.manifest.Position)local aca=(_ca-dba).Magnitude
if aca<=caa.attackRange then
daa.Velocity=Vector3.new()caa.attackCount=caa.attackCount+1;if caa.attackCount%4 ==0 then return
"grabbing"else return"attacking"end end end},["roaming"]={animationEquivalent="walking",transitionLevel=0,step=function(caa)if
caa.closestEntity and aaa(caa,caa.closestEntity)then
caa:setTargetEntity(caa.closestEntity,caa.closestEntity)end;if caa.targetEntity then
return"chasing"end
if not caa.roamDestination then
local cba=caa.roamRadius*d_a:NextNumber()local dba=math.pi*2 *d_a:NextNumber()
local _ca=math.cos(dba)*cba;local aca=math.sin(dba)*cba
local bca=caa.origin+Vector3.new(_ca,0,aca)caa.roamDestination=bca;caa.roamLast=tick()end
local daa=(caa.roamDestination-caa.manifest.Position)*Vector3.new(1,0,1)local _ba=daa.Magnitude;local aba=daa/_ba
caa.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),daa)
caa.manifest.BodyVelocity.Velocity=aba*caa.baseSpeed;local bba=tick()-caa.roamLast
if(_ba<2)or(bba>4)then
caa.manifest.BodyVelocity.Velocity=Vector3.new()caa.roamDestination=nil;return"idling"end end}}}