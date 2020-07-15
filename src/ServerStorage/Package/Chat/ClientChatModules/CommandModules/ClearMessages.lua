
local b=require(script.Parent:WaitForChild("Util"))
function ProcessMessage(c,d,_a)
if string.sub(c,1,4):lower()=="/cls"or
string.sub(c,1,6):lower()=="/clear"then
local aa=d:GetCurrentChannel()if(aa)then aa:ClearMessageLog()end;return true end;return false end;return
{[b.KEY_COMMAND_PROCESSOR_TYPE]=b.COMPLETED_MESSAGE_PROCESSOR,[b.KEY_PROCESSOR_FUNCTION]=ProcessMessage}