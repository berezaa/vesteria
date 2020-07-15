local cb=game:GetService("Debris")
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _c=db.load("network")local ac=db.load("effects")
local bc=db.load("placeSetup")local cc=db.load("tween")local dc=db.load("utilities")
local _d=db.load("projectile")local ad=bc.awaitPlaceFolder("entities")
local function bd()
local __a=Instance.new("Part")__a.Anchored=true;__a.CanCollide=false
__a.TopSurface=Enum.SurfaceType.Smooth;__a.BottomSurface=Enum.SurfaceType.Smooth;__a.CastShadow=false
return __a end;local function cd(__a,a_a,b_a)return __a+ (a_a-__a)*b_a end;local dd
dd={acidSplash=function(__a)
local a_a=script.acidSplash:Clone()a_a.Position=__a.position;a_a.Parent=ad
cc(a_a,{"Size","Transparency"},{
Vector3.new(2,2,2)*__a.radius,1},__a.duration)
delay(__a.duration,function()a_a.emitter.Enabled=false
cb:AddItem(a_a,a_a.emitter.Lifetime.Max)end)end,bloodHeal=function(__a)
local a_a=__a.playerManifest;local b_a=__a.target;if not a_a then return end;if not b_a then return end
local c_a=_c:invoke("{D13D9151-7254-4ED9-8DEA-979E6B884458}",a_a)if not c_a then return end;local d_a=c_a:FindFirstChild("entity")if not d_a then
return end;local _aa=c_a.PrimaryPart;if not _aa then return end
local aaa=d_a:FindFirstChild("UpperTorso")if not aaa then return end
local function baa()local _ba=Instance.new("Part")
_ba.Anchored=true;_ba.CanCollide=false;_ba.TopSurface=Enum.SurfaceType.Smooth
_ba.BottomSurface=Enum.SurfaceType.Smooth;return _ba end
local function caa(_ba,aba,bba)local cba=1;local dba=16;local _ca=script.blood:Clone()local aca=_ca.trail
_ca.CFrame=_ba.CFrame;_ca.Parent=workspace.CurrentCamera;local bca=CFrame.Angles(0,0,bba)*
CFrame.new(0,dba,0)local cca=CFrame.Angles(0,0,-bba)*
CFrame.new(0,dba,0)
ac.onHeartbeatFor(cba,function(dca,_da,ada)
local bda=CFrame.new(_ba.Position,aba.Position)local cda=CFrame.new(aba.Position,_ba.Position)
local dda=bda.Position;local __b=(bda*bca).Position;local a_b=(cda*cca).Position
local b_b=cda.Position;local c_b=dda+ (__b-dda)*ada
local d_b=a_b+ (b_b-a_b)*ada;local _ab=c_b+ (d_b-c_b)*ada
_ca.CFrame=CFrame.new(_ab)end)
delay(cba,function()_ca.Transparency=1;aca.Enabled=false
game:GetService("Debris"):AddItem(_ca,aca.Lifetime)end)end
local function daa(_ba)
for blood=1,3 do local aba=(blood-2)* (math.pi/3)caa(_ba,aaa,aba)end
delay(1,function()local aba=script.restore:Clone()aba.Parent=_aa
aba:Play()cb:AddItem(aba,aba.TimeLength)local bba=1;local cba=baa()
cba.Shape=Enum.PartType.Ball;cba.Color=script.blood.Color
cba.Material=Enum.Material.Neon;cba.Size=Vector3.new()
cba.CFrame=CFrame.new(aaa.Position)cba.Parent=ad
cc(cba,{"Size","Transparency"},{Vector3.new(8,8,8),1},bba)
ac.onHeartbeatFor(bba,function()cba.CFrame=CFrame.new(aaa.Position)end)cb:AddItem(cba,bba)end)end;daa(b_a)end,lightning=function(__a)
local a_a=__a.startCFrame;local b_a=__a.pointCount or 14;local c_a=__a.segmentDeltaY or 4;local d_a=
__a.maxStutter or 4;local _aa=__a.duration or 0.5;local aaa=__a.color or
BrickColor.new("Electric blue").Color
local function baa(daa,_ba)local aba=0.5;local bba=bd()
bba.Color=aaa;bba.Material=Enum.Material.Neon;local cba=(_ba-daa).magnitude;local dba=
(daa+_ba)/2;bba.Size=Vector3.new(0.25,0.25,cba)
bba.CFrame=CFrame.new(dba,_ba)bba.Parent=ad;cc(bba,{"Transparency"},1,aba)
cb:AddItem(bba,aba)end;local caa=a_a
for pointNumber=2,b_a do local daa=math.pi*2 *math.random()local _ba=
math.cos(daa)*d_a*math.random()local aba=(pointNumber-1)*
c_a
local bba=math.sin(daa)*d_a*math.random()local cba=caa*CFrame.new(_ba,aba,bba)
baa(caa.Position,cba.Position)caa=cba end end,orbArrival=function(__a)
dd.orbAnnouncement()local a_a=Random.new(1231996)local b_a=__a.orb
local c_a=b_a.PrimaryPart.Position;local d_a=b_a.Parent;b_a.Parent=nil
local _aa=script.orbArrival:Clone()_aa.Position=c_a;_aa.Parent=ad;_aa.loop:Play()local aaa=1;local baa=0.05
local caa=32
for strikeNumber=1,caa do
for _=1,a_a:NextInteger(1,2)do
local bca=CFrame.new(c_a)*CFrame.Angles(0,math.pi*2 *
a_a:NextNumber(),0)*CFrame.Angles(
math.pi*0.125 *a_a:NextNumber(),0,0)dd.lightning{startCFrame=bca}end
_aa["strike"..a_a:NextInteger(1,6)]:Play()local aca=cd(aaa,baa,(strikeNumber-1)/caa)
wait(
(aca*0.5)+ (aca*0.5 *a_a:NextNumber()))end;local daa=4;_aa.emitter.Enabled=false
_aa.BrickColor=BrickColor.new("Electric blue")_aa.explosion:Play()wait(1)
cc(_aa,{"Size"},{
Vector3.new(1,1,1)*128},daa/4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
cc(_aa,{"Transparency"},{1},daa,Enum.EasingStyle.Linear)_aa.loop:Stop()cb:AddItem(_aa,daa)
local _ba=_d.makeIgnoreList{bc.awaitPlaceFolder("entityManifestCollection"),bc.awaitPlaceFolder("entityRenderCollection")}
local function aba(aca,bca,cca,dca)if dca==nil then dca=1 end;local _da=aca.Position;local ada=math.pi*0.4
local bda=Vector3.new(0,6,0)
for stepNumber=2,cca do local cda=_da+aca.LookVector*bca
local dda=Ray.new(cda+bda,-bda*2)
local __b,a_b=workspace:FindPartOnRayWithIgnoreList(dda,_ba)cda=a_b;local b_b=bd()b_b.Material=Enum.Material.Neon
b_b.BrickColor=BrickColor.new("Electric blue")b_b.CFrame=CFrame.new((_da+cda)/2,cda)b_b.Size=Vector3.new(0.2,0.2,(
cda-_da).Magnitude)
local c_b=script.orbEmitter:Clone()c_b.Parent=b_b;b_b.Parent=ad
spawn(function()for i=5,0,-1 do c_b.Rate=math.random(0,i*2)
wait(2)end;local d_b=5
cc(b_b,{"Transparency"},{1},d_b)cb:AddItem(b_b,d_b)end)if(stepNumber+1)%2 ==0 then
aba(aca,bca,cca-stepNumber,dca)end;_da=cda;dca=-dca
aca=aca*CFrame.Angles(0,ada*
a_a:NextNumber()*dca,0)aca=aca+ (_da-aca.Position)end end;local bba;do local aca=Ray.new(c_a,Vector3.new(0,-8,0))
local bca,cca=workspace:FindPartOnRayWithIgnoreList(aca,_ba)bba=cca end;local cba=
math.pi*2 *a_a:NextNumber()local dba=7
local _ca=math.pi*2 /dba
for crackNumber=1,dba do local aca=cba+_ca*crackNumber;aba(CFrame.new(bba)*
CFrame.Angles(0,aca,0),2,8)end;b_a.Parent=d_a;b_a.PrimaryPart.loop:Play()end,orbAnnouncement=function()
game.StarterGui:SetCore("ChatMakeSystemMessage",{Text="You feel a mystic presence echo through the night...",Color=BrickColor.new("Electric blue").Color,Font=Enum.Font.SourceSansBold})end,orbDeparture=function(__a)
local a_a=__a.orb;local b_a=a_a:GetPrimaryPartCFrame()local c_a=0;local d_a=0;local _aa=0;local aaa=16
ac.onHeartbeatFor(5,function(baa,caa,daa)_aa=
_aa+aaa*baa;d_a=d_a+_aa*baa;c_a=c_a+d_a*baa
a_a:SetPrimaryPartCFrame(
b_a+Vector3.new(0,c_a,0))end)end}
_c:connect("{CE48DECD-5222-4973-B0AB-89B662749171}","OnClientEvent",function(__a,a_a)dd[__a](a_a)end)