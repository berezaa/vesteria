local bb={}bb.ScrollBarThickness=4;local cb=game:GetService("Chat")
local db=cb:WaitForChild("ClientChatModules")local _c=script.Parent
local ac=require(_c:WaitForChild("MessageLabelCreator"))local bc=require(_c:WaitForChild("CurveUtil"))
local cc=require(db:WaitForChild("ChatSettings"))local dc=false
do
local cd,dd=pcall(function()return
UserSettings():IsUserFeatureEnabled("UserFixChatMessageLogPerformance")end)if cd then dc=dd end end;local _d=ac.new()local ad={}ad.__index=ad
local function bd()
local cd=Instance.new("Frame")cd.Selectable=false;cd.Size=UDim2.new(1,0,1,0)
cd.BackgroundTransparency=1;local dd=Instance.new("ScrollingFrame")
dd.Selectable=cc.GamepadNavigationEnabled;dd.Name="Scroller"dd.BackgroundTransparency=1;dd.BorderSizePixel=0
dd.Position=UDim2.new(0,0,0,3)dd.Size=UDim2.new(1,-4,1,-6)
dd.CanvasSize=UDim2.new(0,0,0,0)dd.ScrollBarThickness=bb.ScrollBarThickness;dd.Active=false;dd.Parent=cd
local __a;if dc then __a=Instance.new("UIListLayout")
__a.SortOrder=Enum.SortOrder.LayoutOrder;__a.Parent=dd end
return cd,dd,__a end
function ad:Destroy()self.GuiObject:Destroy()self.Destroyed=true end;function ad:SetActive(cd)self.GuiObject.Visible=cd end
function ad:UpdateMessageFiltered(cd)local dd=
nil;local __a=1;local a_a=self.MessageObjectLog
while(#a_a>=__a)do local b_a=a_a[__a]if b_a.ID==
cd.ID then dd=b_a;break end;__a=__a+1 end
if dd then local b_a=self:IsScrolledDown()
dd.UpdateTextFunction(cd)if dc then self:PositionMessageLabelInWindow(dd,b_a)else
self:ReorderAllMessages()end end end
function ad:AddMessage(cd)self:WaitUntilParentedCorrectly()
local dd=_d:CreateMessageLabel(cd,self.CurrentChannelName)if dd==nil then return end
table.insert(self.MessageObjectLog,dd)self:PositionMessageLabelInWindow(dd)end
function ad:AddMessageAtIndex(cd,dd)
local __a=_d:CreateMessageLabel(cd,self.CurrentChannelName)if __a==nil then return end
table.insert(self.MessageObjectLog,dd,__a)local a_a=self:IsScrolledDown()
self:ReorderAllMessages()if a_a then
self.Scroller.CanvasPosition=Vector2.new(0,math.max(0,
self.Scroller.CanvasSize.Y.Offset-self.Scroller.AbsoluteSize.Y))end end
function ad:RemoveLastMessage()self:WaitUntilParentedCorrectly()
local cd=self.MessageObjectLog[1]
local dd=UDim2.new(0,0,0,cd.BaseFrame.AbsoluteSize.Y)cd:Destroy()
table.remove(self.MessageObjectLog,1)
if not dc then for __a,a_a in pairs(self.MessageObjectLog)do
a_a.BaseFrame.Position=a_a.BaseFrame.Position-dd end;self.Scroller.CanvasSize=
self.Scroller.CanvasSize-dd end end
function ad:IsScrolledDown()
local cd=self.Scroller.CanvasSize.Y.Offset;local dd=self.Scroller.AbsoluteWindowSize.Y
local __a=self.Scroller.CanvasPosition.Y;if dc then return cd<dd or cd+__a>=dd-5 else return
(cd<dd or cd-__a<=dd+5)end end
function ad:PositionMessageLabelInWindow(cd,dd)self:WaitUntilParentedCorrectly()
local __a=cd.BaseFrame
if dc then if dd==nil then dd=self:IsScrolledDown()end
__a.LayoutOrder=cd.ID else __a.Parent=self.Scroller
__a.Position=UDim2.new(0,0,0,self.Scroller.CanvasSize.Y.Offset)end
__a.Size=UDim2.new(1,0,0,cd.GetHeightFunction(self.Scroller.AbsoluteSize.X))if dc then __a.Parent=self.Scroller end
if cd.BaseMessage then
if dc then
for i=1,10 do if
cd.BaseMessage.TextFits then break end
local a_a=self.Scroller.AbsoluteSize.X-i
__a.Size=UDim2.new(1,0,0,cd.GetHeightFunction(a_a))end else local a_a=self.Scroller.AbsoluteSize.X;local b_a=math.min(
self.Scroller.AbsoluteSize.X-10,0)while not
cd.BaseMessage.TextFits do a_a=a_a-1;if a_a<b_a then break end
__a.Size=UDim2.new(1,0,0,cd.GetHeightFunction(a_a))end end end
if dc then if dd then local a_a=self.Scroller.CanvasSize.Y.Offset-
self.Scroller.AbsoluteSize.Y
self.Scroller.CanvasPosition=Vector2.new(0,math.max(0,a_a))end else
dd=self:IsScrolledDown()local a_a=UDim2.new(0,0,0,__a.Size.Y.Offset)self.Scroller.CanvasSize=
self.Scroller.CanvasSize+a_a;if dd then
self.Scroller.CanvasPosition=Vector2.new(0,math.max(0,
self.Scroller.CanvasSize.Y.Offset-self.Scroller.AbsoluteSize.Y))end end end
function ad:ReorderAllMessages()self:WaitUntilParentedCorrectly()if
self.GuiObject.AbsoluteSize.Y<1 then return end
local cd=self.Scroller.CanvasPosition;local dd=self:IsScrolledDown()
self.Scroller.CanvasSize=UDim2.new(0,0,0,0)for __a,a_a in pairs(self.MessageObjectLog)do
self:PositionMessageLabelInWindow(a_a)end;if not dd then
self.Scroller.CanvasPosition=cd end end
function ad:Clear()
for cd,dd in pairs(self.MessageObjectLog)do dd:Destroy()end;self.MessageObjectLog={}if not dc then
self.Scroller.CanvasSize=UDim2.new(0,0,0,0)end end;function ad:SetCurrentChannelName(cd)self.CurrentChannelName=cd end;function ad:FadeOutBackground(cd)
end;function ad:FadeInBackground(cd)end
function ad:FadeOutText(cd)
for i=1,#self.MessageObjectLog
do if self.MessageObjectLog[i].FadeOutFunction then
self.MessageObjectLog[i].FadeOutFunction(cd,bc)end end end
function ad:FadeInText(cd)
for i=1,#self.MessageObjectLog do if
self.MessageObjectLog[i].FadeInFunction then
self.MessageObjectLog[i].FadeInFunction(cd,bc)end end end
function ad:Update(cd)
for i=1,#self.MessageObjectLog do if
self.MessageObjectLog[i].UpdateAnimFunction then
self.MessageObjectLog[i].UpdateAnimFunction(cd,bc)end end end
function ad:WaitUntilParentedCorrectly()while(not
self.GuiObject:IsDescendantOf(game:GetService("Players").LocalPlayer))do
self.GuiObject.AncestryChanged:wait()end end
function bb.new()local cd=setmetatable({},ad)cd.Destroyed=false;local dd,__a,a_a=bd()
cd.GuiObject=dd;cd.Scroller=__a;cd.Layout=a_a;cd.MessageObjectLog={}
cd.Name="MessageLogDisplay"cd.GuiObject.Name="Frame_"..cd.Name;cd.CurrentChannelName=""
cd.GuiObject:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()spawn(function()
cd:ReorderAllMessages()end)end)
if dc then local b_a=true
cd.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
local c_a=cd.Layout.AbsoluteContentSize;cd.Scroller.CanvasSize=UDim2.new(0,0,0,c_a.Y)if b_a then
local d_a=cd.Scroller.AbsoluteWindowSize
cd.Scroller.CanvasPosition=Vector2.new(0,c_a.Y-d_a.Y)end end)
cd.Scroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
b_a=cd:IsScrolledDown()end)end;return cd end;return bb