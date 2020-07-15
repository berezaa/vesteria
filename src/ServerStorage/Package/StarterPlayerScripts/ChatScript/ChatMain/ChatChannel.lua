local ba={}local ca=game:GetService("Chat")
local da=ca:WaitForChild("ClientChatModules")local _b=script.Parent
local ab=require(da:WaitForChild("ChatSettings"))local bb={}bb.__index=bb;function bb:Destroy()self.Destroyed=true end
function bb:SetActive(cb)if
cb==self.Active then return end
if cb==false then
self.MessageLogDisplay:Clear()else
self.MessageLogDisplay:SetCurrentChannelName(self.Name)for i=1,#self.MessageLog do
self.MessageLogDisplay:AddMessage(self.MessageLog[i])end end;self.Active=cb end
function bb:UpdateMessageFiltered(cb)local db=1;local _c=self.MessageLog;local ac=nil;while(#_c>=db)do local bc=_c[db]if
(bc.ID==cb.ID)then ac=bc;break end;db=db+1 end
if ac then
ac.Message=cb.Message;ac.IsFiltered=true;if self.Active then
self.MessageLogDisplay:UpdateMessageFiltered(ac)end else
self:AddMessageToChannelByTimeStamp(cb)end end
function bb:AddMessageToChannel(cb)table.insert(self.MessageLog,cb)if self.Active then
self.MessageLogDisplay:AddMessage(cb)end
if
#self.MessageLog>ab.MessageHistoryLengthPerChannel then self:RemoveLastMessageFromChannel()end end
function bb:InternalAddMessageAtTimeStamp(cb)for i=1,#self.MessageLog do
if
cb.Time<self.MessageLog[i].Time then table.insert(self.MessageLog,i,cb)return end end
table.insert(self.MessageLog,cb)end
function bb:AddMessagesToChannelByTimeStamp(cb,db)for i=db,#cb do
self:InternalAddMessageAtTimeStamp(cb[i])end
while
#self.MessageLog>ab.MessageHistoryLengthPerChannel do table.remove(self.MessageLog,1)end
if self.Active then self.MessageLogDisplay:Clear()for i=1,#self.MessageLog
do
self.MessageLogDisplay:AddMessage(self.MessageLog[i])end end end
function bb:AddMessageToChannelByTimeStamp(cb)
if#self.MessageLog>=1 then
if
self.MessageLog[1].Time>cb.Time then return elseif cb.Time>=
self.MessageLog[#self.MessageLog].Time then self:AddMessageToChannel(cb)return end
for i=1,#self.MessageLog do
if cb.Time<self.MessageLog[i].Time then
table.insert(self.MessageLog,i,cb)if#self.MessageLog>ab.MessageHistoryLengthPerChannel then
self:RemoveLastMessageFromChannel()end;if self.Active then
self.MessageLogDisplay:AddMessageAtIndex(cb,i)end;return end end else self:AddMessageToChannel(cb)end end
function bb:RemoveLastMessageFromChannel()table.remove(self.MessageLog,1)if self.Active then
self.MessageLogDisplay:RemoveLastMessage()end end
function bb:ClearMessageLog()self.MessageLog={}if self.Active then
self.MessageLogDisplay:Clear()end end;function bb:RegisterChannelTab(cb)self.ChannelTab=cb end
function ba.new(cb,db)
local _c=setmetatable({},bb)_c.Destroyed=false;_c.Active=false;_c.MessageLog={}_c.MessageLogDisplay=db;_c.ChannelTab=
nil;_c.Name=cb;return _c end;return ba