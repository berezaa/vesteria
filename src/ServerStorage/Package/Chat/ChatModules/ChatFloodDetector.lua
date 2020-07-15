local db=game:GetService("Chat")
local _c=db:WaitForChild("ClientChatModules")
local ac=require(_c:WaitForChild("ChatConstants"))local bc=true;local cc=true;local dc=true;local _d=7;local ad=15;local bd={}local cd={}local dd=nil
pcall(function()
dd=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if dd==nil then dd={}function dd:Get(b_a,c_a)return c_a end end;local function __a(b_a)table.insert(b_a,
tick()+ad)end
local function a_a(b_a)
local function c_a(d_a,_aa,aaa)if(cd[d_a])then
return false end;local baa=b_a:GetSpeaker(d_a)
if(not baa)then return false end;if(dc and not baa:GetPlayer())then return false end;if(not
bd[d_a])then bd[d_a]={}end;local caa=nil
if(bc)then if(not bd[d_a][aaa])then
bd[d_a][aaa]={}end;caa=bd[d_a][aaa]else caa=bd[d_a]end;local daa=tick()
while(#caa>0 and caa[1]<daa)do table.remove(caa,1)end
if(#caa<_d)then __a(caa)return false else local _ba=math.ceil(caa[1]-daa)
if(cc)then
local aba=string.gsub(dd:Get("GameChat_ChatFloodDetector_MessageDisplaySeconds",string.format("You must wait %d %s before sending another message!",_ba,(
_ba>1)and"seconds"or"second")),"{RBX_NUMBER}",tostring(_ba))baa:SendSystemMessage(aba,aaa)else
baa:SendSystemMessage(dd:Get("GameChat_ChatFloodDetector_Message","You must wait before sending another message!"),aaa)end;return true end end
b_a:RegisterProcessCommandsFunction("flood_detection",c_a,ac.LowPriority)
b_a.SpeakerRemoved:connect(function(d_a)bd[d_a]=nil end)end;return a_a