
local d=require(script.Parent:WaitForChild("Util"))
local _a=require(script.Parent.Parent:WaitForChild("ChatConstants"))
local function aa(ba,ca,da)
if string.sub(ba,1,8):lower()=="/version"or
string.sub(ba,1,9):lower()=="/version "then
d:SendSystemMessageToSelf(string.format("This game is running chat version [%d.%d.%s].",_a.MajorVersion,_a.MinorVersion,_a.BuildVersion),ca:GetCurrentChannel(),{})return true end;return false end;return
{[d.KEY_COMMAND_PROCESSOR_TYPE]=d.COMPLETED_MESSAGE_PROCESSOR,[d.KEY_PROCESSOR_FUNCTION]=aa}