local da=game:GetService("Chat")
local _b=da:WaitForChild("ClientChatModules")
local ab=require(_b:WaitForChild("ChatConstants"))
local bb=require(_b:WaitForChild("ChatSettings"))local cb=nil
pcall(function()
cb=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if cb==nil then cb={}function cb:Get(bc,cc)return cc end end
local db=
bb.ErrorMessageTextColor or Color3.fromRGB(245,50,50)local _c={ChatColor=db}
local function ac(bc)
local function cc(bd)local cd=bd
if string.sub(bd,1,1)=="\""then
local dd=string.find(bd,"\"",2)if dd then cd=string.sub(bd,2,dd-1)end else
local dd=string.match(bd,"^[^%s]+")if dd then cd=dd end end;return cd end
local function dc(bd,cd,dd)local __a=cc(cd)local a_a=bc:GetSpeaker(bd)
if a_a then
if
__a:lower()==bd:lower()then
a_a:SendSystemMessage(cb:Get("GameChat_DoMuteCommand_CannotMuteSelf","You cannot mute yourself."),dd,_c)return end;local b_a=bc:GetSpeaker(__a)
if b_a then
a_a:AddMutedSpeaker(b_a.Name)
a_a:SendSystemMessage(string.gsub(cb:Get("GameChat_ChatMain_SpeakerHasBeenMuted",string.format("Speaker '%s' has been muted.",b_a.Name)),"{RBX_NAME}",b_a.Name),dd)else
a_a:SendSystemMessage(string.gsub(cb:Get("GameChat_MuteSpeaker_SpeakerDoesNotExist",string.format("Speaker '%s' does not exist.",tostring(__a))),"{RBX_NAME}",tostring(__a)),dd,_c)end end end
local function _d(bd,cd,dd)local __a=cc(cd)local a_a=bc:GetSpeaker(bd)
if a_a then
if
__a:lower()==bd:lower()then
a_a:SendSystemMessage(cb:Get("GameChat_DoMuteCommand_CannotMuteSelf","You cannot mute yourself."),dd,_c)return end;local b_a=bc:GetSpeaker(__a)
if b_a then
a_a:RemoveMutedSpeaker(b_a.Name)
a_a:SendSystemMessage(string.gsub(cb:Get("GameChat_ChatMain_SpeakerHasBeenUnMuted",string.format("Speaker '%s' has been unmuted.",b_a.Name)),"{RBX_NAME}",b_a.Name),dd)else
a_a:SendSystemMessage(string.gsub(cb:Get("GameChat_MuteSpeaker_SpeakerDoesNotExist",string.format("Speaker '%s' does not exist.",tostring(__a))),"{RBX_NAME}",tostring(__a)),dd,_c)end end end
local function ad(bd,cd,dd)local __a=false
if
string.sub(cd,1,6):lower()=="/mute "then dc(bd,string.sub(cd,7),dd)__a=true elseif
string.sub(cd,1,8):lower()=="/unmute "then _d(bd,string.sub(cd,9),dd)
__a=true end;return __a end
bc:RegisterProcessCommandsFunction("mute_commands",ad,ab.StandardPriority)end;return ac