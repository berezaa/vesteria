local bc={}local cc=game:GetService("ReplicatedStorage")
local dc=require(cc.modules)local _d=dc.load("network")local ad=dc.load("placeSetup")
local bd=dc.load("utilities")local cd=game:GetService("HttpService")
local dd=game:GetService("ServerStorage")local __a={}
local function a_a(caa)
_d:fireClient("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}",caa.playerTradeSessionData_player1.player,caa)
_d:fireClient("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}",caa.playerTradeSessionData_player2.player,caa)end;local function b_a(caa)
for daa,_ba in pairs(__a)do if
_ba.challenger==caa or _ba.playerChallenged==caa then __a[daa]=nil end end end
local function c_a(caa,daa)
if __a[daa]then
local _ba=__a[daa]b_a(_ba.challenger)b_a(_ba.playerChallenged)
__a[daa]=nil;if
not _ba.challenger.Parent or not _ba.playerChallenged.Parent then return false end
if _ba.wager then
local aba=_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ba.challenger)
local bba=_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ba.playerChallenged)
if aba.gold<_ba.wager or bba.gold<_ba.wager then return false end end
_d:invoke("{64E568DA-DD76-4950-9FB2-7C38E03F50D2}",_ba.challenger,_ba.playerChallenged)
_d:invoke("{64E568DA-DD76-4950-9FB2-7C38E03F50D2}",_ba.playerChallenged,_ba.challenger)
_d:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",_ba.challenger,{text="Your challenge with ".._ba.playerChallenged.Name..
" was accepted, FIGHT!"})
_d:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",_ba.playerChallenged,{text="You've accepted ".._ba.challenger.Name..
"'s challenge! Fight!"})return true end;return false,"invalid or inactive guid"end;local d_a={}
local function _aa(caa,daa,_ba)
if caa and daa and caa~=daa and(not _ba or
(type(_ba)=="number"and _ba>0))then
if true then
if not d_a[caa]or(
tick()-d_a[caa]>3)then d_a[caa]=tick()
local aba=cd:GenerateGUID(false)local bba={challenger=caa,playerChallenged=daa,wager=_ba}__a[aba]=bba
if(
game.PlaceId==4653017449)or(game.PlaceId==2061558182)then
local cba=game.ReplicatedStorage:FindFirstChild("guildId")
if cba then cba=cba.Value;local dba=caa:FindFirstChild("guildId")
local _ca=daa:FindFirstChild("guildId")
if dba and _ca then
if dba.Value==cba then
if _ca.Value==cba then
local aca=_d:invoke("{7EFA8F01-8D3D-4C15-89E1-4C0D30C3C32C}",caa,cba)
local bca=_d:invoke("{7EFA8F01-8D3D-4C15-89E1-4C0D30C3C32C}",daa,cba)
if
aca and bca and aca.rank and bca.rank and

_d:invoke("{94AC3EAB-26B8-4F63-B824-AD872ABD0E10}",aca.rank)>_d:invoke("{94AC3EAB-26B8-4F63-B824-AD872ABD0E10}",bca.rank)then c_a(daa,aba)return true end else c_a(daa,aba)return true end end elseif dba and(not _ca)then
if dba.Value==cba then c_a(daa,aba)return true end end end end
_d:fireClient("{F26D4D4D-ECA9-4D96-AB7A-EDB14307EEDB}",daa,caa,aba)return true else return false,"stop sending challenges too fast"end end elseif caa==daa then return false,"you can't challenge yourself."end;return false,"invalid request"end
local function aaa(caa)
local daa=_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",caa)
if daa then
for _ba,aba in pairs(daa.nonSerializeData.whitelistPVPEnabled)do
_d:invoke("{D7050FA4-2A8B-426F-97E8-604BFE01A579}",caa,aba)
_d:invoke("{D7050FA4-2A8B-426F-97E8-604BFE01A579}",aba,caa)end end end
local function baa()
_d:create("{673F5487-AA5C-490F-BF30-A7B6C949E215}","RemoteFunction","OnServerInvoke",_aa)
_d:create("{F469131B-FC79-4847-8CB3-742E2DACFB15}","RemoteFunction","OnServerInvoke",c_a)
_d:create("{F26D4D4D-ECA9-4D96-AB7A-EDB14307EEDB}","RemoteEvent")
_d:create("{B53276A6-1787-4136-8F7C-FBD317709699}","RemoteEvent")
_d:connect("{4B5C35A0-C7D0-4269-8782-C5C7CB30B14A}","Event",aaa)end;baa()return bc