local da={}local _b=game:GetService("Chat")
local ab=_b:WaitForChild("ClientChatModules")local bb=script.Parent
local cb=require(ab:WaitForChild("ChatSettings"))local db=require(bb:WaitForChild("CurveUtil"))
local _c={}_c.__index=_c
local function ac()local bc=Instance.new("Frame")bc.Selectable=false
bc.Size=UDim2.new(1,0,1,0)bc.BackgroundTransparency=1;local cc=1;local dc=1
local _d=Instance.new("Frame")_d.Selectable=false;_d.Name="BackgroundFrame"
_d.Size=UDim2.new(1,-cc*2,1,-dc*2)_d.Position=UDim2.new(0,cc,0,dc)_d.BackgroundTransparency=1
_d.Parent=bc;local ad=Instance.new("Frame")ad.Selectable=false
ad.Name="UnselectedFrame"ad.Size=UDim2.new(1,0,1,0)ad.Position=UDim2.new(0,0,0,0)
ad.BorderSizePixel=0;ad.BackgroundColor3=cb.ChannelsTabUnselectedColor
ad.BackgroundTransparency=0.6;ad.Parent=_d;local bd=Instance.new("Frame")bd.Selectable=false
bd.Name="SelectedFrame"bd.Size=UDim2.new(1,0,1,0)bd.Position=UDim2.new(0,0,0,0)
bd.BorderSizePixel=0;bd.BackgroundColor3=cb.ChannelsTabSelectedColor
bd.BackgroundTransparency=1;bd.Parent=_d;local cd=Instance.new("ImageLabel")
cd.Selectable=false;cd.Name="BackgroundImage"cd.BackgroundTransparency=1;cd.BorderSizePixel=0
cd.Size=UDim2.new(1,0,1,0)cd.Position=UDim2.new(0,0,0,0)
cd.ScaleType=Enum.ScaleType.Slice;cd.Parent=bd;cd.BackgroundTransparency=0.6 -1;local dd=1.2 *1;cd.BackgroundColor3=Color3.fromRGB(
78 *dd,84 *dd,96 *dd)local __a=2;local a_a=4
local b_a=Instance.new("ImageLabel")b_a.Selectable=false;b_a.Size=UDim2.new(0.5,-__a,0,a_a)
b_a.BackgroundTransparency=1;b_a.ScaleType=Enum.ScaleType.Slice
b_a.SliceCenter=Rect.new(3,3,32,21)b_a.Parent=bd;local c_a=b_a:Clone()c_a.Parent=bd
b_a.Position=UDim2.new(0,__a,1,-a_a)c_a.Position=UDim2.new(0.5,0,1,-a_a)
b_a.Image="rbxasset://textures/ui/Settings/Slider/SelectedBarLeft.png"c_a.Image="rbxasset://textures/ui/Settings/Slider/SelectedBarRight.png"
b_a.Name="BlueBarLeft"c_a.Name="BlueBarRight"local d_a=Instance.new("TextButton")
d_a.Selectable=cb.GamepadNavigationEnabled;d_a.Size=UDim2.new(1,0,1,0)
d_a.Position=UDim2.new(0,0,0,0)d_a.BackgroundTransparency=1;d_a.Font=cb.DefaultFont
d_a.TextSize=cb.ChatChannelsTabTextSize;d_a.TextColor3=Color3.new(1,1,1)d_a.TextStrokeTransparency=0.75
d_a.Parent=_d;local _aa=d_a:Clone()local aaa=d_a:Clone()_aa.Parent=ad;aaa.Parent=bd
_aa.Font=Enum.Font.SourceSans;_aa.Active=false;aaa.Active=false;local baa=Instance.new("Frame")
baa.Selectable=false;baa.Size=UDim2.new(0,18,0,18)
baa.Position=UDim2.new(0.8,-9,0.5,-9)baa.BackgroundTransparency=1;baa.Parent=_d
local caa=Instance.new("ImageLabel")caa.Selectable=false;caa.Size=UDim2.new(1,0,1,0)
caa.BackgroundTransparency=1;caa.Image="rbxasset://textures/ui/Chat/MessageCounter.png"
caa.Visible=false;caa.Parent=baa;local daa=Instance.new("TextLabel")
daa.Selectable=false;daa.BackgroundTransparency=1;daa.Size=UDim2.new(0,13,0,9)daa.Position=UDim2.new(0.5,
-7,0.5,-7)daa.Font=cb.DefaultFont
daa.TextSize=14;daa.TextColor3=Color3.new(1,1,1)daa.Text=""daa.Parent=caa;return bc,d_a,_aa,aaa,
caa,ad,bd end;function _c:Destroy()self.GuiObject:Destroy()end
function _c:UpdateMessagePostedInChannel(bc)if(
self.Active and(bc~=true))then return end
local cc=self.UnreadMessageCount+1;self.UnreadMessageCount=cc;local dc=self.NewMessageIcon;dc.Visible=true;dc.TextLabel.Text=(
cc<100)and tostring(cc)or"!"
local _d=0.15;local ad=UDim2.new(0,0,-0.1,0)local bd=dc.Position;local cd=bd+ad
local dd=Enum.EasingDirection.Out;local __a=Enum.EasingStyle.Quad
dc.Position=UDim2.new(0,0,-0.15,0)
dc:TweenPosition(UDim2.new(0,0,0,0),dd,__a,_d,true)end
function _c:SetActive(bc)self.Active=bc;self.UnselectedFrame.Visible=not bc
self.SelectedFrame.Visible=bc
if(bc)then self.UnreadMessageCount=0;self.NewMessageIcon.Visible=false
self.NameTag.Font=Enum.Font.SourceSansBold else self.NameTag.Font=Enum.Font.SourceSans end end;function _c:SetTextSize(bc)self.NameTag.TextSize=bc end
function _c:FadeOutBackground(bc)
self.AnimParams.Background_TargetTransparency=1
self.AnimParams.Background_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)end
function _c:FadeInBackground(bc)self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)end
function _c:FadeOutText(bc)self.AnimParams.Text_TargetTransparency=1
self.AnimParams.Text_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)self.AnimParams.TextStroke_TargetTransparency=1
self.AnimParams.TextStroke_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)end
function _c:FadeInText(bc)self.AnimParams.Text_TargetTransparency=0
self.AnimParams.Text_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)self.AnimParams.TextStroke_TargetTransparency=0.75
self.AnimParams.TextStroke_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(bc)end
function _c:AnimGuiObjects()
self.UnselectedFrame.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.SelectedFrame.BackgroundImage.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.SelectedFrame.BlueBarLeft.ImageTransparency=self.AnimParams.Background_CurrentTransparency
self.SelectedFrame.BlueBarRight.ImageTransparency=self.AnimParams.Background_CurrentTransparency
self.NameTagNonSelect.TextTransparency=self.AnimParams.Background_CurrentTransparency
self.NameTagNonSelect.TextStrokeTransparency=self.AnimParams.Background_CurrentTransparency
self.NameTag.TextTransparency=self.AnimParams.Text_CurrentTransparency
self.NewMessageIcon.ImageTransparency=self.AnimParams.Text_CurrentTransparency
self.WhiteTextNewMessageNotification.TextTransparency=self.AnimParams.Text_CurrentTransparency
self.NameTagSelect.TextTransparency=self.AnimParams.Text_CurrentTransparency
self.NameTag.TextStrokeTransparency=self.AnimParams.TextStroke_CurrentTransparency
self.WhiteTextNewMessageNotification.TextStrokeTransparency=self.AnimParams.TextStroke_CurrentTransparency
self.NameTagSelect.TextStrokeTransparency=self.AnimParams.TextStroke_CurrentTransparency end
function _c:InitializeAnimParams()self.AnimParams.Text_TargetTransparency=0
self.AnimParams.Text_CurrentTransparency=0
self.AnimParams.Text_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(0)self.AnimParams.TextStroke_TargetTransparency=0.75
self.AnimParams.TextStroke_CurrentTransparency=0.75
self.AnimParams.TextStroke_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(0)self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_CurrentTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=db:NormalizedDefaultExptValueInSeconds(0)end
function _c:Update(bc)
self.AnimParams.Background_CurrentTransparency=db:Expt(self.AnimParams.Background_CurrentTransparency,self.AnimParams.Background_TargetTransparency,self.AnimParams.Background_NormalizedExptValue,bc)
self.AnimParams.Text_CurrentTransparency=db:Expt(self.AnimParams.Text_CurrentTransparency,self.AnimParams.Text_TargetTransparency,self.AnimParams.Text_NormalizedExptValue,bc)
self.AnimParams.TextStroke_CurrentTransparency=db:Expt(self.AnimParams.TextStroke_CurrentTransparency,self.AnimParams.TextStroke_TargetTransparency,self.AnimParams.TextStroke_NormalizedExptValue,bc)self:AnimGuiObjects()end
function da.new(bc)local cc=setmetatable({},_c)local dc,_d,ad,bd,cd,dd,__a=ac()cc.GuiObject=dc
cc.NameTag=_d;cc.NameTagNonSelect=ad;cc.NameTagSelect=bd;cc.NewMessageIcon=cd
cc.UnselectedFrame=dd;cc.SelectedFrame=__a;cc.BlueBarLeft=__a.BlueBarLeft
cc.BlueBarRight=__a.BlueBarRight;cc.BackgroundImage=__a.BackgroundImage
cc.WhiteTextNewMessageNotification=cc.NewMessageIcon.TextLabel;cc.ChannelName=bc;cc.UnreadMessageCount=0;cc.Active=false;cc.GuiObject.Name=
"Frame_"..cc.ChannelName;if
(string.len(bc)>cb.MaxChannelNameLength)then
bc=string.sub(bc,1,cb.MaxChannelNameLength-3).."..."end;cc.NameTag.Text=""
cc.NameTagNonSelect.Text=bc;cc.NameTagSelect.Text=bc;cc.AnimParams={}
cc:InitializeAnimParams()cc:AnimGuiObjects()cc:SetActive(false)return cc end;return da