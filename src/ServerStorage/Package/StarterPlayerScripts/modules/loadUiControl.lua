
return
function()
spawn(function()script.Parent:WaitForChild("blackout")
script.Parent.blackout.Visible=true;script.Parent.blackout.BackgroundTransparency=0 end)local a;local b=game:GetService("RunService")local c=true;local d=true
local function _a()
local adb=game:GetService("ReplicatedStorage")local bdb=require(adb.modules)local cdb=bdb.load("network")
local ddb=bdb.load("levels")local __c=bdb.load("tween")
local a_c=game:GetService("ContentProvider")local b_c=game:GetService("RunService")
local c_c=game:GetService("TeleportService")local d_c=c_c:GetTeleportSetting("arrivingTeleportId")
if d_c and(d_c~=
2015602902 and d_c~=2376885433)then return false end;local _ac={}
table.insert(_ac,game.ReplicatedStorage:WaitForChild("characterAnimations"))
table.insert(_ac,game.ReplicatedStorage:WaitForChild("sounds"))
table.insert(_ac,game:GetService("StarterGui"))
table.insert(_ac,game.ReplicatedStorage:WaitForChild("accessoryLookup"))
spawn(function()script.Parent.spinner.Visible=true
local aac=a_c.RequestQueueSize
while d do local bac=a_c.RequestQueueSize;if bac>aac then aac=bac end;local cac=aac-bac;script.Parent.spinner.Rotation=
script.Parent.spinner.Rotation+2
b_c.RenderStepped:wait()end end)a_c:PreloadAsync({script.Parent})
a_c:PreloadAsync(_ac)script.Parent.spinner.Image="rbxgameasset://accept"
script.Parent.spinner.ImageColor3=Color3.fromRGB(132,255,98)script.Parent.spinner.Rotation=0
script.Parent.blackout.BorderColor3=Color3.fromRGB(132,255,98)d=false end;wait()local aa=game.Players.LocalPlayer
local ba=aa:GetRankInGroup(4238824)local ca=true;local da=ba>=2;if not ca then
script.Parent.menustatus.Text="The game is currently closed. Please come back another time."return false end
script.Parent.blackout.TextLabel.Visible=false;spawn(_a)
script.Parent.menustatus.Text="Loading game files..."local _b=game:GetService("ReplicatedStorage")
local ab=require(_b.modules)local bb=ab.load("network")local cb=ab.load("levels")
local db=ab.load("tween")local _c=ab.load("configuration")local ac=ab.load("utilities")
local bc=require(script.Parent.money)
local cc=require(script.Parent.deathScreen.deathScreen)
cc.init({network=bb,levels=cb,tween=db,utilities=ac,money=bc})local dc=true
if not dc then wait(5)script.Parent.main.Visible=false
script.Parent.landing.Visible=false;script.Parent.leftBar.Visible=false;wait(1)
db(script.Parent.blackout,{"BackgroundTransparency"},{1},3)
script.Parent.menustatus.Text="The game is currently closed. Please check back later."return false end
script.Parent.menustatus.Text="Loading data from server..."
local _d,ad=bb:invokeServer("{382D6FC6-8F3C-45EE-936D-EBEB74BF5928}")local bd;if _d then bd=ad else
script.Parent.menustatus.Text="Failed to load data."wait(3)end;c=false
script.Parent.Notice.Visible=false;script.Parent.menustatus.Visible=false
script.Parent.blackout.Visible=true
script.Parent.blackout.TextLabel.Visible=false;script.Parent.landing.Visible=false
script.Parent.customize.Visible=false;script.Parent.main.Visible=false
script.Parent.onlineFriends.Visible=false
script.Parent.main.Frame.PlayButton.Visible=false
local cd=require(script.Parent:WaitForChild("input"))
if cd.mode.Value=="xbox"or
game:GetService("UserInputService").GamepadEnabled then
game.GuiService.GuiNavigationEnabled=true;game.GuiService.AutoSelectGuiEnabled=true
game.GuiService.SelectedObject=script.Parent.landing.play end;local dd;local __a
spawn(function()local adb={}
while true do local bdb
local cdb,ddb=pcall(function()
bdb=game.Players.LocalPlayer:GetFriendsOnline()end)
if cdb then
local __c=bb:invokeServer("{DECA62CA-EC7F-47C3-84D9-F1525D445BC5}",bdb)
if __c then
for a_c,b_c in pairs(adb)do if b_c then b_c:Destroy()end end;adb={}
for a_c,b_c in pairs(__c)do
local c_c=script.Parent.onlineFriends.SampleFriend:Clone()c_c.username.Text=b_c.UserName
c_c.location.Text=b_c.LastLocation
c_c.thumbnail.Image="https://www.roblox.com/headshot-thumbnail/image?userId="..
b_c.VisitorId.."&width=100&height=100&format=png"c_c.Parent=script.Parent.onlineFriends;c_c.Visible=true
table.insert(adb,c_c)end
script.Parent.onlineFriends.title.Visible=false;if#adb>0 then
script.Parent.onlineFriends.title.Visible=true end end;wait(30)else warn("GetOnlineFriends failed!")wait(10)end end end)
function noticeskip()script.Parent.Notice.Visible=false
script.Parent.main.Visible=true
spawn(function()
local adb=require(script.Parent.main.serverMessage.serverMessage)adb.init()end)script.Parent.onlineFriends.Visible=true;if cd.mode.Value==
"xbox"then game.GuiService.GuiNavigationEnabled=true
game.GuiService.SelectedObject=cd.getBestButton(script.Parent.main.Frame)end
script.swoosh:Play()end
function land()script.Parent.landing.Visible=false
game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat,true)
game.StarterGui:SetCore("ChatBarDisabled",false)game.StarterGui:SetCore("ChatActive",true)
game.StarterGui:SetCore("ChatWindowPosition",UDim2.new(0.7,
-10,0.7,-30))script.Parent.Notice.Visible=true;noticeskip()if
cd.mode.Value=="xbox"then game.GuiService.GuiNavigationEnabled=true
game.GuiService.SelectedObject=cd.getBestButton(script.Parent.Notice)end end;land()
script.Parent.Notice.ok.MouseButton1Click:connect(noticeskip)
game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(1)
local function a_a()
if cd.mode.Value=="xbox"then
script.Parent.customize.buttons.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
script.Parent.customize.shirtColor.UIGridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
script.Parent.customize.hairColor.UIGridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
script.Parent.customize.hairColor.Position=UDim2.new(0.5,0,0,90)
script.Parent.customize.hairColor.AnchorPoint=Vector2.new(0.5,0)
script.Parent.customize.shirtColor.Position=UDim2.new(0.5,0,0,90)
script.Parent.customize.shirtColor.AnchorPoint=Vector2.new(0.5,0)else
script.Parent.customize.buttons.UIListLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
script.Parent.customize.shirtColor.UIGridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
script.Parent.customize.hairColor.UIGridLayout.HorizontalAlignment=Enum.HorizontalAlignment.Left
script.Parent.customize.hairColor.Position=UDim2.new(0,5,0,90)
script.Parent.customize.hairColor.AnchorPoint=Vector2.new(0,0)
script.Parent.customize.shirtColor.Position=UDim2.new(0,5,0,90)
script.Parent.customize.shirtColor.AnchorPoint=Vector2.new(0,0)end end;cd.mode.Changed:connect(a_a)a_a()
script.Parent:WaitForChild("CameraLookat")script.Parent:WaitForChild("CameraOrigin")
local b_a=game:GetService("RunService")local c_a;local d_a=true;local _aa=Instance.new("Folder")
_aa.Name="renderedOptions"_aa.Parent=workspace;local aaa;local baa=Random.new(os.time())
local caa={}
_aa.DescendantAdded:connect(function(adb)
if adb.Name=="bodyPart"then local bdb=adb.Parent
bdb.Color=c_a:FindFirstChild("skinColor"):FindFirstChild(tostring(caa.accessories.skinColorId)).Value elseif adb.Name=="hair_Head"and adb:IsA("BasePart")then
adb.Color=c_a:FindFirstChild("hairColor"):FindFirstChild(tostring(caa.accessories.hairColorId)).Value elseif adb.Name=="shirt"or adb.Name=="shirtTag"then if
adb.Name=="shirtTag"then adb=adb.Parent end;if adb:IsA("BasePart")then
adb.Color=c_a:FindFirstChild("shirtColor"):FindFirstChild(tostring(caa.accessories.shirtColorId)).Value end end end)repeat wait()until not d;wait(1)
db(script.Parent.blackout,{"BackgroundTransparency"},1,1)local daa
local function _ba(adb)for bdb,cdb in pairs(_aa:GetChildren())do
if adb:IsDescendantOf(cdb)then return cdb end end end;local aba
local function bba(adb)
if aba and aba.Parent then aba.PrimaryPart.Transparency=1;aba=nil end
if adb then aba=adb;adb.PrimaryPart.Transparency=0.3 end end;local cba=cd;local dba
function InputChanged(adb,bdb)if

adb.UserInputType==Enum.UserInputType.MouseMovement or adb.UserInputType==Enum.UserInputType.Touch then dba=adb end end;local _ca=3;local aca=15
local bca=CFrame.new(script.Parent.CameraOrigin.Value,script.Parent.CameraLookat.Value)local cca=bca-bca.lookVector*aca;local dca=cca;local _da=tick()
b_a:BindToRenderStep("render",
Enum.RenderPriority.Camera.Value-1,function()local adb
if tick()-_da<_ca then
local __c=bca.lookVector*aca;local a_c=math.clamp((tick()-_da)/_ca,0,1)dca=cca+__c*a_c^
(1 /7)elseif not adb then adb=true;dca=bca end;local bdb=0;local cdb,ddb
if script.Parent.customize.Visible then
dca=script.Parent.CameraTablePos.Value
if dca==script.Parent.CameraTablePos.Value then bdb=50 end
if dba then
workspace.CurrentCamera.CFrame=script.Parent.CameraTablePos.Value
local __c=workspace.CurrentCamera:ScreenPointToRay(dba.Position.X,dba.Position.Y,0)local a_c=_aa:GetChildren()
if#a_c>0 and(cba.mode.Value=="pc"or cba.mode.Value==
"mobile")then
local b_c,c_c=workspace:FindPartOnRayWithWhitelist(Ray.new(__c.Origin,
__c.Direction*250),a_c,true)if b_c then local d_c=_ba(b_c)bba(d_c)else bba()end end end elseif not daa then bdb=100 end
if bdb>0 then
if dba and adb then
local __c=workspace.CurrentCamera:ScreenPointToRay(dba.Position.X,dba.Position.Y,bdb)cdb,ddb=workspace:FindPartOnRay(__c)if ddb then local a_c=dca.Position+
dca.lookVector*50
a_c=Vector3.new(ddb.x+a_c.x*25,ddb.y+a_c.y*
25,ddb.z+a_c.z*25)/26;dba=nil end elseif
not adb then end end end)
local ada=game:GetService("UserInputService").InputChanged:connect(InputChanged)local bda=0
game:GetService("UserInputService").InputBegan:connect(function(adb,bdb)
if
not bdb and
(adb.UserInputType==Enum.UserInputType.MouseButton1 or
adb.UserInputType==Enum.UserInputType.Touch)then bda=tick()
InputChanged(adb,bdb)end end)local cda
game:GetService("UserInputService").InputEnded:connect(function(adb,bdb)
if

not bdb and
(adb.UserInputType==Enum.UserInputType.MouseButton1 or
adb.UserInputType==Enum.UserInputType.Touch)and tick()-bda<=2 then
if aba then local cdb=cda;if cdb=="skinColor"then cdb="skinColorId"end
caa.accessories[cdb]=tonumber(aba.Name)
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",aaa.entity,caa)end end end)
local dda=script.Parent.Notice.content.referral;local __b
script.Parent.Notice.content.referral.invite.Frame.send.Activated:connect(function()
if
not __b then __b=true;dda.invite.Visible=false;dda.status.Visible=true
dda.status.wait.Visible=true;dda.status.status.Visible=false
local adb,bdb=bb:invokeServer("{61693BA9-0B4F-47ED-B6F1-B1BC6D6C126A}",dda.invite.Frame.code.TextBox.Text)
if
game.Players.LocalPlayer:FindFirstChild("acceptedReferral")==nil then
dda.status.wait.Visible=false;dda.status.status.Visible=true
dda.status.status.Text=bdb
if not adb then wait(3)dda.status.Visible=false;dda.invite.Visible=true end end;__b=false end end)
game.Players.LocalPlayer.ChildAdded:connect(function(adb)
if
adb.Name=="acceptedReferral"then
dda.status.status.Text="Referral accepted! Play now to recieve 200 free Ethyr."dda.status.Visible=true;dda.invite.Visible=false
dda.status.status.Visible=true;dda.status.wait.Visible=false end end)local a_b
game.Players.LocalPlayer.ChildRemoved:connect(function(adb)
if



dda.status.Visible and
game.Players.LocalPlayer:FindFirstChild("acceptedReferral")==nil and
game.Players.LocalPlayer:FindFirstChild("messagePending")==nil and not a_b then a_b=true;dda.status.status.Visible=true
dda.status.Visible=true;dda.invite.Visible=false;dda.status.wait.Visible=false
dda.status.status.Text="Referral timed out. Please confirm you entered the username correctly and that the player is online"wait(3)a_b=false;dda.status.Visible=false
dda.invite.Visible=true end end)
local function b_b()
for adb,bdb in
pairs(script.Parent.main.Frame.DataSlots:GetChildren())do if bdb:IsA("ImageButton")then
bdb.ImageColor3=Color3.fromRGB(126,126,126)
bdb.PlayerData.Frame.ImageColor3=Color3.fromRGB(36,36,36)end end end;local c_b=script.Parent.main.play
script.Parent.DataSlot.Changed:Connect(function()
b_b()local adb=script.Parent.DataSlot.Value
local bdb=script.Parent.main.Frame.DataSlots:FindFirstChild(tostring(adb))
if adb and bdb then c_b.Visible=true
bdb.ImageColor3=Color3.fromRGB(57,212,255)
bdb.PlayerData.Frame.ImageColor3=Color3.fromRGB(11,73,111)c_b.Flutter.ImageTransparency=0.3
c_b.Flutter.Size=UDim2.new(1,0,1,0)c_b.Flutter.Visible=true
db(c_b.Flutter,{"Size","ImageTransparency"},{UDim2.new(3,0,3,0),1},0.3)else c_b.Visible=false end end)local d_b=false;local _ab=false
local function aab(adb)local bdb=Vector3.new()local cdb=0;for ddb,__c in
pairs(adb:GetChildren())do
if __c:IsA("BasePart")then bdb=bdb+__c.Position;cdb=cdb+1 end end;return bdb/cdb end
local function bab()
for adb,bdb in pairs(_aa:GetDescendants())do
if bdb.Name=="bodyPart"then local cdb=bdb.Parent
cdb.Color=c_a:FindFirstChild("skinColor"):FindFirstChild(tostring(
caa.accessories.skinColorId or 1)).Value elseif bdb.Name=="hair_Head"and bdb:IsA("BasePart")then
bdb.Color=c_a:FindFirstChild("hairColor"):FindFirstChild(tostring(
caa.accessories.hairColorId or 1)).Value elseif bdb.Name=="shirt"or bdb:FindFirstChild("shirtTag")then
bdb.Color=c_a:FindFirstChild("shirtColor"):FindFirstChild(tostring(
caa.accessories.shirtColorId or 1)).Value end end
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",aaa.entity,caa)end
local function cab(adb)local bdb
if adb:IsA("Color3Value")then
bdb=script.colorRepre:Clone()bdb.value.Color=adb.Value;bdb.Name=adb.Name else bdb=adb:Clone()end;local cdb=aab(bdb)
for a_c,b_c in pairs(bdb:GetDescendants())do
if b_c:IsA("BasePart")then
if

b_c.Parent==bdb and b_c:FindFirstChild("colorOverride")==nil then local c_c=Instance.new("BoolValue")c_c.Name="bodyPart"
c_c.Parent=b_c else b_c.Parent=bdb end;b_c.Anchored=true end end;local ddb=Instance.new("Part")
ddb.Size=Vector3.new(2,0.5,2)
ddb.CFrame=CFrame.new(cdb-Vector3.new(0,2,0))ddb.Parent=bdb;ddb.Anchored=true
ddb.TopSurface=Enum.SurfaceType.Smooth;ddb.Material=Enum.Material.Neon;ddb.Transparency=1
local __c=Instance.new("BoolValue")__c.Name="colorOverride"__c.Parent=ddb;bdb.PrimaryPart=ddb;return bdb end;local dab;local _bb
local function abb()
script.Parent.customize.xboxButtons:ClearAllChildren()
for adb,bdb in pairs(_aa:GetChildren())do
if bdb and bdb.PrimaryPart then
local cdb,ddb=workspace.CurrentCamera:WorldToScreenPoint(bdb.PrimaryPart.Position)
if ddb then
local __c=script.Parent.customize.sampleXboxButton:Clone()__c.Name=bdb.Name
__c.Parent=script.Parent.customize.xboxButtons;__c.Visible=cd.mode.Value=="xbox"
__c.Position=UDim2.new(0,cdb.X,0,cdb.Y+
game.GuiService:GetGuiInset().Y)
__c.Activated:connect(function()
if cd.mode.Value=="xbox"then local a_c=cda;if cda=="skinColor"then
a_c="skinColorId"end
caa.accessories[a_c]=tonumber(__c.Name)
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",aaa.entity,caa)end end)
__c.SelectionGained:connect(function()_bb=bdb;bba(bdb)end)
__c.SelectionLost:connect(function()if _bb==bdb then bba(nil)end end)end end end end
local function bbb()
if cd.mode.Value=="mobile"and
workspace.CurrentCamera.ViewportSize.Y<=700 then
script.Parent.Notice.UIScale.Scale=0.65;script.Parent.main.UIScale.Scale=0.7
script.Parent.main.Size=UDim2.new(1.43,0,1.43,0)
script.Parent.customize.UIScale.Scale=0.7
script.Parent.customize.Size=UDim2.new(1.43,0,1.43,0)else script.Parent.Notice.UIScale.Scale=1
script.Parent.main.UIScale.Scale=1;script.Parent.main.Size=UDim2.new(1,0,1,0)
script.Parent.customize.UIScale.Scale=1
script.Parent.customize.Size=UDim2.new(1,0,1,0)end end;bbb()
cd.mode.Changed:connect(function()for adb,bdb in
pairs(script.Parent.customize.xboxButtons:GetChildren())do
if bdb:IsA("GuiObject")then bdb.Visible=cd.mode.Value=="xbox"end end
bbb()end)
local function cbb(adb)_aa:ClearAllChildren()
c_a=game.ReplicatedStorage:WaitForChild("accessoryLookup")local bdb=c_a:FindFirstChild(adb)
if bdb then local ddb=0;local __c=0
local a_c=workspace:WaitForChild("Tabletop")
for b_c,c_c in pairs(bdb:GetChildren())do local d_c=cab(c_c)
local _ac=a_c.CFrame*
CFrame.new((__c*6)-
a_c.Size.X/2 +1.1,a_c.Size.Y/2 + (__c*3.2),
(ddb*2.5)-a_c.Size.Z/2 +1.1)d_c:SetPrimaryPartCFrame(_ac)d_c.Parent=_aa;ddb=ddb+1;if ddb>4 then
ddb=0;__c=__c+1 end end end
for ddb,__c in
pairs(script.Parent.customize.buttons:GetChildren())do if __c:IsA("ImageButton")then
__c.ImageColor3=Color3.fromRGB(103,255,212)end end
local cdb=script.Parent.customize.buttons:FindFirstChild(adb)
if cdb then cdb.ImageColor3=Color3.fromRGB(255,255,255)end;cda=adb
script.Parent.customize.hairColor.Visible=false
script.Parent.customize.shirtColor.Visible=false;if adb=="hair"then
script.Parent.customize.hairColor.Visible=true elseif adb=="undershirt"then
script.Parent.customize.shirtColor.Visible=true end
abb()end
for adb,bdb in
pairs(script.Parent.customize.buttons:GetChildren())do if bdb:IsA("ImageButton")then
bdb.Activated:connect(function()cbb(bdb.Name)end)end end
local function dbb()if _ab then return false end;_ab=true
local adb=script.Parent.DataSlot.Value
local bdb=script.Parent.main.Frame.DataSlots:FindFirstChild(tostring(adb))
if adb and bdb and not d_b then
if
not
(bd and bd.saveSlotData["-slot"..adb])and not script.Parent.customize.Visible then script.Parent.main.Visible=false
script.Parent.onlineFriends.Visible=false;script.Parent.customize.Visible=true;if
cd.mode.Value=="xbox"then game.GuiService.GuiNavigationEnabled=true
game.GuiService.SelectedObject=cd.getBestButton(script.Parent.customize)end
local cdb=game.ReplicatedStorage:WaitForChild("accessoryLookup")caa.accessories={}
for c_c,d_c in pairs(cdb:GetChildren())do
local _ac=d_c:GetChildren()
if#_ac>0 then local aac=d_c.Name
if aac=="skinColor"or aac=="shirtColor"or aac==
"hairColor"then aac=aac.."Id"end;caa.accessories[aac]=1 end end;cbb("hair")
for c_c,d_c in
pairs(cdb:WaitForChild("hairColor"):GetChildren())do
if d_c:IsA("Color3Value")then
local _ac=script.Parent.customize.colorButtonSample:Clone()_ac.ImageColor3=d_c.value;_ac.Name=d_c.Name
_ac.Parent=script.Parent.customize.hairColor;_ac.Visible=true
_ac.Activated:connect(function()
caa.accessories["hairColorId"]=tonumber(_ac.Name)bab()end)end end
for c_c,d_c in
pairs(cdb:WaitForChild("shirtColor"):GetChildren())do
if d_c:IsA("Color3Value")then
local _ac=script.Parent.customize.colorButtonSample:Clone()_ac.ImageColor3=d_c.value;_ac.Name=d_c.Name
_ac.Parent=script.Parent.customize.shirtColor;_ac.Visible=true
_ac.Activated:connect(function()
caa.accessories["shirtColorId"]=tonumber(_ac.Name)bab()end)end end
aaa=bb:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",workspace:WaitForChild("characterMask"),caa)aaa.Parent=workspace
local ddb=aaa.entity:WaitForChild("AnimationController")
local __c=bb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local a_c;do
if __c[1]then a_c=__c[1].baseData.equipmentType end end
local b_c=bb:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",ddb,"idling",a_c,nil)if b_c then
if typeof(b_c)=="Instance"then b_c:Play()elseif typeof(b_c)=="table"then for c_c,d_c in
pairs(b_c)do d_c:Play()end end end
workspace.CurrentCamera.FieldOfView=30
_G.Aero.Controllers.UI.CameraCFrame=script.Parent.CameraTablePos.Value
_G.Aero.Controllers.UI.FileSelect.LeftPane.AnchorPoint=Vector2.new(1,0)if dd then db(dd,{"Size"},0,0.7)end
script.swoosh:Play()wait(0.7)dca=script.Parent.CameraTablePos.Value
abb()else d_b=true
if
script.Parent.customize.Visible and caa and caa.accessories then
game:GetService("TeleportService"):SetTeleportSetting("playerAccessories",game:GetService("HttpService"):JSONEncode(caa.accessories))a=caa.accessories end;script.Parent.Enabled=false
db(workspace.CurrentCamera,{"FieldOfView"},{120},7)
bb:invoke("{1DEBF1E7-209E-4381-BC0E-1F5D2BF5564E}",bdb.Data.lastLocation.Value)local cdb;if(adb==13 or adb==14 or adb==15)and dc then
cdb="mirror"end
bb:invokeServer("{67882DD1-4A1F-40EC-B406-F7B7D75C8932}",bdb.Data.lastLocation.Value,
nil,adb,a,cdb)end else
script.Parent.main.Frame.PlayButton.Visible=false end;_ab=false end
script.Parent.main.Frame.PlayButton.Activated:Connect(dbb)
script.Parent.main.play.Activated:Connect(dbb)
script.Parent.customize.play.Activated:Connect(dbb)
if cd.mode.Value:lower()=="xbox"or
game:GetService("UserInputService").GamepadEnabled then
game.GuiService.GuiNavigationEnabled=true;game.GuiService.AutoSelectGuiEnabled=true
game.GuiService.SelectedObject=script.Parent.landing.play end;local _cb=4;if dc then _cb=20 elseif da then _cb=10 end
local acb=game.Players.LocalPlayer;script.Parent.main.Frame.DataSlots.CanvasSize=UDim2.new(0,0,0,
10 +_cb* (160))
local bcb={}
local function ccb(adb,bdb,cdb,ddb)if adb.character.ViewportFrame:FindFirstChild("entity")then
adb.character.ViewportFrame.entity:Destroy()end;if
adb.character.ViewportFrame:FindFirstChild("entity2")then
adb.character.ViewportFrame.entity2:Destroy()end
if bdb then bcb[adb]=bdb
if(
ddb==13 or ddb==14 or ddb==15)and dc then
adb.Loading.Visible=false;adb.PlayerData.Level.Visible=false
adb.PlayerData.Location.Visible=false;adb.PlayerData.Class.Text="Tester Slot"
adb.Data.lastLocation.Value=3372071669;adb.PlayerData.Visible=true
adb.BGHolder.BG.Image=
"https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..adb.Data.lastLocation.Value;adb.BGHolder.BG.Visible=true elseif bdb.newb then
adb.Loading.Visible=false;adb.PlayerData.Level.Visible=false
adb.PlayerData.Location.Visible=false;adb.PlayerData.Class.Text="New Adventure"
adb.Data.lastLocation.Value=4561988219;adb.PlayerData.Visible=true
adb.BGHolder.BG.Image=
"https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..adb.Data.lastLocation.Value;adb.BGHolder.BG.Visible=true
local __c=Instance.new("BoolValue")__c.Name="customize"__c.Parent=adb else
local __c=bdb.lastLocation or 2064647391;adb.Data.lastLocation.Value=__c
adb.Loading.Visible=false;adb.PlayerData.Level.Text="lv. "..bdb.level;adb.PlayerData.Class.Text=
bdb.class or"???"
adb.PlayerData.Location.Text="-"
adb.BGHolder.BG.Image="https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..__c;adb.BGHolder.BG.Visible=true
spawn(function()
local a_c=game.MarketplaceService:GetProductInfo(__c,Enum.InfoType.Asset)
if a_c then adb.PlayerData.Location.Text=a_c.Name end end)adb.Data.lastLocation.Value=__c
adb.PlayerData.Visible=true
if bdb.accessories then
local a_c=adb.character.ViewportFrame.CurrentCamera
if a_c==nil then a_c=Instance.new("Camera")
a_c.Parent=adb.character.ViewportFrame;adb.character.ViewportFrame.CurrentCamera=a_c end;local b_c=acb;local c_c=acb.Character
local d_c=adb.character.ViewportFrame.characterMask;local _ac={}_ac.equipment=bdb.equipment or{}
_ac.accessories=bdb.accessories or{}
if _c.getConfigurationValue("doUseProperAnimationForLoadingPlace",acb)then
spawn(function()
local aac=bb:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",d_c,
_ac or{},b_c)aac.Parent=workspace.CurrentCamera
local bac=aac.entity:WaitForChild("AnimationController")
local cac=bb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aac.entity)local dac;do
if cac[1]then dac=cac[1].baseData.equipmentType end end
local _bc=bb:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",bac,"idling",dac,nil)
if _bc then
if typeof(_bc)=="Instance"then _bc:Play()elseif typeof(_bc)=="table"then for abc,bbc in
pairs(_bc)do bbc:Play()end end
spawn(function()
while true do wait(0.1)
if typeof(_bc)=="Instance"then if _bc.Length>0 then break end elseif
typeof(_bc)=="table"then local abc=true
for bbc,cbc in pairs(_bc)do if _bc.Length==0 then abc=false end end;if abc then break end end end
if aac then local abc=aac.entity;abc.Parent=script.Parent.ViewportFrame
aac:Destroy()
local bbc=
CFrame.new(abc.PrimaryPart.Position+
abc.PrimaryPart.CFrame.lookVector*6.3,abc.PrimaryPart.Position)*CFrame.new(-3,0,0)
a_c.CFrame=CFrame.new(bbc.p+Vector3.new(0,1.5,0),abc.PrimaryPart.Position+
Vector3.new(0,0.5,0))end end)end end)else
spawn(function()
local aac=bb:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",d_c,_ac or{},b_c)aac.Parent=workspace.CurrentCamera
local bac=aac.entity:WaitForChild("AnimationController")local cac=bac:LoadAnimation(d_c.idle)cac.Looped=true
cac.Priority=Enum.AnimationPriority.Idle;cac:Play()wait()
if aac then local dac=aac.entity
dac.Parent=adb.character.ViewportFrame;aac:destroy()
local _bc=
CFrame.new(dac.PrimaryPart.Position+
dac.PrimaryPart.CFrame.lookVector*6.3,dac.PrimaryPart.Position)*CFrame.new(3,0,0)
a_c.CFrame=CFrame.new(_bc.p+Vector3.new(0,1.5,0),dac.PrimaryPart.Position+
Vector3.new(0,0.5,0))end end)end elseif not cdb then local a_c=Instance.new("BoolValue")a_c.Name="customize"
a_c.Parent=adb end end else adb.Loading.Sample.TextLabel.Text="Failed!"
wait(1)adb.Loading.Sample.TextLabel.Text="Load"end end;local dcb,_db
function activateFrame(adb)local bdb=tonumber(adb.Name)if _ab then return false end;if dcb then
dcb:Destroy()dcb=nil end;_ab=true
if bcb[adb]then local cdb=bcb[adb]
script.Parent.DataSlot.Value=bdb;if __a then __a:Destroy()__a=nil end
if
cdb.accessories and not cdb.newb and
not(dc and(bdb==13 or bdb==14 or bdb==15))then local ddb={}
ddb.equipment=cdb.equipment;ddb.accessories=cdb.accessories
__a=bb:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",workspace:WaitForChild("characterPreviewMask"),ddb)__a.Parent=workspace;local __c=string.lower(cdb.class)
if
__c=="berserker"or __c=="paladin"or __c=="knight"then
__c="warrior"elseif
__c=="sorcerer"or __c=="cleric"or __c=="warlock"then __c="mage"elseif
__c=="ranger"or __c=="trickster"or __c=="assassin"then __c="hunter"end;local a_c;do
for aac,bac in pairs(cdb.equipment)do
warn("scanning for pet",bac.position==10)if bac.position==10 then a_c=bac;break end end end
if a_c then if dcb then
dcb:Destroy()dcb=nil end
workspace.petPreviewMask.entityId.Value=a_c.id
dcb=bb:invoke("{17A36949-EEA3-4DB6-962F-0E88121DF82E}",workspace.petPreviewMask)
bb:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",workspace.petPreviewMask,"disableNameTagUI",true)
bb:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",workspace.petPreviewMask,"disableHealthBarUI",true)end
local b_c=__a.entity:WaitForChild("AnimationController")
local c_c=bb:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)local d_c;do
if c_c[1]then d_c=c_c[1].baseData.equipmentType end end
local _ac=bb:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",b_c,"idling",d_c,nil)if _ac then
if typeof(_ac)=="Instance"then _ac:Play()elseif typeof(_ac)=="table"then for aac,bac in
pairs(_ac)do bac:Play()end end end end elseif not c then c=true
spawn(function()
while c do
adb.Loading.Sample.TextLabel.Text="."wait(0.3)if not c then break end
adb.Loading.Sample.TextLabel.Text=".."wait(0.3)if not c then break end
adb.Loading.Sample.TextLabel.Text="..."wait(0.3)end end)
local cdb=bb:invokeServer("{1CB180D8-192B-4A5B-A375-7DEF18393276}",bdb)c=false;ccb(adb,cdb,false,bdb)
for ddb,__c in
pairs(script.Parent.main.Frame.DataSlots:GetChildren())do if dc and(bdb==13 or bdb==14 or bdb==15)then
ccb(__c,{},true,tonumber(__c.Name))end
if bd and bd.saveSlotData then
local a_c=cdb.globalData;local b_c=a_c.saveSlotData["-slot"..__c.Name]if b_c and not
bcb[__c]then
ccb(__c,b_c,true,tonumber(__c.Name))end end end end;_ab=false end
for i=1,_cb do
local adb=script.Parent.main.Frame.DataSlots.Sample:Clone()adb.Name=tostring(i)
adb.Parent=script.Parent.main.Frame.DataSlots;adb.Slot.Text="slot "..tostring(i)
adb.PlayerData.Visible=false;adb.Loading.Visible=true;adb.LayoutOrder=i;local bdb=false;if
adb.character.ViewportFrame:FindFirstChild("entity")then
adb.character.ViewportFrame.entity:Destroy()end;if
adb.character.ViewportFrame:FindFirstChild("entity2")then
adb.character.ViewportFrame.entity2:Destroy()end
adb.MouseButton1Click:Connect(function()
activateFrame(adb)end)if i==1 then
spawn(function()activateFrame(adb)activateFrame(adb)end)end;adb.Visible=true end;b_b()
script.Parent.main.Frame.DataSlots.Sample:Destroy()
for adb,bdb in
pairs(script.Parent.main.Frame.DataSlots:GetChildren())do local cdb=tonumber(bdb.Name)if dc and
(cdb==13 or cdb==14 or cdb==15)then
ccb(bdb,{},true,tonumber(bdb.Name))end
if bd then
if bd.saveSlotData then
local ddb=bd.saveSlotData["-slot"..bdb.Name]if ddb and not bcb[bdb]then
ccb(bdb,ddb,true,tonumber(bdb.Name))if bdb.Name=="1"then end end end end end
if bd then if bd.ethyr then script.Parent.main.ethyr.amount.Text=
tostring(bd.ethyr).." Ethyr"else
script.Parent.main.ethyr.amount.Text="0 Ethyr"end
script.Parent.main.ethyr.buy.Activated:Connect(function()
script.Parent.main.products.Visible=
not script.Parent.main.products.Visible end)
for adb,bdb in
pairs(script.Parent.main.products:GetChildren())do
if
bdb:FindFirstChild("productId")and bdb:FindFirstChild("buy")then
bdb.buy.Activated:connect(function()
game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer,bdb.productId.Value)end)end end end
bb:connect("{B8C3BD66-AD7D-4A01-9121-E882FFFA1E44}","OnClientEvent",function(adb)if adb.ethyr then script.Parent.main.ethyr.amount.Text=
tostring(adb.ethyr).." Ethyr"else
script.Parent.main.ethyr.amount.Text="0 Ethyr"end end)
game.Players.LocalPlayer:WaitForChild("DataLoaded")
if cd.mode.Value=="xbox"or
game:GetService("UserInputService").GamepadEnabled then
game.GuiService.GuiNavigationEnabled=true;game.GuiService.AutoSelectGuiEnabled=true
game.GuiService.SelectedObject=script.Parent.landing.play end end