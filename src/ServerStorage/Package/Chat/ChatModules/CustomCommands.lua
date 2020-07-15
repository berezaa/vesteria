
function matches(c,d)c=string.lower(c)d=string.lower(d)if
string.sub(c,1,d:len())==d then return true end end
function isCommand(c)
if matches(c,"/invite ")or matches(c,"/i ")then return"invite"elseif
matches(c,"/duel ")or matches(c,"/d ")then return"duel"elseif matches(c,"/trade ")or
matches(c,"/t ")then return"trade"end end
local function b(c)
local function d(_a,aa,ba)local ca=c:GetSpeaker(_a)local da=ca:GetPlayer()if isCommand(aa)then
local _b=string.gsub(aa,"^[^%s]+ ","")end;return false end
c:RegisterProcessCommandsFunction("customCommands",d)end;return b