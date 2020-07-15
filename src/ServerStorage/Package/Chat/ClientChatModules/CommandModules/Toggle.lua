
local _a=require(script.Parent:WaitForChild("Util"))
local aa=require(script.Parent.Parent:WaitForChild("ChatConstants"))
local ba=game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("Toggle")
local function ca(da,_b,ab)
if string.sub(da,1,7):lower()=="/toggle"then
if
da:lower()=="/toggle"then
_a:SendSystemMessageToSelf("Usage : /toggle <tags/color> : toggles chat tags or chat color.",_b:GetCurrentChannel(),{})return true elseif da:lower()=="/toggle tags"then ba:FireServer("Tags")
_a:SendSystemMessageToSelf("Successfully toggled chat tags.",_b:GetCurrentChannel(),{})return true elseif da:lower()=="/toggle color"then ba:FireServer("Color")
_a:SendSystemMessageToSelf("Successfully toggled chat color.",_b:GetCurrentChannel(),{})return true else
_a:SendSystemMessageToSelf("Usage : /toggle <tags/color> : toggles chat tags or chat color.",_b:GetCurrentChannel(),{})return true end end;return false end;return
{[_a.KEY_COMMAND_PROCESSOR_TYPE]=_a.COMPLETED_MESSAGE_PROCESSOR,[_a.KEY_PROCESSOR_FUNCTION]=ca}