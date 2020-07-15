local cd="UnknownMessage"local dd=1;local __a="MessageType"local a_a="MessageCreatorFunc"
local b_a="BaseFrame"local c_a="BaseMessage"local d_a="UpdateTextFunction"local _aa="GetHeightFunction"
local aaa="FadeInFunction"local baa="FadeOutFunction"local caa="UpdateAnimFunction"
local daa=game:GetService("TextService")local _ba=game:GetService("Players")local aba=_ba.LocalPlayer;while not aba do
_ba.ChildAdded:wait()aba=_ba.LocalPlayer end
local bba=script.Parent.Parent
local cba=require(bba:WaitForChild("ChatSettings"))
local dba=require(bba:WaitForChild("ChatConstants"))
local _ca,aca=pcall(function()return
UserSettings():IsUserFeatureEnabled("UserShouldClipInGameChat")end)local bca=_ca and aca;local cca={}local dca={}dca.__index=dca;function dca:GetStringTextBounds(_da,ada,bda,cda)cda=cda or
Vector2.new(10000,10000)
return daa:GetTextSize(_da,bda,ada,cda)end
function dca:GetMessageHeight(_da,ada,bda)bda=
bda or ada.AbsoluteSize.X
local cda=self:GetStringTextBounds(_da.Text,_da.Font,_da.TextSize,Vector2.new(bda,1000))return cda.Y end
function dca:GetNumberOfSpaces(_da,ada,bda)local cda=self:GetStringTextBounds(_da,ada,bda)
local dda=self:GetStringTextBounds(" ",ada,bda)return math.ceil(cda.X/dda.X)end
function dca:CreateBaseMessage(_da,ada,bda,cda)local dda=self:GetFromObjectPool("Frame")
dda.Selectable=false;dda.Size=UDim2.new(1,0,0,18)dda.Visible=true
dda.BackgroundTransparency=1;local __b=8;local a_b=self:GetFromObjectPool("TextLabel")
a_b.Selectable=false;a_b.Size=UDim2.new(1,- (__b+6),1,0)
a_b.Position=UDim2.new(0,__b,0,0)a_b.BackgroundTransparency=1;a_b.Font=ada;a_b.TextSize=bda
a_b.TextXAlignment=Enum.TextXAlignment.Left;a_b.TextYAlignment=Enum.TextYAlignment.Top
a_b.TextTransparency=0;a_b.TextColor3=cda;a_b.TextWrapped=true
if bca then a_b.ClipsDescendants=true end;a_b.Text=_da;a_b.Visible=true;a_b.Parent=dda;a_b.TextStrokeTransparency=0
a_b.TextStrokeColor3=Color3.new(0.2,0.2,0.2)return dda,a_b end
function dca:AddNameButtonToBaseMessage(_da,ada,bda,cda)
local dda=self:GetStringTextBounds(bda,_da.Font,_da.TextSize)local __b=self:GetFromObjectPool("TextButton")
__b.Selectable=false;__b.Size=UDim2.new(0,dda.X,0,dda.Y)
__b.Position=UDim2.new(0,0,0,0)__b.BackgroundTransparency=1;__b.Font=_da.Font
__b.TextSize=_da.TextSize;__b.TextXAlignment=_da.TextXAlignment
__b.TextYAlignment=_da.TextYAlignment;__b.TextTransparency=_da.TextTransparency
__b.TextStrokeTransparency=_da.TextStrokeTransparency;__b.TextStrokeColor3=_da.TextStrokeColor3;__b.TextColor3=ada
__b.Text=bda;__b.Visible=true;__b.Parent=_da
local a_b=__b.MouseButton1Click:connect(function()
self:NameButtonClicked(__b,cda)end)local b_b=nil
b_b=__b.Changed:connect(function(c_b)if c_b=="Parent"then a_b:Disconnect()
b_b:Disconnect()end end)return __b end
function dca:AddChannelButtonToBaseMessage(_da,ada,bda,cda)
local dda=self:GetStringTextBounds(bda,_da.Font,_da.TextSize)local __b=self:GetFromObjectPool("TextButton")
__b.Selectable=false;__b.Size=UDim2.new(0,dda.X,0,dda.Y)
__b.Position=UDim2.new(0,0,0,0)__b.BackgroundTransparency=1;__b.Font=_da.Font
__b.TextSize=_da.TextSize;__b.TextXAlignment=_da.TextXAlignment
__b.TextYAlignment=_da.TextYAlignment;__b.TextTransparency=_da.TextTransparency
__b.TextStrokeTransparency=_da.TextStrokeTransparency;__b.TextStrokeColor3=_da.TextStrokeColor3;__b.TextColor3=ada
__b.Text=bda;__b.Visible=true;__b.Parent=_da
local a_b=__b.MouseButton1Click:connect(function()
self:ChannelButtonClicked(__b,cda)end)local b_b=nil
b_b=__b.Changed:connect(function(c_b)if c_b=="Parent"then a_b:Disconnect()
b_b:Disconnect()end end)return __b end
function dca:AddTagLabelToBaseMessage(_da,ada,bda)
local cda=self:GetStringTextBounds(bda,_da.Font,_da.TextSize)local dda=self:GetFromObjectPool("TextLabel")
dda.Selectable=false;dda.Size=UDim2.new(0,cda.X,0,cda.Y)
dda.Position=UDim2.new(0,0,0,0)dda.BackgroundTransparency=1;dda.Font=_da.Font
dda.TextSize=_da.TextSize;dda.TextXAlignment=_da.TextXAlignment
dda.TextYAlignment=_da.TextYAlignment;dda.TextTransparency=_da.TextTransparency
dda.TextStrokeTransparency=_da.TextStrokeTransparency;dda.TextStrokeColor3=_da.TextStrokeColor3;dda.TextColor3=ada
dda.Text=bda;dda.Visible=true;dda.Parent=_da;return dda end;function GetWhisperChannelPrefix()
if dba.WhisperChannelPrefix then return dba.WhisperChannelPrefix end;return"To "end
function dca:NameButtonClicked(_da,ada)if
not self.ChatWindow then return end
if cba.ClickOnPlayerNameToWhisper then
local bda=_ba:FindFirstChild(ada)
if bda and bda~=aba then
local cda=GetWhisperChannelPrefix()..ada
if self.ChatWindow:GetChannel(cda)then
self.ChatBar:ResetCustomState()local dda=self.ChatWindow:GetTargetMessageChannel()if
dda~=cda then
self.ChatWindow:SwitchCurrentChannel(cda)end;local __b="/w "..ada
self.ChatBar:SetText(__b)self.ChatBar:CaptureFocus()elseif not
self.ChatBar:IsInCustomState()then local dda="/w "..ada
self.ChatBar:SetText(dda)self.ChatBar:CaptureFocus()end end end end
function dca:ChannelButtonClicked(_da,ada)if not self.ChatWindow then return end
if cba.ClickOnChannelNameToSetMainChannel then
if
self.ChatWindow:GetChannel(ada)then self.ChatBar:ResetCustomState()
local bda=self.ChatWindow:GetTargetMessageChannel()if bda~=ada then
self.ChatWindow:SwitchCurrentChannel(ada)end;self.ChatBar:ResetText()
self.ChatBar:CaptureFocus()end end end
function dca:RegisterChatWindow(_da)self.ChatWindow=_da;self.ChatBar=_da:GetChatBar()end
function dca:GetFromObjectPool(_da)
if self.ObjectPool==nil then return Instance.new(_da)end;return self.ObjectPool:GetInstance(_da)end;function dca:RegisterObjectPool(_da)self.ObjectPool=_da end
function dca:CreateFadeFunctions(_da)
local ada={}
for a_b,b_b in pairs(_da)do ada[a_b]={}for c_b,d_b in pairs(b_b)do
ada[a_b][c_b]={Target=d_b.FadedIn,Current=a_b[c_b],NormalizedExptValue=1}end end
local function bda(a_b,b_b)
for c_b,d_b in pairs(ada)do for _ab,aab in pairs(d_b)do aab.Target=_da[c_b][_ab].FadedIn
aab.NormalizedExptValue=b_b:NormalizedDefaultExptValueInSeconds(a_b)end end end
local function cda(a_b,b_b)
for c_b,d_b in pairs(ada)do for _ab,aab in pairs(d_b)do aab.Target=_da[c_b][_ab].FadedOut
aab.NormalizedExptValue=b_b:NormalizedDefaultExptValueInSeconds(a_b)end end end;local function dda()
for a_b,b_b in pairs(ada)do for c_b,d_b in pairs(b_b)do a_b[c_b]=d_b.Current end end end
local function __b(a_b,b_b)
for c_b,d_b in pairs(ada)do for _ab,aab in pairs(d_b)do
aab.Current=b_b:Expt(aab.Current,aab.Target,aab.NormalizedExptValue,a_b)end end;dda()end;return bda,cda,__b end;function dca:NewBindableEvent(_da)local ada=Instance.new("BindableEvent")
ada.Name=_da;return ada end
function dca:RegisterGuiRoot()end
function cca.new()local _da=setmetatable({},dca)_da.ObjectPool=nil
_da.ChatWindow=nil;_da.DEFAULT_MESSAGE_CREATOR=cd;_da.MESSAGE_CREATOR_MODULES_VERSION=dd
_da.KEY_MESSAGE_TYPE=__a;_da.KEY_CREATOR_FUNCTION=a_a;_da.KEY_BASE_FRAME=b_a
_da.KEY_BASE_MESSAGE=c_a;_da.KEY_UPDATE_TEXT_FUNC=d_a;_da.KEY_GET_HEIGHT=_aa;_da.KEY_FADE_IN=aaa
_da.KEY_FADE_OUT=baa;_da.KEY_UPDATE_ANIMATION=caa;return _da end;return cca.new()