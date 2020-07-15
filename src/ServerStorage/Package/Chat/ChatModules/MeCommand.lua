local _a=game:GetService("Chat")
local aa=_a:WaitForChild("ClientChatModules")
local ba=require(aa:WaitForChild("ChatConstants"))
local function ca(da)local function _b(ab,bb,cb)local db=bb.Message
if db and
string.sub(db,1,4):lower()=="/me "then bb.MessageType=ba.MessageTypeMeCommand end end
da:RegisterFilterMessageFunction("me_command",_b)end;return ca