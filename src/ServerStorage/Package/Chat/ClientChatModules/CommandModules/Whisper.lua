
local ba=require(script.Parent:WaitForChild("Util"))
local ca=require(script.Parent.Parent:WaitForChild("ChatSettings"))local da=game:GetService("Players")local _b=da.LocalPlayer;while _b==nil do
da.ChildAdded:wait()_b=da.LocalPlayer end;local ab={}ab.__index=ab;local bb={}
function ab:TrimWhisperCommand(cb)
if
string.sub(cb,1,3):lower()=="/w "then return string.sub(cb,4)elseif
string.sub(cb,1,9):lower()=="/whisper "then return string.sub(cb,10)end;return nil end;function ab:TrimWhiteSpace(cb)local db=string.gsub(cb,"%s+","")
local _c=cb[#cb]==" "return db,_c end
function ab:ShouldAutoCompleteNames()
if
ca.WhisperCommandAutoCompletePlayerNames~=nil then return ca.WhisperCommandAutoCompletePlayerNames end;return true end
function ab:GetWhisperingPlayer(cb)cb=cb:lower()
local db=self:TrimWhisperCommand(cb)
if db then local _c,ac=self:TrimWhiteSpace(db)local bc={}
local cc=da:GetPlayers()
for i=1,#cc do if cc[i]~=_b then local bd=cc[i].Name:lower()
if
string.sub(bd,1,string.len(_c))==_c then bc[cc[i]]=cc[i].Name:lower()end end end;local dc=0;local _d=nil;local ad=nil;for bd,cd in pairs(bc)do dc=dc+1;_d=bd;ad=cd
if cd==_c and ac then return bd end end
if dc==1 then if
self:ShouldAutoCompleteNames()then return _d elseif ad==_c then return _d end end end;return nil end
function ab:GetWhisperChanneNameColor()if self.ChatSettings.WhisperChannelNameColor then return
self.ChatSettings.WhisperChannelNameColor end;return
Color3.fromRGB(102,14,102)end
function ab:TextUpdated()local cb=self.TextBox.Text
if not self.PlayerNameEntered then
local db=self:GetWhisperingPlayer(cb)
if db then self.PlayerNameEntered=true;self.PlayerName=db.Name
self.MessageModeButton.Size=UDim2.new(0,1000,1,0)
self.MessageModeButton.Text=string.format("[To %s]",db.Name)
self.MessageModeButton.TextColor3=self:GetWhisperChanneNameColor()local _c=self.MessageModeButton.TextBounds.X
self.MessageModeButton.Size=UDim2.new(0,_c,1,0)self.TextBox.Size=UDim2.new(1,-_c,1,0)
self.TextBox.Position=UDim2.new(0,_c,0,0)self.TextBox.Text=" "end else
if cb==""then self.MessageModeButton.Text=""
self.MessageModeButton.Size=UDim2.new(0,0,0,0)self.TextBox.Size=UDim2.new(1,0,1,0)
self.TextBox.Position=UDim2.new(0,0,0,0)self.TextBox.Text=""self.PlayerNameEntered=false
self.ChatBar:ResetCustomState()self.ChatBar:CaptureFocus()end end end
function ab:GetMessage()
if self.PlayerNameEntered then return"/w "..
self.PlayerName.." "..self.TextBox.Text end;return self.TextBox.Text end;function ab:ProcessCompletedMessage()return false end;function ab:Destroy()
self.MessageModeConnection:disconnect()self.Destroyed=true end
function bb.new(cb,db,_c)
local ac=setmetatable({},ab)ac.Destroyed=false;ac.ChatWindow=cb;ac.ChatBar=db;ac.ChatSettings=_c
ac.TextBox=db:GetTextBox()ac.MessageModeButton=db:GetMessageModeTextButton()
ac.OriginalWhisperText=""ac.PlayerNameEntered=false
ac.MessageModeConnection=ac.MessageModeButton.MouseButton1Click:connect(function()
local bc=ac.TextBox.Text
if string.sub(bc,1,1)==" "then bc=string.sub(bc,2)end;ac.ChatBar:ResetCustomState()
ac.ChatBar:SetTextBoxText(bc)ac.ChatBar:CaptureFocus()end)ac:TextUpdated()return ac end
function ProcessMessage(cb,db,_c,ac)if string.sub(cb,1,3):lower()=="/w "or
string.sub(cb,1,9):lower()=="/whisper "then return
bb.new(db,_c,ac)end;return nil end;return
{[ba.KEY_COMMAND_PROCESSOR_TYPE]=ba.IN_PROGRESS_MESSAGE_PROCESSOR,[ba.KEY_PROCESSOR_FUNCTION]=ProcessMessage}