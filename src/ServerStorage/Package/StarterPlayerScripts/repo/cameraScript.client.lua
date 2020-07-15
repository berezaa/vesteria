local _ca=game:GetService("RunService")
local aca=workspace.CurrentCamera;local bca=game:GetService("UserInputService")
local cca=game.Players.LocalPlayer;local dca;local _da=10
game.Players.LocalPlayer.CameraMinZoomDistance=5
local ada=require(game.ReplicatedStorage:WaitForChild("modules"))local bda=ada.load("network")local cda=ada.load("tween")
local dda=ada.load("terrainUtil")local __b=ada.load("camera_shaker")
local a_b=ada.load("configuration")local b_b=-math.rad(20)local c_b=-math.rad(20)
local d_b=math.rad(90)local _ab=math.rad(80)local aab=math.rad(720)local bab=3;local cab=false
local dab=false
local function _bb(d_c,_ac)
local aac,bac,cac,dac=workspace:FindPartOnRayWithIgnoreList(d_c,_ac,true)
local _bc=workspace.placeFolders:FindFirstChild("items")
while
aac and not
(aac.CanCollide and dac~=Enum.Material.Water and(_bc==nil or not
aac:IsDescendantOf(_bc)))do _ac[#_ac+1]=aac
aac,bac,cac,dac=workspace:FindPartOnRayWithIgnoreList(d_c,_ac,true)end;return aac,bac,cac,dac end;local abb=CFrame.new(0,0,_da)
local bbb=game.SoundService.AmbientReverb;local cbb=workspace.CurrentCamera
if
game.PlaceId==2376885433 or
game.PlaceId==2015602902 or game.PlaceId==4623219432 then cbb=game.ReplicatedStorage end;local dbb=Instance.new("CFrameValue")dbb.Name="CFrameValue"
dbb.Parent=cbb;local _cb;local acb
bda:create("{08E952A3-3FAA-4AA6-A94D-BCD3F66B7F7B}","BindableFunction","OnInvoke",function(d_c)_cb=d_c;acb=false
if d_c then
if
workspace.CurrentCamera:FindFirstChild("overridden")==nil then
local _ac=Instance.new("BoolValue")_ac.Name="overridden"_ac.Parent=workspace.CurrentCamera end else if workspace.CurrentCamera:FindFirstChild("overridden")then
workspace.CurrentCamera.overridden:Destroy()end end end)
bda:create("{CBACD40D-5179-4164-AD3B-8BD2B2833CF8}","BindableFunction","OnInvoke",function(d_c,_ac,aac,bac)_cb=d_c;acb=false
if d_c then
if
workspace.CurrentCamera:FindFirstChild("overridden")==nil then
local cac=Instance.new("BoolValue")cac.Name="overridden"cac.Parent=workspace.CurrentCamera end;acb=true;b_b=_ac or b_b;c_b=aac or c_b;abb=bac or abb else if
workspace.CurrentCamera:FindFirstChild("overridden")then
workspace.CurrentCamera.overridden:Destroy()end end end)
local function bcb(d_c)if not dca or not dca.PrimaryPart then return end;local _ac
do
if dab then
_ac=

CFrame.new(dca.PrimaryPart.Position)+Vector3.new(0,0.25 +0.05 *_da,0)+
(CFrame.new(Vector3.new(),aca.CFrame.RightVector)*
CFrame.Angles(0,math.rad(10),0)).lookVector*1.75 else _ac=CFrame.new(dca.PrimaryPart.Position)+
Vector3.new(0,0.25 +0.05 *_da,0)end end;if _cb then
_ac=CFrame.new(_cb.Position)+Vector3.new(0,1,0)end
if not cab then
local aac=(_ac*CFrame.Angles(0,c_b,0)*
CFrame.Angles(b_b,0,0))*abb;local bac={workspace.CurrentCamera}
if
workspace:FindFirstChild("placeFolders")then table.insert(bac,workspace.placeFolders)end;local cac=aac.Position-_ac.Position
local dac=Ray.new(_ac.Position,cac)local _bc,abc=_bb(dac,bac)
dbb.Value=CFrame.new(abc-cac.unit,_ac.p)end;aca.Focus=aca.CFrame end
local function ccb(d_c,_ac,aac)
if d_c then cab=true
if _ac then cda(dbb,{"Value"},d_c,_ac,aac)else dbb.Value=d_c end
if
workspace.CurrentCamera:FindFirstChild("overridden")==nil then local bac=Instance.new("BoolValue")bac.Name="overridden"
bac.Parent=workspace.CurrentCamera end else if workspace.CurrentCamera:FindFirstChild("overridden")then
workspace.CurrentCamera.overridden:Destroy()end;cab=false end end;local dcb
dcb=__b.new(2,function(d_c)aca.CFrame=dbb.Value*d_c end)dcb:Start()
bda:create("{6E4CC329-38FC-4087-A3E8-9F4FB9E3A452}","BindableFunction","OnInvoke",function(d_c)local _ac=dcb
if d_c==nil then
_ac:Shake(__b.Presets.Explosion)elseif d_c=="bump"then _ac:Shake(__b.Presets.Bump)end end)
local function _db(d_c,_ac,aac,bac,cac,dac)
if d_c then cab=true
if _ac then cda(aca,{"CFrame"},d_c,_ac,bac)
spawn(function()wait(aac)
local _bc=dcb;if cac==nil then _bc:Shake(__b.Presets.Explosion)elseif cac=="bump"then
_bc:Shake(__b.Presets.Bump)end end)else dbb.Value=d_c end
if
workspace.CurrentCamera:FindFirstChild("overridden")==nil then local _bc=Instance.new("BoolValue")_bc.Name="overridden"
_bc.Parent=workspace.CurrentCamera end else if workspace.CurrentCamera:FindFirstChild("overridden")then
workspace.CurrentCamera.overridden:Destroy()end;cab=false end end
bda:create("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}","BindableFunction","OnInvoke",ccb)
bda:create("{7FBC244A-51A4-4A87-9F14-7CD7DE4DFCE2}","BindableFunction","OnInvoke",_db)local adb
local function bdb(d_c,_ac)if _ac then return false end
if d_c.KeyCode==Enum.KeyCode.ButtonR3 then
_da=_da-7
if _da<cca.CameraMinZoomDistance then _da=cca.CameraMaxZoomDistance end;if not acb then abb=CFrame.new(0,0,_da)end end
if d_c.UserInputType==Enum.UserInputType.MouseButton2 then
adb=d_c.Position elseif d_c.KeyCode==Enum.KeyCode.Left then
while

d_c.UserInputState~=Enum.UserInputState.Cancel and d_c.UserInputState~=Enum.UserInputState.End do
game:GetService("RunService").RenderStepped:wait()c_b=(c_b+0.04)%aab end elseif d_c.KeyCode==Enum.KeyCode.Right then
while

d_c.UserInputState~=Enum.UserInputState.Cancel and d_c.UserInputState~=Enum.UserInputState.End do
game:GetService("RunService").RenderStepped:wait()c_b=(c_b-0.04)%aab end elseif d_c.KeyCode==Enum.KeyCode.I then
_da=math.clamp(_da-7,cca.CameraMinZoomDistance,cca.CameraMaxZoomDistance)if not acb then abb=CFrame.new(0,0,_da)end elseif d_c.KeyCode==
Enum.KeyCode.O then
_da=math.clamp(_da+7,cca.CameraMinZoomDistance,cca.CameraMaxZoomDistance)if not acb then abb=CFrame.new(0,0,_da)end end end
local function cdb(d_c,_ac)if _ac then return false end
if
d_c.UserInputType==Enum.UserInputType.MouseMovement and(dab or adb)then local aac=d_c.Delta.X/5;local bac=
d_c.Delta.Y/5
if not acb then
b_b=math.clamp(b_b-math.rad(bac),-_ab,_ab)c_b=(c_b-math.rad(aac))%aab end elseif d_c.UserInputType==Enum.UserInputType.MouseWheel then
_da=math.clamp(_da-
(d_c.Position.Z),cca.CameraMinZoomDistance,cca.CameraMaxZoomDistance)if not acb then abb=CFrame.new(0,0,_da)end end end
local function ddb(d_c)if d_c.UserInputType==Enum.UserInputType.MouseButton2 then adb=nil elseif d_c.KeyCode==
Enum.KeyCode.Left then end end;local __c=game:GetService("UserInputService")ddy=0;ddx=0;local a_c
bda:create("{5741FB05-01DA-4A10-9006-76AAAE98E646}","BindableEvent","Event",function(d_c)
a_c=d_c end)
game:GetService("RunService").RenderStepped:connect(function()
if
a_c and a_c.magnitude>0.1 then local _ac=a_c.Y;local aac=a_c.X;if
math.abs(_ac)<0.1 then _ac=0;ddy=0 elseif math.abs(_ac)>0.5 then
ddy=math.clamp(ddy+math.abs(_ac/10),0,4)end;if
math.abs(aac)<0.1 then aac=0;ddx=0 elseif math.abs(aac)>0.5 then
ddx=math.clamp(ddx+math.abs(aac/10),0,4)end
local bac=aac* (1 +ddx)local cac=_ac* (1 +ddy)
if not acb then
b_b=math.clamp(b_b-math.rad(cac),-_ab,_ab)c_b=(c_b-math.rad(bac))%aab end end
local d_c=__c:GetGamepadState(Enum.UserInputType.Gamepad1)
if d_c then
for _ac,aac in pairs(d_c)do
if aac.KeyCode==Enum.KeyCode.Thumbstick2 then
local bac=aac.Position.Y;local cac=aac.Position.X;if math.abs(bac)<0.1 then bac=0;ddy=0 elseif
math.abs(bac)>0.5 then
ddy=math.clamp(ddy+math.abs(bac/10),0,4)end;if
math.abs(cac)<0.1 then cac=0;ddx=0 elseif math.abs(cac)>0.5 then
ddx=math.clamp(ddx+math.abs(cac/10),0,4)end
local dac=cac* (1 +ddx)local _bc=-bac* (1 +ddy)
if not acb then
b_b=math.clamp(b_b-math.rad(_bc),-_ab,_ab)c_b=(c_b-math.rad(dac))%aab end end end end end)
local function b_c(d_c)dca=d_c;if dab then bca.MouseBehavior=Enum.MouseBehavior.LockCenter else
bca.MouseBehavior=Enum.MouseBehavior.Default end end
local function c_c()if cca.Character then b_c(cca.Character)end
cca.CharacterAdded:connect(b_c)bca.InputBegan:connect(bdb)
bca.InputChanged:connect(cdb)bca.InputEnded:connect(ddb)
bda:create("{A1923ADF-D5CB-403B-8289-093517D98E38}","BindableEvent")
bda:create("{2646A2C6-D72A-4BD1-B53E-8106E381F2A9}","BindableFunction","OnInvoke",function()return dab end)
bda:create("{4D9203CB-18FC-42FB-809A-F586C2457CFC}","BindableFunction","OnInvoke",function(d_c)if d_c~=nil then dab=not not d_c else
dab=not dab end
if dab then
bca.MouseBehavior=Enum.MouseBehavior.LockCenter else bca.MouseBehavior=Enum.MouseBehavior.Default end
if dca and dca.PrimaryPart then
dca.PrimaryPart.hitboxGyro.D=5000
dca.PrimaryPart.hitboxGyro.MaxTorque=Vector3.new(100000000,100000000,100000000)dca.PrimaryPart.hitboxGyro.P=3000000 end
bda:fire("{A1923ADF-D5CB-403B-8289-093517D98E38}",dab)end)_ca:BindToRenderStep("cameraRenderUpdate",1,bcb)end;c_c()