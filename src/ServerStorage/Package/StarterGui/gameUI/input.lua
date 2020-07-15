local _d=game:GetService("UserInputService")
local ad=game:GetService("RunService")local bd={}local cd={}local dd={}local __a={}bd.actions=__a;local a_a=script.mode;bd.mode=a_a
local b_a={}
bd.shortcuts={Unknown="???",One="1",KeypadOne="1",Two="2",KeypadTwo="2",Three="3",KeypadThree="3",Four="4",KeypadFour="4",Five="5",KeypadFive="5",Six="6",KeypadSix="6",Seven="7",KeypadSeven="7",Eight="8",KeypadEight="8",Nine="9",KeypadNine="9",Zero="0",KeypadZero="0",Backspace="BkS",Clear="Clr",Return="Rtn",Hash="#",Dollar="$",Percent="%",Ampersand="&",Quote="\"",LeftParenthesis="(",RightParenthesis=")",Asterisk="*",Plus="+",Comma=",",Minus="-",Period=".",Slash="/",Colon=":",Semicolon=";",LessThan="<",GreaterThan=">",Question="?",At="@",LeftBracket="[",RightBracket="]",Caret="^",Underscore="_",Backquote="`",LeftCurly="{",RightCurly="}",Pipe="|",Tilde="~",Delete="Del",Insert="Ins",Home="Hm",PageUp="PgUp",PageDown="PgDn",NumLock="NmLk",CapsLock="CpLk",ScrollLock="ScLk",RightShift="Rshft",LeftShift="Lshft",RightControl="Rctrl",LeftControl="Lctrl",RightAlt="Ralt",LeftAlt="Lalt",RightMeta="Rmta",LeftMeta="Lmta",RightSuper="Rspr",LeftSuper="Lspr",Break="Brk",Power="Pwr"}local c_a={}for dba,_ca in pairs(bd.shortcuts)do c_a[_ca]=dba end
local d_a=bd.shortcuts;local _aa;local aaa
local function baa()
if _aa then
for dba,_ca in pairs(dd)do local aca=_ca.Name;local bca=__a[aca]
if
_ca and _ca:IsA("GuiObject")and _ca:FindFirstChild("keyCode")then
if
bca and bca.bindedTo then _ca.keyCode.Text=bca.bindedTo else _ca.keyCode.Text=" "end end end;if aaa then aaa.refreshKeybinds()end end end
function bd.addAction(dba,_ca,aca,bca)bca=bca or 5
local cca={["target"]=_ca,["default"]=aca,["priority"]=bca}for dca,_da in pairs(cd)do
if dba==_da then cca["bindedTo"]=dca;cca["priority"]=bca;baa()break end end;__a[dba]=cca end;local caa=bd.addAction
local function daa(dba)
if dba:IsA("GuiObject")and
dba:IsDescendantOf(game.Players.LocalPlayer)then local _ca=dba.Parent.Name;dba.Name=_ca
if
dba:IsA("ImageLabel")or dba:IsA("ImageButton")then
local bca=Instance.new("Color3Value")bca.Name="originalColor"bca.Value=dba.ImageColor3;bca.Parent=dba end;table.insert(dd,dba)local aca=__a[_ca]
if
dba:FindFirstChild("keyCode")then if aca and aca.bindedTo then dba.keyCode.Text=aca.bindedTo else
dba.keyCode.Text=" "end end end end;for dba,_ca in
pairs(game.CollectionService:GetTagged("inputObject"))do daa(_ca)end
game.CollectionService:GetInstanceAddedSignal("inputObject"):connect(daa)local _ba
spawn(function()
local dba=require(game.ReplicatedStorage:WaitForChild("modules"))_ba=dba.load("network")
_ba:create("{7AE42210-0ED8-4379-800E-3C54632521A1}","BindableFunction","OnInvoke",caa)
_ba:create("{3BEE1289-FC66-41D7-A436-85EC9777345C}","BindableFunction","OnInvoke",function()local _ca={}
for aca,bca in pairs(__a)do
if
aca:find("hotbarButton")then local cca=bca.bindedTo or bca.default
if c_a[cca]then cca=c_a[cca]end;cca=cca:gsub("Keypad","")
table.insert(_ca,Enum.KeyCode[cca])end end;return _ca end)end)function bd.changeKeybindAction()end;bd.menuButtons={}for dba,_ca in
pairs(script.Parent.right.buttons:GetChildren())do
if _ca:IsA("GuiButton")then bd.menuButtons[_ca.Name]=_ca end end
local function aba(dba)
if
dba:IsA("GuiButton")then
dba.MouseButton1Click:connect(function()local _ca=Instance.new("Sound")
_ca.Name="clickSound"_ca.SoundId="rbxassetid://997701190"_ca.Parent=dba;_ca.Volume=0.1
_ca:Play()game.Debris:AddItem(_ca,3)end)end end
for dba,_ca in pairs(script.Parent:GetDescendants())do aba(_ca)end
script.Parent.DescendantAdded:connect(function(dba)aba(dba)end)local bba;function bd.setCurrentFocusFrame(dba)if bba and bba~=dba then bba.Visible=false end
bba=dba end;local function cba()end;bd.menuScale=1
function bd.init(dba)
local _ca=dba.tween;local aca
local function bca(dca)
if dca:IsA("GuiObject")then
if
(dca:FindFirstChild("xbox")or
dca:FindFirstChild("pc")or dca:FindFirstChild("mobile"))then table.insert(b_a,dca)end
if dca:FindFirstChild("bindable")then
dca.SelectionGained:connect(function()
dba.hotbarHandler.showSelectionPrompt(dca)end)
dca.SelectionLost:connect(function()
dba.hotbarHandler.hideSelectionPrompt(dca)end)end
if dca:FindFirstChild("tooltip")then
dca.MouseEnter:connect(function()aca=dca
_ba:invoke("{8E50CEB3-90F4-484F-8841-721129149A17}",{text=dca.tooltip.Value,source=dca})end)
dca.MouseLeave:connect(function()if aca==dca then aca=nil end
_ba:invoke("{8E50CEB3-90F4-484F-8841-721129149A17}",{source=dca})end)
dca.tooltip.Changed:connect(function()if aca==dca then
_ba:invoke("{8E50CEB3-90F4-484F-8841-721129149A17}",{text=dca.tooltip.Value,source=dca})end end)end
if
dca:IsA("ImageButton")and
(




dca.Parent==script.Parent.right.buttons or dca.Image=="rbxassetid://29202694692"or dca.Image=="rbxassetid://2920343923"or dca.Image=="rbxassetid://3437374574shadow"or dca.Image=="rbxassetid://3437374574"or dca.Image=="rbxassetid://3437766345")then
local function _da()if dca.Active then
if dca.Parent==script.Parent.right.buttons then else end end end
local function ada()
if dca.Parent==script.Parent.right.buttons then else
local cda=dca:FindFirstChild("selectionGlow")
if cda then if
dca.Image=="rbxassetid://3437766345"or"rbxassetid://3445513431"then _ca(cda,{"ImageTransparency"},1,0)else
_ca(cda,{"ImageTransparency"},1,0.2)end end end end
local function bda(cda)
if
cda.UserInputType==Enum.UserInputType.MouseButton1 or cda.UserInputType==
Enum.UserInputType.Gamepad1 or
cda.UserInputType==Enum.UserInputType.Touch then
if dca.Active then ada()
if dca.Image=="rbxassetid://3437766345"then
dca.Image="rbxassetid://3445513431"local dda;local __b=dca:FindFirstChild("UIPadding")if __b==nil then
dda=script.clickPadding:Clone()dda.Parent=dca else
__b.PaddingTop=UDim.new(__b.PaddingTop.Scale,__b.PaddingTop.Offset+4)end
repeat
wait()until cda.UserInputState==Enum.UserInputState.Cancel or cda.UserInputState==
Enum.UserInputState.End;wait(0.1)dca.Image="rbxassetid://3437766345"
if dda then dda:Destroy()elseif __b then __b.PaddingTop=UDim.new(__b.PaddingTop.Scale,
__b.PaddingTop.Offset-4)end elseif dca.Image~="rbxassetid://3445513431"then
local dda=dca:FindFirstChild("activationDark")if dda==nil then dda=script.activationDark:Clone()
dda.Parent=dca end
_ca(dda,{"ImageTransparency"},0.5,0.15)
spawn(function()wait(0.2)
_ca(dda,{"ImageTransparency"},1,0.3)end)end end end end;dca.MouseEnter:connect(_da)
dca.SelectionGained:connect(_da)dca.MouseLeave:connect(ada)
dca.SelectionLost:connect(ada)dca.InputBegan:connect(bda)end end end;for dca,_da in
pairs(script.Parent.Parent:GetDescendants())do bca(_da)end
script.Parent.Parent.DescendantAdded:connect(bca)
local function cca(dca)for _da,ada in pairs(dd)do if ada then ada.Visible=dca end end end
function cba()cca(a_a.Value=="pc")
for dca,_da in pairs(b_a)do _da.Visible=
_da:FindFirstChild(a_a.Value)~=nil end
if a_a.Value=="mobile"then bd.menuScale=0.7
script.Parent.leftBar.UIScale.Scale=0.65
script.Parent.bottomRight.UIScale.Scale=0.65
script.Parent.bottomRight.Size=UDim2.new(1,0,1.625,0)
if
script.Parent.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10")then
script.Parent.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10").Visible=false end
if
script.Parent.bottomRight.hotbarFrame.decor:FindFirstChild("10")then
script.Parent.bottomRight.hotbarFrame.decor:FindFirstChild("10").Visible=false end
script.Parent.bottomRight.AnchorPoint=Vector2.new(1,1)
script.Parent.bottomRight.Position=UDim2.new(1,0,1,0)else bd.menuScale=1
script.Parent.leftBar.UIScale.Scale=1
script.Parent.leftBar.Size=UDim2.new(0,100,1,-250)
script.Parent.bottomRight.UIScale.Scale=1
script.Parent.bottomRight.Size=UDim2.new(1,0,1,0)
script.Parent.bottomRight.AnchorPoint=Vector2.new(0.5,1)
script.Parent.bottomRight.Position=UDim2.new(0.5,0,1,0)
script.Parent.bottomRight.Size=UDim2.new(1,0,1,0)
if
script.Parent.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10")then
script.Parent.bottomRight.hotbarFrame.content:FindFirstChild("hotbarButton10").Visible=true end
if
script.Parent.bottomRight.hotbarFrame.decor:FindFirstChild("10")then
script.Parent.bottomRight.hotbarFrame.decor:FindFirstChild("10").Visible=true end;if
a_a.Value=="xbox"or game.GuiService:IsTenFootInterface()then bd.menuScale=1.2
script.Parent.bottomRight.UIScale.Scale=1.2 end end
_ba:fireServer("{723A57E9-71EF-444B-9AAC-EB43661ABF81}",a_a.Value)end
if _d.TouchEnabled and not _d.MouseEnabled then a_a.Value="mobile"end;a_a.Changed:connect(cba)cba()end
function bd.postInit(dba)_ba=dba.network;aaa=dba.settings;local _ca=false
game.GuiService.AutoSelectGuiEnabled=false;game.GuiService.CoreGuiNavigationEnabled=false
local function aca(bda,cda)local dda=__a[cda]if
dda==nil then return warn("Action",cda,"not found")end
if not
_aa then return warn("Input module not set up yet")end;if _ca then return false end;_ca=true;local __b=cd[bda]local a_b
if __b then a_b=__a[__b]
if a_b then
if not
dba.prompting_Fullscreen.prompt(
"This will override an existing action ("..__b.."). Are you sure?")then _ca=false;return false end end end
local b_b=_ba:invokeServer("{134272B3-131D-418B-8574-31B002C7571C}",bda,cda)
if b_b then local c_b=dda.bindedTo;if c_b then cd[c_b]=nil end;cd[bda]=cda
dda.bindedTo=bda;if a_b then a_b.bindedTo=nil end;baa()_ca=false;return true else _ca=false
warn("Server rejected keybind change")end end
local function bca()
local bda=_ba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","userSettings")cd={}if bda and bda.keybinds then cd=bda.keybinds end;for cda,dda in pairs(cd)do
local __b=__a[dda]if __b then __b.bindedTo=cda end end;for cda,dda in
pairs(__a)do local __b=dda.default
if
__b and dda["bindedTo"]==nil and cd[__b]==nil then cd[__b]=cda;dda["bindedTo"]=__b end end
_aa=true;baa()cba()end;caa("openEquipment",dba.equipment.show,"Q",3)
caa("openInventory",dba.inventory.show,"E",3)caa("openAbilities",dba.abilities.show,"R",3)
caa("openSettings",dba.settings.show,"G",3)
caa("interact",dba.interaction.interact,"C",4)
caa("emote1",function()
_ba:invoke("{A0FA1B07-2089-41D8-91EA-E16F3B6288DF}","dance")end,"N",7)
caa("emote2",function()
_ba:invoke("{A0FA1B07-2089-41D8-91EA-E16F3B6288DF}","sit")end,"M",7)
caa("swapWeapons",function()if
not _ba:invoke("{D4CB0603-73AC-434F-B92F-809E1FBF589B}")then
_ba:fireServer("{F0DA6712-143E-4B1A-AF07-76CEA9F67F46}")end end,"`",8)
_d.InputChanged:connect(function(bda,cda)
if


bda.UserInputType==Enum.UserInputType.Keyboard or bda.UserInputType==Enum.UserInputType.MouseButton1 or bda.UserInputType==Enum.UserInputType.MouseButton2 then a_a.Value="pc"elseif bda.UserInputType==Enum.UserInputType.Gamepad1 then
a_a.Value="xbox"elseif bda.UserInputType==Enum.UserInputType.Touch then a_a.Value="mobile"end;if a_a.Value~="mobile"then
_ba:fire("{2E5C6D9D-C401-4231-8CF6-BBBF30455217}",nil)
_ba:fire("{5741FB05-01DA-4A10-9006-76AAAE98E646}",nil)end end)
local cca=script.Parent:WaitForChild("touchJoystick")cca.Visible=false;local dca=false;local _da;local ada=false
_d.TouchStarted:connect(function(bda,cda)
if not cda then
local dda=bda.Position
if dda.x<300 and dda.y>
workspace.CurrentCamera.ViewportSize.y*0.6 then
if not dca then
cca.Position=UDim2.new(0,dda.x,0,dda.y)dca=true;cca.Visible=true
while

bda.UserInputState~=Enum.UserInputState.End and bda.UserInputState~=Enum.UserInputState.Cancel do local __b=bda.Position;local a_b=__b-dda
_ba:invoke("{8223B2F8-2FC1-480A-B726-2468E4E5FE9E}",a_b.magnitude>80)if a_b.magnitude>35 then a_b=a_b.unit*35 end
cca.stick.Position=UDim2.new(0.5,a_b.X,0.5,a_b.Y)
_ba:fire("{2E5C6D9D-C401-4231-8CF6-BBBF30455217}",a_b.unit)ad.RenderStepped:wait()end
_ba:fire("{2E5C6D9D-C401-4231-8CF6-BBBF30455217}",nil)
_ba:invoke("{8223B2F8-2FC1-480A-B726-2468E4E5FE9E}",false)dca=false;cca.Visible=false end else
if not ada then ada=true
while
bda.UserInputState~=Enum.UserInputState.End and
bda.UserInputState~=Enum.UserInputState.Cancel do local __b=bda.Position;local a_b=__b-dda
_ba:fire("{5741FB05-01DA-4A10-9006-76AAAE98E646}",a_b*0.3)dda=__b;ad.RenderStepped:wait()end;ada=false
_ba:fire("{5741FB05-01DA-4A10-9006-76AAAE98E646}",Vector2.new())end end end end)
_d.InputEnded:connect(function(bda,cda)if bda.KeyCode==Enum.KeyCode.ButtonL2 and
dba.hotbarHandler.focused then
dba.hotbarHandler.releaseFocus(bda)end end)
_d.InputBegan:connect(function(bda,cda)
if


bda.UserInputType==Enum.UserInputType.Keyboard or bda.UserInputType==Enum.UserInputType.MouseButton1 or bda.UserInputType==Enum.UserInputType.MouseButton2 then a_a.Value="pc"elseif bda.UserInputType==Enum.UserInputType.Gamepad1 then
a_a.Value="xbox"elseif bda.UserInputType==Enum.UserInputType.Touch then a_a.Value="mobile"end
if not cda then
if a_a.Value=="xbox"then
if dba.hotbarHandler.focused then
dba.hotbarHandler.releaseFocus(bda)else
if bda.KeyCode==Enum.KeyCode.ButtonB then
if dba.interaction.currentInteraction then
dba.interaction.stopInteract()else dba.focus.close()end;game.GuiService.SelectedObject=nil;print("$ nil a")elseif bda.KeyCode==
Enum.KeyCode.ButtonX then
if dba.itemAcquistion.closestItem then
dba.itemAcquistion.pickupInputGained(bda)else dba.interaction.interact()end elseif bda.KeyCode==Enum.KeyCode.ButtonY then
if game.GuiService.SelectedObject and
game.GuiService.SelectedObject:FindFirstChild("bindable")then else end elseif bda.KeyCode==Enum.KeyCode.ButtonSelect then
dba.settings.open()elseif bda.KeyCode==Enum.KeyCode.ButtonL2 then
dba.hotbarHandler.captureFocus()end end elseif a_a.Value=="pc"then
local dda=d_a[bda.KeyCode.Name]or bda.KeyCode.Name;local __b=dba.settings.remapTarget;if __b then
local b_b=dba.settings.remapTarget.Name;local c_b=__a[b_b]
if c_b then local d_b=aca(dda,b_b)if d_b then end;return false end end
local a_b=cd[dda]
if a_b then local b_b=__a[a_b]
if b_b and(not b_b.active)and
type(b_b.target)=="function"then b_b.active=true
for c_b,d_b in pairs(dd)do
if d_b.Name==a_b then
if d_b and
d_b:IsA("ImageLabel")then local _ab=Color3.fromRGB(0,255,255)
d_b.ImageColor3=_ab
if d_b:FindFirstChild("keyCode")then d_b.keyCode.TextColor3=_ab end end end end;b_b.target(bda)wait()b_b.active=false;wait(0.15)
if
not b_b.active then
for c_b,d_b in pairs(dd)do
if d_b.Name==a_b then
if d_b and d_b:IsA("ImageLabel")then
local _ab=
d_b:FindFirstChild("originalColor")and d_b.originalColor.Value or
Color3.fromRGB(40,40,40)d_b.ImageColor3=_ab;if d_b:FindFirstChild("keyCode")then
d_b.keyCode.TextColor3=Color3.new(1,1,1)end end end end end end end end end end)
for bda,cda in
pairs(script.Parent.right.buttons:GetChildren())do if cda:IsA("GuiButton")then
cda.MouseButton1Click:connect(function()local dda=__a[cda.Name]if dda and
dda.target then dda.target()end end)end end;spawn(bca)end;return bd