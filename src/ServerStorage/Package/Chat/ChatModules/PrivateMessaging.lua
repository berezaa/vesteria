local _b=game:GetService("Chat")
local ab=game:GetService("RunService")local bb=_b:WaitForChild("ClientChatModules")
local cb=require(bb:WaitForChild("ChatConstants"))
local db=require(bb:WaitForChild("ChatSettings"))local _c=nil
pcall(function()
_c=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if _c==nil then _c={}function _c:Get(dc,_d)return _d end end
local ac=
db.ErrorMessageTextColor or Color3.fromRGB(245,50,50)local bc={ChatColor=ac}function GetWhisperChannelPrefix()
if cb.WhisperChannelPrefix then return cb.WhisperChannelPrefix end;return"To "end
local function cc(dc)
local function _d(a_a,b_a)if
ab:IsStudio()then return true end;local c_a=a_a:GetPlayer()
local d_a=b_a:GetPlayer()
if c_a and d_a then
local _aa,aaa=pcall(function()
return _b:CanUsersChatAsync(c_a.UserId,d_a.UserId)end)return _aa and aaa end;return false end
local function ad(a_a,b_a,c_a)local d_a=b_a;local _aa=nil
if(string.sub(b_a,1,1)=="\"")then
local daa=string.find(b_a,"\"",2)if(daa)then d_a=string.sub(b_a,2,daa-1)
_aa=string.sub(b_a,daa+2)end else
local daa=string.match(b_a,"^[^%s]+")if(daa)then d_a=daa
_aa=string.sub(b_a,string.len(d_a)+2)end end;local aaa=dc:GetSpeaker(a_a)local baa=dc:GetSpeaker(d_a)local caa=dc:GetChannel(
GetWhisperChannelPrefix()..d_a)
if
caa and baa then
if not _d(aaa,baa)then
aaa:SendSystemMessage(_c:Get("GameChat_PrivateMessaging_CannotChat","You are not able to chat with this player."),c_a,bc)return end
if
(caa.Name==GetWhisperChannelPrefix()..aaa.Name)then
aaa:SendSystemMessage(_c:Get("GameChat_PrivateMessaging_CannotWhisperToSelf","You cannot whisper to yourself."),c_a,bc)else if(not aaa:IsInChannel(caa.Name))then
aaa:JoinChannel(caa.Name)end
if
(_aa and(string.len(_aa)>0))then aaa:SayMessage(_aa,caa.Name)end;aaa:SetMainChannel(caa.Name)end else
aaa:SendSystemMessage(string.gsub(_c:Get("GameChat_MuteSpeaker_SpeakerDoesNotExist",string.format("Speaker '%s' does not exist.",tostring(d_a))),"{RBX_NAME}",tostring(d_a)),c_a,bc)end end
local function bd(a_a,b_a,c_a)local d_a=false
if
(string.sub(b_a,1,3):lower()=="/w ")then ad(a_a,string.sub(b_a,4),c_a)d_a=true elseif(
string.sub(b_a,1,9):lower()=="/whisper ")then
ad(a_a,string.sub(b_a,10),c_a)d_a=true end;return d_a end
local function cd(a_a,b_a,c_a)local d_a=dc:GetSpeaker(a_a)local _aa=d_a.ExtraData
d_a:SendMessage(b_a,c_a,a_a,_aa)local aaa=dc:GetSpeaker(string.sub(c_a,4))
if(aaa)then
if(not aaa:IsInChannel(
GetWhisperChannelPrefix()..a_a))then aaa:JoinChannel(
GetWhisperChannelPrefix()..a_a)end
aaa:SendMessage(b_a,GetWhisperChannelPrefix()..a_a,a_a,_aa)end;return true end;local function dd(a_a,b_a,c_a)
if cb.MessageTypeWhisper then b_a.MessageType=cb.MessageTypeWhisper end end
dc:RegisterProcessCommandsFunction("whisper_commands",bd,cb.StandardPriority)
local function __a()
if db.WhisperChannelNameColor then return db.WhisperChannelNameColor end;return Color3.fromRGB(102,14,102)end
dc.SpeakerAdded:connect(function(a_a)if
(dc:GetChannel(GetWhisperChannelPrefix()..a_a))then
dc:RemoveChannel(GetWhisperChannelPrefix()..a_a)end;local b_a=dc:AddChannel(
GetWhisperChannelPrefix()..a_a)
b_a.Joinable=false;b_a.Leavable=true;b_a.AutoJoin=false;b_a.Private=true
b_a.WelcomeMessage=string.gsub(_c:Get("GameChat_PrivateMessaging_NowChattingWith",
"You are now privately chatting with "..a_a.."."),"{RBX_NAME}",tostring(a_a))b_a.ChannelNameColor=__a()
b_a:RegisterProcessCommandsFunction("replication_function",cd,cb.LowPriority)
b_a:RegisterFilterMessageFunction("message_type_function",dd)end)
dc.SpeakerRemoved:connect(function(a_a)if
(dc:GetChannel(GetWhisperChannelPrefix()..a_a))then
dc:RemoveChannel(GetWhisperChannelPrefix()..a_a)end end)end;return cc