local aa={}local ba;local ca;local da;function aa.display()end;function aa.hide()end
local _b=game:GetService("RunService")
function aa.init(ab)local bb=ab.network;local cb=ab.tween;local db=ab.input;local _c=ab.utilities
local ac=game.ReplicatedStorage:WaitForChild("accessoryLookup")local bc=Instance.new("Folder")bc.Name="renderedOptions"
bc.Parent=workspace;local cc;local dc=Random.new(os.time())local _d={}
bc.DescendantAdded:connect(function(bba)
if
bba.Name=="bodyPart"then local cba=bba.Parent
cba.Color=ac:FindFirstChild("skinColor"):FindFirstChild(tostring(
_d.accessories.skinColorId or 1)).Value elseif bba.Name=="hair_Head"and bba:IsA("BasePart")then
bba.Color=ac:FindFirstChild("hairColor"):FindFirstChild(tostring(
_d.accessories.hairColorId or 1)).Value elseif bba.Name=="shirt"or bba.Name=="shirtTag"then if
bba.Name=="shirtTag"then bba=bba.Parent end;if bba:IsA("BasePart")then
bba.Color=ac:FindFirstChild("shirtColor"):FindFirstChild(tostring(
_d.accessories.shirtColorId or 1)).Value end end end)local ad=true
local function bd(bba)for cba,dba in pairs(bc:GetChildren())do
if bba:IsDescendantOf(dba)then return dba end end end;local cd
local function dd(bba)
if cd and cd.Parent then cd.PrimaryPart.Transparency=1;cd=nil end;if bba then cd=bba;bba.PrimaryPart.Transparency=0.3 end end;local __a=db;local a_a=0
game:GetService("UserInputService").InputBegan:connect(function(bba,cba)if

not cba and bba.UserInputType==Enum.UserInputType.MouseButton1 then a_a=tick()end end)local b_a
game:GetService("UserInputService").InputEnded:connect(function(bba,cba)
if

not cba and bba.UserInputType==Enum.UserInputType.MouseButton1 and tick()-a_a<=2 then
if cd then local dba=b_a;if dba==
"skinColor"then dba="skinColorId"end
_d.accessories[dba]=tonumber(cd.Name)
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",cc.entity,_d)end end end)
local function c_a()
for bba,cba in
pairs(script.Parent.Frame.DataSlots:GetChildren())do if cba:IsA("ImageButton")then
cba.ImageColor3=Color3.fromRGB(126,126,126)end end end;local d_a=false
local function _aa(bba)local cba=Vector3.new()local dba=0
for _ca,aca in pairs(bba:GetChildren())do if
aca:IsA("BasePart")then cba=cba+aca.Position;dba=dba+1 end end;return cba/dba end
local function aaa()
for bba,cba in pairs(bc:GetDescendants())do
if cba.Name=="bodyPart"then local dba=cba.Parent
dba.Color=ac:FindFirstChild("skinColor"):FindFirstChild(tostring(
_d.accessories.skinColorId or 1)).Value elseif cba.Name=="hair_Head"and cba:IsA("BasePart")then
cba.Color=ac:FindFirstChild("hairColor"):FindFirstChild(tostring(
_d.accessories.hairColorId or 1)).Value elseif cba.Name=="shirt"or cba:FindFirstChild("shirtTag")then
cba.Color=ac:FindFirstChild("shirtColor"):FindFirstChild(tostring(
_d.accessories.shirtColorId or 1)).Value end end
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",cc.entity,_d)end
local function baa(bba)local cba
if bba:IsA("Color3Value")then
cba=script.colorRepre:Clone()cba.value.Color=bba.Value;cba.Name=bba.Name else cba=bba:Clone()end;local dba=_aa(cba)
for bca,cca in pairs(cba:GetDescendants())do
if cca:IsA("BasePart")then
if

cca.Parent==cba and cca:FindFirstChild("colorOverride")==nil then local dca=Instance.new("BoolValue")dca.Name="bodyPart"
dca.Parent=cca else cca.Parent=cba end;cca.Anchored=true end end;local _ca=Instance.new("Part")
_ca.Size=Vector3.new(2,0.5,2)
_ca.CFrame=CFrame.new(dba-Vector3.new(0,2,0))_ca.Parent=cba;_ca.Anchored=true
_ca.TopSurface=Enum.SurfaceType.Smooth;_ca.Material=Enum.Material.Neon;_ca.Transparency=1
local aca=Instance.new("BoolValue")aca.Name="colorOverride"aca.Parent=_ca;cba.PrimaryPart=_ca;return cba end;local caa;local daa
local function _ba()
script.Parent.xboxButtons:ClearAllChildren()
for bba,cba in pairs(bc:GetChildren())do
if cba and cba.PrimaryPart then
local dba,_ca=workspace.CurrentCamera:WorldToScreenPoint(cba.PrimaryPart.Position)
if _ca then
local aca=script.Parent.sampleXboxButton:Clone()aca.Name=cba.Name;aca.Parent=script.Parent.xboxButtons;aca.Visible=
db.mode.Value=="xbox"
aca.Position=UDim2.new(0,dba.X,0,dba.Y+
game.GuiService:GetGuiInset().Y)
aca.Activated:connect(function()if db.mode.Value=="xbox"then
_d.accessories[b_a]=tonumber(aca.Name)
bb:invoke("{819E7CC3-4F36-4808-916D-4395D84EF25F}",cc.entity,_d)end end)
aca.SelectionGained:connect(function()daa=cba;dd(cba)end)
aca.SelectionLost:connect(function()if daa==cba then dd(nil)end end)end end end end
db.mode.Changed:connect(function()for bba,cba in
pairs(script.Parent.xboxButtons:GetChildren())do
if cba:IsA("GuiObject")then cba.Visible=db.mode.Value=="xbox"end end end)
local function aba(bba)bc:ClearAllChildren()
ac=game.ReplicatedStorage:WaitForChild("accessoryLookup")local cba=ac:FindFirstChild(bba)
if cba then local _ca=0;local aca=0;local bca=ca
for cca,dca in
pairs(cba:GetChildren())do local _da=baa(dca)
local ada=bca.CFrame*
CFrame.new((aca*6)-bca.Size.X/2 +1.1,
bca.Size.Y/2 + (aca*3.2),(_ca*2.5)-bca.Size.Z/2 +1.1)_da:SetPrimaryPartCFrame(ada)_da.Parent=bc;_ca=_ca+1;if _ca>4 then
_ca=0;aca=aca+1 end end end
for _ca,aca in
pairs(script.Parent.buttons:GetChildren())do if aca:IsA("ImageButton")then
aca.ImageColor3=Color3.fromRGB(103,255,212)end end
local dba=script.Parent.buttons:FindFirstChild(bba)
if dba then dba.ImageColor3=Color3.fromRGB(255,255,255)end;b_a=bba;script.Parent.hairColor.Visible=false
script.Parent.shirtColor.Visible=false
if bba=="hair"then script.Parent.hairColor.Visible=true elseif
bba=="undershirt"then script.Parent.shirtColor.Visible=true end;_ba()end
for bba,cba in
pairs(script.Parent.buttons:GetChildren())do if cba:IsA("ImageButton")then
cba.Activated:connect(function()aba(cba.Name)end)end end
for bba,cba in
pairs(ac:WaitForChild("hairColor"):GetChildren())do
if cba:IsA("Color3Value")then
local dba=script.Parent.colorButtonSample:Clone()dba.ImageColor3=cba.value;dba.Name=cba.Name
dba.Parent=script.Parent.hairColor;dba.Visible=true
dba.Activated:connect(function()
_d.accessories["hairColorId"]=tonumber(dba.Name)aaa()end)end end
for bba,cba in
pairs(ac:WaitForChild("shirtColor"):GetChildren())do
if cba:IsA("Color3Value")then
local dba=script.Parent.colorButtonSample:Clone()dba.ImageColor3=cba.value;dba.Name=cba.Name
dba.Parent=script.Parent.shirtColor;dba.Visible=true
dba.Activated:connect(function()
_d.accessories["shirtColorId"]=tonumber(dba.Name)aaa()end)end end
function aa.hide()
bb:invoke("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}",false)script.Parent.Enabled=false
script.Parent.Parent.gameUI.Enabled=true;if ba then ba:disconnect()ba=nil end
if cc then cc:Destroy()end end
script.Parent.options.cancel.Activated:connect(aa.hide)
script.Parent.options.done.Activated:connect(function()
da=_d;aa.hide()end)
function aa.display(bba)da=nil;script.Parent.Enabled=true
script.Parent.Parent.gameUI.Enabled=false;ca=bba;if db.mode.Value=="xbox"then
game.GuiService.GuiNavigationEnabled=true
game.GuiService.SelectedObject=db.getBestButton(script.Parent)end
_d.accessories={}
for cca,dca in pairs(ac:GetChildren())do local _da=dca:GetChildren()if#_da>0 then
_d.accessories[dca.Name]=1 end end;local cba=game.Players.LocalPlayer
if

cba.Character and cba.Character.PrimaryPart and cba.Character.PrimaryPart:FindFirstChild("appearance")then
local cca,dca=_c.safeJSONDecode(cba.Character.PrimaryPart.appearance.Value)
if cca and dca.accessories then for _da,ada in pairs(dca.accessories)do
_d.accessories[_da]=ada end end end;aba("hair")if cc then cc:Destroy()end
cc=bb:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",workspace:WaitForChild("characterMask"),_d)cc.Parent=workspace
local dba=cc.entity:WaitForChild("AnimationController")
local _ca=dba:LoadAnimation(workspace.characterMask:WaitForChild("idle"))_ca.Looped=true;_ca.Priority=Enum.AnimationPriority.Idle
_ca:Play()
local aca=
CFrame.new(ca.Position+Vector3.new(0,4.4,0)+
ca.CFrame.rightVector*-28,ca.Position+Vector3.new(0,2.9,0))*CFrame.new(-4,0,0)
bb:invoke("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}",aca,0.7)
cb(workspace.CurrentCamera,{"FieldOfView"},30,0.5)_c.playSound("swoosh")wait(0.7)_ba()if ba then
ba:disconnect()end
local bca=game:GetService("UserInputService").InputChanged:connect(function(cca,dca)
if
cca.UserInputType==Enum.UserInputType.MouseMovement then local _da=0;local ada,bda
if ad and bc and
script.Parent.Enabled then _da=70
local cda=workspace.CurrentCamera:ScreenPointToRay(cca.Position.X,cca.Position.Y,1)local dda=bc:GetChildren()
if
#dda>0 and __a.mode.Value=="pc"then
local __b,a_b=workspace:FindPartOnRayWithWhitelist(Ray.new(cda.Origin,cda.Direction*100),dda,true)if __b then local b_b=bd(__b)dd(b_b)else dd()end end elseif not ad then _da=100 end
if _da>0 then
local cda=workspace.CurrentCamera:ScreenPointToRay(cca.Position.X,cca.Position.Y,_da)ada,bda=workspace:FindPartOnRay(cda)
if bda then local dda=aca.Position+
aca.lookVector*50
dda=Vector3.new(bda.x+dda.x*25,bda.y+dda.y*
25,bda.z+dda.z*25)/26
bb:invoke("{DA5389FD-E8D2-4381-81F2-C8B1EA5D6A5F}",CFrame.new(aca.Position,dda),0.2)end end end end)end
bb:create("{E1394B16-EAC3-48AE-8964-BC6167DDE9B5}","BindableFunction","OnInvoke",aa.display)
bb:create("{7524FB85-BC81-4213-8DC4-CF62E1F1D5BE}","BindableFunction","OnInvoke",aa.hide)
function aa.yieldDesiredAppearance(bba)if script.Parent.Enabled then
return false,"Appearance picker is already active"end;aa.display(bba)repeat
_b.Heartbeat:wait()until not script.Parent.Enabled;return da end
bb:create("{12A0043F-C9ED-41E3-84BD-C0F494FA1AFA}","BindableFunction","OnInvoke",aa.yieldDesiredAppearance)end;return aa