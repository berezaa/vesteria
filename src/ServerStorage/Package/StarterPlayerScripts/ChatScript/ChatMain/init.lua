local dab={}local _bb=60;local abb=game:GetService("RunService")
local bbb=game:GetService("ReplicatedStorage")local cbb=game:GetService("Chat")
local dbb=game:GetService("StarterGui")
local _cb=bbb:WaitForChild("DefaultChatSystemChatEvents")
local acb=bbb:WaitForChild("DefaultChatSystemChatEvents")local bcb=cbb:WaitForChild("ClientChatModules")
local ccb=require(bcb:WaitForChild("ChatConstants"))
local dcb=require(bcb:WaitForChild("ChatSettings"))local _db=bcb:WaitForChild("MessageCreatorModules")
local adb=require(_db:WaitForChild("Util"))local bdb=nil
pcall(function()
bdb=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if bdb==nil then bdb={}function bdb:Get(bcd,ccd)return ccd end end
local cdb=require(game.ReplicatedStorage:WaitForChild("modules"))local ddb=cdb.load("configuration")local __c=10
local a_c={OnNewMessage="RemoteEvent",OnMessageDoneFiltering="RemoteEvent",OnNewSystemMessage="RemoteEvent",OnChannelJoined="RemoteEvent",OnChannelLeft="RemoteEvent",OnMuted="RemoteEvent",OnUnmuted="RemoteEvent",OnMainChannelSet="RemoteEvent",SayMessageRequest="RemoteEvent",GetInitDataRequest="RemoteFunction"}local b_c={}local c_c=Instance.new("BindableEvent")
function TryRemoveChildWithVerifyingIsCorrectType(bcd)if(
a_c[bcd.Name]and bcd:IsA(a_c[bcd.Name]))then a_c[bcd.Name]=nil
b_c[bcd.Name]=bcd;__c=__c-1 end end;for bcd,ccd in pairs(acb:GetChildren())do
TryRemoveChildWithVerifyingIsCorrectType(ccd)end
if(__c>0)then
local bcd=acb.ChildAdded:connect(function(ccd)
TryRemoveChildWithVerifyingIsCorrectType(ccd)if(__c<1)then c_c:Fire()end end)c_c.Event:wait()bcd:disconnect()c_c:Destroy()end;acb=b_c;local d_c=game:GetService("UserInputService")
local _ac=game:GetService("RunService")local aac=game:GetService("Players")local bac=aac.LocalPlayer;while not bac do
aac.ChildAdded:wait()bac=aac.LocalPlayer end;local cac=true;local dac=6
if
dcb.ScreenGuiDisplayOrder~=nil then dac=dcb.ScreenGuiDisplayOrder end;local _bc=bac:WaitForChild("PlayerGui")
local abc=Instance.new("ScreenGui")abc.Name="Chat"abc.ResetOnSpawn=false;abc.DisplayOrder=dac;abc.Parent=_bc
local bbc=false;local cbc=script
local dbc=require(cbc:WaitForChild("ChatWindow"))local _cc=require(cbc:WaitForChild("ChatBar"))
local acc=require(cbc:WaitForChild("ChannelsBar"))
local bcc=require(cbc:WaitForChild("MessageLabelCreator"))
local ccc=require(cbc:WaitForChild("MessageLogDisplay"))
local dcc=require(cbc:WaitForChild("ChatChannel"))
local _dc=require(cbc:WaitForChild("CommandProcessor"))local adc=dbc.new()local bdc=acc.new()local cdc=ccc.new()
local ddc=_dc.new()local __d=_cc.new(ddc,adc)adc:CreateGuiObjects(abc)
adc:RegisterChatBar(__d)adc:RegisterChannelsBar(bdc)
adc:RegisterMessageLogDisplay(cdc)adb:RegisterChatWindow(adc)
local a_d=require(cbc:WaitForChild("MessageSender"))
a_d:RegisterSayMessageFunction(acb.SayMessageRequest)
if(d_c.TouchEnabled)then
__d:SetTextLabelText(bdb:Get("GameChat_ChatMain_ChatBarText",'Tap here to chat'))else
__d:SetTextLabelText(bdb:Get("GameChat_ChatMain_ChatBarTextTouch",'To chat click here or press "/" key'))end
spawn(function()
local bcd=require(cbc:WaitForChild("CurveUtil"))local ccd=dcb.ChatAnimationFPS or 20.0;local dcd=1.0 /ccd
local _dd=tick()
while true do local add=tick()local bdd=add-_dd
local cdd=bcd:DeltaTimeToTimescale(bdd)if cdd~=0 then adc:Update(cdd)end;_dd=add;wait(dcd)end end)function CheckIfPointIsInSquare(bcd,ccd,dcd)
return(
ccd.X<=bcd.X and bcd.X<=dcd.X and ccd.Y<=bcd.Y and bcd.Y<=dcd.Y)end;local b_d=false
local c_d=false;local d_d=0;local _ad=0;local aad=Instance.new("BindableEvent")
local bad=Instance.new("BindableEvent")local cad=Instance.new("BindableEvent")
function DoBackgroundFadeIn(bcd)_ad=tick()
b_d=false;aad:Fire()
adc:FadeInBackground((bcd or dcb.ChatDefaultFadeDuration))local ccd=adc:GetCurrentChannel()
if(ccd)then local dcd=cdc.Scroller
dcd.ScrollingEnabled=true;dcd.ScrollBarThickness=ccc.ScrollBarThickness end end
function DoBackgroundFadeOut(bcd)_ad=tick()b_d=true;aad:Fire()
adc:FadeOutBackground((bcd or dcb.ChatDefaultFadeDuration))local ccd=adc:GetCurrentChannel()if(ccd)then local dcd=cdc.Scroller
dcd.ScrollingEnabled=false;dcd.ScrollBarThickness=0 end end
function DoTextFadeIn(bcd)d_d=tick()c_d=false;aad:Fire()adc:FadeInText(
(bcd or dcb.ChatDefaultFadeDuration)*0)end;function DoTextFadeOut(bcd)d_d=tick()c_d=true;aad:Fire()
adc:FadeOutText((bcd or dcb.ChatDefaultFadeDuration))end;function DoFadeInFromNewInformation()
DoTextFadeIn()
if dcb.ChatShouldFadeInFromNewInformation then DoBackgroundFadeIn()end end;function InstantFadeIn()
DoBackgroundFadeIn(0)DoTextFadeIn(0)end;function InstantFadeOut()
DoBackgroundFadeOut(0)DoTextFadeOut(0)end;local dad=nil
function UpdateFadingForMouseState(bcd)
dad=bcd;bad:Fire()if(__d:IsFocused())then return end
if(bcd)then
DoBackgroundFadeIn()DoTextFadeIn()else DoBackgroundFadeIn()end end
spawn(function()
while true do _ac.RenderStepped:wait()
while
(dad or __d:IsFocused())do if(dad)then bad.Event:wait()end;if(__d:IsFocused())then
cad.Event:wait()end end
if(not b_d)then local bcd=tick()-_ad;if(bcd>dcb.ChatWindowBackgroundFadeOutTime)then
DoBackgroundFadeOut()end elseif(not c_d)then local bcd=tick()-d_d;if(bcd>
dcb.ChatWindowTextFadeOutTime)then DoTextFadeOut()end else
aad.Event:wait()end end end)
function getClassicChatEnabled()
if dcb.ClassicChatEnabled~=nil then return dcb.ClassicChatEnabled end;return aac.ClassicChat end
function getBubbleChatEnabled()
if dcb.BubbleChatEnabled~=nil then return dcb.BubbleChatEnabled end;return aac.BubbleChat end;function bubbleChatOnly()return
not getClassicChatEnabled()and getBubbleChatEnabled()end
function UpdateMousePosition(bcd)if

not(dab.Visible and dab.IsCoreGuiEnabled and
(dab.TopbarEnabled or dcb.ChatOnWithTopBarOff))then return end;if bubbleChatOnly()then
return end;local ccd=adc.GuiObject.AbsolutePosition
local dcd=adc.GuiObject.AbsoluteSize;local _dd=CheckIfPointIsInSquare(bcd,ccd,ccd+dcd)if(_dd~=dad)then
UpdateFadingForMouseState(_dd)end end
d_c.InputChanged:connect(function(bcd)
if
(bcd.UserInputType==Enum.UserInputType.MouseMovement)then
local ccd=Vector2.new(bcd.Position.X,bcd.Position.Y)UpdateMousePosition(ccd)end end)
d_c.TouchTap:connect(function(bcd,ccd)UpdateMousePosition(bcd[1])end)
d_c.TouchMoved:connect(function(bcd,ccd)
local dcd=Vector2.new(bcd.Position.X,bcd.Position.Y)UpdateMousePosition(dcd)end)UpdateFadingForMouseState(true)
UpdateFadingForMouseState(false)local _bd={}
do
function _bd.Signal()local bcd={}local ccd=Instance.new('BindableEvent')
local dcd=nil;local _dd=nil
function bcd:fire(...)dcd={...}_dd=select('#',...)ccd:Fire()end;function bcd:connect(add)if not add then error("connect(nil)",2)end
return ccd.Event:connect(function()
add(unpack(dcd,1,_dd))end)end
function bcd:wait()
ccd.Event:wait()
assert(dcd,"Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")return unpack(dcd,1,_dd)end;return bcd end end
function SetVisibility(bcd)adc:SetVisible(bcd)
dab.VisibilityStateChanged:fire(bcd)dab.Visible=bcd;if(dab.IsCoreGuiEnabled)then if(bcd)then InstantFadeIn()else
InstantFadeOut()end end end
do dab.TopbarEnabled=true;dab.MessageCount=0;dab.Visible=true
dab.IsCoreGuiEnabled=true;function dab:ToggleVisibility()
SetVisibility(not adc:GetVisible())end;function dab:SetVisible(bcd)if(adc:GetVisible()~=bcd)then
SetVisibility(bcd)end end;function dab:FocusChatBar()
__d:CaptureFocus()end;function dab:EnterWhisperState(bcd)
__d:EnterWhisperState(bcd)end
function dab:GetVisibility()return adc:GetVisible()end;function dab:GetMessageCount()return self.MessageCount end
function dab:TopbarEnabledChanged(bcd)
self.TopbarEnabled=bcd
self.CoreGuiEnabled:fire(game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.Chat))end;function dab:IsFocused(bcd)return __d:IsFocused()end
dab.ChatBarFocusChanged=_bd.Signal()dab.VisibilityStateChanged=_bd.Signal()
dab.MessagesChanged=_bd.Signal()dab.MessagePosted=_bd.Signal()
dab.CoreGuiEnabled=_bd.Signal()dab.ChatMakeSystemMessageEvent=_bd.Signal()
dab.ChatWindowPositionEvent=_bd.Signal()dab.ChatWindowSizeEvent=_bd.Signal()
dab.ChatBarDisabledEvent=_bd.Signal()
function dab:fChatWindowPosition()return adc.GuiObject.Position end;function dab:fChatWindowSize()return adc.GuiObject.Size end;function dab:fChatBarDisabled()return
not __d:GetEnabled()end
function dab:SpecialKeyPressed(bcd,ccd)if(
bcd==Enum.SpecialKey.ChatHotkey)then
if cac then DoChatBarFocus()end end end end
dab.CoreGuiEnabled:connect(function(bcd)dab.IsCoreGuiEnabled=bcd;bcd=bcd and
(dab.TopbarEnabled or dcb.ChatOnWithTopBarOff)
adc:SetCoreGuiEnabled(bcd)if(not bcd)then __d:ReleaseFocus()InstantFadeOut()else
InstantFadeIn()end end)
function trimTrailingSpaces(bcd)local ccd=#bcd;while ccd>0 do
if bcd:find("^%s",ccd)then ccd=ccd-1 else break end end;return bcd:sub(1,ccd)end
dab.ChatMakeSystemMessageEvent:connect(function(bcd)
if(bcd["Text"]and
type(bcd["Text"])=="string")then while(not bbc)do wait()end
local ccd=dcb.GeneralChannelName;local dcd=adc:GetChannel(ccd)
if(dcd)then
local _dd={ID=-1,FromSpeaker=nil,SpeakerUserId=0,OriginalChannel=ccd,IsFiltered=true,MessageLength=string.len(bcd.Text),Message=trimTrailingSpaces(bcd.Text),MessageType=ccb.MessageTypeSetCore,Time=os.time(),ExtraData=bcd}dcd:AddMessageToChannel(_dd)
bdc:UpdateMessagePostedInChannel(ccd)dab.MessageCount=dab.MessageCount+1
dab.MessagesChanged:fire(dab.MessageCount)end end end)
dab.ChatBarDisabledEvent:connect(function(bcd)if cac then __d:SetEnabled(not bcd)if(bcd)then
__d:ReleaseFocus()end end end)
dab.ChatWindowSizeEvent:connect(function(bcd)adc.GuiObject.Size=bcd end)
dab.ChatWindowPositionEvent:connect(function(bcd)adc.GuiObject.Position=bcd end)
function DoChatBarFocus()if(not adc:GetCoreGuiEnabled())then return end;if(not
__d:GetEnabled())then return end
if
(not __d:IsFocused()and __d:GetVisible())then dab:SetVisible(true)InstantFadeIn()
__d:CaptureFocus()dab.ChatBarFocusChanged:fire(true)end end
cad.Event:connect(function(bcd)
dab.ChatBarFocusChanged:fire(bcd)end)
function DoSwitchCurrentChannel(bcd)if(adc:GetChannel(bcd))then
adc:SwitchCurrentChannel(bcd)end end
function SendMessageToSelfInTargetChannel(bcd,ccd,dcd)local _dd=adc:GetChannel(ccd)
if(_dd)then
local add={ID=-1,FromSpeaker=nil,SpeakerUserId=0,OriginalChannel=ccd,IsFiltered=true,MessageLength=string.len(bcd),Message=trimTrailingSpaces(bcd),MessageType=ccb.MessageTypeSystem,Time=os.time(),ExtraData=dcd}_dd:AddMessageToChannel(add)end end
function chatBarFocused()if(not dad)then DoBackgroundFadeIn()
if(c_d)then DoTextFadeIn()end end;cad:Fire(true)end
function chatBarFocusLost(bcd,ccd)DoBackgroundFadeIn()cad:Fire(false)
if(bcd)then
local dcd=__d:GetTextBox().Text
if __d:IsInCustomState()then local _dd=__d:GetCustomMessage()
if _dd then dcd=_dd end;local add=__d:CustomStateProcessCompletedMessage(dcd)
__d:ResetCustomState()if add then return end end;dcd=string.sub(dcd,1,dcb.MaximumMessageLength)
__d:GetTextBox().Text=""
if dcd~=""then dab.MessagePosted:fire(dcd)
if not
ddc:ProcessCompletedChatMessage(dcd,adc)then
if dcb.DisallowedWhiteSpace then
for i=1,#dcb.DisallowedWhiteSpace do
if
dcb.DisallowedWhiteSpace[i]=="\t"then
dcd=string.gsub(dcd,dcb.DisallowedWhiteSpace[i]," ")else
dcd=string.gsub(dcd,dcb.DisallowedWhiteSpace[i],"")end end end;dcd=string.gsub(dcd,"\n","")
dcd=string.gsub(dcd,"[ ]+"," ")local _dd=adc:GetTargetMessageChannel()if _dd then
a_d:SendMessage(dcd,_dd)else a_d:SendMessage(dcd,nil)end end end end end;local abd={}
function setupChatBarConnections()for i=1,#abd do abd[i]:Disconnect()end
abd={}
local bcd=__d:GetTextBox().FocusLost:connect(chatBarFocusLost)table.insert(abd,bcd)
local ccd=__d:GetTextBox().Focused:connect(chatBarFocused)table.insert(abd,ccd)end;setupChatBarConnections()
__d.GuiObjectsChanged:connect(setupChatBarConnections)
function getEchoMessagesInGeneral()
if dcb.EchoMessagesInGeneralChannel==nil then return true end;return dcb.EchoMessagesInGeneralChannel end
acb.OnMessageDoneFiltering.OnClientEvent:connect(function(bcd)
if
not dcb.ShowUserOwnFilteredMessage then if bcd.FromSpeaker==bac.Name then return end end;local ccd=bcd.OriginalChannel;local dcd=adc:GetChannel(ccd)if dcd then
dcd:UpdateMessageFiltered(bcd)end
if
getEchoMessagesInGeneral()and dcb.GeneralChannelName and ccd~=dcb.GeneralChannelName then
local _dd=adc:GetChannel(dcb.GeneralChannelName)if _dd then _dd:UpdateMessageFiltered(bcd)end end end)
acb.OnNewMessage.OnClientEvent:connect(function(bcd,ccd)
local dcd=adc:GetChannel(ccd)
if(dcd)then dcd:AddMessageToChannel(bcd)if(bcd.FromSpeaker~=bac.Name)then
bdc:UpdateMessagePostedInChannel(ccd)end
if
getEchoMessagesInGeneral()and dcb.GeneralChannelName and ccd~=dcb.GeneralChannelName then
local _dd=adc:GetChannel(dcb.GeneralChannelName)if _dd then _dd:AddMessageToChannel(bcd)end end;dab.MessageCount=dab.MessageCount+1
dab.MessagesChanged:fire(dab.MessageCount)DoFadeInFromNewInformation()end end)
acb.OnNewSystemMessage.OnClientEvent:connect(function(bcd,ccd)
ccd=ccd or"System"local dcd=adc:GetChannel(ccd)
if(dcd)then
dcd:AddMessageToChannel(bcd)bdc:UpdateMessagePostedInChannel(ccd)dab.MessageCount=dab.MessageCount+
1
dab.MessagesChanged:fire(dab.MessageCount)DoFadeInFromNewInformation()
if
getEchoMessagesInGeneral()and
dcb.GeneralChannelName and ccd~=dcb.GeneralChannelName then local _dd=adc:GetChannel(dcb.GeneralChannelName)if _dd then
_dd:AddMessageToChannel(bcd)end end end end)
function HandleChannelJoined(bcd,ccd,dcd,_dd,add,bdd)
if adc:GetChannel(bcd)then adc:RemoveChannel(bcd)end;if(bcd==dcb.GeneralChannelName)then bbc=true end;if _dd then
__d:SetChannelNameColor(bcd,_dd)end;local cdd=adc:AddChannel(bcd)
if(cdd)then if
(bcd==dcb.GeneralChannelName)then DoSwitchCurrentChannel(bcd)end
if
(dcd)then local ddd=1;if#dcd>dcb.MessageHistoryLengthPerChannel then
ddd=#dcd-dcb.MessageHistoryLengthPerChannel end;for i=ddd,#dcd do
cdd:AddMessageToChannel(dcd[i])end
if getEchoMessagesInGeneral()and add then
if
dcb.GeneralChannelName and bcd~=dcb.GeneralChannelName then
local ___a=adc:GetChannel(dcb.GeneralChannelName)
if ___a then ___a:AddMessagesToChannelByTimeStamp(dcd,ddd)end end end end
if(ccd~="")then
local ddd={ID=-1,FromSpeaker=nil,SpeakerUserId=0,OriginalChannel=bcd,IsFiltered=true,MessageLength=string.len(ccd),Message=trimTrailingSpaces(ccd),MessageType=ccb.MessageTypeWelcome,Time=os.time(),ExtraData=nil}cdd:AddMessageToChannel(ddd)
if
getEchoMessagesInGeneral()and bdd and not dcb.ShowChannelsBar then
if
bcd~=dcb.GeneralChannelName then local ___a=adc:GetChannel(dcb.GeneralChannelName)if ___a then
___a:AddMessageToChannel(ddd)end end end end;DoFadeInFromNewInformation()end end
acb.OnChannelJoined.OnClientEvent:connect(function(bcd,ccd,dcd,_dd)
HandleChannelJoined(bcd,ccd,dcd,_dd,false,true)end)
acb.OnChannelLeft.OnClientEvent:connect(function(bcd)
adc:RemoveChannel(bcd)DoFadeInFromNewInformation()end)
acb.OnMuted.OnClientEvent:connect(function(bcd)end)
acb.OnUnmuted.OnClientEvent:connect(function(bcd)end)
acb.OnMainChannelSet.OnClientEvent:connect(function(bcd)
DoSwitchCurrentChannel(bcd)end)
coroutine.wrap(function()
local bcd=_cb:WaitForChild("ChannelNameColorUpdated",5)if bcd then
bcd.OnClientEvent:connect(function(ccd,dcd)__d:SetChannelNameColor(ccd,dcd)end)end end)()local bbd=nil;local cbd=nil;local dbd=nil;local _cd=nil
pcall(function()
bbd=dbb:GetCore("PlayerBlockedEvent")cbd=dbb:GetCore("PlayerMutedEvent")
dbd=dbb:GetCore("PlayerUnblockedEvent")_cd=dbb:GetCore("PlayerUnmutedEvent")end)
function SendSystemMessageToSelf(bcd)local ccd=adc:GetCurrentChannel()
if ccd then
local dcd={ID=-1,FromSpeaker=nil,SpeakerUserId=0,OriginalChannel=ccd.Name,IsFiltered=true,MessageLength=string.len(bcd),Message=trimTrailingSpaces(bcd),MessageType=ccb.MessageTypeSystem,Time=os.time(),ExtraData=
nil}ccd:AddMessageToChannel(dcd)end end
function MutePlayer(bcd)local ccd=_cb:FindFirstChild("MutePlayerRequest")if ccd then return
ccd:InvokeServer(bcd.Name)end;return false end
if bbd then
bbd.Event:connect(function(bcd)
if MutePlayer(bcd)then
SendSystemMessageToSelf(string.gsub(bdb:Get("GameChat_ChatMain_SpeakerHasBeenBlocked",string.format("Speaker '%s' has been blocked.",bcd.Name)),"{RBX_NAME}",bcd.Name))end end)end
if cbd then
cbd.Event:connect(function(bcd)
if MutePlayer(bcd)then
SendSystemMessageToSelf(string.gsub(bdb:Get("GameChat_ChatMain_SpeakerHasBeenMuted",string.format("Speaker '%s' has been muted.",bcd.Name)),"{RBX_NAME}",bcd.Name))end end)end
function UnmutePlayer(bcd)local ccd=_cb:FindFirstChild("UnMutePlayerRequest")if ccd then return
ccd:InvokeServer(bcd.Name)end;return false end
if dbd then
dbd.Event:connect(function(bcd)
if UnmutePlayer(bcd)then
SendSystemMessageToSelf(string.gsub(bdb:Get("GameChat_ChatMain_SpeakerHasBeenUnBlocked",string.format("Speaker '%s' has been unblocked.",bcd.Name)),"{RBX_NAME}",bcd.Name))end end)end
if _cd then
_cd.Event:connect(function(bcd)
if UnmutePlayer(bcd)then
SendSystemMessageToSelf(string.gsub(bdb:Get("GameChat_ChatMain_SpeakerHasBeenUnMuted",string.format("Speaker '%s' has been unmuted.",bcd.Name)),"{RBX_NAME}",bcd.Name))end end)end
spawn(function()
if bac.UserId>0 then
pcall(function()local bcd=dbb:GetCore("GetBlockedUserIds")
if#bcd>
0 then
local ccd=_cb:FindFirstChild("SetBlockedUserIdsRequest")if ccd then ccd:FireServer(bcd)end end end)end end)
spawn(function()
local bcd,ccd=pcall(function()return cbb:CanUserChatAsync(bac.UserId)end)if bcd then cac=_ac:IsStudio()or ccd end end)local acd=acb.GetInitDataRequest:InvokeServer()
for bcd,ccd in
pairs(acd.Channels)do if ccd[1]==dcb.GeneralChannelName then
HandleChannelJoined(ccd[1],ccd[2],ccd[3],ccd[4],true,false)end end
for bcd,ccd in pairs(acd.Channels)do if ccd[1]~=dcb.GeneralChannelName then
HandleChannelJoined(ccd[1],ccd[2],ccd[3],ccd[4],true,false)end end;return dab