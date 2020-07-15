local cca=game:GetService('Players')
local dca=game:GetService("ReplicatedStorage")local _da=game:GetService("Chat")
local ada=game:GetService("TextService")local bda=cca.LocalPlayer;while bda==nil do cca.ChildAdded:wait()
bda=cca.LocalPlayer end
local cda=bda:WaitForChild("PlayerGui")
local dda,__b=pcall(function()return
UserSettings():IsUserFeatureEnabled("UserShouldClipInGameChat")end)local a_b=dda and __b;local b_b=Enum.Font.SourceSans
local c_b=Enum.FontSize.Size24;local d_b=24;local _ab=d_b+10;local aab=14;local bab=30;local cab=1.5;local dab=400;local _bb=250;local abb="..."
local bbb=128;local cbb=bbb-string.len(abb)-1;local dbb=65;local _cb=100
local acb={WHITE="dub",BLUE="blu",GREEN="gre",RED="red"}local bcb=Instance.new("ScreenGui")bcb.Name="BubbleChat"
bcb.ResetOnSpawn=false;bcb.Parent=cda;local function ccb(_bc,abc,bbc)
return abc+ (bbc-abc)*
math.min(string.len(_bc)/75.0,1.0)end
local function dcb()local _bc={}_bc.data={}
local abc=Instance.new("BindableEvent")_bc.Emptied=abc.Event;function _bc:Size()return#_bc.data end;function _bc:Empty()return
_bc:Size()<=0 end
function _bc:PopFront()
table.remove(_bc.data,1)if _bc:Empty()then abc:Fire()end end;function _bc:Front()return _bc.data[1]end;function _bc:Get(bbc)
return _bc.data[bbc]end
function _bc:PushBack(bbc)table.insert(_bc.data,bbc)end;function _bc:GetData()return _bc.data end;return _bc end
local function _db()local _bc={}_bc.Fifo=dcb()_bc.BillboardGui=nil;return _bc end
local function adb()local _bc={}_bc.data={}local abc=0;function _bc:Size()return abc end
function _bc:Erase(bbc)if _bc.data[bbc]then abc=
abc-1 end;_bc.data[bbc]=nil end
function _bc:Set(bbc,cbc)_bc.data[bbc]=cbc;if cbc then abc=abc+1 end end
function _bc:Get(bbc)if not bbc then return end;if not _bc.data[bbc]then _bc.data[bbc]=_db()
local cbc=nil
cbc=_bc.data[bbc].Fifo.Emptied:connect(function()
cbc:disconnect()_bc:Erase(bbc)end)end;return
_bc.data[bbc]end;function _bc:GetData()return _bc.data end;return _bc end
local function bdb(_bc,abc,bbc)local cbc={}function cbc:ComputeBubbleLifetime(dbc,_cc)
if _cc then return ccb(dbc,8,15)else return ccb(dbc,12,20)end end;cbc.Origin=nil;cbc.RenderBubble=
nil;cbc.Message=_bc
cbc.BubbleDieDelay=cbc:ComputeBubbleLifetime(_bc,bbc)cbc.BubbleColor=abc;cbc.IsLocalPlayer=bbc;return cbc end
local function cdb(_bc,abc,bbc)local cbc=bdb(abc,acb.WHITE,bbc)if _bc then cbc.User=_bc.Name
cbc.Origin=_bc.Character end;return cbc end
local function ddb(_bc,abc,bbc,cbc)local dbc=bdb(abc,cbc,bbc)dbc.Origin=_bc;return dbc end
function createChatBubbleMain(_bc,abc)local bbc=Instance.new("ImageLabel")
bbc.Name="ChatBubble"bbc.ScaleType=Enum.ScaleType.Slice;bbc.SliceCenter=abc
bbc.Image=
"rbxasset://textures/"..tostring(_bc)..".png"bbc.BackgroundTransparency=1;bbc.BorderSizePixel=0
bbc.Size=UDim2.new(1.0,0,1.0,0)bbc.Position=UDim2.new(0,0,0,0)return bbc end
function createChatBubbleTail(_bc,abc)local bbc=Instance.new("ImageLabel")
bbc.Name="ChatBubbleTail"bbc.Image="rbxasset://textures/ui/dialog_tail.png"
bbc.BackgroundTransparency=1;bbc.BorderSizePixel=0;bbc.Position=_bc;bbc.Size=abc;return bbc end
function createChatBubbleWithTail(_bc,abc,bbc,cbc)local dbc=createChatBubbleMain(_bc,cbc)
local _cc=createChatBubbleTail(abc,bbc)_cc.Parent=dbc;return dbc end
function createScaledChatBubbleWithTail(_bc,abc,bbc,cbc)local dbc=createChatBubbleMain(_bc,cbc)
local _cc=Instance.new("Frame")_cc.Name="ChatBubbleTailFrame"_cc.BackgroundTransparency=1
_cc.SizeConstraint=Enum.SizeConstraint.RelativeXX;_cc.Position=UDim2.new(0.5,0,1,0)
_cc.Size=UDim2.new(abc,0,abc,0)_cc.Parent=dbc
local acc=createChatBubbleTail(bbc,UDim2.new(1,0,0.5,0))acc.Parent=_cc;return dbc end
function createChatImposter(_bc,abc,bbc)local cbc=Instance.new("ImageLabel")
cbc.Name="DialogPlaceholder"
cbc.Image="rbxasset://textures/"..tostring(_bc)..".png"cbc.BackgroundTransparency=1;cbc.BorderSizePixel=0
cbc.Position=UDim2.new(0,0,-1.25,0)cbc.Size=UDim2.new(1,0,1,0)
local dbc=Instance.new("ImageLabel")dbc.Name="DotDotDot"
dbc.Image="rbxasset://textures/"..tostring(abc)..".png"dbc.BackgroundTransparency=1;dbc.BorderSizePixel=0
dbc.Position=UDim2.new(0.001,0,bbc,0)dbc.Size=UDim2.new(1,0,0.7,0)dbc.Parent=cbc;return cbc end;local __c={}__c.ChatBubble={}__c.ChatBubbleWithTail={}
__c.ScalingChatBubbleWithTail={}__c.CharacterSortedMsg=adb()
local function a_c(_bc,abc,bbc,cbc,dbc)
__c.ChatBubble[_bc]=createChatBubbleMain(abc,dbc)
__c.ChatBubbleWithTail[_bc]=createChatBubbleWithTail(abc,UDim2.new(0.5,-aab,1,cbc and-1 or 0),UDim2.new(0,30,0,aab),dbc)
__c.ScalingChatBubbleWithTail[_bc]=createScaledChatBubbleWithTail(abc,0.5,UDim2.new(-0.5,0,0,cbc and-1 or 0),dbc)end
a_c(acb.WHITE,"ui/dialog_white","ui/chatBubble_white_notify_bkg",false,Rect.new(5,5,15,15))
a_c(acb.BLUE,"ui/dialog_blue","ui/chatBubble_blue_notify_bkg",true,Rect.new(7,7,33,33))
a_c(acb.RED,"ui/dialog_red","ui/chatBubble_red_notify_bkg",true,Rect.new(7,7,33,33))
a_c(acb.GREEN,"ui/dialog_green","ui/chatBubble_green_notify_bkg",true,Rect.new(7,7,33,33))
function __c:SanitizeChatLine(_bc)if string.len(_bc)>cbb then return
string.sub(_bc,1,cbb+string.len(abb))else return _bc end end
local function b_c(_bc)local abc=Instance.new("BillboardGui")abc.Adornee=_bc
abc.Size=UDim2.new(0,dab,0,_bb)abc.StudsOffset=Vector3.new(0,1.5,2)abc.Parent=bcb
local bbc=Instance.new("Frame")bbc.Name="BillboardFrame"bbc.Size=UDim2.new(1,0,1,0)bbc.Position=UDim2.new(0,0,
-0.5,0)bbc.BackgroundTransparency=1
bbc.Parent=abc;local cbc=nil
cbc=bbc.ChildRemoved:connect(function()if#bbc:GetChildren()<=1 then
cbc:disconnect()abc:Destroy()end end)
__c:CreateSmallTalkBubble(acb.WHITE).Parent=bbc;return abc end
function __c:CreateBillboardGuiHelper(_bc,abc)
if _bc and not
__c.CharacterSortedMsg:Get(_bc)["BillboardGui"]then
if not abc then if
_bc:IsA("BasePart")then local bbc=b_c(_bc)
__c.CharacterSortedMsg:Get(_bc)["BillboardGui"]=bbc;return end end
if _bc:IsA("Model")then local bbc=_bc:FindFirstChild("Head")if bbc and
bbc:IsA("BasePart")then local cbc=b_c(bbc)
__c.CharacterSortedMsg:Get(_bc)["BillboardGui"]=cbc end end end end;local function c_c(_bc)if not _bc then return 100000 end
return(_bc.Position-
game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude end
local function d_c(_bc)if _bc and
cca.LocalPlayer.Character then
return _bc:IsDescendantOf(cca.LocalPlayer.Character)end end
function __c:SetBillboardLODNear(_bc)local abc=d_c(_bc.Adornee)
_bc.Size=UDim2.new(0,dab,0,_bb)
_bc.StudsOffset=Vector3.new(0,abc and 1.5 or 2.5,abc and 2 or 0.1)_bc.Enabled=true
local bbc=_bc.BillboardFrame:GetChildren()for i=1,#bbc do bbc[i].Visible=true end
_bc.BillboardFrame.SmallTalkBubble.Visible=false end
function __c:SetBillboardLODDistant(_bc)local abc=d_c(_bc.Adornee)
_bc.Size=UDim2.new(4,0,3,0)
_bc.StudsOffset=Vector3.new(0,3,abc and 2 or 0.1)_bc.Enabled=true
local bbc=_bc.BillboardFrame:GetChildren()for i=1,#bbc do bbc[i].Visible=false end
_bc.BillboardFrame.SmallTalkBubble.Visible=true end;function __c:SetBillboardLODVeryFar(_bc)_bc.Enabled=false end
function __c:SetBillboardGuiLOD(_bc,abc)if
not abc then return end
if abc:IsA("Model")then
local cbc=abc:FindFirstChild("Head")if not cbc then abc=abc.PrimaryPart else abc=cbc end end;local bbc=c_c(abc)if bbc<dbb then __c:SetBillboardLODNear(_bc)elseif bbc>=dbb and
bbc<_cb then __c:SetBillboardLODDistant(_bc)else
__c:SetBillboardLODVeryFar(_bc)end end
function __c:CameraCFrameChanged()
for _bc,abc in
pairs(__c.CharacterSortedMsg:GetData())do local bbc=abc["BillboardGui"]if bbc then
__c:SetBillboardGuiLOD(bbc,_bc)end end end
function __c:CreateBubbleText(_bc)local abc=Instance.new("TextLabel")
abc.Name="BubbleText"abc.BackgroundTransparency=1
abc.Position=UDim2.new(0,bab/2,0,0)abc.Size=UDim2.new(1,-bab,1,0)abc.Font=b_b;if a_b then
abc.ClipsDescendants=true end;abc.TextWrapped=true;abc.FontSize=c_b;abc.Text=_bc
abc.Visible=false;abc.AutoLocalize=false;return abc end
function __c:CreateSmallTalkBubble(_bc)
local abc=__c.ScalingChatBubbleWithTail[_bc]:Clone()abc.Name="SmallTalkBubble"abc.AnchorPoint=Vector2.new(0,0.5)
abc.Position=UDim2.new(0,0,0.5,0)abc.Visible=false;local bbc=__c:CreateBubbleText("...")
bbc.TextScaled=true;bbc.TextWrapped=false;bbc.Visible=true;bbc.Parent=abc;return abc end
function __c:UpdateChatLinesForOrigin(_bc,abc)
local bbc=__c.CharacterSortedMsg:Get(_bc).Fifo;local cbc=bbc:Size()local dbc=bbc:GetData()if#dbc<=1 then return end
for index=(#dbc-1),1,
-1 do local _cc=dbc[index]local acc=_cc.RenderBubble;if not acc then return end
local bcc=cbc-index+1
if bcc>1 then local dcc=acc:FindFirstChild("ChatBubbleTail")if dcc then
dcc:Destroy()end;local _dc=acc:FindFirstChild("BubbleText")if _dc then
_dc.TextTransparency=0.5 end end
local ccc=UDim2.new(acc.Position.X.Scale,acc.Position.X.Offset,1,abc-
acc.Size.Y.Offset-aab)
acc:TweenPosition(ccc,Enum.EasingDirection.Out,Enum.EasingStyle.Bounce,0.1,true)abc=abc-acc.Size.Y.Offset-aab end end
function __c:DestroyBubble(_bc,abc)if not _bc then return end;if _bc:Empty()then return end
local bbc=_bc:Front().RenderBubble;if not bbc then _bc:PopFront()return end
spawn(function()while
_bc:Front().RenderBubble~=abc do wait()end
bbc=_bc:Front().RenderBubble;local cbc=0;local dbc=bbc:FindFirstChild("BubbleText")
local _cc=bbc:FindFirstChild("ChatBubbleTail")
while bbc and bbc.ImageTransparency<1 do cbc=wait()
if bbc then local acc=cbc*cab;bbc.ImageTransparency=
bbc.ImageTransparency+acc;if dbc then
dbc.TextTransparency=dbc.TextTransparency+acc end;if _cc then
_cc.ImageTransparency=_cc.ImageTransparency+acc end end end;if bbc then bbc:Destroy()_bc:PopFront()end end)end
function __c:CreateChatLineRender(_bc,abc,bbc,cbc)if not _bc then return end;if not
__c.CharacterSortedMsg:Get(_bc)["BillboardGui"]then
__c:CreateBillboardGuiHelper(_bc,bbc)end
local dbc=__c.CharacterSortedMsg:Get(_bc)["BillboardGui"]
if dbc then
local _cc=__c.ChatBubbleWithTail[abc.BubbleColor]:Clone()_cc.Visible=false;local acc=__c:CreateBubbleText(abc.Message)
acc.Parent=_cc;_cc.Parent=dbc.BillboardFrame;abc.RenderBubble=_cc
local bcc=ada:GetTextSize(acc.Text,d_b,b_b,Vector2.new(dab,_bb))local ccc=math.max((bcc.X+bab)/dab,0.1)
local dcc=(bcc.Y/d_b)_cc.Size=UDim2.new(0,0,0,0)
_cc.Position=UDim2.new(0.5,0,1,0)local _dc=dcc*_ab
_cc:TweenSizeAndPosition(UDim2.new(ccc,0,0,_dc),UDim2.new((1 -ccc)/2,0,1,-_dc),Enum.EasingDirection.Out,Enum.EasingStyle.Elastic,0.1,true,function()
acc.Visible=true end)__c:SetBillboardGuiLOD(dbc,abc.Origin)__c:UpdateChatLinesForOrigin(abc.Origin,
-_dc)
delay(abc.BubbleDieDelay,function()
__c:DestroyBubble(cbc,_cc)end)end end
function __c:OnPlayerChatMessage(_bc,abc,bbc)
if not __c:BubbleChatEnabled()then return end;local cbc=cca.LocalPlayer;local dbc=cbc~=nil and _bc~=cbc
local _cc=__c:SanitizeChatLine(abc)local acc=cdb(_bc,_cc,not dbc)
if _bc and acc.Origin then
local bcc=__c.CharacterSortedMsg:Get(acc.Origin).Fifo;bcc:PushBack(acc)
__c:CreateChatLineRender(_bc.Character,acc,true,bcc)end end
function __c:OnGameChatMessage(_bc,abc,bbc)local cbc=cca.LocalPlayer
local dbc=cbc~=nil and(cbc.Character~=_bc)local _cc=acb.WHITE
if bbc==Enum.ChatColor.Blue then _cc=acb.BLUE elseif bbc==
Enum.ChatColor.Green then _cc=acb.GREEN elseif bbc==Enum.ChatColor.Red then _cc=acb.RED end;local acc=__c:SanitizeChatLine(abc)
local bcc=ddb(_bc,acc,not dbc,_cc)
__c.CharacterSortedMsg:Get(bcc.Origin).Fifo:PushBack(bcc)
__c:CreateChatLineRender(_bc,bcc,false,__c.CharacterSortedMsg:Get(bcc.Origin).Fifo)end
function __c:BubbleChatEnabled()
local _bc=_da:FindFirstChild("ClientChatModules")
if _bc then local abc=_bc:FindFirstChild("ChatSettings")if abc then
local bbc=require(abc)
if bbc.BubbleChatEnabled~=nil then return bbc.BubbleChatEnabled end end end;return cca.BubbleChat end
function __c:ShowOwnFilteredMessage()
local _bc=_da:FindFirstChild("ClientChatModules")
if _bc then local abc=_bc:FindFirstChild("ChatSettings")if abc then
abc=require(abc)return abc.ShowUserOwnFilteredMessage end end;return false end;function findPlayer(_bc)
for abc,bbc in pairs(cca:GetPlayers())do if bbc.Name==_bc then return bbc end end end
_da.Chatted:connect(function(_bc,abc,bbc)
__c:OnGameChatMessage(_bc,abc,bbc)end)local _ac=nil
if game.Workspace.CurrentCamera then
_ac=game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):connect(function(_bc)
__c:CameraCFrameChanged()end)end
game.Workspace.Changed:connect(function(_bc)
if _bc=="CurrentCamera"then if _ac then
_ac:disconnect()end
if game.Workspace.CurrentCamera then
_ac=game.Workspace.CurrentCamera:GetPropertyChangedSignal("CFrame"):connect(function(abc)
__c:CameraCFrameChanged()end)end end end)local aac=nil
function getAllowedMessageTypes()if aac then return aac end
local _bc=_da:FindFirstChild("ClientChatModules")
if _bc then local abc=_bc:FindFirstChild("ChatSettings")if abc then
abc=require(abc)
if abc.BubbleChatMessageTypes then aac=abc.BubbleChatMessageTypes;return aac end end
local bbc=_bc:FindFirstChild("ChatConstants")if bbc then bbc=require(bbc)
aac={bbc.MessageTypeDefault,bbc.MessageTypeWhisper}end;return aac end;return{"Message","Whisper"}end
function checkAllowedMessageType(_bc)local abc=getAllowedMessageTypes()for i=1,#abc do if
abc[i]==_bc.MessageType then return true end end;return false end
local bac=dca:WaitForChild("DefaultChatSystemChatEvents")local cac=bac:WaitForChild("OnMessageDoneFiltering")
local dac=bac:WaitForChild("OnNewMessage")
dac.OnClientEvent:connect(function(_bc,abc)
if not checkAllowedMessageType(_bc)then return end;local bbc=findPlayer(_bc.FromSpeaker)if not bbc then return end;if not
_bc.IsFiltered or _bc.FromSpeaker==bda.Name then
if
_bc.FromSpeaker~=bda.Name or __c:ShowOwnFilteredMessage()then return end end;__c:OnPlayerChatMessage(bbc,_bc.Message,
nil)end)
cac.OnClientEvent:connect(function(_bc,abc)
if not checkAllowedMessageType(_bc)then return end;local bbc=findPlayer(_bc.FromSpeaker)if not bbc then return end;if

_bc.FromSpeaker==bda.Name and not __c:ShowOwnFilteredMessage()then return end
__c:OnPlayerChatMessage(bbc,_bc.Message,nil)end)