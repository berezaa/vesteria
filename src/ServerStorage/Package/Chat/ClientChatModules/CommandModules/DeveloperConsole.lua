local c=game:GetService("StarterGui")
local d=require(script.Parent:WaitForChild("Util"))
function ProcessMessage(_a,aa,ba)
if string.sub(_a,1,8):lower()=="/console"or
string.sub(_a,1,11):lower()=="/newconsole"then
local ca,da=pcall(function()return
c:GetCore("DevConsoleVisible")end)
if ca then
local _b,ab=pcall(function()c:SetCore("DevConsoleVisible",not da)end)if not _b and ab then
print("Error making developer console visible: "..ab)end end;return true elseif
string.sub(_a,1,11):lower()=="/oldconsole"then
local ca,da=pcall(function()return c:GetCore("DeveloperConsoleVisible")end)
if ca then
local _b,ab=pcall(function()c:SetCore("DeveloperConsoleVisible",not da)end)if not _b and ab then
print("Error making developer console visible: "..ab)end end;return true end;return false end;return
{[d.KEY_COMMAND_PROCESSOR_TYPE]=d.COMPLETED_MESSAGE_PROCESSOR,[d.KEY_PROCESSOR_FUNCTION]=ProcessMessage}