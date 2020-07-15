local cc={}local dc=game:GetService("Players")
local _d=game:GetService("Chat")local ad=dc.LocalPlayer;local bd=ad:WaitForChild("PlayerGui")local cd=640
local dd=1024;local __a=1;local a_a=2;local b_a=3;local c_a=game:GetService("Chat")
local d_a=c_a:WaitForChild("ClientChatModules")local _aa=script.Parent
local aaa=require(_aa:WaitForChild("ChatChannel"))
local baa=require(d_a:WaitForChild("ChatSettings"))
local caa=require(_aa:WaitForChild("CurveUtil"))local daa={}daa.__index=daa
function getClassicChatEnabled()if baa.ClassicChatEnabled~=nil then
return baa.ClassicChatEnabled end;return dc.ClassicChat end
function getBubbleChatEnabled()
if baa.BubbleChatEnabled~=nil then return baa.BubbleChatEnabled end;return dc.BubbleChat end;function bubbleChatOnly()return
not getClassicChatEnabled()and getBubbleChatEnabled()end
function mergeProps(_ba,aba)if
not _ba or not aba then return end;for bba,cba in pairs(_ba)do if aba[bba]~=nil then
aba[bba]=cba end end end
function daa:CreateGuiObjects(_ba)local aba
pcall(function()
aba=c_a:InvokeChatCallback(Enum.ChatCallbackType.OnCreatingChatWindow,nil)end)mergeProps(aba,baa)local bba=Instance.new("Frame")
bba.BackgroundTransparency=1;bba.Active=baa.WindowDraggable;bba.Parent=_ba;bba.AutoLocalize=false
local cba=Instance.new("Frame")cba.Selectable=false;cba.Name="ChatBarParentFrame"
cba.BackgroundTransparency=1;cba.Parent=bba;local dba=Instance.new("Frame")
dba.Selectable=false;dba.Name="ChannelsBarParentFrame"dba.BackgroundTransparency=1
dba.Position=UDim2.new(0,0,0,0)dba.Parent=bba;local _ca=Instance.new("Frame")
_ca.Selectable=false;_ca.Name="ChatChannelParentFrame"_ca.BackgroundTransparency=1
_ca.BackgroundColor3=baa.BackGroundColor;_ca.BackgroundTransparency=0.6;_ca.BorderSizePixel=0;_ca.Parent=bba
local aca=Instance.new("ImageButton")aca.Selectable=false;aca.Image=""aca.BackgroundTransparency=0.6
aca.BorderSizePixel=0;aca.Visible=false;aca.BackgroundColor3=baa.BackGroundColor
aca.Active=true;if bubbleChatOnly()then
aca.Position=UDim2.new(1,-aca.AbsoluteSize.X,0,0)else
aca.Position=UDim2.new(1,-aca.AbsoluteSize.X,1,-aca.AbsoluteSize.Y)end
aca.Parent=bba;local bca=Instance.new("ImageLabel")bca.Selectable=false
bca.Size=UDim2.new(0.8,0,0.8,0)bca.Position=UDim2.new(0.2,0,0.2,0)
bca.BackgroundTransparency=1;bca.Image="rbxassetid://261880743"bca.Parent=aca;local function cca()local cab=bba;while(cab and not
cab:IsA("ScreenGui"))do cab=cab.Parent end;return
cab end;local dca=b_a
local _da=cca()if(_da.AbsoluteSize.X<=cd)then dca=__a elseif(_da.AbsoluteSize.X<=dd)then
dca=a_a end;local ada=false
local function bda()if(ada)then return end
ada=true;if(not bba:IsDescendantOf(bd))then return end;local cab=cca()
local dab=baa.MinimumWindowSize;local _bb=baa.MaximumWindowSize
local abb=dba.AbsoluteSize.Y+cba.AbsoluteSize.Y
local bbb=(dab.X.Scale*cab.AbsoluteSize.X)+dab.X.Offset
local cbb=math.max((dab.Y.Scale*cab.AbsoluteSize.Y)+dab.Y.Offset,abb)
local dbb=(_bb.X.Scale*cab.AbsoluteSize.X)+_bb.X.Offset
local _cb=(_bb.Y.Scale*cab.AbsoluteSize.Y)+_bb.Y.Offset;local acb=bba.AbsoluteSize.X;local bcb=bba.AbsoluteSize.Y
if(acb<bbb)then local _db=UDim2.new(0,
bbb-acb,0,0)bba.Size=bba.Size+_db elseif(acb>dbb)then local _db=UDim2.new(0,
dbb-acb,0,0)bba.Size=bba.Size+_db end
if(bcb<cbb)then local _db=UDim2.new(0,0,0,cbb-bcb)
bba.Size=bba.Size+_db elseif(bcb>_cb)then local _db=UDim2.new(0,0,0,_cb-bcb)
bba.Size=bba.Size+_db end
local ccb=bba.AbsoluteSize.X/cab.AbsoluteSize.X
local dcb=bba.AbsoluteSize.Y/cab.AbsoluteSize.Y;bba.Size=UDim2.new(ccb,0,dcb,0)ada=false end
bba.Changed:connect(function(cab)if(cab=="AbsoluteSize")then bda()end end)
aca.DragBegin:connect(function(cab)bba.Draggable=false end)
local function cda(cab)if
baa.WindowDraggable==false and baa.WindowResizable==false then return end;local dab=cab-bba.AbsolutePosition+
aca.AbsoluteSize
bba.Size=UDim2.new(0,dab.X,0,dab.Y)if bubbleChatOnly()then
aca.Position=UDim2.new(1,-aca.AbsoluteSize.X,0,0)else
aca.Position=UDim2.new(1,-aca.AbsoluteSize.X,1,-aca.AbsoluteSize.Y)end end
aca.DragStopped:connect(function(cab,dab)bba.Draggable=baa.WindowDraggable end)local dda=false
aca.Changed:connect(function(cab)
if
(cab=="AbsolutePosition"and not bba.Draggable)then if(dda)then return end;dda=true;cda(aca.AbsolutePosition)dda=false end end)
local function __b(cab)
if(dca==__a)then cab=cab or baa.ChatChannelsTabTextSizePhone else cab=cab or
baa.ChatChannelsTabTextSize end;local dab=cab;local _bb=math.max(32,dab+8)+2;return _bb end
local function a_b(cab)if(dca==__a)then cab=cab or baa.ChatBarTextSizePhone else
cab=cab or baa.ChatBarTextSize end;local dab=cab
local _bb=dab+ (7 *2)+ (5 *2)return _bb end
if bubbleChatOnly()then cba.Position=UDim2.new(0,0,0,0)dba.Visible=false
dba.Active=false;_ca.Visible=false;_ca.Active=false;local cab=0;local dab=0;local _bb=cca()
if(dca==__a)then
cab=baa.DefaultWindowSizePhone.X.Scale;dab=baa.DefaultWindowSizePhone.X.Offset elseif(dca==a_a)then
cab=baa.DefaultWindowSizeTablet.X.Scale;dab=baa.DefaultWindowSizeTablet.X.Offset else
cab=baa.DefaultWindowSizeTablet.X.Scale;dab=baa.DefaultWindowSizeTablet.X.Offset end;local abb=a_b()bba.Size=UDim2.new(cab,dab,0,abb)
bba.Position=baa.DefaultWindowPosition else local cab=cca()
if(dca==__a)then bba.Size=baa.DefaultWindowSizePhone elseif(dca==a_a)then
bba.Size=baa.DefaultWindowSizeTablet else bba.Size=baa.DefaultWindowSizeDesktop end;bba.Position=baa.DefaultWindowPosition end
if(dca==__a)then baa.ChatWindowTextSize=baa.ChatWindowTextSizePhone
baa.ChatChannelsTabTextSize=baa.ChatChannelsTabTextSizePhone;baa.ChatBarTextSize=baa.ChatBarTextSizePhone end;local function b_b(cab)bba.Active=cab;bba.Draggable=cab end
local function c_b(cab)
aca.Visible=cab;aca.Draggable=cab;local dab=cba.Size.Y.Offset
if(cab)then
cba.Size=UDim2.new(1,-dab-2,0,dab)
if not bubbleChatOnly()then cba.Position=UDim2.new(0,0,1,-dab)end else cba.Size=UDim2.new(1,0,0,dab)if not bubbleChatOnly()then cba.Position=UDim2.new(0,0,1,
-dab)end end end
local function d_b()local cab=__b()local dab=a_b()
if(baa.ShowChannelsBar)then
_ca.Size=UDim2.new(1,0,1,- (cab+dab+2 +2))_ca.Position=UDim2.new(0,0,0,cab+2)else
_ca.Size=UDim2.new(1,0,1,- (dab+2 +2))_ca.Position=UDim2.new(0,0,0,2)end end
local function _ab(cab)local dab=__b(cab)dba.Size=UDim2.new(1,0,0,dab)d_b()end
local function aab(cab)local dab=a_b(cab)cba.Size=UDim2.new(1,0,0,dab)
if
not bubbleChatOnly()then cba.Position=UDim2.new(0,0,1,-dab)end;aca.Size=UDim2.new(0,dab,0,dab)
aca.Position=UDim2.new(1,-dab,1,-dab)d_b()c_b(baa.WindowResizable)end;local function bab(cab)dba.Visible=cab;d_b()end
_ab(baa.ChatChannelsTabTextSize)aab(baa.ChatBarTextSize)b_b(baa.WindowDraggable)
c_b(baa.WindowResizable)bab(baa.ShowChannelsBar)
baa.SettingsChanged:connect(function(cab,dab)
if
(cab=="WindowDraggable")then b_b(dab)elseif(cab=="WindowResizable")then c_b(dab)elseif(cab=="ChatChannelsTabTextSize")then
_ab(dab)elseif(cab=="ChatBarTextSize")then aab(dab)elseif(cab=="ShowChannelsBar")then bab(dab)end end)self.GuiObject=bba;self.GuiObjects.BaseFrame=bba
self.GuiObjects.ChatBarParentFrame=cba;self.GuiObjects.ChannelsBarParentFrame=dba
self.GuiObjects.ChatChannelParentFrame=_ca;self.GuiObjects.ChatResizerFrame=aca
self.GuiObjects.ResizeIcon=bca;self:AnimGuiObjects()end;function daa:GetChatBar()return self.ChatBar end;function daa:RegisterChatBar(_ba)
self.ChatBar=_ba
self.ChatBar:CreateGuiObjects(self.GuiObjects.ChatBarParentFrame)end;function daa:RegisterChannelsBar(_ba)
self.ChannelsBar=_ba
self.ChannelsBar:CreateGuiObjects(self.GuiObjects.ChannelsBarParentFrame)end
function daa:RegisterMessageLogDisplay(_ba)
self.MessageLogDisplay=_ba
self.MessageLogDisplay.GuiObject.Parent=self.GuiObjects.ChatChannelParentFrame end
function daa:AddChannel(_ba)if(self:GetChannel(_ba))then
error("Channel '".._ba.."' already exists!")return end
local aba=aaa.new(_ba,self.MessageLogDisplay)self.Channels[_ba:lower()]=aba
aba:SetActive(false)local bba=self.ChannelsBar:AddChannelTab(_ba)
bba.NameTag.MouseButton1Click:connect(function()
self:SwitchCurrentChannel(_ba)end)aba:RegisterChannelTab(bba)return aba end
function daa:GetFirstChannel()for _ba,aba in pairs(self.Channels)do return aba end;return nil end
function daa:RemoveChannel(_ba)if(not self:GetChannel(_ba))then
error("Channel '".._ba.."' does not exist!")end;local aba=_ba:lower()local bba=false;if(
self.Channels[aba]==self:GetCurrentChannel())then bba=true
self:SwitchCurrentChannel(nil)end
self.Channels[aba]:Destroy()self.Channels[aba]=nil
self.ChannelsBar:RemoveChannelTab(_ba)
if(bba)then
local cba=(self:GetChannel(baa.GeneralChannelName)~=nil)
local dba=(aba==baa.GeneralChannelName:lower())local _ca=nil
if(cba and not dba)then _ca=baa.GeneralChannelName else
local aca=self:GetFirstChannel()_ca=(aca and aca.Name or nil)end;self:SwitchCurrentChannel(_ca)end
if not baa.ShowChannelsBar then if self.ChatBar.TargetChannel==_ba then
self.ChatBar:SetChannelTarget(baa.GeneralChannelName)end end end;function daa:GetChannel(_ba)return
_ba and self.Channels[_ba:lower()]or nil end
function daa:GetTargetMessageChannel()
if(
not baa.ShowChannelsBar)then return self.ChatBar.TargetChannel else
local _ba=self:GetCurrentChannel()return _ba and _ba.Name end end;function daa:GetCurrentChannel()return self.CurrentChannel end
function daa:SwitchCurrentChannel(_ba)
if(
not baa.ShowChannelsBar)then local cba=self:GetChannel(_ba)if(cba)then
self.ChatBar:SetChannelTarget(cba.Name)end;_ba=baa.GeneralChannelName end;local aba=self:GetCurrentChannel()
local bba=self:GetChannel(_ba)if bba==nil then
error(string.format("Channel '%s' does not exist.",_ba))end
if(bba~=aba)then
if(aba)then
aba:SetActive(false)
local cba=self.ChannelsBar:GetChannelTab(aba.Name)cba:SetActive(false)end
if(bba)then bba:SetActive(true)
local cba=self.ChannelsBar:GetChannelTab(bba.Name)cba:SetActive(true)end;self.CurrentChannel=bba end end;function daa:UpdateFrameVisibility()
self.GuiObject.Visible=(self.Visible and self.CoreGuiEnabled)end;function daa:GetVisible()
return self.Visible end;function daa:SetVisible(_ba)self.Visible=_ba
self:UpdateFrameVisibility()end
function daa:GetCoreGuiEnabled()return self.CoreGuiEnabled end;function daa:SetCoreGuiEnabled(_ba)self.CoreGuiEnabled=_ba
self:UpdateFrameVisibility()end;function daa:EnableResizable()
self.GuiObjects.ChatResizerFrame.Active=true end;function daa:DisableResizable()
self.GuiObjects.ChatResizerFrame.Active=false end
function daa:FadeOutBackground(_ba)
self.ChannelsBar:FadeOutBackground(_ba)
self.MessageLogDisplay:FadeOutBackground(_ba)self.ChatBar:FadeOutBackground(_ba)
self.AnimParams.Background_TargetTransparency=1
self.AnimParams.Background_NormalizedExptValue=caa:NormalizedDefaultExptValueInSeconds(_ba)end
function daa:FadeInBackground(_ba)
self.ChannelsBar:FadeInBackground(_ba)
self.MessageLogDisplay:FadeInBackground(_ba)self.ChatBar:FadeInBackground(_ba)
self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=caa:NormalizedDefaultExptValueInSeconds(_ba)end
function daa:FadeOutText(_ba)
self.MessageLogDisplay:FadeOutText(_ba)self.ChannelsBar:FadeOutText(_ba)end
function daa:FadeInText(_ba)
self.MessageLogDisplay:FadeInText(_ba)self.ChannelsBar:FadeInText(_ba)end
function daa:AnimGuiObjects()
self.GuiObjects.ChatChannelParentFrame.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.ChatResizerFrame.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.ResizeIcon.ImageTransparency=self.AnimParams.Background_CurrentTransparency end
function daa:InitializeAnimParams()self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_CurrentTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=caa:NormalizedDefaultExptValueInSeconds(0)end
function daa:Update(_ba)self.ChatBar:Update(_ba)
self.ChannelsBar:Update(_ba)self.MessageLogDisplay:Update(_ba)
self.AnimParams.Background_CurrentTransparency=caa:Expt(self.AnimParams.Background_CurrentTransparency,self.AnimParams.Background_TargetTransparency,self.AnimParams.Background_NormalizedExptValue,_ba)self:AnimGuiObjects()end
function cc.new()local _ba=setmetatable({},daa)_ba.GuiObject=nil;_ba.GuiObjects={}_ba.ChatBar=
nil;_ba.ChannelsBar=nil;_ba.MessageLogDisplay=nil;_ba.Channels={}_ba.CurrentChannel=
nil;_ba.Visible=true;_ba.CoreGuiEnabled=true;_ba.AnimParams={}
_ba:InitializeAnimParams()return _ba end;return cc