local cc={}local dc=game:GetService("UserInputService")
local _d=game:GetService("RunService")local ad=game:GetService("Players")
local bd=game:GetService("TextService")local cd=ad.LocalPlayer;while not cd do ad.PlayerAdded:wait()
cd=ad.LocalPlayer end;local dd=game:GetService("Chat")
local __a=dd:WaitForChild("ClientChatModules")local a_a=script.Parent
local b_a=require(__a:WaitForChild("ChatSettings"))
local c_a=require(a_a:WaitForChild("CurveUtil"))local d_a=__a:WaitForChild("CommandModules")
local _aa=require(d_a:WaitForChild("Whisper"))
local aaa=require(a_a:WaitForChild("MessageSender"))local baa=nil
pcall(function()
baa=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if baa==nil then baa={}function baa:Get(_ba,aba)return aba end end;local caa={}caa.__index=caa
function caa:CreateGuiObjects(_ba)self.ChatBarParentFrame=_ba;local aba=7;local bba=5
local cba=Instance.new("Frame")cba.Selectable=false;cba.Size=UDim2.new(1,0,1,0)
cba.BackgroundTransparency=0.6;cba.BorderSizePixel=0;cba.BackgroundColor3=b_a.ChatBarBackGroundColor
cba.Parent=_ba;local dba=Instance.new("Frame")dba.Selectable=false
dba.Name="BoxFrame"dba.BackgroundTransparency=0.6;dba.BorderSizePixel=0
dba.BackgroundColor3=b_a.ChatBarBoxColor;dba.Size=UDim2.new(1,-aba*2,1,-aba*2)
dba.Position=UDim2.new(0,aba,0,aba)dba.Parent=cba;local _ca=Instance.new("Frame")
_ca.BackgroundTransparency=1;_ca.Size=UDim2.new(1,-bba*2,1,-bba*2)
_ca.Position=UDim2.new(0,bba,0,bba)_ca.Parent=dba;local aca=Instance.new("TextBox")
aca.Selectable=b_a.GamepadNavigationEnabled;aca.Name="ChatBar"aca.BackgroundTransparency=1
aca.Size=UDim2.new(1,0,1,0)aca.Position=UDim2.new(0,0,0,0)
aca.TextSize=b_a.ChatBarTextSize;aca.Font=b_a.ChatBarFont;aca.TextColor3=b_a.ChatBarTextColor
aca.TextTransparency=0.4;aca.TextStrokeTransparency=1;aca.ClearTextOnFocus=false
aca.TextXAlignment=Enum.TextXAlignment.Left;aca.TextYAlignment=Enum.TextYAlignment.Top
aca.TextWrapped=true;aca.Text=""aca.Parent=_ca;local bca=Instance.new("TextButton")
bca.Selectable=false;bca.Name="MessageMode"bca.BackgroundTransparency=1
bca.Position=UDim2.new(0,0,0,0)bca.TextSize=b_a.ChatBarTextSize;bca.Font=b_a.ChatBarFont
bca.TextXAlignment=Enum.TextXAlignment.Left;bca.TextWrapped=true;bca.Text=""bca.Size=UDim2.new(0,0,0,0)
bca.TextYAlignment=Enum.TextYAlignment.Center;bca.TextColor3=self:GetDefaultChannelNameColor()
bca.Visible=true;bca.Parent=_ca;local cca=Instance.new("TextLabel")
cca.Selectable=false;cca.TextWrapped=true;cca.BackgroundTransparency=1;cca.Size=aca.Size
cca.Position=aca.Position;cca.TextSize=aca.TextSize;cca.Font=aca.Font
cca.TextColor3=aca.TextColor3;cca.TextTransparency=aca.TextTransparency
cca.TextStrokeTransparency=aca.TextStrokeTransparency;cca.TextXAlignment=aca.TextXAlignment
cca.TextYAlignment=aca.TextYAlignment;cca.Text="..."cca.Parent=_ca;self.GuiObject=cba;self.TextBox=aca
self.TextLabel=cca;self.GuiObjects.BaseFrame=cba
self.GuiObjects.TextBoxFrame=dba;self.GuiObjects.TextBox=aca;self.GuiObjects.TextLabel=cca
self.GuiObjects.MessageModeTextButton=bca;self:AnimGuiObjects()
self:SetUpTextBoxEvents(aca,cca,bca)if self.UserHasChatOff then self:DoLockChatBar()end
self.eGuiObjectsChanged:Fire()end
function caa:DoLockChatBar()
if self.TextLabel then
if cd.UserId>0 then
self.TextLabel.Text=baa:Get("GameChat_ChatMessageValidator_SettingsError","To chat in game, turn on chat in your Privacy Settings.")else
self.TextLabel.Text=baa:Get("GameChat_SwallowGuestChat_Message","Sign up to chat in game.")end;self:CalculateSize()end;if self.TextBox then self.TextBox.Active=false
self.TextBox.Focused:connect(function()
self.TextBox:ReleaseFocus()end)end end
function caa:SetUpTextBoxEvents(_ba,aba,bba)for dba,_ca in pairs(self.TextBoxConnections)do _ca:disconnect()self.TextBoxConnections[dba]=
nil end
self.TextBoxConnections.UserInputBegan=dc.InputBegan:connect(function(dba,_ca)if(
dba.KeyCode==Enum.KeyCode.Backspace)then
if
(self:IsFocused()and _ba.Text=="")then self:SetChannelTarget(b_a.GeneralChannelName)end end end)
self.TextBoxConnections.TextBoxChanged=_ba.Changed:connect(function(dba)if dba=="AbsoluteSize"then
self:CalculateSize()return end;if dba~="Text"then return end
self:CalculateSize()if(string.len(_ba.Text)>b_a.MaximumMessageLength)then
_ba.Text=string.sub(_ba.Text,1,b_a.MaximumMessageLength)return end
if
not self.InCustomState then
local _ca=self.CommandProcessor:ProcessInProgressChatMessage(_ba.Text,self.ChatWindow,self)
if _ca then self.InCustomState=true;self.CustomState=_ca end else self.CustomState:TextUpdated()end end)local function cba(dba)
if dba or _ba.Text~=""then aba.Visible=false else aba.Visible=true end end
self.TextBoxConnections.MessageModeClick=bba.MouseButton1Click:connect(function()if
bba.Text~=""then
self:SetChannelTarget(b_a.GeneralChannelName)end end)
self.TextBoxConnections.TextBoxFocused=_ba.Focused:connect(function()if not self.UserHasChatOff then
self:CalculateSize()cba(true)end end)
self.TextBoxConnections.TextBoxFocusLost=_ba.FocusLost:connect(function(dba,_ca)
self:CalculateSize()
if(_ca and _ca.KeyCode==Enum.KeyCode.Escape)then _ba.Text=""end;cba(false)end)end;function caa:GetTextBox()return self.TextBox end;function caa:GetMessageModeTextButton()return
self.GuiObjects.MessageModeTextButton end;function caa:GetMessageModeTextLabel()return
self:GetMessageModeTextButton()end;function caa:IsFocused()if
self.UserHasChatOff then return false end;return
self:GetTextBox():IsFocused()end;function caa:GetVisible()return
self.GuiObject.Visible end;function caa:CaptureFocus()
if
not self.UserHasChatOff then self:GetTextBox():CaptureFocus()end end;function caa:ReleaseFocus(_ba)
self:GetTextBox():ReleaseFocus(_ba)end;function caa:ResetText()
self:GetTextBox().Text=""end;function caa:SetText(_ba)
self:GetTextBox().Text=_ba end
function caa:GetEnabled()return self.GuiObject.Visible end
function caa:SetEnabled(_ba)if self.UserHasChatOff then self.GuiObject.Visible=true else
self.GuiObject.Visible=_ba end end;function caa:SetTextLabelText(_ba)
if not self.UserHasChatOff then self.TextLabel.Text=_ba end end;function caa:SetTextBoxText(_ba)
self.TextBox.Text=_ba end
function caa:GetTextBoxText()return self.TextBox.Text end
function caa:ResetSize()self.TargetYSize=0;self:TweenToTargetYSize()end
local function daa(_ba)return
bd:GetTextSize(_ba.Text,_ba.TextSize,_ba.Font,Vector2.new(_ba.AbsoluteSize.X,10000))end
function caa:CalculateSize()if self.CalculatingSizeLock then return end
self.CalculatingSizeLock=true;local _ba=nil;local aba=nil
if
self:IsFocused()or self.TextBox.Text~=""then _ba=self.TextBox.TextSize;aba=daa(self.TextBox).Y else
_ba=self.TextLabel.TextSize;aba=daa(self.TextLabel).Y end;local bba=aba-_ba;if(self.TargetYSize~=bba)then self.TargetYSize=bba
self:TweenToTargetYSize()end;self.CalculatingSizeLock=false end
function caa:TweenToTargetYSize()local _ba=UDim2.new(1,0,1,self.TargetYSize)
local aba=self.GuiObject.Size;local bba=self.GuiObject.AbsoluteSize.Y
self.GuiObject.Size=_ba;local cba=self.GuiObject.AbsoluteSize.Y
self.GuiObject.Size=aba;local dba=math.abs(cba-bba)
local _ca=math.min(1,(dba* (1 /self.TweenPixelsPerSecond)))
local aca=pcall(function()
self.GuiObject:TweenSize(_ba,Enum.EasingDirection.Out,Enum.EasingStyle.Quad,_ca,true)end)if(not aca)then self.GuiObject.Size=_ba end end
function caa:SetTextSize(_ba)if not self:IsInCustomState()then if self.TextBox then
self.TextBox.TextSize=_ba end
if self.TextLabel then self.TextLabel.TextSize=_ba end end end
function caa:GetDefaultChannelNameColor()
if b_a.DefaultChannelNameColor then return b_a.DefaultChannelNameColor end;return Color3.fromRGB(35,76,142)end
function caa:SetChannelTarget(_ba)local aba=self.GuiObjects.MessageModeTextButton
local bba=self.TextBox;local cba=self.TextLabel;self.TargetChannel=_ba
if
not self:IsInCustomState()then
if _ba~=b_a.GeneralChannelName then aba.Size=UDim2.new(0,1000,1,0)
aba.Text=string.format("[%s] ",_ba)local dba=self:GetChannelNameColor(_ba)if dba then aba.TextColor3=dba else
aba.TextColor3=self:GetDefaultChannelNameColor()end;local _ca=aba.TextBounds.X
aba.Size=UDim2.new(0,_ca,1,0)bba.Size=UDim2.new(1,-_ca,1,0)
bba.Position=UDim2.new(0,_ca,0,0)cba.Size=UDim2.new(1,-_ca,1,0)
cba.Position=UDim2.new(0,_ca,0,0)else aba.Text=""aba.Size=UDim2.new(0,0,0,0)
bba.Size=UDim2.new(1,0,1,0)bba.Position=UDim2.new(0,0,0,0)
cba.Size=UDim2.new(1,0,1,0)cba.Position=UDim2.new(0,0,0,0)end end end;function caa:IsInCustomState()return self.InCustomState end
function caa:ResetCustomState()
if
self.InCustomState then self.CustomState:Destroy()self.CustomState=nil
self.InCustomState=false
self.ChatBarParentFrame:ClearAllChildren()self:CreateGuiObjects(self.ChatBarParentFrame)
self:SetTextLabelText(baa:Get("GameChat_ChatMain_ChatBarText",'To chat click here or press "/" key'))end end
function caa:EnterWhisperState(_ba)self:ResetCustomState()
self:CaptureFocus()
if _aa.CustomStateCreator then
self.CustomState=_aa.CustomStateCreator(_ba,self.ChatWindow,self,b_a)self.InCustomState=true else
self:SetText("/w ".._ba.Name)end end
function caa:GetCustomMessage()if self.InCustomState then
return self.CustomState:GetMessage()end;return nil end
function caa:CustomStateProcessCompletedMessage(_ba)if self.InCustomState then return
self.CustomState:ProcessCompletedMessage()end;return false end
function caa:FadeOutBackground(_ba)self.AnimParams.Background_TargetTransparency=1
self.AnimParams.Background_NormalizedExptValue=c_a:NormalizedDefaultExptValueInSeconds(_ba)self:FadeOutText(_ba)end
function caa:FadeInBackground(_ba)self.AnimParams.Background_TargetTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=c_a:NormalizedDefaultExptValueInSeconds(_ba)self:FadeInText(_ba)end
function caa:FadeOutText(_ba)self.AnimParams.Text_TargetTransparency=1
self.AnimParams.Text_NormalizedExptValue=c_a:NormalizedDefaultExptValueInSeconds(_ba)end
function caa:FadeInText(_ba)self.AnimParams.Text_TargetTransparency=0.4
self.AnimParams.Text_NormalizedExptValue=c_a:NormalizedDefaultExptValueInSeconds(_ba)end
function caa:AnimGuiObjects()
self.GuiObject.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.TextBoxFrame.BackgroundTransparency=self.AnimParams.Background_CurrentTransparency
self.GuiObjects.TextLabel.TextTransparency=self.AnimParams.Text_CurrentTransparency
self.GuiObjects.TextBox.TextTransparency=self.AnimParams.Text_CurrentTransparency
self.GuiObjects.MessageModeTextButton.TextTransparency=self.AnimParams.Text_CurrentTransparency end
function caa:InitializeAnimParams()self.AnimParams.Text_TargetTransparency=0.4
self.AnimParams.Text_CurrentTransparency=0.4;self.AnimParams.Text_NormalizedExptValue=1
self.AnimParams.Background_TargetTransparency=0.6;self.AnimParams.Background_CurrentTransparency=0.6
self.AnimParams.Background_NormalizedExptValue=1 end
function caa:Update(_ba)
self.AnimParams.Text_CurrentTransparency=c_a:Expt(self.AnimParams.Text_CurrentTransparency,self.AnimParams.Text_TargetTransparency,self.AnimParams.Text_NormalizedExptValue,_ba)
self.AnimParams.Background_CurrentTransparency=c_a:Expt(self.AnimParams.Background_CurrentTransparency,self.AnimParams.Background_TargetTransparency,self.AnimParams.Background_NormalizedExptValue,_ba)self:AnimGuiObjects()end
function caa:SetChannelNameColor(_ba,aba)self.ChannelNameColors[_ba]=aba;if
self.GuiObjects.MessageModeTextButton.Text==_ba then
self.GuiObjects.MessageModeTextButton.TextColor3=aba end end
function caa:GetChannelNameColor(_ba)return self.ChannelNameColors[_ba]end
function cc.new(_ba,aba)local bba=setmetatable({},caa)bba.GuiObject=nil
bba.ChatBarParentFrame=nil;bba.TextBox=nil;bba.TextLabel=nil;bba.GuiObjects={}
bba.eGuiObjectsChanged=Instance.new("BindableEvent")bba.GuiObjectsChanged=bba.eGuiObjectsChanged.Event
bba.TextBoxConnections={}bba.InCustomState=false;bba.CustomState=nil;bba.TargetChannel=nil
bba.CommandProcessor=_ba;bba.ChatWindow=aba;bba.TweenPixelsPerSecond=500;bba.TargetYSize=0
bba.AnimParams={}bba.CalculatingSizeLock=false;bba.ChannelNameColors={}
bba.UserHasChatOff=false;bba:InitializeAnimParams()
b_a.SettingsChanged:connect(function(cba,dba)if
(cba=="ChatBarTextSize")then bba:SetTextSize(dba)end end)
coroutine.wrap(function()
local cba,dba=pcall(function()return dd:CanUserChatAsync(cd.UserId)end)local _ca=cba and(_d:IsStudio()or dba)if _ca==false then
bba.UserHasChatOff=true;bba:DoLockChatBar()end end)()return bba end;return cc