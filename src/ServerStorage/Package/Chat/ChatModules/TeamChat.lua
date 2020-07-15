local da=game:GetService("Chat")
local _b=da:WaitForChild("ClientChatModules")
local ab=require(_b:WaitForChild("ChatSettings"))
local bb=require(_b:WaitForChild("ChatConstants"))local cb=nil
pcall(function()
cb=require(game:GetService("Chat").ClientChatModules.ChatLocalization)end)if cb==nil then cb={}function cb:Get(bc,cc)return cc end end
local db=
ab.ErrorMessageTextColor or Color3.fromRGB(245,50,50)local _c={ChatColor=db}
local function ac(bc)local cc=game:GetService("Players")
local dc=bc:AddChannel("Team")
dc.WelcomeMessage=cb:Get("GameChat_TeamChat_WelcomeMessage","This is a private channel between you and your team members.")dc.Joinable=false;dc.Leavable=false;dc.AutoJoin=false;dc.Private=true
local function _d(a_a,b_a,c_a)
local d_a=bc:GetSpeaker(a_a)local _aa=bc:GetChannel(c_a)
if c_a=="Team"then
if(d_a and _aa)then
local aaa=d_a:GetPlayer()
if(aaa)then
for baa,caa in pairs(_aa:GetSpeakerList())do local daa=bc:GetSpeaker(caa)
if(daa)then
local _ba=daa:GetPlayer()
if(_ba)then
if(aaa.Team==_ba.Team)then
local aba={NameColor=aaa.TeamColor.Color,ChannelColor=aaa.TeamColor.Color}daa:SendMessage(b_a,c_a,a_a,aba)else end end end end end end;return true end end
dc:RegisterProcessCommandsFunction("replication_function",_d,bb.LowPriority)
local function ad(a_a,b_a,c_a)if b_a==nil then b_a=""end;local d_a=bc:GetSpeaker(a_a)
if d_a then
local _aa=d_a:GetPlayer()
if _aa then
if _aa.Team==nil then
d_a:SendSystemMessage(cb:Get("GameChat_TeamChat_CannotTeamChatIfNotInTeam","You cannot team chat if you are not on a team!"),c_a,_c)return end;local aaa=bc:GetChannel("Team")
if aaa then if
not d_a:IsInChannel(aaa.Name)then d_a:JoinChannel(aaa.Name)end
if b_a and
string.len(b_a)>0 then d_a:SayMessage(b_a,aaa.Name)end;d_a:SetMainChannel(aaa.Name)end end end end
local function bd(a_a,b_a,c_a)local d_a=false;if b_a==nil then error("Message is nil")end;if c_a==
"Team"then return false end
if

string.sub(b_a,1,6):lower()=="/team "or b_a:lower()=="/team"then ad(a_a,string.sub(b_a,7),c_a)d_a=true elseif
string.sub(b_a,1,3):lower()=="/t "or b_a:lower()=="/t"then
ad(a_a,string.sub(b_a,4),c_a)d_a=true end;return d_a end
bc:RegisterProcessCommandsFunction("team_commands",bd,bb.StandardPriority)
local function cd()
if ab.DefaultChannelNameColor then return ab.DefaultChannelNameColor end;return Color3.fromRGB(35,76,142)end
local function dd(a_a,b_a)
if b_a.Neutral or b_a.Team==nil then
a_a:UpdateChannelNameColor(dc.Name,cd())
if a_a:IsInChannel(dc.Name)then a_a:LeaveChannel(dc.Name)end elseif not b_a.Neutral and b_a.Team then
a_a:UpdateChannelNameColor(dc.Name,b_a.Team.TeamColor.Color)if not a_a:IsInChannel(dc.Name)then
a_a:JoinChannel(dc.Name)end end end
bc.SpeakerAdded:connect(function(a_a)local b_a=bc:GetSpeaker(a_a)if b_a then
local c_a=b_a:GetPlayer()if c_a then dd(b_a,c_a)end end end)local __a={}
cc.PlayerAdded:connect(function(a_a)
local b_a=a_a.Changed:connect(function(c_a)
local d_a=bc:GetSpeaker(a_a.Name)
if d_a then
if c_a=="Neutral"then dd(d_a,a_a)elseif c_a=="Team"then dd(d_a,a_a)
if
d_a:IsInChannel(dc.Name)then
d_a:SendSystemMessage(string.gsub(cb:Get("GameChat_TeamChat_NowInTeam",string.format("You are now on the '%s' team.",a_a.Team.Name)),"{RBX_NAME}",a_a.Team.Name),dc.Name)end end end end)__a[a_a]=b_a end)
cc.PlayerRemoving:connect(function(a_a)local b_a=__a[a_a]
if b_a then b_a:Disconnect()end;__a[a_a]=nil end)end;return ac