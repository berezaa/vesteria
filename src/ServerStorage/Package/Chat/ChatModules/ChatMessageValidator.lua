local da=game:GetService("Chat")
local _b=game:GetService("RunService")local ab=da:WaitForChild("ClientChatModules")
local bb=require(ab:WaitForChild("ChatSettings"))
local cb=require(ab:WaitForChild("ChatConstants"))local db=nil
pcall(function()
db=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if db==nil then db={}function db:Get(bc,cc)return cc end end
local _c={"\n","\r","\t","\v","\f"}if bb.DisallowedWhiteSpace then _c=bb.DisallowedWhiteSpace end
local function ac(bc)
local function cc(_d)if
_b:IsStudio()then return true end
local ad,bd=pcall(function()
return da:CanUserChatAsync(_d.UserId)end)return ad and bd end
local function dc(_d,ad,bd)local cd=bc:GetSpeaker(_d)local dd=cd:GetPlayer()
if not cd then return false end;if not dd then return false end;if
not _b:IsStudio()and dd.UserId<1 then return true end
if not cc(dd)then
cd:SendSystemMessage(db:Get("GameChat_ChatMessageValidator_SettingsError","Your chat settings prevent you from sending messages."),bd)return true end
if ad:len()>bb.MaximumMessageLength+1 then
cd:SendSystemMessage(db:Get("GameChat_ChatMessageValidator_MaxLengthError","Your message exceeds the maximum message length."),bd)return true end
for i=1,#_c do
if string.find(ad,_c[i])then
cd:SendSystemMessage(db:Get("GameChat_ChatMessageValidator_WhitespaceError","Your message contains whitespace that is not allowed."),bd)return true end end;return false end
bc:RegisterProcessCommandsFunction("message_validation",dc,bb.LowPriority)end;return ac