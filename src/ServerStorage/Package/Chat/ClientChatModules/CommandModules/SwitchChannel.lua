
local c=require(script.Parent:WaitForChild("Util"))local d=nil
pcall(function()
d=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)
if d==nil then d={Get=function(_a,aa)return aa end}end
function ProcessMessage(_a,aa,ba)if string.sub(_a,1,3):lower()~="/c "then
return false end;local ca=string.sub(_a,4)
local da=aa:GetChannel(ca)
if da then aa:SwitchCurrentChannel(ca)
if not ba.ShowChannelsBar then
local _b=aa:GetCurrentChannel()
if _b then
c:SendSystemMessageToSelf(string.gsub(d:Get("GameChat_SwitchChannel_NowInChannel",string.format("You are now chatting in channel: '%s'",ca)),"{RBX_NAME}",ca),da,{})end end else local _b=aa:GetCurrentChannel()
if _b then
c:SendSystemMessageToSelf(string.gsub(d:Get("GameChat_SwitchChannel_NotInChannel",string.format("You are not in channel: '%s'",ca)),"{RBX_NAME}",ca),_b,{ChatColor=Color3.fromRGB(245,50,50)})end end;return true end;return
{[c.KEY_COMMAND_PROCESSOR_TYPE]=c.COMPLETED_MESSAGE_PROCESSOR,[c.KEY_PROCESSOR_FUNCTION]=ProcessMessage}