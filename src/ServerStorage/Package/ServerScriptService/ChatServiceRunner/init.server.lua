local dd="DefaultChatSystemChatEvents"
local __a=game:GetService("ReplicatedStorage")local a_a=script;local b_a=game:GetService("Players")
local c_a=game:GetService("RunService")local d_a=game:GetService("Chat")
local _aa=require(a_a:WaitForChild("ChatService"))local aaa=d_a:WaitForChild("ClientChatModules")
local baa=require(aaa:WaitForChild("ChatSettings"))local caa=nil
pcall(function()
caa=require(d_a.ClientChatModules.ChatLocalization)end)
if caa==nil then caa={Get=function(bda,cda)return cda end}end;local daa={}local _ba=__a:FindFirstChild(dd)
if _ba then _ba:Destroy()_ba=nil end;if(not _ba)then _ba=Instance.new("Folder")_ba.Name=dd
_ba.Archivable=false;_ba.Parent=__a end;local function aba()end
local function bba(bda,cda,dda)
for __b,a_b in
pairs(bda:GetChildren())do if(a_b:IsA(dda)and a_b.Name==cda)then return a_b end end;return nil end
local function cba(bda,cda,dda)local __b=bba(bda,cda,dda)if(not __b)then __b=Instance.new(dda)
__b.Name=cda;__b.Parent=bda end;daa[cda]=__b;return __b end;local function dba(bda,cda)local dda=cba(bda,cda,"RemoteEvent")
dda.OnServerEvent:Connect(aba)return dda end
dba(_ba,"OnNewMessage")dba(_ba,"OnMessageDoneFiltering")
dba(_ba,"OnNewSystemMessage")dba(_ba,"OnChannelJoined")dba(_ba,"OnChannelLeft")
dba(_ba,"OnMuted")dba(_ba,"OnUnmuted")dba(_ba,"OnMainChannelSet")
dba(_ba,"ChannelNameColorUpdated")dba(_ba,"SayMessageRequest")
dba(_ba,"SetBlockedUserIdsRequest")cba(_ba,"GetInitDataRequest","RemoteFunction")
cba(_ba,"MutePlayerRequest","RemoteFunction")cba(_ba,"UnMutePlayerRequest","RemoteFunction")_ba=daa
local function _ca(bda)
local cda=_aa:GetSpeaker(bda.Name)if(cda)then _aa:RemoveSpeaker(bda.Name)end
cda=_aa:InternalAddSpeakerWithPlayerObject(bda.Name,bda,false)for dda,__b in pairs(_aa:GetAutoJoinChannelList())do
cda:JoinChannel(__b.Name)end
cda:InternalAssignEventFolder(_ba)
cda.ChannelJoined:connect(function(dda,__b)local a_b=nil;local b_b=nil;local c_b=_aa:GetChannel(dda)if(c_b)then
a_b=c_b:GetHistoryLogForSpeaker(cda)b_b=c_b.ChannelNameColor end
_ba.OnChannelJoined:FireClient(bda,dda,__b,a_b,b_b)end)
cda.Muted:connect(function(dda,__b,a_b)
_ba.OnMuted:FireClient(bda,dda,__b,a_b)end)
cda.Unmuted:connect(function(dda)_ba.OnUnmuted:FireClient(bda,dda)end)_aa:InternalFireSpeakerAdded(cda.Name)end
_ba.SayMessageRequest.OnServerEvent:connect(function(bda,cda,dda)if type(cda)~="string"then
return end;if type(dda)~="string"then return end
local __b=_aa:GetSpeaker(bda.Name)if(__b)then return __b:SayMessage(cda,dda)end;return nil end)
_ba.MutePlayerRequest.OnServerInvoke=function(bda,cda)if type(cda)~="string"then return end
local dda=_aa:GetSpeaker(bda.Name)
if dda then local __b=_aa:GetSpeaker(cda)if __b then
dda:AddMutedSpeaker(__b.Name)return true end end;return false end
_ba.UnMutePlayerRequest.OnServerInvoke=function(bda,cda)if type(cda)~="string"then return end
local dda=_aa:GetSpeaker(bda.Name)
if dda then local __b=_aa:GetSpeaker(cda)if __b then
dda:RemoveMutedSpeaker(__b.Name)return true end end;return false end;local aca={}
b_a.PlayerAdded:connect(function(bda)
for cda,dda in pairs(aca)do
local __b=_aa:GetSpeaker(cda.Name)
if __b then for i=1,#dda do local a_b=dda[i]if a_b==bda.UserId then
__b:AddMutedSpeaker(bda.Name)end end end end end)
b_a.PlayerRemoving:connect(function(bda)aca[bda]=nil end)
_ba.SetBlockedUserIdsRequest.OnServerEvent:connect(function(bda,cda)if
type(cda)~="table"then return end;aca[bda]=cda
local dda=_aa:GetSpeaker(bda.Name)
if dda then for i=1,#cda do
if type(cda[i])=="number"then
local __b=b_a:GetPlayerByUserId(cda[i])if __b then dda:AddMutedSpeaker(__b.Name)end end end end end)
_ba.GetInitDataRequest.OnServerInvoke=(function(bda)local cda=_aa:GetSpeaker(bda.Name)if not(
cda and cda:GetPlayer())then _ca(bda)
cda=_aa:GetSpeaker(bda.Name)end;local dda={}dda.Channels={}
dda.SpeakerExtraData={}
for __b,a_b in pairs(cda:GetChannelList())do local b_b=_aa:GetChannel(a_b)
if(b_b)then
local c_b={a_b,b_b:GetWelcomeMessageForSpeaker(cda),b_b:GetHistoryLogForSpeaker(cda),b_b.ChannelNameColor}table.insert(dda.Channels,c_b)end end;for __b,a_b in pairs(_aa:GetSpeakerList())do local b_b=_aa:GetSpeaker(a_b)
dda.SpeakerExtraData[a_b]=b_b.ExtraData end;return dda end)
local function bca(bda,cda,dda)local __b=_aa:GetSpeaker(bda)local a_b=_aa:GetChannel(cda)
if(__b)then
if(a_b)then
if
(a_b.Joinable)then
if(not __b:IsInChannel(a_b.Name))then
__b:JoinChannel(a_b.Name)else __b:SetMainChannel(a_b.Name)
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_SwitchChannel_NowInChannel",string.format("You are now chatting in channel: '%s'",a_b.Name)),"{RBX_NAME}",a_b.Name),a_b.Name)end else
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_ChatServiceRunner_YouCannotJoinChannel",("You cannot join channel '"..cda.."'.")),"{RBX_NAME}",cda),dda)end else
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_ChatServiceRunner_ChannelDoesNotExist",("Channel '"..
cda.."' does not exist.")),"{RBX_NAME}",cda),dda)end end end
local function cca(bda,cda,dda)local __b=_aa:GetSpeaker(bda)local a_b=_aa:GetChannel(cda)
if(__b)then
if
(__b:IsInChannel(cda))then
if(a_b.Leavable)then __b:LeaveChannel(a_b.Name)
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_ChatService_YouHaveLeftChannel",string.format("You have left channel '%s'",cda)),"{RBX_NAME}",a_b.Name),"System")else
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_ChatServiceRunner_YouCannotLeaveChannel",("You cannot leave channel '"..cda.."'.")),"{RBX_NAME}",cda),dda)end else
__b:SendSystemMessage(string.gsub(caa:Get("GameChat_ChatServiceRunner_YouAreNotInChannel",("You are not in channel '"..cda.."'.")),"{RBX_NAME}",cda),dda)end end end
_aa:RegisterProcessCommandsFunction("default_commands",function(bda,cda,dda)
if(string.sub(cda,1,6):lower()==
"/join ")then bca(bda,string.sub(cda,7),dda)
return true elseif(string.sub(cda,1,3):lower()=="/j ")then
bca(bda,string.sub(cda,4),dda)return true elseif
(string.sub(cda,1,7):lower()=="/leave ")then cca(bda,string.sub(cda,8),dda)return true elseif(
string.sub(cda,1,3):lower()=="/l ")then cca(bda,string.sub(cda,4),dda)return
true elseif(string.sub(cda,1,3)=="/e "or
string.sub(cda,1,7)=="/emote ")then return true end;return false end)
if baa.GeneralChannelName and baa.GeneralChannelName~=""then
local bda=_aa:AddChannel(baa.GeneralChannelName)bda.Leavable=false;bda.AutoJoin=true
bda:RegisterGetWelcomeMessageFunction(function(cda)if c_a:IsStudio()then
return nil end;local dda=cda:GetPlayer()
if dda then
local __b,a_b=pcall(function()return
d_a:CanUserChatAsync(dda.UserId)end)if __b and not a_b then return""end end end)end;local dca=_aa:AddChannel("System")dca.Leavable=false
dca.AutoJoin=true
dca.WelcomeMessage=caa:Get("GameChat_ChatServiceRunner_SystemChannelWelcomeMessage","This channel is for system and game notifications.")
dca.SpeakerJoined:connect(function(bda)dca:MuteSpeaker(bda)end)
local function _da(bda)if bda:IsA("ModuleScript")then local cda=require(bda)if(type(cda)=="function")then
cda(_aa)end end end;local ada=d_a:WaitForChild("ChatModules")
ada.ChildAdded:connect(function(bda)
local cda,dda=pcall(_da,bda)if not cda and dda then
print("Error running module "..bda.Name..": "..dda)end end)
for bda,cda in pairs(ada:GetChildren())do local dda,__b=pcall(_da,cda)if not dda and __b then
print(
"Error running module "..cda.Name..": "..__b)end end
b_a.PlayerRemoving:connect(function(bda)if(_aa:GetSpeaker(bda.Name))then
_aa:RemoveSpeaker(bda.Name)end end)