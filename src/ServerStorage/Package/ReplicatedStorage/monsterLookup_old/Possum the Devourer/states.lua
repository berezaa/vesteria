local dc=game:GetService("Debris")
local _d=game:GetService("ReplicatedStorage")local ad=require(_d.modules)local bd=ad.load("utilities")
local cd=ad.load("detection")local dd=ad.load("network")local __a=ad.load("placeSetup")
local a_a=ad.load("projectile")local b_a=ad.load("placeSetup")local c_a=ad.load("tween")
local d_a=ad.load("effects")local _aa=b_a.getPlaceFolder("entities")
local aaa=Random.new()
local function baa(bba)local cba=140;local dba=cba^2;local _ca=nil;local aca=0
for bca,cca in
pairs(game:GetService("Players"):GetPlayers())do local dca=cca.Character
if dca then local _da=dca.PrimaryPart;if _da then
local ada=_da.Position-bba.manifest.Position;local bda=ada.X^2 +ada.Z^2
if bda<=dba and bda>aca then _ca=_da;aca=bda end end end end;return _ca end
local function caa(bba,cba)
local dba=(cba.Position-bba.manifest.Position).Magnitude;local _ca=bba.aggressionRange;return(dba<=_ca)and
bba:isTargetEntityInLineOfSight(dba,false,cba)end
local function daa(bba,cba,dba)local _ca=script.airBlastPart:Clone()
_ca.CFrame=bba.CFrame*CFrame.new(0,
-bba.Size.Y*0.5,0)_ca.Parent=_aa
c_a(_ca,{"Size"},Vector3.new(2,2,2)*cba,0.25)c_a(_ca,{"Transparency"},1,1)dc:AddItem(_ca,1)local aca=
dba.Position-_ca.Position;local bca=aca.Magnitude;local cca=aca/bca
if bca<=
cba then
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",bba,dba.Position,"monster","airBlast")
dd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",cca*128)end end
local function _ba(bba,cba,dba)local _ca=bba.manifest;local aca=_ca.BodyVelocity;local bca=-aca.MaxForce;aca.MaxForce=
aca.MaxForce+bca
delay(dba,function()aca.MaxForce=aca.MaxForce-bca end)_ca.Velocity=_ca.Velocity+cba end
local function aba(bba)
return
function(cba,dba,_ca,aca)local bca=aca:FindFirstChild("entity")if not bca then return end
local cca=bca:FindFirstChild("Jaw")if not cca then return end
local dca=aca:FindFirstChild("clientHitboxToServerHitboxReference")if not dca then return end;local _da=dca.Value;if not _da then return end
local ada=cba.Character;if not ada then return end;local bda=ada.PrimaryPart;if not bda then return end
local cda=bca:FindFirstChild("HumanoidRootPart")if not cda then return end
dba:GetMarkerReachedSignal("startDamage"):Wait()local dda=false
while dba.IsPlaying and(not dda)do
local __b=cd.projection_Box(bda.CFrame,bda.Size,cca.Position)
if cd.boxcast_singleTarget(cca.CFrame,cca.Size*bba,__b)then dda=true
dd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_da,__b,"monster","lash")end;wait(0.05)end end end
return
{processDamageRequest=function(bba,cba)
if bba=="munch"then return cba*0.1,"physical","direct"else return cba,"physical","direct"end end,getClosestEntities=function(bba)
local cba=bd.getEntities()for i=#cba,1,-1 do local dba=cba[i]local _ca=dba:FindFirstChild("entityType")
if _ca and
_ca.Value~="character"then table.remove(cba,i)end end
return cba end,onDamageReceived=function(bba,cba,dba,_ca)
if
cba=="player"then if bba.targetEntity then return end
if not dba.Character then return end;local aca=dba.Character.PrimaryPart;if not aca then return end
bba:setTargetEntity(aca,aca)end end,default="settingUp",states={["settingUp"]={animationEquivalent="idling",transitionLevel=0,step=function(bba)
bba.origin=bba.manifest.Position;bba.roamLast=tick()bba.roamTime=6;bba.roamRadius=32
bba.roamDestination=nil;bba.chargeLast=0;bba.chargeTime=15;bba.chargeDuration=3
bba.chargeSpeedModifier=3;bba.attackCount=0;return"idling"end},["idling"]={transitionLevel=0,step=function(bba)if
bba.closestEntity and caa(bba,bba.closestEntity)then
bba:setTargetEntity(bba.closestEntity,bba.closestEntity)end;if bba.targetEntity then
return"chasing"end;local cba=tick()-bba.roamLast;if cba>bba.roamTime then return
"roaming"end end},["attacking"]={transitionLevel=0,lockTimeForPreventStateTransition=1.3,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=aba(Vector3.new(1,1,1)),step=function(bba,cba)if
cba then return"chasing"end end},["swipingLeft"]={transitionLevel=0,lockTimeForPreventStateTransition=1.3,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=aba(Vector3.new(1.5,1.5,1.5)),step=function(bba,cba)
local dba=bba.manifest.BodyVelocity
dba.Velocity=bba.manifest.CFrame.RightVector*bba.baseSpeed
if not bba.leaping then bba.leaping=true
delay(0.8,function()
local _ca=bba.manifest.CFrame*
CFrame.Angles(0,-math.pi/2,0)*CFrame.Angles(math.pi/4,0,0)_ba(bba,_ca.LookVector*64,1)
local aca=bba.manifest.BodyGyro
aca.CFrame=aca.CFrame*CFrame.Angles(0,math.pi/2,0)end)end
if cba then dba.Velocity=Vector3.new()bba.leaping=false;return"chasing"end end},["swipingRight"]={transitionLevel=0,lockTimeForPreventStateTransition=1.3,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=aba(Vector3.new(1.5,1.5,1.5)),step=function(bba,cba)
local dba=bba.manifest.BodyVelocity
dba.Velocity=-bba.manifest.CFrame.RightVector*bba.baseSpeed
if not bba.leaping then bba.leaping=true
delay(0.8,function()
local _ca=bba.manifest.CFrame*
CFrame.Angles(0,math.pi/2,0)*CFrame.Angles(math.pi/4,0,0)_ba(bba,_ca.LookVector*64,1)
local aca=bba.manifest.BodyGyro
aca.CFrame=aca.CFrame*CFrame.Angles(0,-math.pi/2,0)end)end
if cba then dba.Velocity=Vector3.new()bba.leaping=false;return"chasing"end end},["grabbing"]={transitionLevel=0,lockTimeForPreventStateTransition=0.2,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(bba,cba)
if
cba then local dba={}
for cca,dca in pairs(game.Players:GetPlayers())do
if dca.Character then
local _da=dca.Character.PrimaryPart
if _da then local ada=_da:FindFirstChild("state")if
ada and ada.Value~="dead"then table.insert(dba,_da)end end end end
local _ca=(bba.manifest.CFrame*CFrame.new(0,-bba.manifest.Size.Y/2,- (
bba.manifest.Size.Z/2)-7)).Position;local aca=6 ^2;local bca=nil
for cca,dca in pairs(dba)do local _da=dca.Position-_ca;local ada=_da.Y^2;local bda=
_da.X^2 +_da.Z^2
if(ada<=aca)and(bda<=aca)then aca=bda;bca=dca end end
if bca then local cca=Instance.new("ObjectValue")cca.Name="devourTarget"
cca.Value=bca;cca.Parent=bba.manifest;return"devouring"else return"grabRecovering"end end end,execute=function(bba,cba,dba,_ca)
local aca=_ca:FindFirstChild("entity")if not aca then return end
local bca=aca:FindFirstChild("HumanoidRootPart")if not bca then return end end},["devouring"]={transitionLevel=0,lockTimeForPreventStateTransition=5,doNotLoopAnimation=false,animationPriority=Enum.AnimationPriority.Action,step=function(bba,cba)
if
cba then
local dba=bba.manifest:FindFirstChild("devourTarget")if dba then dba:Destroy()end;return"grabRecovering"end end,execute=function(bba,cba,dba,_ca)
local aca=_ca:FindFirstChild("entity")if not aca then return end;local bca=aca:FindFirstChild("LowerTeeth")if not
bca then return end
local cca=_ca:FindFirstChild("clientHitboxToServerHitboxReference")if not cca then return end;local dca=cca.Value;if not dca then return end
local _da=bba.Character;if not _da then return end;local ada=_da.PrimaryPart;if not ada then return end
local bda=dca:FindFirstChild("devourTarget")if not bda then return end;local cda=bda.Value;if not cda then return end
local dda=dd:invoke("{D13D9151-7254-4ED9-8DEA-979E6B884458}",cda)if not dda then return end
local __b=aca:FindFirstChild("HumanoidRootPart")if not __b then return end
d_a.onHeartbeatFor(5.6,function(a_b,b_b,c_b)
cda.CFrame=
bca.CFrame*CFrame.new(0,1,-2)*CFrame.Angles(math.pi/2,0,0)cda.Velocity=Vector3.new()if(c_b==1)and(ada==cda)then
dd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",
-cda.CFrame.UpVector*64)end end)
if ada==cda then local function a_b()
dd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",dca,ada.Position,"monster","munch")end;local b_b,c_b
b_b=cba:GetMarkerReachedSignal("munch"):Connect(a_b)
c_b=cba.Stopped:Connect(function()b_b:Disconnect()c_b:Disconnect()end)a_b()end end},["grabRecovering"]={transitionLevel=0,lockTimeForPreventStateTransition=1,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,step=function(bba,cba)if
cba then return"chasing"end end},["charging"]={transitionLevel=0,animationPriority=Enum.AnimationPriority.Action,execute=function(bba,cba,dba,_ca)
local aca=_ca:FindFirstChild("entity")if not aca then return end
local bca={aca:FindFirstChild("Head"),aca:FindFirstChild("FrontTorso")}if#bca<2 then return end
local cca=_ca:FindFirstChild("clientHitboxToServerHitboxReference")if not cca then return end;local dca=cca.Value;if not dca then return end
local _da=bba.Character;if not _da then return end;local ada=_da.PrimaryPart;if not ada then return end
local bda=aca:FindFirstChild("HumanoidRootPart")if not bda then return end;local cda=false
while cba.IsPlaying and(not cda)do
for dda,__b in pairs(bca)do
local a_b=cd.projection_Box(ada.CFrame,ada.Size,__b.Position)
if
cd.boxcast_singleTarget(__b.CFrame,__b.Size*Vector3.new(1,1,1),a_b)then cda=true
dd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",dca,a_b,"monster","headbutt")local b_b=aca.PrimaryPart.Position;local c_b=ada.Position;local d_b=(c_b-b_b)*
Vector3.new(1,0,1)
local _ab=CFrame.new(Vector3.new(),d_b)*CFrame.Angles(
math.pi/4,0,0)local aab=_ab.LookVector
dd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",aab*128)end end;wait(0.05)end end,step=function(bba,cba)
local dba=bba.manifest.BodyVelocity;local _ca=bba.manifest.BodyGyro;if not caa(bba,bba.targetEntity)then return
"chasing"end
local aca=(bba.targetEntity.Position-
bba.manifest.Position)*Vector3.new(1,0,1)local bca=aca.Unit
_ca.CFrame=CFrame.new(Vector3.new(),aca)
dba.Velocity=bca*bba.baseSpeed*bba.chargeSpeedModifier
local cca=cd.projection_Box(bba.manifest.CFrame,bba.manifest.Size,bba.targetEntity.Position)
local dca=cd.projection_Box(bba.targetEntity.CFrame,bba.targetEntity.Size,bba.manifest.Position)local _da=(dca-cca).Magnitude;local ada=(_da<=bba.attackRange)local bda=tick()-
bba.chargeLast;local cda=(bda>=bba.chargeDuration)if
ada or cda then return"chargeRecovering"end end},["chargeRecovering"]={transitionLevel=0,lockTimeForPreventStateTransition=0.75,doNotLoopAnimation=true,animationPriority=Enum.AnimationPriority.Action,execute=function(bba,cba,dba,_ca)
local aca=_ca:FindFirstChild("entity")if not aca then return end;local bca=aca:FindFirstChild("Head")
if not bca then return end
local cca=_ca:FindFirstChild("clientHitboxToServerHitboxReference")if not cca then return end;local dca=cca.Value;if not dca then return end
local _da=bba.Character;if not _da then return end;local ada=_da.PrimaryPart;if not ada then return end
local bda=aca:FindFirstChild("HumanoidRootPart")if not bda then return end;local cda=false
while cba.IsPlaying and(not cda)do
local dda=cd.projection_Box(ada.CFrame,ada.Size,bca.Position)
if
cd.boxcast_singleTarget(bca.CFrame,bca.Size*Vector3.new(1,1,1),dda)then cda=true
dd:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",dca,dda,"monster","headbutt")local __b=aca.PrimaryPart.Position;local a_b=ada.Position;local b_b=(a_b-__b)*
Vector3.new(1,0,1)
local c_b=CFrame.new(Vector3.new(),b_b)*CFrame.Angles(
math.pi/4,0,0)local d_b=c_b.LookVector
dd:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",d_b*128)end;wait(0.05)end end,step=function(bba,cba)
local dba=bba.manifest.BodyVelocity;dba.Velocity=dba.Velocity*0.75;if cba then return"chasing"end end},["chasing"]={animationEquivalent="walking",transitionLevel=0,step=function(bba)
local cba=bba.manifest.BodyVelocity;local dba=bba.manifest.BodyGyro;if not bba.targetEntity then
cba.Velocity=Vector3.new()return"idling"end;if
not caa(bba,bba.targetEntity)then cba.Velocity=Vector3.new()
bba:setTargetEntity(nil,nil)return"idling"end;local _ca=tick()-
bba.chargeLast;if _ca>=bba.chargeTime then local ada=baa(bba)
if ada then
bba:setTargetEntity(ada,ada)bba.chargeLast=tick()return"charging"end end
local aca=(
bba.targetEntity.Position-bba.manifest.Position)*Vector3.new(1,0,1)local bca=aca.Unit
dba.CFrame=CFrame.new(Vector3.new(),aca)cba.Velocity=bca*bba.baseSpeed
local cca=cd.projection_Box(bba.manifest.CFrame,bba.manifest.Size,bba.targetEntity.Position)
local dca=cd.projection_Box(bba.targetEntity.CFrame,bba.targetEntity.Size,bba.manifest.Position)local _da=(dca-cca).Magnitude
if _da<=bba.attackRange then
cba.Velocity=Vector3.new()bba.attackCount=bba.attackCount+1;local ada=bba.attackCount%4
if
ada==6 then return"grabbing"else
local bda=(bba.manifest.CFrame*CFrame.Angles(0,math.pi/2,0)):PointToObjectSpace(bba.targetEntity.Position)local cda=math.deg(math.atan2(-bda.Z,bda.X))
if
cda<-45 then dba.CFrame=bba.manifest.CFrame;return"swipingRight"elseif cda>45 then
dba.CFrame=bba.manifest.CFrame;return"swipingLeft"else return"attacking"end end end end},["roaming"]={animationEquivalent="walking",transitionLevel=0,step=function(bba)if
bba.closestEntity and caa(bba,bba.closestEntity)then
bba:setTargetEntity(bba.closestEntity,bba.closestEntity)end;if bba.targetEntity then
return"chasing"end
if not bba.roamDestination then
local bca=bba.roamRadius*aaa:NextNumber()local cca=math.pi*2 *aaa:NextNumber()
local dca=math.cos(cca)*bca;local _da=math.sin(cca)*bca
local ada=bba.origin+Vector3.new(dca,0,_da)bba.roamDestination=ada;bba.roamLast=tick()end
local cba=(bba.roamDestination-bba.manifest.Position)*Vector3.new(1,0,1)local dba=cba.Magnitude;local _ca=cba/dba
bba.manifest.BodyGyro.CFrame=CFrame.new(Vector3.new(),cba)
bba.manifest.BodyVelocity.Velocity=_ca*bba.baseSpeed;local aca=tick()-bba.roamLast
if(dba<2)or(aca>4)then
bba.manifest.BodyVelocity.Velocity=Vector3.new()bba.roamDestination=nil;return"idling"end end}}}