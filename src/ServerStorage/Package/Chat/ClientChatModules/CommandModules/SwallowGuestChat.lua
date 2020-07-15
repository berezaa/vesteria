
local d=require(script.Parent:WaitForChild("Util"))local _a=game:GetService("RunService")local aa=nil
pcall(function()
aa=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if aa==nil then aa={}function aa:Get(ba,ca)return ca end end
function ProcessMessage(ba,ca,da)
local _b=game:GetService("Players").LocalPlayer
if _b and _b.UserId<0 and not _a:IsStudio()then
local ab=ca:GetCurrentChannel()if ab then
d:SendSystemMessageToSelf(aa:Get("GameChat_SwallowGuestChat_Message","Create a free account to get access to chat permissions!"),ab,{})end;return
true end;return false end;return
{[d.KEY_COMMAND_PROCESSOR_TYPE]=d.COMPLETED_MESSAGE_PROCESSOR,[d.KEY_PROCESSOR_FUNCTION]=ProcessMessage}