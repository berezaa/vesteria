local bb=game:GetService("Chat")
local cb=bb:WaitForChild("ClientChatModules")
local db=require(cb:WaitForChild("ChatSettings"))
local _c=require(cb:WaitForChild("ChatConstants"))local ac=game:GetService("ReplicatedStorage")
local bc=require(ac.modules)local cc=bc.load("network")local dc=nil
pcall(function()
dc=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if dc==nil then dc={}function dc:Get(cd,dd)return dd end end
local _d=
db.ErrorMessageTextColor or Color3.fromRGB(245,50,50)local ad={ChatColor=_d}
local function bd(cd)local dd=game:GetService("Players")
local __a=cd:AddChannel("Party")__a.Joinable=false;__a.Leavable=false;__a.AutoJoin=false;__a.Private=true
local function a_a(baa,caa,daa)
local _ba=cd:GetSpeaker(baa)local aba=cd:GetChannel(daa)
if daa=="Party"then
if(_ba and aba)then
local bba=_ba:GetPlayer()
if(bba)then
local cba=cc:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",bba)
if cba and cba.members and#cba.members>0 then
for dba,_ca in
pairs(cba.members)do
if _ca and _ca.player then local aca=_ca.player.Name
local bca=cd:GetSpeaker(aca)
if(bca)then local cca=bca:GetPlayer()
if(cca)then
local dca={ChannelColor=Color3.fromRGB(0,240,244),ChatColor=Color3.fromRGB(0,240,244)}bca:SendMessage(caa,daa,baa,dca)end end end end end end end;return true end end
__a:RegisterProcessCommandsFunction("replication_function_party",a_a,_c.LowPriority)
local function b_a(baa,caa,daa)if caa==nil then caa=""end;local _ba=cd:GetSpeaker(baa)
if _ba then
local aba=_ba:GetPlayer()
if aba then
local bba=cc:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",aba)
if bba==nil or bba.members==nil then
_ba:SendSystemMessage(dc:Get("GameChat_PartyChat_CannotPartyChatIfNotInParty","You cannot party chat if you are not on a party!"),daa,ad)return end;local cba=cd:GetChannel("Party")
if cba then if
not _ba:IsInChannel(cba.Name)then _ba:JoinChannel(cba.Name)end
if caa and
string.len(caa)>0 then _ba:SayMessage(caa,cba.Name)end;_ba:SetMainChannel(cba.Name)end end end end
local function c_a(baa,caa,daa)local _ba=false;if caa==nil then error("Message is nil")end;if daa==
"Party"then return false end
if

string.sub(caa,1,6):lower()=="/party "or caa:lower()=="/party"then b_a(baa,string.sub(caa,7),daa)_ba=true elseif
string.sub(caa,1,3):lower()=="/p "or caa:lower()=="/p"then
b_a(baa,string.sub(caa,4),daa)_ba=true end;return _ba end
cd:RegisterProcessCommandsFunction("party_commands",c_a,_c.StandardPriority)local function d_a()return Color3.fromRGB(0,240,244)end
local function _aa(baa,caa)
baa:UpdateChannelNameColor(__a.Name,d_a())if not baa:IsInChannel(__a.Name)then
baa:JoinChannel(__a.Name)end end
cd.SpeakerAdded:connect(function(baa)local caa=cd:GetSpeaker(baa)if caa then
local daa=caa:GetPlayer()if daa then _aa(caa,daa)end end end)local aaa={}
cc:connect("{2ECD2D2F-8941-4664-B665-7ED91347531F}","Event",function(baa)
local caa=cd:GetSpeaker(baa.Name)if caa then _aa(caa,baa)end;aaa[baa]=nil end)
dd.PlayerRemoving:connect(function(baa)local caa=aaa[baa]
if caa then caa:Disconnect()end;aaa[baa]=nil end)end;return bd