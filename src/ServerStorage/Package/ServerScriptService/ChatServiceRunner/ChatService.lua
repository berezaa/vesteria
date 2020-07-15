local a_a=3;local b_a={50 /1000,100 /1000,200 /1000}local c_a=60
local d_a=3;local _aa=60;local aaa=60;local baa={}local caa=game:GetService("RunService")
local daa=game:GetService("Chat")local _ba=daa:WaitForChild("ClientChatModules")
local aba=script.Parent;local bba=daa:WaitForChild("ClientChatModules")
local cba=require(bba:WaitForChild("ChatSettings"))
local dba=cba.ErrorMessageTextColor or Color3.fromRGB(245,50,50)local _ca={ChatColor=dba}
local aca=require(bba:WaitForChild("ChatConstants"))
local bca=require(aba:WaitForChild("ChatChannel"))local cca=require(aba:WaitForChild("Speaker"))
local dca=require(aba:WaitForChild("Util"))local _da=nil
pcall(function()
_da=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if _da==nil then _da={}function _da:Get(a_b,b_b)return b_b end end;local ada={}ada.__index=ada
function ada:AddChannel(a_b,b_b)if(self.ChatChannels[a_b:lower()])then
error(string.format("Channel %q alrady exists.",a_b))end
local function c_b(bab,cab)
if(cab:lower()=="/leave")then
local dab=self:GetChannel(a_b)local _bb=self:GetSpeaker(bab)
if(dab and _bb)then
if(dab.Leavable)then
_bb:LeaveChannel(a_b)
_bb:SendSystemMessage(string.gsub(_da:Get("GameChat_ChatService_YouHaveLeftChannel",string.format("You have left channel '%s'",a_b)),"{RBX_NAME}",a_b),"System")else
_bb:SendSystemMessage(_da:Get("GameChat_ChatService_CannotLeaveChannel","You cannot leave this channel."),a_b)end end;return true end;return false end;local d_b=bca.new(self,a_b)
self.ChatChannels[a_b:lower()]=d_b
d_b:RegisterProcessCommandsFunction("default_commands",c_b,aca.HighPriority)
local _ab,aab=pcall(function()self.eChannelAdded:Fire(a_b)end)if not _ab and aab then
print("Error addding channel: "..aab)end;if b_b~=nil then d_b.AutoJoin=b_b
if b_b then for bab,cab in
pairs(self.Speakers)do cab:JoinChannel(a_b)end end end;return d_b end
function ada:RemoveChannel(a_b)
if(self.ChatChannels[a_b:lower()])then
local b_b=self.ChatChannels[a_b:lower()].Name
self.ChatChannels[a_b:lower()]:InternalDestroy()self.ChatChannels[a_b:lower()]=nil
local c_b,d_b=pcall(function()
self.eChannelRemoved:Fire(b_b)end)if not c_b and d_b then
print("Error removing channel: "..d_b)end else
warn(string.format("Channel %q does not exist.",a_b))end end
function ada:GetChannel(a_b)return self.ChatChannels[a_b:lower()]end
function ada:AddSpeaker(a_b)if(self.Speakers[a_b:lower()])then
error("Speaker \""..a_b.."\" already exists!")end;local b_b=cca.new(self,a_b)
self.Speakers[a_b:lower()]=b_b
local c_b,d_b=pcall(function()self.eSpeakerAdded:Fire(a_b)end)if not c_b and d_b then
print("Error adding speaker: "..d_b)end;return b_b end;function ada:InternalUnmuteSpeaker(a_b)
for b_b,c_b in pairs(self.ChatChannels)do if c_b:IsSpeakerMuted(a_b)then
c_b:UnmuteSpeaker(a_b)end end end
function ada:RemoveSpeaker(a_b)
if
(self.Speakers[a_b:lower()])then local b_b=self.Speakers[a_b:lower()].Name
self:InternalUnmuteSpeaker(b_b)
self.Speakers[a_b:lower()]:InternalDestroy()self.Speakers[a_b:lower()]=nil
local c_b,d_b=pcall(function()
self.eSpeakerRemoved:Fire(b_b)end)if not c_b and d_b then
print("Error removing speaker: "..d_b)end else
warn("Speaker \""..a_b.."\" does not exist!")end end
function ada:GetSpeaker(a_b)return self.Speakers[a_b:lower()]end
function ada:GetChannelList()local a_b={}
for b_b,c_b in pairs(self.ChatChannels)do if(not c_b.Private)then
table.insert(a_b,c_b.Name)end end;return a_b end
function ada:GetAutoJoinChannelList()local a_b={}for b_b,c_b in pairs(self.ChatChannels)do if c_b.AutoJoin then
table.insert(a_b,c_b)end end;return a_b end
function ada:GetSpeakerList()local a_b={}for b_b,c_b in pairs(self.Speakers)do
table.insert(a_b,c_b.Name)end;return a_b end
function ada:SendGlobalSystemMessage(a_b)for b_b,c_b in pairs(self.Speakers)do
c_b:SendSystemMessage(a_b,nil)end end
function ada:RegisterFilterMessageFunction(a_b,b_b,c_b)if
self.FilterMessageFunctions:HasFunction(a_b)then
error(string.format("FilterMessageFunction '%s' already exists",a_b))end
self.FilterMessageFunctions:AddFunction(a_b,b_b,c_b)end;function ada:FilterMessageFunctionExists(a_b)return
self.FilterMessageFunctions:HasFunction(a_b)end
function ada:UnregisterFilterMessageFunction(a_b)if

not self.FilterMessageFunctions:HasFunction(a_b)then
error(string.format("FilterMessageFunction '%s' does not exists",a_b))end
self.FilterMessageFunctions:RemoveFunction(a_b)end
function ada:RegisterProcessCommandsFunction(a_b,b_b,c_b)if
self.ProcessCommandsFunctions:HasFunction(a_b)then
error(string.format("ProcessCommandsFunction '%s' already exists",a_b))end
self.ProcessCommandsFunctions:AddFunction(a_b,b_b,c_b)end
function ada:ProcessCommandsFunctionExists(a_b)return
self.ProcessCommandsFunctions:HasFunction(a_b)end
function ada:UnregisterProcessCommandsFunction(a_b)if not
self.ProcessCommandsFunctions:HasFunction(a_b)then
error(string.format("ProcessCommandsFunction '%s' does not exist",a_b))end
self.ProcessCommandsFunctions:RemoveFunction(a_b)end;local bda=0;local cda=0;local dda=0
function ada:InternalNotifyFilterIssue()
if(tick()-cda)>aaa then dda=0 end;dda=dda+1;cda=tick()
if dda>=d_a then
if(tick()-bda)>_aa then bda=tick()
local a_b=self:GetChannel("System")
if a_b then
a_b:SendSystemMessage(_da:Get("GameChat_ChatService_ChatFilterIssues","The chat filter is currently experiencing issues and messages may be slow to appear."),_ca)end end end end;local __b={}
function ada:InternalApplyRobloxFilter(a_b,b_b,c_b)
if
(caa:IsServer()and not caa:IsStudio())then local d_b=self:GetSpeaker(a_b)
local _ab=c_b and self:GetSpeaker(c_b)if d_b==nil then return nil end;local aab=d_b:GetPlayer()
local bab=_ab and _ab:GetPlayer()if aab==nil then return b_b end;local cab=tick()local dab=0
while true do
local _bb,abb=pcall(function()if bab then return
daa:FilterStringAsync(b_b,aab,bab)else
return daa:FilterStringForBroadcast(b_b,aab)end end)
if _bb then return abb else warn("Error filtering message:",abb)end;dab=dab+1;if dab>a_a or(tick()-cab)>c_a then
self:InternalNotifyFilterIssue()return nil end
local bbb=b_a[math.min(#b_a,dab)]
local cbb=bbb+ ( (math.random()*2 -1)*bbb)wait(cbb)end else if not __b[b_b]then __b[b_b]=true;wait()end;return b_b end;return nil end
function ada:InternalApplyRobloxFilterNewAPI(a_b,b_b,c_b)local d_b=false
local _ab=caa:IsServer()and not caa:IsStudio()
if(d_b or _ab)then local aab=self:GetSpeaker(a_b)
if aab==nil then return false,nil,nil end;local bab=aab:GetPlayer()if bab==nil then return true,false,b_b end
local cab,dab=pcall(function()
local _bb=game:GetService("TextService")local abb=_bb:FilterStringAsync(b_b,bab.UserId,c_b)return abb end)
if(cab)then return true,true,dab else
warn("Error filtering message:",b_b,dab)self:InternalNotifyFilterIssue()return false,nil,nil end end;wait()return true,false,b_b end
function ada:InternalDoMessageFilter(a_b,b_b,c_b)
local d_b=self.FilterMessageFunctions:GetIterator()
for _ab,aab,bab in d_b do
local cab,dab=pcall(function()aab(a_b,b_b,c_b)end)if not cab then
warn(string.format("DoMessageFilter Function '%s' failed for reason: %s",_ab,dab))end end end
function ada:InternalDoProcessCommands(a_b,b_b,c_b)
local d_b=self.ProcessCommandsFunctions:GetIterator()
for _ab,aab,bab in d_b do
local cab,dab=pcall(function()local _bb=aab(a_b,b_b,c_b)if type(_bb)~="boolean"then
error("Process command functions must return a bool")end;return _bb end)if not cab then
warn(string.format("DoProcessCommands Function '%s' failed for reason: %s",_ab,dab))elseif dab then return true end end;return false end;function ada:InternalGetUniqueMessageId()local a_b=self.MessageIdCounter;self.MessageIdCounter=a_b+1;return
a_b end
function ada:InternalAddSpeakerWithPlayerObject(a_b,b_b,c_b)if
(self.Speakers[a_b:lower()])then
error("Speaker \""..a_b.."\" already exists!")end;local d_b=cca.new(self,a_b)
d_b:InternalAssignPlayerObject(b_b)self.Speakers[a_b:lower()]=d_b
if c_b then
local _ab,aab=pcall(function()
self.eSpeakerAdded:Fire(a_b)end)if not _ab and aab then
print("Error adding speaker: "..aab)end end;return d_b end
function ada:InternalFireSpeakerAdded(a_b)
local b_b,c_b=pcall(function()self.eSpeakerAdded:Fire(a_b)end)if not b_b and c_b then
print("Error firing speaker added: "..c_b)end end
function baa.new()local a_b=setmetatable({},ada)a_b.MessageIdCounter=0
a_b.ChatChannels={}a_b.Speakers={}
a_b.FilterMessageFunctions=dca:NewSortedFunctionContainer()
a_b.ProcessCommandsFunctions=dca:NewSortedFunctionContainer()a_b.eChannelAdded=Instance.new("BindableEvent")
a_b.eChannelRemoved=Instance.new("BindableEvent")a_b.eSpeakerAdded=Instance.new("BindableEvent")
a_b.eSpeakerRemoved=Instance.new("BindableEvent")a_b.ChannelAdded=a_b.eChannelAdded.Event
a_b.ChannelRemoved=a_b.eChannelRemoved.Event;a_b.SpeakerAdded=a_b.eSpeakerAdded.Event
a_b.SpeakerRemoved=a_b.eSpeakerRemoved.Event;a_b.ChatServiceMajorVersion=0;a_b.ChatServiceMinorVersion=5;return a_b end;return baa.new()