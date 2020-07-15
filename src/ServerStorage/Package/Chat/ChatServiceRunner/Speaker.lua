local ba={}local ca=script.Parent;local function da(cb)local db={}for _c,ac in pairs(cb)do db[_c]=ac end
return db end;local _b={}
local ab={eDestroyed=true,eSaidMessage=true,eReceivedMessage=true,eReceivedUnfilteredMessage=true,eMessageDoneFiltering=true,eReceivedSystemMessage=true,eChannelJoined=true,eChannelLeft=true,eMuted=true,eUnmuted=true,eExtraDataUpdated=true,eMainChannelSet=true,eChannelNameColorUpdated=true}
local bb={Destroyed="eDestroyed",SaidMessage="eSaidMessage",ReceivedMessage="eReceivedMessage",ReceivedUnfilteredMessage="eReceivedUnfilteredMessage",RecievedUnfilteredMessage="eReceivedUnfilteredMessage",MessageDoneFiltering="eMessageDoneFiltering",ReceivedSystemMessage="eReceivedSystemMessage",ChannelJoined="eChannelJoined",ChannelLeft="eChannelLeft",Muted="eMuted",Unmuted="eUnmuted",ExtraDataUpdated="eExtraDataUpdated",MainChannelSet="eMainChannelSet",ChannelNameColorUpdated="eChannelNameColorUpdated"}
_b.__index=function(cb,db)local _c=rawget(_b,db)if _c then return _c end;if
ab[db]and not rawget(cb,db)then
rawset(cb,db,Instance.new("BindableEvent"))end;local ac=bb[db]if
ac and not rawget(cb,db)then if not rawget(cb,ac)then
rawset(cb,ac,Instance.new("BindableEvent"))end
rawset(cb,db,rawget(cb,ac).Event)end;return
rawget(cb,db)end
function _b:LazyFire(cb,...)local db=rawget(self,cb)if db then db:Fire(...)end end
function _b:SayMessage(cb,db,_c)if
(self.ChatService:InternalDoProcessCommands(self.Name,cb,db))then return end;if(not db)then return end
local ac=self.Channels[db:lower()]if(not ac)then
error("Speaker is not in channel \""..db.."\"")end
local bc=ac:InternalPostMessage(self,cb,_c)
if(bc)then
local cc,dc=pcall(function()self:LazyFire("eSaidMessage",bc,db)end)if not cc and dc then
print("Error saying message: "..dc)end end;return bc end
function _b:JoinChannel(cb)if(self.Channels[cb:lower()])then
warn("Speaker is already in channel \""..cb.."\"")return end
local db=self.ChatService:GetChannel(cb)if(not db)then
error("Channel \""..cb.."\" does not exist!")end
self.Channels[cb:lower()]=db;db:InternalAddSpeaker(self)
local _c,ac=pcall(function()
self.eChannelJoined:Fire(db.Name,db:GetWelcomeMessageForSpeaker(self))end)if not _c and ac then
print("Error joining channel: "..ac)end end
function _b:LeaveChannel(cb)
if(not self.Channels[cb:lower()])then warn("Speaker is not in channel \""..
cb.."\"")return end;local db=self.Channels[cb:lower()]self.Channels[cb:lower()]=
nil;db:InternalRemoveSpeaker(self)
local _c,ac=pcall(function()
self:LazyFire("eChannelLeft",db.Name)
self.EventFolder.OnChannelLeft:FireClient(self.PlayerObj,db.Name)end)if not _c and ac then
print("Error leaving channel: "..ac)end end;function _b:IsInChannel(cb)
return(self.Channels[cb:lower()]~=nil)end
function _b:GetChannelList()local cb={}for db,_c in pairs(self.Channels)do
table.insert(cb,_c.Name)end;return cb end
function _b:SendMessage(cb,db,_c,ac)local bc=self.Channels[db:lower()]
if(bc)then
bc:SendMessageToSpeaker(cb,self.Name,_c,ac)else
warn(string.format("Speaker '%s' is not in channel '%s' and cannot receive a message in it.",self.Name,db))end end
function _b:SendSystemMessage(cb,db,_c)local ac=self.Channels[db:lower()]
if(ac)then
ac:SendSystemMessageToSpeaker(cb,self.Name,_c)else
warn(string.format("Speaker '%s' is not in channel '%s' and cannot receive a system message in it.",self.Name,db))end end;function _b:GetPlayer()return self.PlayerObj end
function _b:SetExtraData(cb,db)
self.ExtraData[cb]=db;self:LazyFire("eExtraDataUpdated",cb,db)end;function _b:GetExtraData(cb)return self.ExtraData[cb]end
function _b:SetMainChannel(cb)
local db,_c=pcall(function()
self:LazyFire("eMainChannelSet",cb)
self.EventFolder.OnMainChannelSet:FireClient(self.PlayerObj,cb)end)if not db and _c then
print("Error setting main channel: ".._c)end end
function _b:AddMutedSpeaker(cb)self.MutedSpeakers[cb:lower()]=true end
function _b:RemoveMutedSpeaker(cb)self.MutedSpeakers[cb:lower()]=false end
function _b:IsSpeakerMuted(cb)return self.MutedSpeakers[cb:lower()]end
function _b:InternalDestroy()for cb,db in pairs(self.Channels)do
db:InternalRemoveSpeaker(self)end
self.eDestroyed:Fire()self.EventFolder=nil;self.eDestroyed:Destroy()
self.eSaidMessage:Destroy()self.eReceivedMessage:Destroy()
self.eReceivedUnfilteredMessage:Destroy()self.eMessageDoneFiltering:Destroy()
self.eReceivedSystemMessage:Destroy()self.eChannelJoined:Destroy()
self.eChannelLeft:Destroy()self.eMuted:Destroy()
self.eUnmuted:Destroy()self.eExtraDataUpdated:Destroy()
self.eMainChannelSet:Destroy()self.eChannelNameColorUpdated:Destroy()end;function _b:InternalAssignPlayerObject(cb)self.PlayerObj=cb end;function _b:InternalAssignEventFolder(cb)
self.EventFolder=cb end
function _b:InternalSendMessage(cb,db)
local _c,ac=pcall(function()
self:LazyFire("eReceivedUnfilteredMessage",cb,db)
self.EventFolder.OnNewMessage:FireClient(self.PlayerObj,cb,db)end)if not _c and ac then
print("Error sending internal message: "..ac)end end
function _b:InternalSendFilteredMessage(cb,db)
local _c,ac=pcall(function()
self:LazyFire("eReceivedMessage",cb,db)self:LazyFire("eMessageDoneFiltering",cb,db)
self.EventFolder.OnMessageDoneFiltering:FireClient(self.PlayerObj,cb,db)end)if not _c and ac then
print("Error sending internal filtered message: "..ac)end end
function _b:InternalSendFilteredMessageWithFilterResult(cb,db)local _c=da(cb)local ac=_c.FilterResult
local bc=self:GetPlayer()local cc=""
pcall(function()
if(_c.IsFilterResult)then if(bc)then cc=ac:GetChatForUserAsync(bc.UserId)else
cc=ac:GetNonChatStringForBroadcastAsync()end else cc=ac end end)if(#cc>0)then _c.Message=cc;_c.FilterResult=nil
self:InternalSendFilteredMessage(_c,db)end end
function _b:InternalSendSystemMessage(cb,db)
local _c,ac=pcall(function()
self:LazyFire("eReceivedSystemMessage",cb,db)
self.EventFolder.OnNewSystemMessage:FireClient(self.PlayerObj,cb,db)end)if not _c and ac then
print("Error sending internal system message: "..ac)end end
function _b:UpdateChannelNameColor(cb,db)
self:LazyFire("eChannelNameColorUpdated",cb,db)
self.EventFolder.ChannelNameColorUpdated:FireClient(self.PlayerObj,cb,db)end
function ba.new(cb,db)local _c=setmetatable({},_b)_c.ChatService=cb;_c.PlayerObj=nil
_c.Name=db;_c.ExtraData={}_c.Channels={}_c.MutedSpeakers={}_c.EventFolder=nil;return _c end;return ba