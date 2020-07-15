local aa=game:GetService("Players")local ba={"/party ","/p "}
function IsPartyCommand(ab)
for i=1,
#ba do local bb=ba[i]if
string.sub(ab,1,bb:len()):lower()==bb then return true end end;return false end;local ca={}ca.__index=ca
local da=require(script.Parent:WaitForChild("Util"))local _b={}
function ca:EnterPartyChat()self.PartyChatEntered=true
self.MessageModeButton.Size=UDim2.new(0,1000,1,0)self.MessageModeButton.Text="[Party]"
self.MessageModeButton.TextColor3=self:GetPartyChatColor()local ab=self.MessageModeButton.TextBounds.X
self.MessageModeButton.Size=UDim2.new(0,ab,1,0)self.TextBox.Size=UDim2.new(1,-ab,1,0)
self.TextBox.Position=UDim2.new(0,ab,0,0)self.OriginalPartyText=self.TextBox.Text
self.TextBox.Text=" "end
function ca:TextUpdated()local ab=self.TextBox.Text
if not self.PartyChatEntered then if
IsPartyCommand(ab)then self:EnterPartyChat()end else
if ab==""then
self.MessageModeButton.Text=""self.MessageModeButton.Size=UDim2.new(0,0,0,0)
self.TextBox.Size=UDim2.new(1,0,1,0)self.TextBox.Position=UDim2.new(0,0,0,0)
self.TextBox.Text=""self.PartyChatEntered=false
self.ChatBar:ResetCustomState()self.ChatBar:CaptureFocus()end end end
function ca:GetMessage()
if self.PartyChatEntered then return"/p "..self.TextBox.Text end;return self.TextBox.Text end;function ca:ProcessCompletedMessage()return false end;function ca:Destroy()
self.MessageModeConnection:disconnect()self.Destroyed=true end;function ca:GetPartyChatColor()return
Color3.fromRGB(0,240,244)end
function _b.new(ab,bb,cb)
local db=setmetatable({},ca)db.Destroyed=false;db.ChatWindow=ab;db.ChatBar=bb;db.ChatSettings=cb
db.TextBox=bb:GetTextBox()db.MessageModeButton=bb:GetMessageModeTextButton()
db.OriginalPartyText=""db.PartyChatEntered=false
db.MessageModeConnection=db.MessageModeButton.MouseButton1Click:connect(function()
local _c=db.TextBox.Text
if string.sub(_c,1,1)==" "then _c=string.sub(_c,2)end;db.ChatBar:ResetCustomState()
db.ChatBar:SetTextBoxText(_c)db.ChatBar:CaptureFocus()end)db:EnterPartyChat()return db end
function ProcessMessage(ab,bb,cb,db)if cb.TargetChannel=="Party"then return end;if IsPartyCommand(ab)then return
_b.new(bb,cb,db)end;return nil end;return
{[da.KEY_COMMAND_PROCESSOR_TYPE]=da.IN_PROGRESS_MESSAGE_PROCESSOR,[da.KEY_PROCESSOR_FUNCTION]=ProcessMessage}