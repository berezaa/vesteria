local b_a={}local c_a=game:GetService("ReplicatedStorage")
local d_a=require(c_a.modules)local _aa=d_a.load("network")local aaa=d_a.load("placeSetup")
local baa=d_a.load("utilities")local caa=d_a.load("configuration")
local daa=game:GetService("HttpService")local _ba=game:GetService("ServerStorage")
local aba=require(c_a.itemData)local bba={}local cba={}
local function dba(c_b)
for d_b,_ab in pairs(bba)do if

_ab.playerTradeSessionData_player1.player==c_b or _ab.playerTradeSessionData_player2.player==c_b then return _ab end end;return nil end
local function _ca(c_b)
_aa:fireClient("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}",c_b.playerTradeSessionData_player1.player,c_b)
_aa:fireClient("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}",c_b.playerTradeSessionData_player2.player,c_b)end;local function aca(c_b)
for d_b,_ab in pairs(cba)do if
_ab.playerToTradeWith==c_b or _ab.tradeRequester==c_b then cba[d_b]=nil end end end
local bca={}
local function cca(c_b,d_b)
if
not caa.getConfigurationValue("isTradingEnabled",c_b)or
not caa.getConfigurationValue("isTradingEnabled",d_b)then
return false,"Trading is disabled right now."end
if c_b:FindFirstChild("DataSaveFailed")then
_aa:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",c_b,{text="Cannot trade during DataStore outage.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end
if c_b and d_b and c_b~=d_b then
if not dba(c_b)and not dba(d_b)then
if
not bca[c_b]or(tick()-bca[c_b]>3)then bca[c_b]=tick()
local _ab=daa:GenerateGUID(false)cba[_ab]={tradeRequester=c_b,playerToTradeWith=d_b}
_aa:fireClient("{B9B41A65-A85E-4D55-92C9-43350C1DC213}",d_b,c_b,_ab)return true else return false,"stop sending trades so fast."end end elseif c_b==d_b then return false,"you can't trade with yourself, idiot."end;return false,"player is already trading"end
local function dca(c_b,d_b)
local _ab=_aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",c_b)local aab=0
do
for bab,cab in pairs(d_b)do local dab=aba[cab.id]if dab.soulbound then return false end;if not
cab.stacks then cab.stacks=1 end
if cab.stacks<=0 then return false elseif
math.floor(cab.stacks)~=cab.stacks then return false end;aab=aab+1 end end
if _ab then local bab=0;local cab={}
for dab,_bb in pairs(_ab.inventory)do
for abb,bbb in pairs(d_b)do
if _bb.position==bbb.position and
_bb.id==bbb.id and
(bbb.stacks or 1)<= (_bb.stacks or 1)then
if _bb.soulbound then return false end;cab[abb]=_bb;bab=bab+1;break end end end;return bab==aab,cab end end;local function _da(c_b)
for d_b,_ab in pairs(bba)do if _ab.id==c_b then return _ab end end;return nil end
local function ada(c_b)local d_b=dba(c_b)
if
d_b then d_b.state="canceled"
d_b.playerTradeSessionData_player1.state="denied"d_b.playerTradeSessionData_player2.state="denied"
_ca(d_b)
for _ab,aab in pairs(bba)do if aab==d_b then table.remove(bba,_ab)break end end end end;local bda={}
local function cda(c_b,d_b,_ab,aab)local bab=dba(c_b)
if not bab then return false,"no tradeSessionData found for player"end
if bab.guid~=d_b then return false,"invalid guid for tradeSessionData"end;local cab=bab.playerTradeSessionData_player1.player
local dab=bab.playerTradeSessionData_player2.player
if cab.Parent==nil or cab:FindFirstChild("teleporting")or
cab:FindFirstChild("DataLoaded")==nil then return false,
"invalid players"end
if dab.Parent==nil or dab:FindFirstChild("teleporting")or
dab:FindFirstChild("DataLoaded")==nil then return false,
"invalid players"end
local _bb=_aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",c_b)
if
_bb and bab and bab.state~="completed"and bab.state~="canceled"then
local abb=(bab.playerTradeSessionData_player1.player==c_b and
bab.playerTradeSessionData_player1)or
(
bab.playerTradeSessionData_player2.player==c_b and bab.playerTradeSessionData_player2)
if _ab=="state"and
(aab=="approved"or aab=="denied"or aab=="none")then
if aab~=abb.state then abb.state=aab
local bbb=daa:GenerateGUID(false)bda[d_b]=bbb
if
_ab=="state"and aab=="denied"and bab.state=="countdown"then bab.state="active"_ca(bab)return true end
if
bab.state~="countdown"and
bab.playerTradeSessionData_player1.state=="approved"and
bab.playerTradeSessionData_player2.state=="approved"then bab.state="countdown"_ca(bab)local cbb=tick()
while
(tick()-cbb)<6 and(
bab.playerTradeSessionData_player1.state=="approved"and
bab.playerTradeSessionData_player2.state=="approved")do wait(1 /4)end
if


cab.Parent~=game.Players or cab:FindFirstChild("teleporting")or cab:FindFirstChild("DataLoaded")==nil or
not _aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cab)then return false,"invalid players call 2"end
if


dab.Parent~=game.Players or dab:FindFirstChild("teleporting")or dab:FindFirstChild("DataLoaded")==nil or
not _aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dab)then return false,"invalid players call 2"end
if not
dca(cab,bab.playerTradeSessionData_player1.inventoryTransferDataCollection)then return false,
tostring(cab).." has invalid trade data"end
if not
dca(dab,bab.playerTradeSessionData_player2.inventoryTransferDataCollection)then return false,
tostring(dab).." has invalid trade data"end
if bda[d_b]==bbb and
(
bab.playerTradeSessionData_player1.state=="approved"and bab.playerTradeSessionData_player2.state=="approved")then
local dbb,_cb=_aa:invoke("{4C29D9FD-2312-4C1B-92EB-5CF5E5F20177}",bab.playerTradeSessionData_player1.player,bab.playerTradeSessionData_player1.inventoryTransferDataCollection,bab.playerTradeSessionData_player1.gold,bab.playerTradeSessionData_player2.player,bab.playerTradeSessionData_player2.inventoryTransferDataCollection,bab.playerTradeSessionData_player2.gold)if dbb then bab.state="completed"_ca(bab)else ada(c_b)end;bda[d_b]=
nil;for acb,bcb in pairs(bba)do
if bcb.guid==d_b then table.remove(bba,acb)end end;return dbb,_cb end else bab.state="active"_ca(bab)end;return true end elseif _ab=="gold"and(type(aab)=="number"and aab>=0)then
if
_bb.gold>=aab then abb.gold=aab
bab.playerTradeSessionData_player1.state="none"bab.playerTradeSessionData_player2.state="none"
bab.state="active"_ca(bab)return true else return false,"invalid gold"end elseif
_ab=="inventoryTransferDataCollection"and(typeof(aab)=="table")then local bbb,cbb=dca(c_b,aab)
if bbb then
bab.playerTradeSessionData_player1.state="none"bab.playerTradeSessionData_player2.state="none"
bab.state="active"abb.inventoryTransferDataCollection=cbb;_ca(bab)return true else return false,
"invalid trade transfer data"end else return false,"invalid key"end end;return false,"invalid"end
local function dda(c_b,d_b)
if c_b:FindFirstChild("DataSaveFailed")then
_aa:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",c_b,{text="Cannot trade during DataStore outage.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end
if cba[d_b]then local _ab=cba[d_b]aca(_ab.tradeRequester)
aca(_ab.playerToTradeWith)
if not _ab.tradeRequester.Parent or
not _ab.playerToTradeWith.Parent then return false end;local aab={}aab.guid=d_b;aab.state="active"
aab.playerTradeSessionData_player1={}
aab.playerTradeSessionData_player1.player=_ab.tradeRequester;aab.playerTradeSessionData_player1.state="pending"
aab.playerTradeSessionData_player1.gold=0
aab.playerTradeSessionData_player1.inventoryTransferDataCollection={}aab.playerTradeSessionData_player2={}
aab.playerTradeSessionData_player2.player=_ab.playerToTradeWith;aab.playerTradeSessionData_player2.state="pending"
aab.playerTradeSessionData_player2.gold=0
aab.playerTradeSessionData_player2.inventoryTransferDataCollection={}table.insert(bba,aab)_ca(aab)return true end;return false,"invalid or inactive guid"end
local function __b(c_b)local d_b=dba(c_b)if d_b then
d_b.playerTradeSessionData_player1.state="none"d_b.playerTradeSessionData_player2.state="none"
d_b.state="active"end end;local function a_b(c_b)bca[c_b]=nil end
local function b_b()
game.Players.PlayerRemoving:connect(a_b)
_aa:create("{E19F4AF9-ED86-4E1B-B157-66AFF77A1928}","RemoteFunction","OnServerInvoke",ada)
_aa:create("{07FFBB87-C6E5-447F-8E77-F41C936AF801}","RemoteFunction","OnServerInvoke",cca)
_aa:create("{2681E5E8-E682-40E8-9D85-069793E724AF}","RemoteFunction","OnServerInvoke",dda)
_aa:create("{704827CF-86F6-4225-B83C-8986C104F12D}","RemoteFunction","OnServerInvoke",cda)
_aa:create("{B9B41A65-A85E-4D55-92C9-43350C1DC213}","RemoteEvent")
_aa:create("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}","RemoteEvent")
_aa:connect("{09C72219-6A16-49DD-8AD0-F17E13FAEDD9}","Event",__b)end;b_b()return b_a