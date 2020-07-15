local ab={}
local bb=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")local cb=game:GetService("Chat")
local db=cb:WaitForChild("ClientChatModules")local _c=script.Parent
local ac=require(_c:WaitForChild("ChannelsTab"))
local bc=require(_c:WaitForChild("MessageSender"))
local cc=require(db:WaitForChild("ChatSettings"))local dc=require(_c:WaitForChild("CurveUtil"))
local _d={}_d.__index=_d
function _d:CreateGuiObjects(ad)local bd=Instance.new("Frame")
bd.Selectable=false;bd.Size=UDim2.new(1,0,1,0)bd.BackgroundTransparency=1
bd.Parent=ad;local cd=Instance.new("Frame")cd.Selectable=false
cd.Name="ScrollingBase"cd.BackgroundTransparency=1;cd.ClipsDescendants=true
cd.Size=UDim2.new(1,0,1,0)cd.Position=UDim2.new(0,0,0,0)cd.Parent=bd
local dd=Instance.new("Frame")dd.Selectable=false;dd.Name="ScrollerSizer"dd.BackgroundTransparency=1
dd.Size=UDim2.new(1,0,1,0)dd.Position=UDim2.new(0,0,0,0)dd.Parent=cd
local __a=Instance.new("Frame")__a.Selectable=false;__a.Name="ScrollerFrame"__a.BackgroundTransparency=1
__a.Size=UDim2.new(1,0,1,0)__a.Position=UDim2.new(0,0,0,0)__a.Parent=dd
local a_a=Instance.new("Frame")a_a.Selectable=false;a_a.Size=UDim2.new(1,0,1,0)
a_a.Position=UDim2.new(0,0,0,0)a_a.ClipsDescendants=true;a_a.BackgroundTransparency=1;a_a.Parent=bd
local b_a=Instance.new("Frame")b_a.Selectable=false;b_a.Name="LeaveConfirmationFrame"
b_a.Size=UDim2.new(1,0,1,0)b_a.Position=UDim2.new(0,0,1,0)b_a.BackgroundTransparency=0.6
b_a.BorderSizePixel=0;b_a.BackgroundColor3=Color3.new(0,0,0)b_a.Parent=a_a
local c_a=Instance.new("TextButton")c_a.Selectable=false;c_a.Size=UDim2.new(1,0,1,0)
c_a.BackgroundTransparency=1;c_a.Text=""c_a.Parent=b_a;local d_a=Instance.new("TextButton")
d_a.Selectable=false;d_a.Size=UDim2.new(0.25,0,1,0)d_a.BackgroundTransparency=1
d_a.Font=cc.DefaultFont;d_a.TextSize=18;d_a.TextStrokeTransparency=0.75
d_a.Position=UDim2.new(0,0,0,0)d_a.TextColor3=Color3.new(0,1,0)d_a.Text="Confirm"
d_a.Parent=b_a;local _aa=d_a:Clone()_aa.Parent=b_a
_aa.Position=UDim2.new(0.75,0,0,0)_aa.TextColor3=Color3.new(1,0,0)_aa.Text="Cancel"
local aaa=Instance.new("TextLabel")aaa.Selectable=false;aaa.Size=UDim2.new(0.5,0,1,0)
aaa.Position=UDim2.new(0.25,0,0,0)aaa.BackgroundTransparency=1;aaa.TextColor3=Color3.new(1,1,1)
aaa.TextStrokeTransparency=0.75;aaa.Text="Leave channel <XX>?"aaa.Font=cc.DefaultFont;aaa.TextSize=18
aaa.Parent=b_a;local baa=Instance.new("StringValue")baa.Name="LeaveTarget"
baa.Parent=b_a;local caa=b_a.Position
d_a.MouseButton1Click:connect(function()bc:SendMessage(string.format("/leave %s",baa.Value),
nil)
b_a:TweenPosition(caa,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)end)
_aa.MouseButton1Click:connect(function()
b_a:TweenPosition(caa,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,0.2,true)end)local daa=0.7;local _ba=(1 -daa)/2
local aba="rbxasset://textures/ui/Chat/TabArrowBackground.png"local bba="rbxasset://textures/ui/Chat/TabArrow.png"aba="rbxassetid://471630199"
bba="rbxassetid://471630112"local cba=Instance.new("ImageButton",bd)
cba.Selectable=cc.GamepadNavigationEnabled;cba.Name="PageLeftButton"
cba.SizeConstraint=Enum.SizeConstraint.RelativeYY;cba.Size=UDim2.new(daa,0,daa,0)cba.BackgroundTransparency=1
cba.Position=UDim2.new(0,4,_ba,0)cba.Visible=false;cba.Image=aba
local dba=Instance.new("ImageLabel",cba)dba.Name="ArrowLabel"dba.BackgroundTransparency=1
dba.Size=UDim2.new(0.4,0,0.4,0)dba.Image=bba;local _ca=Instance.new("Frame",bd)
_ca.Selectable=false;_ca.BackgroundTransparency=1;_ca.Name="PositionalHelper"
_ca.Size=cba.Size;_ca.SizeConstraint=cba.SizeConstraint
_ca.Position=UDim2.new(1,0,_ba,0)local aca=cba:Clone()aca.Parent=_ca;aca.Name="PageRightButton"
aca.Size=UDim2.new(1,0,1,0)aca.SizeConstraint=Enum.SizeConstraint.RelativeXY;aca.Position=UDim2.new(
-1,-4,0,0)local bca=UDim2.new(0.05,0,0,0)aca.ArrowLabel.Position=
UDim2.new(0.3,0,0.3,0)+bca;cba.ArrowLabel.Position=
UDim2.new(0.3,0,0.3,0)-bca
cba.ArrowLabel.Rotation=180;self.GuiObject=bd;self.GuiObjects.BaseFrame=bd
self.GuiObjects.ScrollerSizer=dd;self.GuiObjects.ScrollerFrame=__a
self.GuiObjects.PageLeftButton=cba;self.GuiObjects.PageRightButton=aca
self.GuiObjects.LeaveConfirmationFrame=b_a;self.GuiObjects.LeaveConfirmationNotice=aaa
self.GuiObjects.PageLeftButtonArrow=cba.ArrowLabel;self.GuiObjects.PageRightButtonArrow=aca.ArrowLabel
self:AnimGuiObjects()
cba.MouseButton1Click:connect(function()self:ScrollChannelsFrame(-1)end)
aca.MouseButton1Click:connect(function()self:ScrollChannelsFrame(1)end)self:ScrollChannelsFrame(0)end
function _d:UpdateMessagePostedInChannel(ad)local bd=self:GetChannelTab(ad)if(bd)then
bd:UpdateMessagePostedInChannel()else
warn("ChannelsTab '"..ad.."' does not exist!")end end
function _d:AddChannelTab(ad)if(self:GetChannelTab(ad))then
error("Channel tab '"..ad.."'already exists!")end;local bd=ac.new(ad)
bd.GuiObject.Parent=self.GuiObjects.ScrollerFrame;self.ChannelTabs[ad:lower()]=bd
self.NumTabs=self.NumTabs+1;self:OrganizeChannelTabs()
if(cc.RightClickToLeaveChannelEnabled)then
bd.NameTag.MouseButton2Click:connect(function()
self.LeaveConfirmationNotice.Text=string.format("Leave channel %s?",bd.ChannelName)
self.LeaveConfirmationFrame.LeaveTarget.Value=bd.ChannelName
self.LeaveConfirmationFrame:TweenPosition(UDim2.new(0,0,0,0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.2,true)end)end;return bd end
function _d:RemoveChannelTab(ad)
if(not self:GetChannelTab(ad))then error("Channel tab '"..
ad.."'does not exist!")end;local bd=ad:lower()
self.ChannelTabs[bd]:Destroy()self.ChannelTabs[bd]=nil;self.NumTabs=self.NumTabs-1
self:OrganizeChannelTabs()end
function _d:GetChannelTab(ad)return self.ChannelTabs[ad:lower()]end
function _d:OrganizeChannelTabs()local ad={}
table.insert(ad,self:GetChannelTab(cc.GeneralChannelName))
table.insert(ad,self:GetChannelTab("System"))for bd,cd in pairs(self.ChannelTabs)do
if(cd.ChannelName~=cc.GeneralChannelName and
cd.ChannelName~="System")then table.insert(ad,cd)end end
for bd,cd in
pairs(ad)do cd.GuiObject.Position=UDim2.new(bd-1,0,0,0)end
self.GuiObjects.ScrollerSizer.Size=UDim2.new(1 /
math.max(1,math.min(cc.ChannelsBarFullTabSize,self.NumTabs)),0,1,0)self:ScrollChannelsFrame(0)end;function _d:ResizeChannelTabText(ad)
for bd,cd in pairs(self.ChannelTabs)do cd:SetTextSize(ad)end end
function _d:ScrollChannelsFrame(ad)if
(self.ScrollChannelsFrameLock)then return end;self.ScrollChannelsFrameLock=true
local bd=cc.ChannelsBarFullTabSize;local cd=self.CurPageNum+ad;if(cd<0)then cd=0 elseif
(cd>0 and cd+bd>self.NumTabs)then cd=self.NumTabs-bd end
self.CurPageNum=cd;local dd=0.15;local __a=UDim2.new(-self.CurPageNum,0,0,0)self.GuiObjects.PageLeftButton.Visible=(
self.CurPageNum>0)self.GuiObjects.PageRightButton.Visible=(
self.CurPageNum+bd<self.NumTabs)if
ad==0 then self.ScrollChannelsFrameLock=false;return end;local function a_a()
self.ScrollChannelsFrameLock=false end
self:WaitUntilParentedCorrectly()
self.GuiObjects.ScrollerFrame:TweenPosition(__a,Enum.EasingDirection.InOut,Enum.EasingStyle.Quad,dd,true,a_a)end
function _d:FadeOutBackground(ad)
for bd,cd in pairs(self.ChannelTabs)do cd:FadeOutBackground(ad)end;self.AnimParams.Background_TargetTransparency=1
self.AnimParams.Background_NormalizedExptValue=dc:NormalizedDefaultExptValueInSeconds(ad)end
function _d:FadeInBackground(ad)
for bd,cd in pairs(self.ChannelTabs)do cd:FadeInBackground(ad)end;self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=dc:NormalizedDefaultExptValueInSeconds(ad)end;function _d:FadeOutText(ad)
for bd,cd in pairs(self.ChannelTabs)do cd:FadeOutText(ad)end end
function _d:FadeInText(ad)for bd,cd in
pairs(self.ChannelTabs)do cd:FadeInText(ad)end end
function _d:AnimGuiObjects()
self.GuiObjects.PageLeftButton.ImageTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.PageRightButton.ImageTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.PageLeftButtonArrow.ImageTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.PageRightButtonArrow.ImageTransparency=self.AnimParams.Background_CurrentTransparency end
function _d:InitializeAnimParams()self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_CurrentTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=dc:NormalizedDefaultExptValueInSeconds(0)end
function _d:Update(ad)
for bd,cd in pairs(self.ChannelTabs)do cd:Update(ad)end
self.AnimParams.Background_CurrentTransparency=dc:Expt(self.AnimParams.Background_CurrentTransparency,self.AnimParams.Background_TargetTransparency,self.AnimParams.Background_NormalizedExptValue,ad)self:AnimGuiObjects()end
function _d:WaitUntilParentedCorrectly()while(not
self.GuiObject:IsDescendantOf(game:GetService("Players").LocalPlayer))do
self.GuiObject.AncestryChanged:wait()end end
function ab.new()local ad=setmetatable({},_d)ad.GuiObject=nil;ad.GuiObjects={}
ad.ChannelTabs={}ad.NumTabs=0;ad.CurPageNum=0;ad.ScrollChannelsFrameLock=false
ad.AnimParams={}ad:InitializeAnimParams()
cc.SettingsChanged:connect(function(bd,cd)if
(bd=="ChatChannelsTabTextSize")then ad:ResizeChannelTabText(cd)end end)return ad end;return ab