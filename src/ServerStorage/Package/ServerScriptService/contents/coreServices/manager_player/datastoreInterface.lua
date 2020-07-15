local _d=false;local ad=game:GetService("ReplicatedStorage")
local bd=require(ad.modules)local cd=bd.load("levels")local dd=bd.load("utilities")
local __a=bd.load("network")
local a_a=require(ad:WaitForChild("abilityBookLookup"))local b_a={}local c_a=game:GetService("DataStoreService")
local d_a=false;local _aa=31;local function aaa(dba)
for _ca,aca in pairs(dba:GetCurrentPage())do return aca.value end end
local baa=game:GetService("RunService")
local function caa(dba,_ca)local aca=dba.userId;local bca
local cca,dca=pcall(function()
local dda=(
game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local __b=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(aca),
"GlobalPlayerSaveTimes".._aa..dda)local a_b=__b:GetSortedAsync(false,1)bca=aaa(a_b)end)if not cca then return false,nil,"(GODS): "..dca end;local _da
local function ada(dda)
local __b,a_b=pcall(function()
local b_b=(
game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local c_b=game:GetService("DataStoreService"):GetDataStore(tostring(aca),
"GlobalPlayerData".._aa..b_b)_da=c_b:GetAsync(tostring(dda))end)if not __b then return false,"(GDS): "..a_b end;return true,""end
if _ca then local dda,__b=ada(_ca)if not dda then return false,nil,__b end end
if not _da then local dda,__b=ada(bca)if not dda then return false,nil,__b end end
if(bca and _da==nil)then local dda="globalSave-NoData"
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","LastGlobalSave provided but no GlobalData??")end)
dba:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..dda)error("Game rejected data.")return false,nil,"game rejected data"elseif _ca and
bca==nil then local dda="globalSave-providedNoLast"
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","providedVersion but no LastGlobalSave")end)
dba:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..dda)error("Game rejected data.")return false,nil,"game rejected data"end;local bda=1583707058;local cda=1583710658
if _da and _da.lastSaveTimestamp then
if
_da.lastSaveTimestamp>=bda and _da.lastSaveTimestamp<=cda then
if not _da.rollback1 then
game:GetService("TeleportService"):Teleport(2759159666,dba)return false,nil,"Requires rollback"end end end;return true,_da,"Successfully loaded!"end;function b_a:getPlayerGlobalSaveFileData(dba,_ca)return caa(dba,_ca)end
local function daa(dba,_ca)if
game.PlaceId==3372071669 or game.PlaceId==2061558182 or
game.ReplicatedStorage:FindFirstChild("doNotSaveData")then
return true,nil,_ca.version end;if not
_ca.version then return false,"no global version"end
local aca=(
game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local bca=game:GetService("DataStoreService"):GetDataStore(tostring(dba),
"GlobalPlayerData".._aa..aca)
local cca,dca=pcall(function()bca:SetAsync(tostring(_ca.version),_ca)end)
if not cca then warn("GDS update Failed!")return false,"(GDS): "..dca end
local _da=
(game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local ada=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(dba),
"GlobalPlayerSaveTimes".._aa.._da)
local bda,cda=pcall(function()
ada:SetAsync("s"..tostring(_ca.version),_ca.version)end)
if not bda then warn("GODS update Failed!")return false,"(GODS): "..cda end;return true,nil,_ca.version end
function b_a:updatePlayerGlobalSaveFileData(dba,_ca)return daa(dba,_ca)end
local function _ba(dba,_ca,aca)
if(baa:IsStudio()or baa:IsRunMode())and(not _d)then
if
game.PlaceId==4561988219 then local aab={}aab.newb=true;aab.globalData={}return true,aab end
if game.PlaceId==4041427413 then local aab={}aab.newb=true;aab.globalData={}return true,aab end;local d_b=dba:FindFirstChild("dataSlot")
if d_b==nil then
d_b=Instance.new("IntValue")d_b.Name="dataSlot"d_b.Parent=dba;d_b.Value=0 end
local _ab={gold=10,level=1,inventory={},equipment={},moneyFlag2=true,isTestingDontSave=true,abilityBooks={},abilities={}}_ab.globalData={}_ab.flags=_ab.flags or{}
_ab.flags.enchantWipe3=true;_ab.flags.completedGauntlet=true;_ab.inventory={}
_ab.equipment={{id=5,position=1}}return true,_ab end;local bca;local cca=dba.userId;local dca=_ca;local _da;if aca then _da=aca end
local ada="-slot"..tostring(dca)local bda;local cda,dda,__b=caa(dba,_da)if not __b then return false,nil,__b end;if dda then
bda=dda.lastSave[ada]end
if not bda then
warn("DSI>Obtaining data from legacy method")
local d_b,_ab=pcall(function()
local aab=
(game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local bab=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(cca),
"PlayerSaveTimes".._aa..ada..aab)local cab=bab:GetSortedAsync(false,1)bda=aaa(cab)or 0 end)if not d_b then return false,nil,"(ODS): ".._ab end end;local a_b,b_b
if bda>1 then
a_b,b_b=pcall(function()
local d_b=(
game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local _ab=game:GetService("DataStoreService"):GetDataStore(tostring(cca),
"PlayerData".._aa..ada..d_b)bca=_ab:GetAsync(tostring(bda))
bca.globalData=dda or{}local aab
if bca==nil then
if false then
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","DataStores returned nil data for provided timestamp")end)aab="nil-provided"else
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","DataStores returned nil data for recorded timestamp")end)aab="nil-recorded"end elseif typeof(bca)~="table"then
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","DataStores returned invalid (non-table) data")end)aab="invalid"elseif
bca.level==nil or bca.inventory==nil or
bca.gold==nil or bca.equipment==nil then
spawn(function()
__a:invoke("{79598458-CED2-488B-A719-1E295449F68E}",dba,"critical","DataStores returned data with missing values")end)aab="missing"end
if aab then
dba:Kick("Critical error prevented your data from being loaded. The developers have been alerted. Please try again later. Error code: "..aab)error("Game rejected data.")end
if bca and not bca.timestamp then bca.timestamp=bda end end)else a_b=true;bca={}bca.newb=true;bca.globalData=dda or{}end;if not a_b then return false,nil,"(DS): "..b_b end
local c_b=dba:FindFirstChild("dataSlot")if c_b==nil then c_b=Instance.new("IntValue")c_b.Name="dataSlot"
c_b.Parent=dba end;c_b.Value=dca;return true,bca end
local function aba(dba,_ca,aca,bca)if game.ReplicatedStorage:FindFirstChild("doNotSaveData")then return true,
"don't save data here"end
local cca=_ca;aca.lastSaveTimestamp=os.time()bca.lastSaveTimestamp=os.time()if not
bca.version then return false,"no global version"end;if
not aca.timestamp then return false,"no data timestamp"end
local dca="-slot"..tostring(cca)
local _da=
(game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local ada=game:GetService("DataStoreService"):GetDataStore(tostring(dba),
"GlobalPlayerData".._aa.._da)
local bda,cda=pcall(function()ada:SetAsync(tostring(bca.version),bca)end)
if not bda then warn("GDS update Failed!")return false,"(GDS): "..cda end
local dda=
(game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local __b=game:GetService("DataStoreService"):GetDataStore(tostring(dba),
"PlayerData".._aa..dca..dda)
local a_b,b_b=pcall(function()
__b:SetAsync(tostring(aca.timestamp),aca)end)
if not a_b then warn("DS update Failed!")return false,"(DS): "..b_b end
local c_b=
(game.ReplicatedStorage:FindFirstChild("mirrorWorld")and"mirror")or""
local d_b=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(dba),
"GlobalPlayerSaveTimes".._aa..c_b)
local _ab,aab=pcall(function()
d_b:SetAsync("s"..tostring(bca.version),bca.version)end)
if not _ab then warn("GODS update Failed!")return false,"(GODS): "..aab end;return true,nil,bca.version end
if _d then
delay(10,function()
local dba={userId=133827873,UserId=133827873,FindFirstChild=function()return{}end}local _ca,aca=_ba(dba,1)aca.level=30
local bca,cca,dca=aba(dba.UserId,1,aca,aca.globalData)
print(string.format("data modification for UserId %d was %s because %s. Current version: %d.",dba.UserId,bca and"successful"or
"unsuccessful",bca and"nothing went wrong"or cca,dca))end)end;local bba=Random.new()
local function cba(dba,_ca,aca)aca.timestamp=aca.timestamp or 0;aca.globalData.version=
aca.globalData.version or 0;aca.globalData.itemStorage=
aca.globalData.itemStorage or{}aca.globalData.emotes=
aca.globalData.emotes or{}
aca.monsterBook=aca.monsterBook or{}aca.bountyBook=aca.bountyBook or{}aca.inventory=aca.inventory or
{{id=5,position=1}}
aca.equipment=aca.equipment or{}aca.hotbar=aca.hotbar or{}
aca.abilities=aca.abilities or{}aca.abilityBooks=aca.abilityBooks or{}aca.abilityBooks.adventurer=
aca.abilityBooks.adventurer or{}aca.abilityBooks.adventurer.pointsAssigned=
aca.abilityBooks.adventurer.pointsAssigned or 0;aca.accessories=
aca.accessories or{}
aca.professions=aca.professions or{}aca.statistics=aca.statistics or{}aca.statistics.str=
aca.statistics.str or 0
aca.statistics.int=aca.statistics.int or 0;aca.statistics.dex=aca.statistics.dex or 0;aca.statistics.vit=
aca.statistics.vit or 0;aca.statistics.modifierData=
aca.statistics.modifierData or{}aca.statistics.pointsAssigned=
aca.statistics.pointsAssigned or 0;aca.statistics.pointsUnassigned=
aca.statistics.pointsUnassigned or 0
aca.statusEffects=aca.statusEffects or{}aca.flags=aca.flags or{dataRecovery11_14=true}aca.gold=
aca.gold or 10;aca.exp=aca.exp or 0
aca.level=aca.level or 1;aca.internalData=aca.internalData or{}aca.internalData.suspicion=
aca.internalData.suspicion or 0
if not aca.abilitiesReset2 then
aca.abilities={}aca.hotbar={}aca.abilitiesReset2=true end
if not aca.flags.stealthRevoke then
for bca,cca in pairs(aca.abilities)do
if cca.id==15 and not
aca.abilityBooks.Admin then
table.remove(aca.abilities,bca)if aca.abilityBooks.Hunter then
aca.abilityBooks.Hunter.pointsAssigned=
aca.abilityBooks.Hunter.pointsAssigned- (cca.rank or 0)end elseif
aca.abilityBooks.Admin then end end;aca.flags.stealthRevoke=true end
if not aca.flags.fixcolors2 then
if aca.accessories then if aca.accessories.skinColor then
aca.accessories.skinColorId=aca.accessories.skinColor end;if aca.accessories.faceColor then
aca.accessories.faceColorId=aca.accessories.faceColor end;if aca.accessories.hairColor then
aca.accessories.hairColorId=aca.accessories.hairColor end end;aca.flags.fixcolors2=true end
if not aca.flags.fixcolors3 then
if aca.accessories then if aca.accessories.shirtColor then
aca.accessories.shirtColorId=aca.accessories.shirtColor end end;aca.flags.fixcolors3=true end
aca.accessories.shirtColorId=aca.accessories.shirtColorId or 1;if d_a then aca.gold=10000;aca.level=10 end
aca.keyPreferences=aca.keyPreferences or nil;aca.health=aca.health or nil
aca.savePosition=aca.savePosition or nil;aca.class=aca.class or"Adventurer"
aca.subclass=aca.subclass or nil;aca.treasureChests=aca.treasureChests or{}
aca.quests=aca.quests or{}aca.quests.completed=aca.quests.completed or{}aca.quests.active=
aca.quests.active or{}
aca.userSettings=aca.userSettings or{}aca.sessionCount=aca.sessionCount or 1;aca.nonSerializeData={}
aca.nonSerializeData.saveFileNumber=_ca;aca.nonSerializeData.playerPointer=dba
aca.nonSerializeData.isGlobalPVPEnabled=false;aca.nonSerializeData.whitelistPVPEnabled={}
aca.nonSerializeData.temporaryEquipment={}aca.nonSerializeData.perksActivated={}end
function b_a:getLatestSaveVersion(dba)local _ca=dba.UserId
local aca=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(_ca),
"GlobalPlayerSaveTimes".._aa)local bca=aca:GetSortedAsync(false,1)if not bca then return 0 end
bca=bca:GetCurrentPage()if not bca[1]then return 0 end;return bca[1].value end
function b_a:getPlayerSaveFileDataOlderThan(dba,_ca,aca)aca=tonumber(aca)
print(string.format("Attempting to find save data with timestamp older than %d.",aca))local bca=dba.UserId
local cca=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(bca),
"GlobalPlayerSaveTimes".._aa)local dca=cca:GetSortedAsync(false,1)
if not dca then
print("Failed to acquire pages for save times. Reverting to default behavior.")return self:getPlayerSaveFileData(dba,_ca)end;dca=dca:GetCurrentPage()
if not dca[1]then
print("Player does not have any lastSaveId possibilities. Reverting to default behavior.")return self:getPlayerSaveFileData(dba,_ca)end;local _da=dca[1].value;_da=tonumber(_da)local ada;local bda="-slot".._ca
local cda=game:GetService("DataStoreService"):GetDataStore(tostring(bca),
"GlobalPlayerData".._aa)local dda=_da
while dda>0 do local __b=cda:GetAsync(tostring(dda))
local a_b=tonumber(__b.lastSaveTimestamp)
print(string.format("Testing id %d: timestamp %d < %d?",dda,a_b,aca))
if a_b<=aca then print("Found id with older timestamp.")
ada=__b.lastSave[bda]
if not ada then
print("This id does not have a file for this slot. Reverting to default behavior.")return self:getPlayerSaveFileData(dba,_ca)else
print("Found save file for this id and this slot. Returning it.")local b_b,c_b,d_b=self:getPlayerSaveFileData(dba,_ca,ada)if b_b then
c_b.globalData.version=_da end;return b_b,c_b,d_b end end;dda=dda-1 end
print("Exhausted all lastSaveId possibilities. Reverting to default behavior.")return self:getPlayerSaveFileData(dba,_ca)end
function b_a:getPlayerSaveFileData(dba,_ca,aca)local bca,cca,dca=_ba(dba,_ca,aca)if not bca then
warn("datastore-failure: ",dba,dca)return bca,cca,dca end;cba(dba,_ca,cca)
return bca,cca end
function b_a:updatePlayerSaveFileData(dba,_ca)
if game.PlaceId==2061558182 or
game.ReplicatedStorage:FindFirstChild("doNotSaveData")then return true,nil,0 end;_ca.newb=false;local aca=_ca.nonSerializeData.saveFileNumber;local bca="-slot"..
tostring(aca)_ca.timestamp=_ca.timestamp+1;_ca.globalData.version=
_ca.globalData.version+1;_ca.globalData.lastSave=
_ca.globalData.lastSave or{}
_ca.globalData.lastSave[bca]=_ca.timestamp
_ca.globalData.saveSlotData=_ca.globalData.saveSlotData or{}
local cca=game.ReplicatedStorage:FindFirstChild("lastLocationOverride")and
game.ReplicatedStorage.lastLocationOverride.Value or game.PlaceId;if _ca.lastLocationDeathOverride then cca=_ca.lastLocationDeathOverride
_ca.lastLocationDeathOverride=nil end
_ca.globalData.saveSlotData[bca]={level=_ca.level,class=_ca.class,lastLocation=cca,equipment=_ca.equipment,accessories=_ca.accessories,customized=true}_ca=dd.copyTable(_ca)local dca=_ca.nonSerializeData
_ca.nonSerializeData=nil;local _da=_ca.globalData;_ca.globalData=nil
if
game:GetService("ReplicatedStorage"):FindFirstChild("lastLocationOverride")then _ca.lastPhysicalPosition=nil end;_ca.lastLocation=cca;return aba(dba,aca,_ca,_da)end
function b_a:wipePlayerSaveFileData(dba,_ca)local aca={}
cba(dba,_ca.nonSerializeData.saveFileNumber,aca)return b_a:updatePlayerSaveFileData(dba.userId,aca)end;return b_a