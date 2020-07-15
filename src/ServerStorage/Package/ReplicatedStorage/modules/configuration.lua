local bd={}local cd=game:GetService("InsertService")
local dd=game:GetService("HttpService")local __a=game:GetService("RunService")
local a_a=game:GetService("ReplicatedStorage")local b_a=require(a_a.modules)local c_a=b_a.load("network")
local d_a=2553891018;local _aa;local aaa;local baa;local caa;local daa={}local _ba=__a:IsServer()
local aba=__a:IsClient()
local function bba(cca)if aba then
warn("Unable to call `getGameConfiguration` on client")return nil end;local dca={}
for _da,ada in pairs(aaa)do
if ada.overrides then
local bda=nil;local cda=nil
for dda,__b in pairs(ada.overrides)do
local a_b,b_b=string.match(dda,"([puid]+):(%d+)")
if
a_b=="pid"and b_b and game.PlaceId==tonumber(b_b)then bda=__b elseif
a_b=="uid"and b_b and cca and cca.userId==tonumber(b_b)then cda=__b end end
if cda~=nil then dca[_da]=cda elseif bda~=nil then dca[_da]=bda else dca[_da]=ada.value end else dca[_da]=ada.value end end;return dca end
local function cba()if aba then
warn("Unable to call `updateGameConfiguration` on client")return nil end;local cca
local dca,_da=pcall(function()return
game:GetService("InsertService"):GetLatestAssetVersionAsync(d_a)end)
if dca and _da then
if not _aa or _aa~=_da then
local ada,bda=pcall(function()return
game:GetService("InsertService"):LoadAssetVersion(_da)end)
if ada and bda and bda:GetChildren()[1]then
cca=require(bda:GetChildren()[1])_aa=_da else
if not aaa then
warn("ERR2: gameConfiguration failed to load, defaulting to embedded gameConfiguration")
cca=require(game.ServerStorage.gameConfiguration)end end end else
if not aaa then
warn("ERR1: gameConfiguration failed to load, defaulting to embedded gameConfiguration")
cca=require(game.ServerStorage.gameConfiguration)end end
if cca then aaa=cca;local ada={}
for bda,cda in pairs(game.Players:GetPlayers())do
ada[cda]=bba(cda)for dda,__b in pairs(ada[cda])do
if dda:sub(1,7)=="server_"then ada[cda][dda]=nil end end end;caa=bba(nil)daa=ada
for bda,cda in pairs(game.Players:GetPlayers())do if
daa[cda]then
c_a:fireClient("{15B90E4A-8442-4D6D-A622-4A0AE40D1816}",cda,daa[cda],caa)end end
c_a:fire("{6EB94876-090C-423B-A85F-85A8F7E441EF}",caa)end end;local function dba(cca)return daa[cca],caa end
function bd.getConfigurationValue(cca,dca)
if _ba then if not caa then while not caa do
wait(0.1)end end
if dca then local _da=daa[dca][cca]if _da==nil then return
caa[cca]end;return _da else return caa[cca]end elseif aba then
if not baa and not caa then while not baa and not caa do wait(0.1)end end;local _da=baa[cca]if _da==nil then return caa[cca]end;return _da end end;local function _ca(cca)daa[cca]=bba(cca)end
local function aca(cca)daa[cca]=nil end
local function bca()
if _ba then
c_a:create("{40B2DF1B-4DE1-4A17-8BE5-C9A8617E2F81}","RemoteFunction","OnServerInvoke",dba)
c_a:create("{15B90E4A-8442-4D6D-A622-4A0AE40D1816}","RemoteEvent")
c_a:create("{6EB94876-090C-423B-A85F-85A8F7E441EF}","BindableEvent")cba()
for cca,dca in pairs(game.Players:GetPlayers())do _ca(dca)end;game.Players.PlayerAdded:connect(_ca)
game.Players.PlayerRemoving:connect(aca)while
wait(bd.getConfigurationValue("gameConfigurationRefreshTimeInSeconds",nil))do cba()end elseif aba then
c_a:create("{6EB94876-090C-423B-A85F-85A8F7E441EF}","BindableEvent")
c_a:connect("{15B90E4A-8442-4D6D-A622-4A0AE40D1816}","OnClientEvent",function(cca,dca)baa=cca;caa=dca
c_a:fire("{6EB94876-090C-423B-A85F-85A8F7E441EF}",baa,caa)end)
baa,caa=c_a:invokeServer("{40B2DF1B-4DE1-4A17-8BE5-C9A8617E2F81}")end end;spawn(bca)return bd