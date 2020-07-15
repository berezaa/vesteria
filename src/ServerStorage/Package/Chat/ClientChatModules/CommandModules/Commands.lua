
local ab=require(script.Parent:WaitForChild("Util"))local bb={}bb.__index=bb
local cb=require(game.ReplicatedStorage:WaitForChild("modules"))local db=cb.load("network")local _c=cb.load("configuration")
function matches(ad,bd)
ad=string.lower(ad)bd=string.lower(bd)if string.sub(ad,1,bd:len())==bd then return
true end end
function isCommand(ad)
if matches(ad,"/invite ")or matches(ad,"/i ")then return"invite"elseif
matches(ad,"/duel ")or matches(ad,"/d ")then return"duel"elseif matches(ad,"/trade ")or
matches(ad,"/t ")then return"trade"elseif matches(ad,"/e ")then return"emote",true elseif
matches(ad,"/expel ")then return"expel"end end
local ac={invite="Invite player to party:",duel="Challenge player to duel:",trade="Request trade with player:",emote="Perform emote:",expel="Expel player from Guild Hall:"}function bb:TrimWhiteSpace(ad)local bd=string.gsub(ad,"%s+","")
local cd=ad[#ad]==" "return bd,cd end
function bb:AutoComplete(ad)
ad=ad:lower()local bd=ad
if bd then local cd,dd=self:TrimWhiteSpace(bd)local __a={}
local a_a=game.Players:GetPlayers()
for i=1,#a_a do
if a_a[i]~=game.Players.LocalPlayer then
local _aa=a_a[i].Name:lower()if string.sub(_aa,1,string.len(cd))==cd then
__a[a_a[i]]=a_a[i].Name:lower()end end end;local b_a=0;local c_a=nil;local d_a=nil;for _aa,aaa in pairs(__a)do b_a=b_a+1;c_a=_aa;d_a=aaa
if aaa==cd and dd then return _aa end end;if b_a==1 then return c_a end end;return nil end
function bb:enterFocus(ad)
ad=ad or isCommand(self:GetMessage())
if ad then self.currentCommand=ad
self.MessageModeButton.Size=UDim2.new(0,1000,1,0)self.MessageModeButton.Text=ac[ad]or ad..":"
self.MessageModeButton.TextColor3=Color3.fromRGB(0,12,255)local bd=self.MessageModeButton.TextBounds.X
self.MessageModeButton.Size=UDim2.new(0,bd,1,0)self.TextBox.Size=UDim2.new(1,-bd,1,0)
self.TextBox.Position=UDim2.new(0,bd,0,0)self.OriginalPartyText=self.TextBox.Text
self.TextBox.Text=" "end end
function bb:TextUpdated()local ad=self.TextBox.Text
if not self.currentCommand then
local bd=isCommand(ad)if bd then self:enterFocus(bd)end else
if ad==""then
self.MessageModeButton.Text=""self.MessageModeButton.Size=UDim2.new(0,0,0,0)
self.TextBox.Size=UDim2.new(1,0,1,0)self.TextBox.Position=UDim2.new(0,0,0,0)
self.TextBox.Text=""self.currentCommand=nil
self.ChatBar:ResetCustomState()self.ChatBar:CaptureFocus()elseif self.doAutoComplete then
local bd=self:AutoComplete(ad)if bd then self.TextBox.Text=" "..bd.Name end
self.ChatBar:CaptureFocus()self.doAutoComplete=false end end end
function bb:GetMessage()local ad=self.currentCommand;if ad then return
"/"..ad..self.TextBox.Text end;return self.TextBox.Text end;local bc=game:GetService("StarterGui")
local cc=Color3.new(0.7,0.7,0.7)local dc=Color3.new(1,0.6,0.6)
if game.gameId==712031239 then
bc:SetCore("ChatMakeSystemMessage",{Text="Welcome to Free to Play Vesteria! This game is still in early development and may be reset. Say '/help' for a list of commands.",Color=Color3.fromRGB(0,255,149)})else
bc:SetCore("ChatMakeSystemMessage",{Text="Welcome to Vesteria! Say '/help' for a list of commands.",Color=Color3.fromRGB(0,255,149)})end
function bb:ProcessCompletedMessage()local ad=self:GetMessage()local bd=self.currentCommand
if bd then
if bd==
"emote"then
local cd=string.gsub(self:GetMessage(),"^[^%s]+ ","")local dd,__a=false,"invalid emote"
dd,__a=db:invoke("{A0FA1B07-2089-41D8-91EA-E16F3B6288DF}",cd)if not dd then
bc:SetCore("ChatMakeSystemMessage",{Text=__a,Color=dc})end else
local cd=string.gsub(self:GetMessage(),"^[^%s]+ ","")local dd=game.Players:FindFirstChild(cd)if dd==nil then
dd=game.Players:FindFirstChild(string.gsub(cd," ",""))end
if dd then local __a,a_a=false,"invalid command"
if
bd=="invite"then
__a,a_a=db:invokeServer("{AB032646-DB09-4482-B67B-0F1EA25F97EF}",dd)
if __a then
bc:SetCore("ChatMakeSystemMessage",{Text="Sent a party invite to "..cd,Color=cc})else
bc:SetCore("ChatMakeSystemMessage",{Text=a_a,Color=dc})end elseif bd=="duel"then
__a,a_a=db:invokeServer("{673F5487-AA5C-490F-BF30-A7B6C949E215}",dd)
if __a then
bc:SetCore("ChatMakeSystemMessage",{Text="Sent a duel challenge to "..cd,Color=cc})else
bc:SetCore("ChatMakeSystemMessage",{Text=a_a,Color=dc})end elseif bd=="expel"then
__a,a_a=db:invokeServer("{C9FBA844-B9C8-4A26-9EC1-C55089506DFD}",dd)if __a then
bc:SetCore("ChatMakeSystemMessage",{Text="Expelling "..cd.."...",Color=cc})end elseif bd=="trade"then
__a,a_a=false,"Trading is temporarily disabled."if _c.getConfigurationValue("isTradingEnabled")then
__a,a_a=db:invokeServer("{07FFBB87-C6E5-447F-8E77-F41C936AF801}",dd)end;if __a then
bc:SetCore("ChatMakeSystemMessage",{Text=
"Sent a trade request to "..cd,Color=cc})end end;if not __a then
bc:SetCore("ChatMakeSystemMessage",{Text=a_a,Color=dc})end else
bc:SetCore("ChatMakeSystemMessage",{Text="Invalid player",Color=dc})end end;return true end
if(ad:lower()=="/?"or ad:lower()=="/help")then
bc:SetCore("ChatMakeSystemMessage",{Text="Vesteria chat commands:",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /me <text> :: roleplaying command for doing actions.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /whisper <player> (/w) :: whisper a private message to a player.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /mute <player> :: stop seeing chats from a player.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /unmute <player> :: unmute a muted player.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /party <text> (/p) :: send a message to party members.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /invite <player> (/i) :: invite a player to your party.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /duel <player> (/d) :: challenge a player to a duel.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /trade <player> (/t) :: request a trade with a player.",Color=cc})
bc:SetCore("ChatMakeSystemMessage",{Text="  /e <emote> (/t) :: perform emote.",Color=cc})return true end;return false end
function bb:Destroy()print("destroy custom state")self.Destroyed=true end
function bb.new(ad,bd,cd,dd)local __a={}setmetatable(__a,bb)__a.Destroyed=false
__a.ChatWindow=ad;__a.ChatBar=bd;__a.ChatSettings=cd;__a.TextBox=bd:GetTextBox()
__a.MessageModeButton=bd:GetMessageModeTextButton()__a.MessageModeLabel=bd:GetMessageModeTextLabel()if dd then
__a.doAutoComplete=false else __a.doAutoComplete=true end
__a.MessageModeConnection=__a.MessageModeButton.MouseButton1Click:connect(function()
local a_a=__a.TextBox.Text
if string.sub(a_a,1,1)==" "then a_a=string.sub(a_a,2)end;__a.ChatBar:ResetCustomState()
__a.ChatBar:SetTextBoxText(a_a)__a.ChatBar:CaptureFocus()end)__a:enterFocus()return __a end;local function _d(ad,bd,cd,dd)local __a,a_a=isCommand(ad)
if __a or ad:lower()=="/?"or
ad:lower()=="/help"then return bb.new(bd,cd,dd,a_a)end end;return
{[ab.KEY_COMMAND_PROCESSOR_TYPE]=ab.IN_PROGRESS_MESSAGE_PROCESSOR,[ab.KEY_PROCESSOR_FUNCTION]=_d}