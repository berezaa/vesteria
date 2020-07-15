local ca={}local da={}local _b={}local ab=game:GetService("HttpService")
local bb=game:GetService("RunService")local cb=require(game.ReplicatedStorage.modules)
local db=cb.load("network")
function ca:registerForEvent(_c,ac)local bc=ab:GenerateGUID()
local cc={callback=ac,guid=bc,eventName=_c}da[bc]=cc;if not _b[_c]then _b[_c]={}end
table.insert(_b[_c],bc)return bc end
function ca:deregisterEventByGuid(_c)if not da[_c]then return end;local ac=da[_c].eventName
da[_c]=nil;local bc=_b[ac]if not bc then return end;for index=#bc,1,-1 do local cc=bc[index]if cc==_c then
table.remove(bc,index)end end end;ca.deregisterFromEvent=ca.deregisterEventByGuid
function ca:__invokeCallbacks(_c,...)local ac=_b[_c]if
not ac then return end;for bc,cc in pairs(ac)do local dc=da[cc]
if dc then dc.callback(...)end end end
function ca:fireEventAll(_c,...)self:__invokeCallbacks(_c,...)
local ac=require(script.Parent).load("network")
if bb:IsServer()then
ac:fireAllClients("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}",_c,...)else
ac:fireServer("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}",_c,...)end end
function ca:fireEventLocal(_c,...)self:__invokeCallbacks(_c,...)end
function ca:fireEventPlayer(_c,ac,...)if not bb:IsServer()then
error("events:fireEventPlayer can only be called from the server.")end
self:__invokeCallbacks(_c,ac,...)
local bc=require(script.Parent).load("network")
bc:fireClient("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}",ac,_c,...)end
function ca:fireEventPlayers(_c,ac,...)if not bb:IsServer()then
error("events:fireEventPlayers can only be called from the server.")end
self:__invokeCallbacks(_c,ac,...)
local bc=require(script.Parent).load("network")for cc,dc in pairs(ac)do
bc:fireClient("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}",dc,_c,...)end end
function ca:fireEventExcluding(_c,ac,...)if not bb:IsServer()then
error("events:fireEventExcluding can only be called from the server.")end
self:__invokeCallbacks(_c,ac,...)
local bc=require(script.Parent).load("network")
local cc=game:GetService("Players"):GetPlayers()
for dc,_d in pairs(cc)do if _d~=ac then
bc:fireClient("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}",_d,_c,...)end end end;return ca