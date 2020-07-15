local aaa={}local baa=game:GetService("HttpService")
local caa=game:GetService("ReplicatedStorage")local daa=require(caa.modules)local _ba=daa.load("network")
local aba=daa.load("placeSetup")local bba=daa.load("physics")local cba=daa.load("utilities")
local dba=daa.load("ability_utilities")local _ca=daa.load("events")
local aca=require(caa.abilityLookup)local bca={id=0}local cca=baa:JSONEncode(bca)local dca={}
local function _da(abb,bbb)
local cbb=_ba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",abb)if cbb and cbb.abilities then
for dbb,_cb in pairs(cbb.abilities)do if
_cb.id==bbb and _cb.rank>0 then return true end end end;return false end;local ada={}local function bda(abb,bbb,cbb)return
ada[abb]and ada[abb][bbb]and ada[abb][bbb][cbb]end
local cda=0.25
local function dda(abb,bbb,cbb,dbb,_cb)
if abb.Character and abb.Character.PrimaryPart and
cba.isEntityManifestValid(abb.Character.PrimaryPart)then
local acb=_ba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",abb)local bcb=aca[bbb](acb,dbb)
if bcb and _da(abb,bbb)then
local ccb,dcb=cba.safeJSONDecode(abb.Character.PrimaryPart.activeAbilityExecutionData.Value)
if ccb then
if cbb=="begin"and(dcb.id==0)then dbb["ability-state"]=cbb
dbb["ability-guid"]=_cb
local _db=dba.getAbilityStatisticsForRank(bcb,_ba:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",abb,bbb))local adb=_db.manaCost or 20
local bdb=(_db.cooldown or 5)* (1 -
acb.nonSerializeData.statistics_final.abilityCDR)dbb["ability-statistics"]=_db;if bcb.executionData then for ddb,__c in pairs(bcb.executionData)do
dbb[ddb]=__c end end
local cdb={manaCost=adb,cooldown=bdb,abilityStatistics=_db,abilityExecutionData=dbb,abilityBaseData=bcb}_ca:fireEventLocal("playerWillUseAbility",abb,cdb)
adb=cdb.manaCost;bdb=cdb.cooldown;if
abb.Character.PrimaryPart.mana.Value<adb then return false end
if
dca[abb]and(not dca[abb][bbb]or
tick()-dca[abb][bbb]>=bdb-cda)then
dbb["_dex"]=acb.nonSerializeData.statistics_final.dex or 0
dbb["_int"]=acb.nonSerializeData.statistics_final.int or 0
dbb["_vit"]=acb.nonSerializeData.statistics_final.vit or 0
dbb["_str"]=acb.nonSerializeData.statistics_final.str or 0;if bcb._abilityExecutionDataCallback then
bcb._abilityExecutionDataCallback(acb,dbb)end;dbb.IS_ENHANCED=bcb._doEnhanceAbility and
bcb._doEnhanceAbility(acb)
local ddb,__c=cba.safeJSONEncode(dbb)if not ddb then
warn("ability:: failed to encode curr executiondata")return end;if ada[abb][bbb]and
ada[abb][bbb][_cb]then
warn("attempt to begin already valid guid")return false end
dca[abb][bbb]=tick()if not ada[abb][bbb]then ada[abb][bbb]={}end
ada[abb][bbb][_cb]={executionData=dbb,previousEntityHits={},timestamp=tick(),lastUpdated=tick(),player=abb,timesUpdated=0}abb.Character.PrimaryPart.mana.Value=
abb.Character.PrimaryPart.mana.Value-adb
abb.Character.PrimaryPart.activeAbilityExecutionData.Value=__c;if bcb.startAbility_server then
spawn(function()bcb:startAbility_server(abb,abb,dbb)end)end
spawn(function()
wait(bcb.GUID_Invalidation_Time or 10)
if ada[abb]and ada[abb][bbb]then ada[abb][bbb][_cb]=nil end end)
_ca:fireEventLocal("playerUsedAbility",abb,bbb,dbb,_cb)else warn("ability:: invalid cd waittime")end elseif
cbb=="update"and bbb==dcb.id and ada[abb]and
ada[abb][bbb]and ada[abb][bbb][_cb]then dbb["ability-state"]=cbb;dbb["ability-guid"]=_cb
if

ada[abb][bbb][_cb].timesUpdated+1 <= (bcb.maxUpdateTimes or math.huge)then ada[abb][bbb][_cb].timesUpdated=
ada[abb][bbb][_cb].timesUpdated+1
ada[abb][bbb][_cb].lastUpdated=tick()
dbb["times-updated"]=ada[abb][bbb][_cb].timesUpdated
dbb["last-updated"]=ada[abb][bbb][_cb].lastUpdated;local _db,adb=cba.safeJSONEncode(dbb)if not _db then return end
abb.Character.PrimaryPart.activeAbilityExecutionData.Value=adb end elseif cbb=="end"and bbb==dcb.id then
abb.Character.PrimaryPart.activeAbilityExecutionData.Value=cca else
warn("ability:: invalid state data",cbb,bbb,dcb.id)end else
warn("ability:: failed to decode current abilityexecutiondata")end else
warn("ability:: invalid ability, cannot activate?",not not bcb)end else warn("ability:: invalid character")end end
local function __b(abb,bbb)local cbb=dca[abb]if not cbb then return end;cbb[bbb]=nil
_ba:fireClient("{B62079C1-52DB-4F8A-8629-2288C1E97E3D}",abb,bbb)end
local function a_b(abb,bbb,cbb,dbb)
if cbb=="ability"and dca[abb]then
local _cb=_ba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",abb)local acb=aca[dbb](_cb)if not acb then return end;if acb.onPlayerKilledMonster_server then
acb.onPlayerKilledMonster_server(abb,bbb)end
if acb.resetCooldownOnKill then __b(abb,dbb)end end end;local function b_b(abb)dca[abb]={}ada[abb]={}end;local function c_b(abb)dca[abb]=nil
ada[abb]=nil end
local function d_b(abb)local bbb={}if ada[abb]then
for cbb,dbb in pairs(ada[abb])do for _cb,acb in pairs(dbb)do if acb then
table.insert(bbb,cbb)break end end end end;return bbb end
local function _ab(abb,bbb,cbb,...)local dbb=bbb["cast-player-userId"]
local _cb=bbb["cast-player-userId"]and
game.Players:GetPlayerByUserId(bbb["cast-player-userId"])
if _cb then
if _cb.Character and _cb.Character.PrimaryPart then
local acb,bcb=cba.safeJSONDecode(_cb.Character.PrimaryPart.activeAbilityExecutionData.Value)
if acb then
local ccb=_ba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",abb)local dcb=aca[cbb](ccb,bcb)
if
bcb.id==cbb and dcb and dcb.execute_server then return dcb:execute_server(_cb,bcb,_cb==abb,...)end end end end end;local function aab()end
local function bab(abb,bbb,cbb,dbb,_cb)
if
ada[abb]and ada[abb][bbb]and ada[abb][bbb][cbb]then local acb;do
for bcb,ccb in pairs(ada[abb][bbb][cbb].previousEntityHits)do if
ccb.entityManifest==dbb then acb=ccb end end end
if acb then
table.insert(acb.hitData,{hitPosition=dbb.Position,sourceTag=_cb})else
table.insert(ada[abb][bbb][cbb].previousEntityHits,{entityManifest=dbb,hitData={{hitPosition=dbb.Position,sourceTag=_cb}}})end end end;local function cab(abb,bbb,cbb)
if
ada[abb]and ada[abb][bbb]and ada[abb][bbb][cbb]then ada[abb][bbb][cbb]=nil end end
local function dab(abb,bbb,cbb,dbb,_cb)
local acb=_ba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",abb)local bcb=aca[bbb](acb)
if bcb and _da(abb,bbb)then
local ccb=dba.getAbilityStatisticsForRank(bcb,_ba:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",abb,bbb))
if bcb._serverProcessAbilityHit then
bcb._serverProcessAbilityHit(abb,ccb,cbb,dbb,_cb)else
_ba:fire("{9AF17239-FE35-48D5-B980-F2FA7DF2DBBC}",abb,dbb,nil,"ability",bbb,_cb,cbb)end end end
local function _bb()
for abb,bbb in pairs(game.Players:GetPlayers())do b_b(bbb)end;game.Players.PlayerAdded:connect(b_b)
game.Players.PlayerRemoving:connect(c_b)
_ba:create("{FA49DA7F-FF25-45CB-9BD1-DEBA1A3DEF4D}","RemoteEvent","OnServerEvent",dab)
_ba:create("{51A91F3B-9019-471D-A6C9-79833B23B075}","RemoteEvent","OnServerEvent",function(abb,bbb,cbb,dbb,_cb)
if typeof(cbb)=="boolean"then dda(abb,bbb,cbb and
"begin"or"end",dbb,_cb)elseif
typeof(cbb)=="string"then dda(abb,bbb,cbb,dbb,_cb)end end)
_ba:create("{701E50EC-EF85-469A-BB2F-D17735863DCE}","BindableFunction","OnInvoke",bda)
_ba:create("{1116BB97-A7FB-4554-BDEC-B014207542AD}","BindableFunction","OnInvoke",dba.getAbilityStatisticsForRank)
_ba:create("{76068A31-E777-4EF3-B551-476E626A098C}","BindableFunction","OnInvoke",d_b)
_ba:create("{B62079C1-52DB-4F8A-8629-2288C1E97E3D}","RemoteEvent")
_ba:create("{5517DD42-A175-4E6C-8DD5-842CB17CE9F3}","BindableFunction","OnInvoke",__b)
_ba:create("{CDAE72AC-EFED-4B26-9F40-98C8E2978E1A}","BindableEvent","Event",bab)
_ba:create("{3FCD7BDD-A7A6-432F-8173-8E1AD2FFCD7D}","BindableFunction","OnInvoke",cab)
_ba:connect("{AB123BAD-136A-4C15-8F68-EC88EF38D4A9}","Event",a_b)
_ba:create("{0650EB64-0176-4935-9226-F83AA6EF8464}","RemoteFunction","OnServerInvoke",_ab)
_ba:create("{5C3090D0-3924-43A8-AA44-52290EB13ACA}","RemoteFunction","OnServerInvoke",aab)
_ba:create("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}","RemoteFunction","OnServerInvoke",_ab)
_ba:create("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}","RemoteEvent","OnServerEvent",_ab)
_ba:create("{BE1205CC-1952-4C32-BE72-9A9C3C53E41C}","RemoteFunction")
_ba:create("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}","RemoteEvent")
_ba:create("{2581F2A9-703B-4F16-92AF-36663C1F5160}","RemoteEvent","OnServerEvent",function(abb,...)
_ba:fireAllClientsExcludingPlayer("{2581F2A9-703B-4F16-92AF-36663C1F5160}",abb,...)end)
_ba:create("{B9B957FF-963D-41E0-A64D-CF4DD5D07AC6}","RemoteEvent","OnServerEvent",function(abb,...)
_ba:fireAllClientsExcludingPlayer("{B9B957FF-963D-41E0-A64D-CF4DD5D07AC6}",abb,...)end)end;spawn(_bb)return aaa