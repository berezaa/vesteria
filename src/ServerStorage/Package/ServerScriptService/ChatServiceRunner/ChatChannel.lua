local cb=false;local db
do
local __a=(game:GetService("TextService")~=nil)
local a_a,b_a=pcall(function()return
UserSettings():IsUserFeatureEnabled("UserInGameChatUseNewFilterAPIV2")end)local c_a=(a_a and b_a)db=(cb or c_a)and __a end;local _c={}local ac=script.Parent;local bc=game:GetService("Chat")
local cc=game:GetService("RunService")local dc=bc:WaitForChild("ClientChatModules")
local _d=require(dc:WaitForChild("ChatConstants"))local ad=require(ac:WaitForChild("Util"))local bd=nil
pcall(function()
bd=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if bd==nil then bd={Get=function(__a,a_a)return a_a end}end;local cd={}cd.__index=cd
function cd:SendSystemMessage(__a,a_a)
local b_a=self:InternalCreateMessageObject(__a,nil,true,a_a)
local c_a,d_a=pcall(function()self.eMessagePosted:Fire(b_a)end)if not c_a and d_a then
print("Error posting message: "..d_a)end
self:InternalAddMessageToHistoryLog(b_a)for _aa,aaa in pairs(self.Speakers)do
aaa:InternalSendSystemMessage(b_a,self.Name)end;return b_a end
function cd:SendSystemMessageToSpeaker(__a,a_a,b_a)local c_a=self.Speakers[a_a]
if(c_a)then
local d_a=self:InternalCreateMessageObject(__a,nil,true,b_a)c_a:InternalSendSystemMessage(d_a,self.Name)else
warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a system message",a_a,self.Name))end end
function cd:SendMessageObjToFilters(__a,a_a,b_a)local c_a=a_a.Message;a_a.Message=__a
self:InternalDoMessageFilter(b_a.Name,a_a,self.Name)
self.ChatService:InternalDoMessageFilter(b_a.Name,a_a,self.Name)local d_a=a_a.Message;a_a.Message=c_a;return d_a end
function cd:CanCommunicateByUserId(__a,a_a)if cc:IsStudio()then return true end;if __a==0 or a_a==0 then
return true end
local b_a,c_a=pcall(function()return bc:CanUsersChatAsync(__a,a_a)end)return b_a and c_a end
function cd:CanCommunicate(__a,a_a)local b_a=__a:GetPlayer()local c_a=a_a:GetPlayer()if b_a and c_a then return
self:CanCommunicateByUserId(b_a.UserId,c_a.UserId)end
return true end
function cd:SendMessageToSpeaker(__a,a_a,b_a,c_a)local d_a=self.Speakers[a_a]
local _aa=self.ChatService:GetSpeaker(b_a)
if d_a and _aa then local aaa=d_a:IsSpeakerMuted(b_a)if aaa then return end;if not
self:CanCommunicate(d_a,_aa)then return end;local baa=a_a==b_a
local caa=self:InternalCreateMessageObject(__a,b_a,baa,c_a)__a=self:SendMessageObjToFilters(__a,caa,b_a)
d_a:InternalSendMessage(caa,self.Name)
if(not db)then
local daa=self.ChatService:InternalApplyRobloxFilter(caa.FromSpeaker,__a,a_a)if daa then caa.Message=daa;caa.IsFiltered=true
d_a:InternalSendFilteredMessage(caa,self.Name)end else
local daa=self.Private and
Enum.TextFilterContext.PrivateChat or Enum.TextFilterContext.PublicChat
local _ba,aba,bba=self.ChatService:InternalApplyRobloxFilterNewAPI(caa.FromSpeaker,__a,daa)if(_ba)then caa.FilterResult=bba;caa.IsFilterResult=aba;caa.IsFiltered=true
d_a:InternalSendFilteredMessageWithFilterResult(caa,self.Name)end end else
warn(string.format("Speaker '%s' is not in channel '%s' and cannot be sent a message",a_a,self.Name))end end
function cd:KickSpeaker(__a,a_a)local b_a=self.ChatService:GetSpeaker(__a)if
(not b_a)then
error("Speaker \""..__a.."\" does not exist!")end;local c_a=""local d_a=""
if(a_a)then
c_a=string.format("You were kicked from '%s' for the following reason(s): %s",self.Name,a_a)
d_a=string.format("%s was kicked for the following reason(s): %s",__a,a_a)else
c_a=string.format("You were kicked from '%s'",self.Name)d_a=string.format("%s was kicked",__a)end;self:SendSystemMessageToSpeaker(c_a,__a)
b_a:LeaveChannel(self.Name)self:SendSystemMessage(d_a)end
function cd:MuteSpeaker(__a,a_a,b_a)local c_a=self.ChatService:GetSpeaker(__a)if
(not c_a)then
error("Speaker \""..__a.."\" does not exist!")end
self.Mutes[__a:lower()]=
(b_a==0 or b_a==nil)and 0 or(os.time()+b_a)if(a_a)then
self:SendSystemMessage(string.format("%s was muted for the following reason(s): %s",__a,a_a))end
local d_a,_aa=pcall(function()
self.eSpeakerMuted:Fire(__a,a_a,b_a)end)if not d_a and _aa then
print("Error mutting speaker: ".._aa)end
local aaa=self.ChatService:GetSpeaker(__a)
if(aaa)then
local baa,caa=pcall(function()aaa.eMuted:Fire(self.Name,a_a,b_a)end)if not baa and caa then
print("Error mutting speaker: "..caa)end end end
function cd:UnmuteSpeaker(__a)local a_a=self.ChatService:GetSpeaker(__a)if
(not a_a)then
error("Speaker \""..__a.."\" does not exist!")end
self.Mutes[__a:lower()]=nil
local b_a,c_a=pcall(function()self.eSpeakerUnmuted:Fire(__a)end)if not b_a and c_a then
print("Error unmuting speaker: "..c_a)end
local d_a=self.ChatService:GetSpeaker(__a)
if(d_a)then
local _aa,aaa=pcall(function()d_a.eUnmuted:Fire(self.Name)end)if not _aa and aaa then
print("Error unmuting speaker: "..aaa)end end end
function cd:IsSpeakerMuted(__a)return(self.Mutes[__a:lower()]~=nil)end
function cd:GetSpeakerList()local __a={}for a_a,b_a in pairs(self.Speakers)do
table.insert(__a,b_a.Name)end;return __a end
function cd:RegisterFilterMessageFunction(__a,a_a,b_a)if
self.FilterMessageFunctions:HasFunction(__a)then
error(string.format("FilterMessageFunction '%s' already exists",__a))end
self.FilterMessageFunctions:AddFunction(__a,a_a,b_a)end;function cd:FilterMessageFunctionExists(__a)
return self.FilterMessageFunctions:HasFunction(__a)end
function cd:UnregisterFilterMessageFunction(__a)if not
self.FilterMessageFunctions:HasFunction(__a)then
error(string.format("FilterMessageFunction '%s' does not exists",__a))end
self.FilterMessageFunctions:RemoveFunction(__a)end
function cd:RegisterProcessCommandsFunction(__a,a_a,b_a)if
self.ProcessCommandsFunctions:HasFunction(__a)then
error(string.format("ProcessCommandsFunction '%s' already exists",__a))end
self.ProcessCommandsFunctions:AddFunction(__a,a_a,b_a)end
function cd:ProcessCommandsFunctionExists(__a)return
self.ProcessCommandsFunctions:HasFunction(__a)end
function cd:UnregisterProcessCommandsFunction(__a)if not
self.ProcessCommandsFunctions:HasFunction(__a)then
error(string.format("ProcessCommandsFunction '%s' does not exist",__a))end
self.ProcessCommandsFunctions:RemoveFunction(__a)end
local function dd(__a)local a_a={}for b_a,c_a in pairs(__a)do a_a[b_a]=c_a end;return a_a end;function cd:GetHistoryLog()return dd(self.ChatHistory)end
function cd:GetHistoryLogForSpeaker(__a)local a_a=
-1;local b_a=__a:GetPlayer()if b_a then a_a=b_a.UserId end;local c_a={}
if(not
db)then
for i=1,#self.ChatHistory do
local d_a=self.ChatHistory[i].SpeakerUserId;if self:CanCommunicateByUserId(a_a,d_a)then
table.insert(c_a,dd(self.ChatHistory[i]))end end else
for i=1,#self.ChatHistory do
local d_a=self.ChatHistory[i].SpeakerUserId
if self:CanCommunicateByUserId(a_a,d_a)then
local _aa=dd(self.ChatHistory[i])
if(_aa.MessageType==_d.MessageTypeDefault or
_aa.MessageType==_d.MessageTypeMeCommand)then local aaa=_aa.FilterResult
if
(_aa.IsFilterResult)then if(b_a)then _aa.Message=aaa:GetChatForUserAsync(b_a.UserId)else
_aa.Message=aaa:GetNonChatStringForBroadcastAsync()end else _aa.Message=aaa end end;table.insert(c_a,_aa)end end end;return c_a end
function cd:InternalDestroy()
for __a,a_a in pairs(self.Speakers)do a_a:LeaveChannel(self.Name)end;self.eDestroyed:Fire()
self.eDestroyed:Destroy()self.eMessagePosted:Destroy()
self.eSpeakerJoined:Destroy()self.eSpeakerLeft:Destroy()
self.eSpeakerMuted:Destroy()self.eSpeakerUnmuted:Destroy()end
function cd:InternalDoMessageFilter(__a,a_a,b_a)
local c_a=self.FilterMessageFunctions:GetIterator()
for d_a,_aa,aaa in c_a do
local baa,caa=pcall(function()_aa(__a,a_a,b_a)end)if not baa then
warn(string.format("DoMessageFilter Function '%s' failed for reason: %s",d_a,caa))end end end
function cd:InternalDoProcessCommands(__a,a_a,b_a)
local c_a=self.ProcessCommandsFunctions:GetIterator()
for d_a,_aa,aaa in c_a do
local baa,caa=pcall(function()local daa=_aa(__a,a_a,b_a)if type(daa)~="boolean"then
error("Process command functions must return a bool")end;return daa end)if not baa then
warn(string.format("DoProcessCommands Function '%s' failed for reason: %s",d_a,caa))elseif caa then return true end end;return false end
function cd:InternalPostMessage(__a,a_a,b_a)if(self:InternalDoProcessCommands(__a.Name,a_a,self.Name))then
return false end
if(
self.Mutes[__a.Name:lower()]~=nil)then
local daa=self.Mutes[__a.Name:lower()]
if(daa>0 and os.time()>daa)then
self:UnmuteSpeaker(__a.Name)else
self:SendSystemMessageToSpeaker(bd:Get("GameChat_ChatChannel_MutedInChannel","You are muted and cannot talk in this channel"),__a.Name)return false end end
local c_a=self:InternalCreateMessageObject(a_a,__a.Name,false,b_a)c_a.Message=a_a;local d_a
pcall(function()
d_a=bc:InvokeChatCallback(Enum.ChatCallbackType.OnServerReceivingMessage,c_a)end)c_a.Message=nil;if d_a then if d_a.ShouldDeliver==false then return false end
c_a=d_a end
a_a=self:SendMessageObjToFilters(a_a,c_a,__a)local _aa={}
for daa,_ba in pairs(self.Speakers)do
local aba=_ba:IsSpeakerMuted(__a.Name)
if not aba and self:CanCommunicate(__a,_ba)then
table.insert(_aa,_ba.Name)
if _ba.Name==__a.Name then local bba=dd(c_a)bba.Message=a_a;bba.IsFiltered=true
_ba:InternalSendMessage(bba,self.Name)else _ba:InternalSendMessage(c_a,self.Name)end end end
local aaa,baa=pcall(function()self.eMessagePosted:Fire(c_a)end)if not aaa and baa then
print("Error posting message: "..baa)end
if(not db)then local daa={}
for aba,bba in pairs(_aa)do
local cba=self.ChatService:InternalApplyRobloxFilter(c_a.FromSpeaker,a_a,bba)if cba then daa[bba]=cba else return false end end
for aba,bba in pairs(_aa)do local cba=self.Speakers[bba]if(cba)then local dba=dd(c_a)
dba.Message=daa[bba]dba.IsFiltered=true
cba:InternalSendFilteredMessage(dba,self.Name)end end
local _ba=self.ChatService:InternalApplyRobloxFilter(c_a.FromSpeaker,a_a)if _ba then c_a.Message=_ba else return false end;c_a.IsFiltered=true
self:InternalAddMessageToHistoryLog(c_a)else
local daa=self.Private and Enum.TextFilterContext.PrivateChat or
Enum.TextFilterContext.PublicChat
local _ba,aba,bba=self.ChatService:InternalApplyRobloxFilterNewAPI(c_a.FromSpeaker,a_a,daa)
if(_ba)then c_a.FilterResult=bba;c_a.IsFilterResult=aba else return false end;c_a.IsFiltered=true
self:InternalAddMessageToHistoryLog(c_a)
for cba,dba in pairs(_aa)do local _ca=self.Speakers[dba]if(_ca)then
_ca:InternalSendFilteredMessageWithFilterResult(c_a,self.Name)end end end;local caa={}
for daa,_ba in pairs(self.Speakers)do
local aba=_ba:IsSpeakerMuted(__a.Name)
if not aba and self:CanCommunicate(__a,_ba)then local bba=false;for cba,dba in pairs(_aa)do if
_ba.Name==dba then bba=true;break end end;if not
bba then table.insert(caa,_ba.Name)end end end
if(not db)then
for daa,_ba in pairs(caa)do local aba=self.Speakers[_ba]
if aba then
local bba=self.ChatService:InternalApplyRobloxFilter(c_a.FromSpeaker,a_a,_ba)if bba==nil then return false end;local cba=dd(c_a)cba.Message=bba
cba.IsFiltered=true;aba:InternalSendFilteredMessage(cba,self.Name)end end else
for daa,_ba in pairs(caa)do local aba=self.Speakers[_ba]if aba then
aba:InternalSendFilteredMessageWithFilterResult(c_a,self.Name)end end end;return c_a end
function cd:InternalAddSpeaker(__a)if(self.Speakers[__a.Name])then
warn("Speaker \""..
__a.name.."\" is already in the channel!")return end
self.Speakers[__a.Name]=__a
local a_a,b_a=pcall(function()self.eSpeakerJoined:Fire(__a.Name)end)if not a_a and b_a then
print("Error removing channel: "..b_a)end end
function cd:InternalRemoveSpeaker(__a)if(not self.Speakers[__a.Name])then
warn("Speaker \""..__a.name..
"\" is not in the channel!")return end;self.Speakers[__a.Name]=
nil
local a_a,b_a=pcall(function()
self.eSpeakerLeft:Fire(__a.Name)end)if not a_a and b_a then
print("Error removing speaker: "..b_a)end end
function cd:InternalRemoveExcessMessagesFromLog()local __a=table.remove;while
(#self.ChatHistory>self.MaxHistory)do __a(self.ChatHistory,1)end end;function cd:InternalAddMessageToHistoryLog(__a)table.insert(self.ChatHistory,__a)
self:InternalRemoveExcessMessagesFromLog()end;function cd:GetMessageType(__a,a_a)if a_a==
nil then return _d.MessageTypeSystem end
return _d.MessageTypeDefault end
function cd:InternalCreateMessageObject(__a,a_a,b_a,c_a)
local d_a=self:GetMessageType(__a,a_a)local _aa=-1;local aaa=nil;if a_a then aaa=self.Speakers[a_a]
if aaa then
local caa=aaa:GetPlayer()if caa then _aa=caa.UserId else _aa=0 end end end
local baa={ID=self.ChatService:InternalGetUniqueMessageId(),FromSpeaker=a_a,SpeakerUserId=_aa,OriginalChannel=self.Name,MessageLength=string.len(__a),MessageType=d_a,IsFiltered=b_a,Message=
b_a and __a or nil,Time=os.time(),ExtraData={}}if aaa then
for caa,daa in pairs(aaa.ExtraData)do baa.ExtraData[caa]=daa end end;if(c_a)then for caa,daa in pairs(c_a)do
baa.ExtraData[caa]=daa end end;return baa end
function cd:SetChannelNameColor(__a)self.ChannelNameColor=__a;for a_a,b_a in pairs(self.Speakers)do
b_a:UpdateChannelNameColor(self.Name,__a)end end
function cd:GetWelcomeMessageForSpeaker(__a)
if self.GetWelcomeMessageFunction then
local a_a=self.GetWelcomeMessageFunction(__a)if a_a then return a_a end end;return self.WelcomeMessage end
function cd:RegisterGetWelcomeMessageFunction(__a)if type(__a)~="function"then
error("RegisterGetWelcomeMessageFunction must be called with a function.")end
self.GetWelcomeMessageFunction=__a end
function cd:UnRegisterGetWelcomeMessageFunction()self.GetWelcomeMessageFunction=nil end
function _c.new(__a,a_a,b_a,c_a)local d_a=setmetatable({},cd)d_a.ChatService=__a;d_a.Name=a_a;d_a.WelcomeMessage=
b_a or""d_a.GetWelcomeMessageFunction=nil
d_a.ChannelNameColor=c_a;d_a.Joinable=true;d_a.Leavable=true;d_a.AutoJoin=false;d_a.Private=false
d_a.Speakers={}d_a.Mutes={}d_a.MaxHistory=200;d_a.HistoryIndex=0;d_a.ChatHistory={}
d_a.FilterMessageFunctions=ad:NewSortedFunctionContainer()
d_a.ProcessCommandsFunctions=ad:NewSortedFunctionContainer()d_a.eDestroyed=Instance.new("BindableEvent")
d_a.eMessagePosted=Instance.new("BindableEvent")d_a.eSpeakerJoined=Instance.new("BindableEvent")
d_a.eSpeakerLeft=Instance.new("BindableEvent")d_a.eSpeakerMuted=Instance.new("BindableEvent")
d_a.eSpeakerUnmuted=Instance.new("BindableEvent")d_a.MessagePosted=d_a.eMessagePosted.Event
d_a.SpeakerJoined=d_a.eSpeakerJoined.Event;d_a.SpeakerLeft=d_a.eSpeakerLeft.Event
d_a.SpeakerMuted=d_a.eSpeakerMuted.Event;d_a.SpeakerUnmuted=d_a.eSpeakerUnmuted.Event
d_a.Destroyed=d_a.eDestroyed.Event;return d_a end;return _c