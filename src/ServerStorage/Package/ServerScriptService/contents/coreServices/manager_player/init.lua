local bbba={}local cbba={}local dbba={}
local _cba=require(script.datastoreInterface)local acba=false;local bcba=game:GetService("RunService")
local ccba=game:GetService("TeleportService")local dcba=game:GetService("CollectionService")
local _dba=game:GetService("HttpService")local adba=game:GetService("ReplicatedStorage")
local bdba=require(adba.modules)local cdba=bdba.load("network")
local ddba=bdba.load("utilities")local __ca=bdba.load("physics")local a_ca=bdba.load("levels")
local b_ca=bdba.load("mapping")local c_ca=bdba.load("configuration")
local d_ca=bdba.load("ability_utilities")local _aca=bdba.load("placeSetup")
local aaca=bdba.load("enchantment")local baca=bdba.load("events")local caca=bdba.load("detection")
local daca=_aca.getPlaceFolder("playerManifestCollection")local _bca=_aca.getPlaceFolder("playerRenderCollection")
local abca=_aca.getPlaceFolder("monsterManifestCollection")
local bbca=_aca.getPlaceFolder("entityManifestCollection")local cbca=_aca.getPlaceFolder("entityRenderCollection")
local dbca=_aca.getPlaceFolder("pvpZoneCollection")local _cca=_aca.getPlaceFolder("temporaryEquipment")
local acca=require(adba.itemData)local bcca=require(adba.itemAttributes)
local ccca=require(adba.perkLookup)local dcca=require(adba.monsterLookup)
local _dca=require(adba.questLookup)local adca=require(adba.abilityBookLookup)
local bdca=require(adba.abilityLookup)local cdca=require(adba.blessingLookup)
local ddca=require(adba.statusEffectLookup)local __da=require(adba.professionLookup)
local a_da=bdba.load("projectile")local b_da=3;local c_da=49;if
game.gameId==712031239 or game.PlaceId==2103419922 then c_da=999999999 end
local d_da={id=true,stacks=true,modifierData=true,position=true,successfulUpgrades=true,upgrades=true}local function _ada(cddb)return cbba[cddb]end
local function aada(cddb,...)return _ada(...)end
cdba:create("{7BDAB86F-3DCD-4852-A080-DEE6722D7D05}","BindableFunction","OnInvoke",function(cddb)
local dddb,___c,a__c=_cba:getPlayerGlobalSaveFileData(cddb)
if not dddb then
local b__c,c__c=pcall(function()
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error","getPlayerGlobalData failed: "..a__c)
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"data:fail:save")end)if not b__c then
warn("Failed to report data error: "..c__c)end end;return dddb,___c,a__c end)
cdba:create("{D7CF503F-34C4-4C60-A03E-D16D199CC344}","BindableFunction","OnInvoke",function(cddb,dddb)local ___c=cddb.userId
local a__c,b__c,c__c=_cba:updatePlayerGlobalSaveFileData(___c,dddb)
if not a__c then
local d__c,_a_c=pcall(function()
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error","setPlayerGlobalData failed: "..b__c)
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"data:fail:save")end)if not d__c then
warn("Failed to report data error: ".._a_c)end end;return a__c,b__c,c__c end)
local function bada(cddb)
if cddb.Character then cddb.Character:Destroy()end;cddb:LoadCharacter()local dddb=tick()repeat wait(0.1)until
cddb.Character and
cddb.Character.PrimaryPart or(tick()-dddb>=10)
if
cddb.Character and cddb.Character.PrimaryPart then
cddb.Character.PrimaryPart.mana.Value=math.ceil(
cddb.Character.PrimaryPart.maxMana.Value*0.5)
cddb.Character.PrimaryPart.health.Value=math.ceil(
cddb.Character.PrimaryPart.maxHealth.Value*0.5)end end
local function cada(cddb,dddb)dddb=dddb:lower()if dddb=="adventurer"then return true end
local ___c=cbba[cddb]if not ___c then return false end;if ___c.class:lower()==dddb then
return true end
return ___c.abilityBooks[dddb]~=nil end
cdba:create("{CDA68697-FC61-45D0-A42E-362554813D0B}","RemoteFunction","OnServerInvoke",cada)
cdba:create("{07B904D8-B25D-4390-B4E3-CF54AF8F7D86}","BindableFunction","OnInvoke",cada)
local function dada(cddb)
if cada(cddb,"warrior")then return 2470481225 elseif cada(cddb,"mage")then return 3112029149 elseif
cada(cddb,"hunter")then return 2546689567 else return 2064647391 end end
local function _bda(cddb)local dddb=cbba[cddb]if not dddb then return end;local ___c="acceptedDeathConsequences"
local a__c=cddb:FindFirstChild(___c)if a__c then return end;local b__c="game:death"
dddb.nonSerializeData.incrementPlayerData("gold",- (
dddb.gold*0.1),b__c)local c__c=a_ca.getEXPToNextLevel(dddb.level)local d__c=math.clamp(dddb.exp-c__c*
0.2,0,c__c)
dddb.nonSerializeData.setPlayerData("exp",d__c)
local _a_c=game.ReplicatedStorage:FindFirstChild("nearestCityId")and
game.ReplicatedStorage.nearestCityId.Value
local aa_c=_a_c or dddb.homePlaceId or dada(cddb)aa_c=ddba.placeIdForGame(aa_c)
dddb.lastLocationDeathOverride=aa_c;a__c=Instance.new("BoolValue")a__c.Name=___c
a__c.Value=true;a__c.Parent=cddb;local ba_c=cddb.Character
if ba_c then local ca_c=ba_c.PrimaryPart
if ca_c then
local da_c=ca_c:FindFirstChild("health")local _b_c=ca_c:FindFirstChild("mana")if da_c and _b_c then da_c.Value=1
_b_c.Value=1 end end end
if game.PlaceId==2103419922 then cddb:Kick("You are dead.")return end
cdba:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",cddb,dddb.lastLocationDeathOverride,"default",nil,"death")end
cdba:create("{07334FE6-6852-4306-B683-A0F5E3B3CB7C}","RemoteEvent","OnServerEvent",_bda)
local function abda(cddb)
if cddb.Character then cddb.Character:Destroy()end
if
cddb:FindFirstChild("awaitingDeathGuiResponse")==nil then local ___c=Instance.new("BoolValue")
___c.Name="awaitingDeathGuiResponse"___c.Value=true;___c.Parent=cddb end
cdba:fireClient("{5C7009DB-4822-41F0-BA22-AC7C5CB51128}",cddb)local dddb=70
while dddb>0 do dddb=dddb-wait(1)if cddb.Character then return end end;_bda(cddb)end
cdba:create("{5C7009DB-4822-41F0-BA22-AC7C5CB51128}","RemoteEvent")
local function bbda(cddb,dddb)if adba:FindFirstChild("isGlobalSafeZone")then if not dddb then bada(cddb)end;return
true end;if not dddb then abda(cddb)
return true end;local ___c=cbba[cddb]
if ___c then
if
adba:FindFirstChild("isGlobalUnsafeZone")or
(___c.nonSerializeData.isInPVPZone and ___c.nonSerializeData.isPVPZoneUnsafe)then
if
cddb.Character and
cddb.Character.PrimaryPart and
cddb.Character.PrimaryPart:FindFirstChild("health")and
cddb.Character.PrimaryPart.health:FindFirstChild("killingBlow")then
if
cddb.Character.PrimaryPart.health.killingBlow.Value=="damage"then
error("Data wiping has been disabled")_cba:wipePlayerSaveFileData(cddb,___c)return end end else bada(cddb)return end end end;local function cbda(cddb)end
local function dbda(cddb)local dddb=cddb.userId
if
not cddb:FindFirstChild("teleporting")then
if
cddb:FindFirstChild("awaitingDeathGuiResponse")or
cddb:FindFirstChild("acceptedDeathConsequences")or(
cddb:FindFirstChild("isPlayerSpawning")and cddb.isPlayerSpawning.Value)then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." rage quit.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})else
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." disconnected.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end;local ___c=Instance.new("BoolValue")___c.Name="disconnected"
___c.Parent=cddb end;dbba[cddb]=nil
if cbba[cddb]then
for c__c,d__c in pairs(cbba[cddb].equipment)do
local _a_c=acca[d__c.id]
if _a_c.perks then
for aa_c,ba_c in pairs(_a_c.perks)do local ca_c=ccca[aa_c]
if ca_c and ca_c.onUnequipped then
local da_c,_b_c=pcall(function()
ca_c.onUnequipped(cddb,_a_c,tostring(d__c.position))end)if not da_c then
warn(string.format("item %s unequip failed because: %s",_a_c.name,_b_c))end end end end end
local ___c=cddb:FindFirstChild("awaitingDeathGuiResponse")if ___c~=nil then ___c:Destroy()_bda(cddb)end
if
cddb:FindFirstChild("entityGUID")then
local c__c=cdba:invoke("{D9E9266C-A8D0-478F-A0CF-A39D56B75ED8}",cddb)if c__c then cbba[cddb].packagedStatusEffects=c__c end end;local a__c=cddb.Character
if a__c then local c__c=a__c.PrimaryPart
if c__c then
local d__c=c__c:FindFirstChild("health")local _a_c=c__c:FindFirstChild("mana")if d__c and _a_c then
cbba[cddb]["condition"]={health=d__c.Value,mana=_a_c.Value}end end end;local b__c=cbba[cddb]cbba[cddb]=nil
for i=1,5 do
local c__c,d__c,_a_c=_cba:updatePlayerSaveFileData(dddb,b__c)
if not c__c then warn(cddb.Name,"'s data failed to save.",d__c)
local aa_c,ba_c=pcall(function()
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error",
"Failed to save player data (on exit!): "..d__c)
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"data:fail:save")end)if not aa_c then
warn("Failed to report data error: "..ba_c)end
local ca_c,da_c=pcall(function()
game:GetService("MessagingService"):PublishAsync("datawarning",{userId=dddb})end)if not ca_c then
warn("Failed to send warning: "..da_c)end else if cddb:FindFirstChild("DataSaveFailed")then
cddb.DataSaveFailed:Destroy()end;return _a_c end end end
if cddb.Character then cddb.Character.Parent=nil;cddb.Character=nil end end
local function _cda(cddb,dddb)
if dddb and dddb.unbanTime>os.time()then if
cddb:FindFirstChild("DataLoaded")then dbda()end
local ___c=dddb.unbanTime-os.time()
if dddb.reason then
cddb:Kick("You have been banned for: "..dddb.reason.." (unbanned in "..
ddba.timeToString(___c)..")")else
cddb:Kick("You have been banned (unbanned in "..ddba.timeToString(___c)..")")end end end
local acda=game:GetService("DataStoreService"):GetDataStore("banRecord")
game.Players.PlayerAdded:connect(function(cddb)
local dddb=acda:GetAsync(cddb.userId)if dddb then _cda(cddb,dddb)end end)
local function bcda(cddb,dddb,___c,a__c)a__c=a__c or"system"local b__c=cbba[cddb]local c__c
for i=1,3 do
local d__c,_a_c=pcall(function()
acda:UpdateAsync(cddb.userId,function(aa_c)aa_c=aa_c or
{}c__c=aa_c;c__c.reason=___c;c__c.source=a__c;c__c.previousRecords=
c__c.previousRecords or{}
table.insert(c__c.previousRecords,{reason=___c,source=a__c,duration=dddb,timestamp=os.time()})if b__c then c__c.offendingData=b__c end
c__c.unbanTime=c__c.unbanTime or 0
if c__c.unbanTime>=os.time()then
c__c.unbanTime=c__c.unbanTime+dddb else c__c.unbanTime=os.time()+dddb end;return c__c end)end)if d__c then break end end;_cda(cddb,c__c)end
cdba:create("{7F950F67-EB33-446A-83AE-F154B23F1CFE}","BindableFunction","OnInvoke",bcda)
local function ccda(cddb,dddb)local ___c=cbba[cddb]
___c.internalData.suspicion=___c.internalData.suspicion+dddb
if ___c.internalData.suspicion>100 then local a__c
for i=1,3 do
local b__c,c__c=pcall(function()
acda:UpdateAsync(cddb.userId,function(d__c)
d__c=d__c or{}a__c=d__c;local _a_c="cheating suspicion"local aa_c="system"local ba_c=36000;a__c.cheatingBans=(
a__c.cheatingBans or 0)+1;local ca_c=a__c.cheatingBans;if
ca_c>=5 then ba_c=14 *86400 elseif ca_c==4 then ba_c=7 *86400 elseif ca_c==3 then ba_c=3 *86400 elseif ca_c==2 then
ba_c=86400 end;a__c.previousRecords=
a__c.previousRecords or{}
table.insert(a__c.previousRecords,{reason=_a_c,source=aa_c,duration=ba_c,timestamp=os.time()})a__c.reason=_a_c;a__c.source=aa_c
if ___c then a__c.offendingData=___c end;a__c.unbanTime=a__c.unbanTime or 0;if
a__c.unbanTime>=os.time()then a__c.unbanTime=a__c.unbanTime+ba_c else
a__c.unbanTime=os.time()+ba_c end;return a__c end)end)if b__c then ___c.internalData.suspicion=0;break end end end end
cdba:create("{716B5956-53DD-466A-9978-FF034627B069}","BindableFunction","OnInvoke",ccda)
local function dcda()local cddb=1 /3;local dddb=dcba:GetTagged("door")
local ___c=dcba:GetTagged("cannon")local a__c=dcba:GetTagged("escapeRope")local b__c=50
local function c__c(da_c,_b_c,ab_c)
for bb_c,cb_c in pairs(_b_c)do
local db_c=

cb_c:IsA("Model")and(cb_c.PrimaryPart and cb_c.PrimaryPart.Position)or cb_c.Position
if db_c and(da_c-db_c).magnitude<=b__c then return true,cb_c end end;return false,nil end
local function d__c(da_c)for _b_c,ab_c in pairs(dddb)do
if ab_c.Parent.Name==da_c.Parent.Name and
ab_c.Parent~=da_c.Parent then return ab_c end end end
local function _a_c(da_c)
local _b_c=c_ca.getConfigurationValue("server_TPExploitTimeWindow")
local ab_c=c_ca.getConfigurationValue("server_TPExploitScoreToFail")local bb_c=0
if dbba[da_c]then for cb_c,db_c in pairs(dbba[da_c].sketchyMovements)do
if
tick()-db_c.timestamp<=_b_c then bb_c=bb_c+db_c.movementRatio end end end;return bb_c>=ab_c end
cdba:create("{1BE8BEBB-FB1D-4894-9F35-98F0BDADD81D}","BindableEvent","Event",function(da_c,_b_c,ab_c)
if dbba[da_c]then
if dbba[da_c].positions and#
dbba[da_c].positions>0 then
local bb_c=dbba[da_c].positions[#
dbba[da_c].positions].position;local cb_c=cbba[da_c]
local db_c=(ab_c.Position-bb_c).magnitude
if
db_c>
cb_c.nonSerializeData.statistics_final.walkspeed*4 *cddb+5 then warn("earlyTrigger exploiter!",da_c)
local _c_c=c_ca.getConfigurationValue("tpExploitPunishment")
if _c_c=="suspicion"then
local ac_c=c_ca.getConfigurationValue("tpExploitPunishmentSuspicionAddAmount")ccda(da_c,ac_c or 25)elseif _c_c=="kick"then
da_c:Kick("TP Exploiting")elseif _c_c=="redirect"then da_c:Kick("Anti-exploit")end end end end end)
local function aa_c(da_c,_b_c,ab_c)local bb_c=Instance.new("Part",workspace)
bb_c.Size=Vector3.new(1,1,1)bb_c.CanCollide=false;bb_c.Anchored=true;bb_c.BrickColor=da_c
bb_c.CFrame=CFrame.new(_b_c)bb_c.Name=ab_c end
local function ba_c(da_c,_b_c)local ab_c,bb_c=da_c.Origin-_b_c,da_c.Direction
local cb_c=ab_c- ( (ab_c:Dot(bb_c))/
(bb_c:Dot(bb_c)))*bb_c;return _b_c+cb_c end
cdba:create("{40B15535-4971-4C14-A24E-E7F003E3FC9B}","RemoteEvent","OnServerEvent",function(da_c,_b_c)
if
_b_c and dcba:HasTag(_b_c,"escapeRope")then
local ab_c,bb_c=c__c(da_c.Character.PrimaryPart.Position,a__c)
if ab_c and bb_c==_b_c then if
bb_c.Parent and bb_c.Parent:FindFirstChild("Target")then
cdba:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",da_c,bb_c.Parent.Target.CFrame)end end end end)
local function ca_c(da_c)
local _b_c=cdba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",da_c)
if _b_c then
if _a_c(da_c)then
if
c_ca.getConfigurationValue("doLogTPExploitersInPlayerDataFlags")then _b_c.flags.isPlayerTPExploiter=true end;warn("player exploiting!",da_c)
local ab_c=c_ca.getConfigurationValue("tpExploitPunishment")
if ab_c=="suspicion"then
local bb_c=c_ca.getConfigurationValue("tpExploitPunishmentSuspicionAddAmount")ccda(da_c,bb_c or 25)elseif ab_c=="kick"then
da_c:Kick("TP Exploiting")elseif ab_c=="redirect"then da_c:Kick("Anti-exploit")end end end end
cdba:create("{2946EC53-992A-45AE-A777-8F7438CE89A5}","BindableFunction","OnInvoke",function(da_c,_b_c)local ab_c=dbba[da_c]if ab_c then
table.insert(ab_c.sketchyMovements,{movementRatio=_b_c,timestamp=tick()})ca_c(da_c)end end)
while true do local da_c=wait(cddb)
for _b_c,ab_c in pairs(dbba)do
if
_b_c:FindFirstChild("isPlayerSpawning")and not
_b_c.isPlayerSpawning.Value and
_b_c:FindFirstChild("playerSpawnTime")and(os.time()-
_b_c.playerSpawnTime.Value>=5)then
if

_b_c.Character and _b_c.Character.PrimaryPart and
_b_c.Character.PrimaryPart:FindFirstChild("state")and
_b_c.Character.PrimaryPart.state.Value~="dead"and c_ca.getConfigurationValue("isTeleportingExploitFixEnabled",_b_c)then local bb_c=cbba[_b_c]
if#ab_c.positions>0 then
local cb_c=_b_c.Character.PrimaryPart.Position;local db_c=_b_c.Character.PrimaryPart.Velocity;local _c_c=ab_c.positions[#
ab_c.positions].position
local ac_c=ab_c.positions[
#ab_c.positions].velocity
local bc_c=db_c.magnitude>ac_c.magnitude and db_c or ac_c
if bc_c.magnitude<0.1 then
if(cb_c-_c_c).magnitude>=0.1 then
if(cb_c-_c_c).magnitude<
bb_c.nonSerializeData.statistics_final.walkspeed*da_c then
bc_c=

(cb_c-_c_c).unit*bb_c.nonSerializeData.statistics_final.walkspeed*da_c end else bc_c=Vector3.new()end elseif bc_c.magnitude<
bb_c.nonSerializeData.statistics_final.walkspeed*da_c then
bc_c=bc_c.unit*
bb_c.nonSerializeData.statistics_final.walkspeed*da_c end
bc_c=bc_c*c_ca.getConfigurationValue("server_TPExploitVelocityMultiplier")
local cc_c=( (cb_c-_c_c)*Vector3.new(1,0,1)).magnitude
local dc_c=math.max(bb_c.nonSerializeData.statistics_final.walkspeed,0.1)
local _d_c=cc_c/ (
math.max((bc_c*Vector3.new(1,0,1)).magnitude,dc_c)*da_c)if bc_c.Magnitude<16 then _d_c=1 end
table.insert(ab_c.positions,{position=cb_c,velocity=_b_c.Character.PrimaryPart.Velocity})
if#ab_c.positions>10 then table.remove(ab_c.positions,1)end
if cc_c>
(bb_c.nonSerializeData.statistics_final.walkspeed*3)*da_c then local ad_c=false
if
not ad_c then local bd_c,cd_c=c__c(cb_c,dddb,"curr")
local dd_c,__ac=c__c(_c_c,dddb,"prev")
if bd_c and dd_c then ad_c=true elseif bd_c or dd_c then local a_ac=cd_c or __ac;local b_ac=d__c(a_ac)
if b_ac then
local c_ac=Ray.new(a_ac.Position,
b_ac.Position-a_ac.Position)
if
(cb_c-ba_c(c_ac,cb_c)).magnitude<=b__c and(_c_c-
ba_c(c_ac,_c_c)).magnitude<=b__c then ad_c=true;warn("is good at intersection!")end end end end
if not ad_c then local bd_c,cd_c=c__c(_c_c,a__c)
if bd_c and
(cd_c.Parent.Target.Position-cb_c).magnitude<=b__c then ad_c=true elseif cd_c then
local dd_c=Ray.new(cd_c.Position,
cd_c.Parent.Target.Position-cd_c.Position)
if
(cb_c-ba_c(dd_c,cb_c)).magnitude<=b__c and(_c_c-
ba_c(dd_c,_c_c)).magnitude<=b__c then ad_c=true;warn("is good at intersection for rope!")end end end
if not ad_c then local bd_c,cd_c=c__c(_c_c,___c)
if bd_c then
if
math.acos((
cd_c.Parent.target.CFrame.lookVector*Vector3.new(1,0,1)).unit:Dot(((
cb_c-_c_c).unit)))<=math.pi/2 then
ab_c.lastCannon=cd_c;ab_c.lastTimeNearCannon=tick()end end
if
ab_c.lastTimeNearCannon and tick()-ab_c.lastTimeNearCannon<=7 then if
math.acos((
ab_c.lastCannon.Parent.target.CFrame.lookVector*Vector3.new(1,0,1)).unit:Dot(((
cb_c-_c_c).unit)))<=math.pi/2 then
ad_c=true end else ab_c.lastCannon=
nil;ab_c.lastTimeNearCannon=nil end end
if not ad_c then
local bd_c=bc_c.magnitude>0.01 and bc_c.unit or Vector3.new()if
math.acos((bd_c*Vector3.new(1,0,1)):Dot(( (cb_c-_c_c).unit*
Vector3.new(1,0,1))))<=math.pi/2 then
if _d_c<=1 then ad_c=true end end end
if not ad_c then
local bd_c=cdba:invoke("{76068A31-E777-4EF3-B551-476E626A098C}",_b_c)
for cd_c,dd_c in pairs(bd_c)do local __ac=bdca[dd_c](bb_c)if
__ac and __ac.__serverValidateMovement then
if __ac.__serverValidateMovement(_b_c,_c_c,cb_c)then ad_c=true;break end end end end;if not ad_c then
table.insert(ab_c.sketchyMovements,{movementRatio=_d_c,timestamp=tick()})ca_c(_b_c)end end else
table.insert(ab_c.positions,{position=_b_c.Character.PrimaryPart.Position,velocity=_b_c.Character.PrimaryPart.Velocity})end else ab_c.positions={}end else
if ab_c.positions and#ab_c.positions>0 then ab_c.positions={}end end end end end
local function _dda(cddb)wait(0.1)local dddb=0
do
local ___c,a__c=pcall(function()return cddb:GetRankInGroup(4238824)end)if ___c and a__c>dddb then dddb=a__c end end
if

game:GetService("RunService"):IsStudio()or
cddb.Name=="berezaa"or cddb.Name=="Polymorphic"or cddb.Name=="sk3let0n"or dddb>=250 then
local ___c=Instance.new("BoolValue")___c.Name="developer"___c.Parent=cddb end;if dddb>1 then local ___c=Instance.new("BoolValue")___c.Name="QA"
___c.Parent=cddb end end
game.Players.PlayerAdded:connect(_dda)
for cddb,dddb in pairs(game.Players:GetPlayers())do _dda(dddb)end
function getProfessionLevel(cddb,dddb)local ___c=cbba[cddb]if ___c then
if __da[dddb]then ___c.professions[dddb]=
___c.professions[dddb]or{level=1,exp=0}return
___c.professions[dddb].level end end end
cdba:create("{83E76C51-0968-447F-84F6-89C2F8206D22}","BindableFunction","OnInvoke",getProfessionLevel)
function grantProfessionExp(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then a__c.professions[dddb]=
a__c.professions[dddb]or{level=1,exp=0}
local b__c=a__c.professions[dddb]local c__c=a_ca.getEXPToNextLevel(b__c.level)
if b__c.exp>=c__c then b__c.exp=
b__c.exp-c__c;b__c.level=b__c.level+1
local d__c=cddb.professions:FindFirstChild(dddb)if d__c then d__c.Value=b__c.level end
if cddb.Character and
cddb.Character.PrimaryPart then local _a_c=Instance.new("Attachment")
_a_c.Parent=cddb.Character.PrimaryPart;_a_c.Orientation=Vector3.new(0,0,0)
_a_c.Axis=Vector3.new(1,0,0)_a_c.SecondaryAxis=Vector3.new(0,1,0)
local aa_c=script.particles.Wave:Clone()aa_c.Parent=_a_c
aa_c.Color=ColorSequence.new(b__c.color)aa_c:Emit(1)game.Debris:AddItem(_a_c,5)end end
a__c.nonSerializeData.playerDataChanged:Fire("professions")end end
cdba:create("{158D37DB-244C-4E9D-A976-D89B26BA9197}","BindableFunction","OnInvoke",grantProfessionExp)
function playerRequest_changeAccessories(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then
if ___c:IsA("ModuleScript")then
local b__c=require(___c)
if b__c and b__c.characterCustomization then local c__c=b__c.characterCustomization;local d__c=
c__c.cost or 50000
if#dddb>0 and a__c.gold>=d__c then
local _a_c=ddba.copyTable(a__c.accessories)
for aa_c,ba_c in pairs(dddb)do
local ca_c=
game.ReplicatedStorage.accessoryLookup:FindFirstChild(ba_c.accessory)or
game.ReplicatedStorage.accessoryLookup:FindFirstChild(string.gsub(ba_c.accessory,"Id",""))if
ca_c and ca_c:FindFirstChild(tostring(ba_c.value))then _a_c[ba_c.accessory]=ba_c.value else
return false,"Invalid accessory request"end end
a__c.nonSerializeData.setPlayerData("accessories",_a_c)
a__c.nonSerializeData.incrementPlayerData("gold",-50000)return true end;return false,"Not enough money or no accessory choice"end;return false,"Invalid source"end;return false,"No source provided"end;return false,"Player data not found"end
cdba:create("{4595A8AD-A7FD-4928-8775-217FBA807A8B}","RemoteFunction","OnServerInvoke",playerRequest_changeAccessories)local adda={"equipment","consumable","miscellaneous"}local bdda=20
local cdda=99;local ddda=20;local ___b={}
local function a__b(cddb,dddb)
if dddb and typeof(dddb)=="Instance"and
dddb:IsA("Player")then if not cbba[dddb]then
while not cbba[dddb]do wait(0.1)end end;return cbba[dddb].equipment end end
cdba:create("{3CF63D4B-DA7B-4A10-80F6-714C85D44A70}","RemoteEvent")
local function b__b(cddb)local dddb=cddb.Character;local ___c=dddb.PrimaryPart
if ___c.state.Value~="dead"then
cddb.isPlayerSpawning.Value=true;cddb.playerSpawnTime.Value=os.time()
___c.state.Value="dead"local a__c;if ___c:FindFirstChild("killingBlow")and
___c.killingBlow:FindFirstChild("source")then
a__c=___c.killingBlow.source.Value end
cdba:fire("{4B5C35A0-C7D0-4269-8782-C5C7CB30B14A}",cddb,dddb,a__c)baca:fireEventLocal("entityManifestDied",___c)
if
___c.health.Value<=___c.maxHealth.Value*-3 then
ddba.playSound("DEATH",___c)else ddba.playSound("kill",___c)end;local b__c=7;if game.ReplicatedStorage:FindFirstChild("respawnTime")then
b__c=game.ReplicatedStorage.respawnTime.Value end;local c__c
do
local _a_c=game:GetService("ReplicatedStorage")
if
_a_c:FindFirstChild("safeZone")or(game.PlaceId==2061558182)then c__c="normal"elseif _a_c:FindFirstChild("overrideDeathBehavior")then c__c="custom"else
c__c="dangerous"end end;local d__c=300
if not adba:FindFirstChild("safeZone")then
delay(3,function()
if true then return end;local _a_c=cddb:FindFirstChild("tombstone")
if _a_c==nil then
_a_c=Instance.new("ObjectValue")_a_c.Name="tombstone"_a_c.Parent=cddb end;if _a_c.Value then _a_c.Value:Destroy()end
local aa_c=script.tombstone:Clone()aa_c.CanCollide=false
local ba_c=(dddb.PrimaryPart.CFrame-Vector3.new(0,
dddb.PrimaryPart.Size.Y/2,0)).Position
local ca_c=Ray.new(dddb.PrimaryPart.Position,Vector3.new(0,-50,0))
local da_c,_b_c=workspace:FindPartOnRayWithIgnoreList(ca_c,{workspace.placeFolders,workspace.CurrentCamera},false,true)if da_c and _b_c then
ba_c=_b_c+Vector3.new(0,aa_c.Size.Y/2.1,0)end
aa_c.CFrame=dddb.PrimaryPart.CFrame-
dddb.PrimaryPart.Position+ba_c
local ab_c=cdba:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Hitbox",aa_c.Position-Vector3.new(0,4,0),
nil,{isPassive=true,isDamageImmune=true,isTargetImmune=true,specialName=cddb.Name.."'s Tombstone"})
if ab_c.manifest then ab_c.manifest.CanCollide=false
ab_c.manifest.Anchored=true;game.Debris:AddItem(ab_c.manifest,d__c)
aa_c.Parent=ab_c.manifest;_a_c.Value=ab_c.manifest else aa_c:Destroy()
return false,"Failed to spawn tombstone."end end)end
if c__c=="dangerous"then
cdba:fireClient("{5C7009DB-4822-41F0-BA22-AC7C5CB51128}",cddb)local _a_c=Instance.new("BoolValue")
_a_c.Name="awaitingDeathGuiResponse"_a_c.Value=true;_a_c.Parent=cddb;local aa_c=true;local ba_c=70
while ba_c>0 do
ba_c=ba_c-wait(1)local ca_c=cddb.Character
if ca_c then local da_c=ca_c.PrimaryPart
if da_c then
local _b_c=da_c:FindFirstChild("state")if _b_c and _b_c.Value~="dead"then aa_c=false;break end end end end
if cddb and cddb.Parent then _a_c:Destroy()if aa_c then _bda(cddb)end end end
if c__c=="normal"then
delay(b__c,function()
if cddb then local _a_c=cddb.Character
if _a_c then local aa_c=_a_c.PrimaryPart
if aa_c then
local ba_c=aa_c:FindFirstChild("state")if ba_c and ba_c.Value~="dead"then return end end;cddb.Character:Destroy()end;cddb:LoadCharacter()end end)end end end
local function c__b(cddb,dddb)local ___c=cbba[cddb]local a__c=0;if ___c then
for b__c,c__c in pairs(___c.inventory)do if c__c.id==dddb then a__c=a__c+
c__c.stacks or 1 end end end;return a__c end;local function d__b(cddb,dddb)if dddb<=0 then b__b(cddb)end end
local function _a_b(cddb,dddb)
local ___c=cbba[cddb]
if ___c and cddb.Character and cddb.Character.PrimaryPart then
local a__c=___c.nonSerializeData.statistics_final
local b__c=cddb.Character.PrimaryPart.maxHealth.Value
local c__c=cddb.Character.PrimaryPart.maxMana.Value
cddb.Character.PrimaryPart.maxMana.Value=a__c.maxMana
cddb.Character.PrimaryPart.maxHealth.Value=a__c.maxHealth
local d__c=cddb.Character.PrimaryPart.maxHealth.Value
local _a_c=cddb.Character.PrimaryPart.maxMana.Value;if dddb then
d__c=cddb.Character.PrimaryPart.health.Value+ (d__c-b__c)
_a_c=cddb.Character.PrimaryPart.mana.Value+ (_a_c-c__c)end;cddb.Character.PrimaryPart.maxStamina.Value=
a__c.stamina or 0
cddb.Character.PrimaryPart.health.Value=math.clamp(d__c,0,cddb.Character.PrimaryPart.maxHealth.Value)
cddb.Character.PrimaryPart.mana.Value=math.clamp(_a_c,0,cddb.Character.PrimaryPart.maxMana.Value)end end
local function aa_b(cddb)
game:GetService("TeleportService"):Teleport(2376885433,cddb,{teleportReason="Heading back to the main menu..."},game.ReplicatedStorage.returnToLobby)end
local function ba_b(cddb)
if cddb.Character and cddb.Character.PrimaryPart and
cddb.Character.PrimaryPart:FindFirstChild("health")then
if
cddb.Character.PrimaryPart.health.Value>0 and
cddb.Character.PrimaryPart.state.Value~="dead"then
if not
game.ReplicatedStorage:FindFirstChild("safeZone")then
local dddb=game.Lighting.ClockTime<5.9 or
game.Lighting.ClockTime>18.6
local ___c={"got themselves into a sticky situation","is not having a good time right now","pondered the meaning of life a little too hard","wants to go home right now","tripped over a pebble","forgot how to breathe","is just taking a long nap... right guys?","ceased to exist","ignored the warning","used the stones to destroy... uh... themselves.","didn't wash their hands for 20 seconds","evaporated into thin air","suddenly stopped being alive","pressed the wrong button",
dddb and"stared directly at the moon"or"stared directly into the sun"}local a__c=___c[math.random(1,#___c)]local b__c="☠ "..cddb.Name.." "..
a__c.." ☠"
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=b__c,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,130,100)})end
cddb.Character.PrimaryPart.health.Value=0 end else if
not game.ReplicatedStorage:FindFirstChild("noRespawns")then cddb:LoadCharacter()end end end;local ca_b={"dex","int","str","vit"}
local function da_b(cddb,dddb,___c)if not dddb and
(not cddb or not cbba[cddb])then return nil end
local a__c=___c or cbba[cddb]local b__c={}local c__c={}local d__c={}local _a_c={}local aa_c={}local ba_c=0;local ca_c=0
local function da_c(dd_c)
for __ac,a_ac in pairs(dd_c)do
for b_ac,c_ac in pairs(a_ac)do
if b_ac==
"defense"then ba_c=ba_c+c_ac elseif b_ac=="damage"or b_ac=="baseDamage"then ca_c=
ca_c+c_ac else b__c[b_ac]=(b__c[b_ac]or 0)+c_ac end end end end;for dd_c,__ac in pairs(ca_b)do b__c[__ac]=0;c__c[__ac]=0;d__c[__ac]=1;_a_c[__ac]=0
aa_c[__ac]=1 end;local _b_c={}
for dd_c,__ac in pairs(ca_b)do b__c[__ac]=
a__c.statistics[__ac]or 0;c__c[__ac]=c__c[__ac]or 0;d__c[__ac]=
d__c[__ac]or 1;_a_c[__ac]=c__c[__ac]or 0;aa_c[__ac]=
aa_c[__ac]or 1 end
local ab_c=cdba:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",cddb.entityGUID.Value)
for dd_c,__ac in pairs(ab_c)do if
__ac.statusEffectModifier and __ac.statusEffectModifier.modifierData then local a_ac=__ac.statusEffectModifier.modifierData
da_c({a_ac})end end;local bb_c=3;local cb_c,db_c
for dd_c,__ac in pairs(a__c.equipment)do local a_ac=acca[__ac.id]
if a_ac then if a_ac.modifierData then
da_c(a_ac.modifierData)end;local b_ac=__ac.position;local c_ac=false
if b_ac==1 then cb_c=a_ac
c_ac=true;if a_ac.attackSpeed then bb_c=a_ac.attackSpeed end elseif b_ac==11 and
a_ac.equipmentType=="sword"then db_c=a_ac;c_ac=true elseif
b_ac==11 and(
a_ac.equipmentType=="bow"or a_ac.equipmentType=="dagger")then c_ac=true elseif b_ac==11 and a_ac.equipmentType=="fishing-rod"then
c_ac=true end
if(not c_ac)and(a_ac.baseDamage or a_ac.damage)then ca_c=ca_c+ (
a_ac.baseDamage or a_ac.damage)end;local d_ac=0
if __ac.enchantments then
for _aac,aaac in pairs(__ac.enchantments)do local baac=acca[aaac.id]
if
baac.enchantments then local caac=baac.enchantments[aaac.state]
if caac then if caac.modifierData then
da_c({baac.enchantments[aaac.state].modifierData})end;if caac.statUpgrade then
d_ac=d_ac+caac.statUpgrade end end end end end
if d_ac>0 and a_ac.statUpgrade then local _aac={}
for aaac,baac in pairs(a_ac.statUpgrade)do if baac~=0 then _aac[aaac]=
baac*d_ac end end;da_c({_aac})end
if __ac.attribute then local _aac=bcca[__ac.attribute]
if _aac and _aac.modifier then
local aaac=_aac.modifier(a_ac,__ac)if aaac then da_c({aaac})end end end end;if __ac.modifierData then da_c(__ac.modifierData)end end
if cb_c and db_c then
local dd_c=
( (cb_c.baseDamage or 0)+ (cb_c.damage or 0)+ (
db_c.baseDamage or 0)+ (db_c.damage or 0))/2;ca_c=ca_c+dd_c elseif cb_c and(not db_c)then
local dd_c=(cb_c.baseDamage or 0)+ (cb_c.damage or 0)ca_c=ca_c+dd_c end;for dd_c,__ac in pairs(b__c)do _b_c[dd_c]=__ac end;_b_c.damageTakenMulti=1 + (
b__c.damageTakenMulti or 0)_b_c.damageGivenMulti=1 + (
b__c.damageGivenMulti or 0)
_b_c.equipmentDefense=ba_c;_b_c.defense=ba_c
_b_c.equipmentDamage=(ca_c+ (b__c.equipmentDamage or 0))_b_c.damage=_b_c.equipmentDamage
_b_c.physicalDamage=_b_c.equipmentDamage;_b_c.magicalDamage=_b_c.equipmentDamage
_b_c.physicalDefense=_b_c.equipmentDefense;_b_c.magicalDefense=_b_c.equipmentDefense
_b_c.stamina=3 + (b__c.stamina or 0)
_b_c.staminaRecovery=1 + (b__c.staminaRecovery or 0)local _c_c=a__c.level;local ac_c=_b_c.vit;local bc_c=_b_c.int;local cc_c=a__c.class
local dc_c=15 + (5 *_c_c)dc_c=dc_c+ (5 *ac_c)
if b__c.maxHealth then dc_c=dc_c+b__c.maxHealth end;_b_c.maxHealth=math.ceil(dc_c)local _d_c=3 + (2 *_c_c)_d_c=_d_c+
1 *bc_c
if b__c.maxMana then _d_c=_d_c+b__c.maxMana end;_b_c.maxMana=math.ceil(_d_c)local ad_c=1;if b__c.manaRegen then ad_c=ad_c+
b__c.manaRegen/100 end
_b_c.manaRegen=(1.0 +
0.035 *a__c.level+0.050 *_b_c.int)*ad_c;local bd_c=1
if b__c.healthRegen then bd_c=bd_c+b__c.healthRegen/100 end;_b_c.healthRegen=
(0.5 +0.240 *a__c.level+0.100 *_b_c.vit)*bd_c;_b_c.jump=75 +
(b__c.jump or 0)
_b_c.consumeTimeReduction=0 + (b__c.consumeTimeReduction or 0)_b_c.attackSpeed=0 + (bb_c-3)/3.5
_b_c.criticalStrikeChance=
( (0.5 /100)/3)*_b_c.dex+ (b__c.criticalStrikeChance or 0)
_b_c.blockChance=
math.clamp(0.20 * (_b_c.dex/ (3 *a__c.level)),0,1)+ (b__c.blockChance or 0)
_b_c.criticalStrikeDamage=2 + (b__c.criticalStrikeDamage or 0)_b_c.greed=1 + (b__c.greed or 0)
_b_c.wisdom=1 + (b__c.wisdom or 0)_b_c.luck=b__c.luck or 0
_b_c.luckEffectiveness=1.5 + (b__c.luckEffectiveness or 0)_b_c.walkspeed=18 + (b__c.walkspeed or 0)
_b_c.merchantCostReduction=0;_b_c.abilityCDR=0;_b_c.attackRangeIncrease=0
_b_c.consumableHealthIncrease=0;_b_c.consumableManaIncrease=0
for dd_c,__ac in pairs(_b_c)do
local a_ac=b__c[dd_c.."_totalMultiplicative"]if a_ac then _b_c[dd_c]=__ac* (1 +a_ac)end end;local cd_c={}
for dd_c,__ac in pairs(a__c.equipment)do local a_ac=acca[__ac.id]
if a_ac.perks then for b_ac,c_ac in
pairs(a_ac.perks)do cd_c[b_ac]=true end end
if __ac.perks then for b_ac,c_ac in pairs(__ac.perks)do cd_c[b_ac]=true end end end
for dd_c,__ac in pairs(ccca)do
local a_ac=__ac.condition and __ac.condition(_b_c)
if __ac.class and cada(cddb,__ac.class)then a_ac=true end;if a_ac or cd_c[dd_c]then cd_c[dd_c]=true
if __ac.apply then __ac.apply(_b_c)end else cd_c[dd_c]=false end end;_b_c.activePerks=cd_c
a__c.nonSerializeData.statistics_final=_b_c;_a_b(cddb,true)
if cddb then
for dd_c,__ac in pairs(ca_b)do
local a_ac=cddb:FindFirstChild(__ac)if a_ac==nil then a_ac=Instance.new("IntValue")a_ac.Name=__ac
a_ac.Parent=cddb end;a_ac.Value=_b_c[__ac]end
if cbba[cddb]then
cdba:fireClient("{9928EED8-32C2-49B0-8C6A-30D599B6414B}",cddb,a__c.statistics,_b_c)
a__c.nonSerializeData.playerDataChanged:Fire("nonSerializeData")end end;return _b_c end
local function _b_b(cddb,dddb)
if not dddb or not dddb.Character or
not dddb.Character.PrimaryPart then return false end;local ___c;local a__c=cddb:GetChildren()
for i=1,#a__c do
local b__c=cddb[tostring(i)]
local c__c=cddb[tostring(i==#a__c and 1 or i+1)]
local d__c=
(c__c.Position-b__c.Position):Cross(
dddb.Character.PrimaryPart.Position-b__c.Position).Y<0;if ___c~=nil and d__c~=___c then return false end;___c=d__c end
if ___c then
local b__c=dddb.Character.PrimaryPart.Position.Y
local c__c=a__c[1].Position.Y+a__c[1].Size.Y/2
local d__c=a__c[1].Position.Y-a__c[1].Size.Y/2;return b__c>=d__c and b__c<=c__c end;return ___c end
cdba:create("{29E02EB4-1E19-4560-8A94-009F594B7F57}","BindableEvent")
local function ab_b(cddb,dddb)if cddb.Parent==nil then return false end;return
not not
game.StarterPlayer.StarterCharacter.PrimaryPart:FindFirstChild(dddb.Name)end;local bb_b=32;local cb_b=bb_b^2
local function db_b(cddb)local dddb=cddb.Character;if not dddb then return end
local ___c=dddb.PrimaryPart;if not ___c then return end
local a__c=cddb:FindFirstChild("respawnPoint")if not a__c then return end
local b__c=game.ReplicatedStorage.spawnPoints:GetChildren()local c__c=nil;local d__c=cb_b
local function _a_c(aa_c)
if not aa_c:FindFirstChild("description")then return end;if aa_c:FindFirstChild("ignore")then return end;local ba_c=aa_c.Value.Position-
___c.Position;local ca_c=
ba_c.X*ba_c.X+ba_c.Y*ba_c.Y+ba_c.Z*ba_c.Z;if ca_c<=d__c then
c__c=aa_c;d__c=ca_c end end;for aa_c,ba_c in pairs(b__c)do _a_c(ba_c)end
if
c__c and(a__c.Value~=c__c)then a__c.Value=c__c
local aa_c=c__c:FindFirstChild("description")and c__c.description.Value
if aa_c then local ba_c=cbba[cddb]
local ca_c=ba_c.locations[tostring(game.PlaceId)]ca_c.spawns[c__c.Name]={text=aa_c}
ba_c.nonSerializeData.playerDataChanged:Fire("locations")end
baca:fireEventPlayer("playerRespawnPointChanged",cddb,a__c.Value)end end
local function _c_b(cddb,dddb)
while dddb.Parent~=bbca do wait(0.1)dddb.Parent=bbca end;da_b(cddb,false,cbba[cddb])
if dddb:WaitForChild("hitbox",10)then
dddb.PrimaryPart=dddb.hitbox;local ___c
do local _d_c=dddb.PrimaryPart
for bd_c,cd_c in
pairs(game.StarterPlayer.StarterCharacter.PrimaryPart:GetChildren())do
if
not dddb.PrimaryPart:FindFirstChild(cd_c.Name)then cddb:Kick("Anti-exploit")end end;local function ad_c(bd_c)
if ab_b(_d_c,bd_c)then cddb:Kick("Anti-exploit")end end
dddb.PrimaryPart.ChildRemoved:connect(ad_c)end
cdba:fire("{29E02EB4-1E19-4560-8A94-009F594B7F57}",cddb,dddb)
local a__c=pcall(function()dddb.PrimaryPart:SetNetworkOwner(cddb)end)
do while not a__c do wait(0.5)
a__c=pcall(function()
dddb.PrimaryPart:SetNetworkOwner(cddb)end)end end;_a_b(cddb)local b__c=cbba[cddb]
if b__c and b__c.condition then
local _d_c=dddb.PrimaryPart;if not _d_c then return end;local ad_c=_d_c.health;local bd_c=_d_c.mana;if
not(ad_c and bd_c)then return end
ad_c.Value=math.max(1,b__c.condition.health)bd_c.Value=math.max(1,b__c.condition.mana)b__c.condition=
nil end
d__b(cddb,cddb.Character.PrimaryPart.health.Value)local c__c=true
if dddb.PrimaryPart and
cddb.Character.PrimaryPart.health.Value>0 then
cddb.Character.PrimaryPart.health.Changed:connect(function(_d_c)
d__b(cddb,_d_c)if _d_c<=0 then c__c=false end end)end;local d__c=0;local _a_c=0;local aa_c=cbba[cddb]
spawn(function()
while true do local _d_c=wait(1)
if

c_ca.getConfigurationValue("server_doRedirectMaxHealthDeletions")and dddb.PrimaryPart and not
dddb.PrimaryPart:FindFirstChild("maxHealth")then cddb:Kick("Anti-exploit")end;db_b(cddb)
if

c__c and dddb and dddb.PrimaryPart and cddb.Character==dddb and aa_c and aa_c.nonSerializeData then local ad_c=
(tick()- (aa_c.nonSerializeData.lastTimeInCombat or 0))<=4
local bd_c=aa_c.nonSerializeData.statistics_final;local cd_c=1;local dd_c=1
local __ac=cddb.Character.PrimaryPart:FindFirstChild("state")
if __ac and __ac.Value=="sitting"and
cddb.Character.PrimaryPart.Anchored then cd_c=cd_c*2;dd_c=dd_c*2 end;if ad_c then dd_c=dd_c*0;cd_c=cd_c*0.5 end;if
__ac and __ac.Value=="dead"then dd_c=0;cd_c=0 end;local a_ac=bd_c.healthRegen*_d_c*dd_c*
0.5;local b_ac=d__c+a_ac
local c_ac=math.floor(b_ac)if c_ac>0 then
dddb.PrimaryPart.health.Value=math.clamp(
dddb.PrimaryPart.health.Value+c_ac,0,dddb.PrimaryPart.maxHealth.Value)end;local d_ac=bd_c.manaRegen*
_d_c*cd_c*0.5
local _aac=_a_c+d_ac;local aaac=math.floor(_aac)if aaac>0 then
dddb.PrimaryPart.mana.Value=math.clamp(
dddb.PrimaryPart.mana.Value+aaac,0,dddb.PrimaryPart.maxMana.Value)end
d__c=b_ac-c_ac;_a_c=_aac-aaac else break end end end)local ba_c=dddb.PrimaryPart;local ca_c=0;local da_c=1
local _b_c=Vector3.new(1,1,1)*0.2;local ab_c=nil;local bb_c
local function cb_c(_d_c)local ad_c="☠ "..
cddb.Name.." was killed by ".._d_c.Name.." ☠"
local bd_c=_d_c:FindFirstChild("message")
if bd_c then ad_c=bd_c.Value
ad_c=string.gsub(ad_c,"%[playerName]",cddb.Name)ad_c=string.gsub(ad_c,"%[trapName]",_d_c.Name)ad_c="☠ "..
ad_c.." ☠"end;return ad_c end
local function db_c(_d_c,ad_c)ca_c=ad_c+da_c;if _d_c:FindFirstChild("cooldown")then
ca_c=ad_c+_d_c.cooldown.Value end
if _d_c:FindFirstChild("statusEffect")then
local cd_c=_d_c.statusEffect.Value
local function dd_c(b_ac)local c_ac={}for d_ac,_aac in pairs(b_ac:GetChildren())do
if _aac:IsA("Folder")then
c_ac[_aac.Name]=dd_c(_aac)else c_ac[_aac.Name]=_aac.Value end end
return c_ac end;local __ac=dd_c(_d_c.statusEffect)
cdba:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",ba_c,cd_c,__ac,ba_c,"trap",0)local a_ac=Instance.new("StringValue")
a_ac.Name="deathTrapKillMessage"a_ac.Value=cb_c(_d_c)a_ac.Parent=cddb;game:GetService("Debris"):AddItem(a_ac,
__ac.duration or 1)end;local bd_c
if _d_c:FindFirstChild("damage")then bd_c=_d_c.damage.Value elseif
_d_c:FindFirstChild("percentDamage")then local cd_c=ba_c:FindFirstChild("maxHealth")if cd_c then bd_c=cd_c.Value*
_d_c.percentDamage.Value end end
if bd_c then local cd_c=ba_c:FindFirstChild("health")if not cd_c then return end;if
cd_c.Value<=0 then return end
cd_c.Value=math.max(0,cd_c.Value-bd_c)local dd_c=Instance.new("Sound")
dd_c.SoundId="rbxassetid://2065833626"dd_c.MaxDistance=1000;dd_c.Volume=1.5;dd_c.EmitterSize=5
dd_c.Parent=ba_c;dd_c:Play()
game:GetService("Debris"):AddItem(dd_c,dd_c.TimeLength)
if cd_c.Value<=0 then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cb_c(_d_c),Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,130,100)})end end
if _d_c:FindFirstChild("knockback")then
local cd_c=caca.projection_Box(_d_c.CFrame,_d_c.Size,ba_c.Position)local dd_c=ba_c.Position-cd_c
cdba:fireClient("{6A99938B-6371-4BBA-9DF6-AC72C78A47D6}",cddb,dd_c.Unit*
_d_c.knockback.Value)end end
local function _c_c(_d_c)local ad_c=ba_c.Position-_d_c.Position
local bd_c=math.max(math.abs(ad_c.X),math.abs(ad_c.Y),math.abs(ad_c.Z))
local cd_c=math.max(_d_c.Size.X,_d_c.Size.Y,_d_c.Size.Z)if bd_c>cd_c then return false end;local dd_c=ba_c.CFrame;local __ac=ba_c.Size+_b_c+
Vector3.new(0,2,0)
local a_ac=caca.projection_Box(dd_c,__ac,_d_c.Position)if
not caca.boxcast_singleTarget(_d_c.CFrame,_d_c.Size,a_ac)then return false end;return true end
local function ac_c(_d_c,ad_c)if not _c_c(_d_c)then return end;if _d_c:FindFirstChild("reference")then
_d_c=_d_c.reference.Value;if not _d_c then return end end
bb_c=_d_c
if _d_c:FindFirstChild("onTouched")then _d_c=_d_c.onTouched end;db_c(_d_c,ad_c)end
local function bc_c(_d_c)if _c_c(_d_c)then return end;local ad_c=bb_c;bb_c=nil
if
ad_c:FindFirstChild("onTouchEnded")then db_c(ad_c.onTouchEnded,tick())end end
local function cc_c()if(not ba_c.Parent)or(ba_c.Parent~=cddb.Character)then
ab_c:Disconnect()end;if bb_c then bc_c(bb_c)end
local _d_c=tick()if _d_c<ca_c then return end;local ad_c=ba_c.Position-
Vector3.new(0,ba_c.Size.Y/2,0)
local bd_c=Vector3.new(0,-2,0)local cd_c=dcba:GetTagged("deathTrap")for dd_c,__ac in pairs(cd_c)do
local a_ac=ac_c(__ac,_d_c)if a_ac then break end end end;ab_c=bcba.Heartbeat:Connect(cc_c)
__ca:setWholeCollisionGroup(dddb,"characters")local dc_c=dddb.PrimaryPart end end
cdba:create("{6A99938B-6371-4BBA-9DF6-AC72C78A47D6}","RemoteEvent")
local function ac_b(cddb,dddb)if cddb.Character and cddb.Character.PrimaryPart then
cddb.Character:SetPrimaryPartCFrame(dddb)end end
cdba:create("{367D4574-CA55-456C-A141-E3E9FBB58C29}","RemoteEvent","OnServerEvent",ac_b)
local function bc_b(cddb)
if not cbba[cddb]then while not cbba[cddb]do wait()end end
if cbba[cddb]then local dddb={}
for ___c,a__c in pairs(cbba[cddb])do dddb[___c]=a__c end
cdba:fireClient("{52DBE4DB-B72C-4132-B3D1-D3D3255E271A}",cddb,dddb)end end
local function cc_b(cddb,dddb)dddb=dddb or cbba[cddb]
if dddb then local ___c={}
___c.equipment=dddb.equipment;___c.accessories=dddb.accessories
___c.temporaryEquipment=dddb.nonSerializeData.temporaryEquipment;if cddb.Character and cddb.Character.PrimaryPart then
cddb.Character.PrimaryPart.appearance.Value=_dba:JSONEncode(___c)end end end
local function dc_b(cddb,dddb)local ___c=cbba[cddb]
if ___c then
if dddb and dddb:IsDescendantOf(_cca)then
if not
___c.nonSerializeData.temporaryEquipment[dddb.Name]then
___c.nonSerializeData.temporaryEquipment[dddb.Name]=true;cc_b(cddb,___c)return true end end end;return false end
local function _d_b(cddb,dddb)if cddb:FindFirstChild("entityGUID")then
cdba:invoke("{5E232F74-B2D2-4ECA-8874-A7C3E681398C}",cddb.entityGUID.Value)end end
local function ad_b(cddb)
if
game.PlaceId==2376885433 or game.PlaceId==3323943158 or game.PlaceId==2015602902 then return{}end
if not cbba[cddb]then while not cbba[cddb]do wait()end end;local dddb={}for ___c,a__c in pairs(cbba[cddb])do dddb[___c]=a__c end;return
dddb end
local function bd_b(cddb,dddb)
if not cbba[cddb]then while not cbba[cddb]do wait(0.1)end end;if cbba[cddb]then
cdba:fireClient("{9658901E-8F65-43C2-AC62-1A0E2E55839B}",cddb,dddb,cbba[cddb][dddb])end end
local function cd_b(cddb)for dddb,___c in pairs(cddb)do if ___c then return dddb end end;return nil end
local function dd_b(cddb)
while true do local dddb=false;for ___c,a__c in pairs(cddb)do local b__c=acca[a__c.id]
if
b__c.equipmentSlot~=a__c.position then dddb=true;table.remove(cddb,___c)break end end;if
not dddb then break end end end
local function __ab(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c={}local b__c=false;local c__c=false;local d__c=0
local _a_c=ddba.copyTable(dddb)
for ba_c,ca_c in pairs(_a_c)do local da_c=acca[ca_c.id]
if
da_c and(ca_c.stacks or 1)>0 then
for _b_c,ab_c in pairs(___c.inventory)do
if ab_c.id==ca_c.id then
if da_c.canStack then
if ca_c.stacks>0 then local bb_c=math.clamp(ca_c.stacks,1,
ab_c.stacks or 1)local cb_c={}
cb_c.id=ca_c.id;cb_c.position=ab_c.position
for db_c,_c_c in pairs(ab_c)do if not cb_c[db_c]then
if
type(_c_c)=="table"then cb_c[db_c]=ddba.copyTable(_c_c)else cb_c[db_c]=_c_c end end end;cb_c.stacks=bb_c;ca_c.stacks=ca_c.stacks-bb_c
table.insert(a__c,cb_c)if ca_c.stacks==0 then break end end else
if ab_c.position==ca_c.position then local bb_c={}bb_c.id=ca_c.id
bb_c.position=ca_c.position;for cb_c,db_c in pairs(ab_c)do
if not bb_c[cb_c]then if type(db_c)=="table"then
bb_c[cb_c]=ddba.copyTable(db_c)else bb_c[cb_c]=db_c end end end
table.insert(a__c,bb_c)ca_c.stacks=0;break end end end end;if ca_c.stacks==0 then else break end else break end end;local aa_c=true;for ba_c,ca_c in pairs(_a_c)do
if(ca_c.stacks or 1)>0 then aa_c=false end end;return a__c,not aa_c end;return nil,true end
local function a_ab(cddb,dddb,___c)local a__c={}local b__c={}
for i_category=1,#adda do a__c[adda[i_category]]=bdda end;local c__c=cbba[cddb]
if c__c then for aa_c,ba_c in pairs(c__c.inventory)do local ca_c=acca[ba_c.id]
if ca_c then a__c[ca_c.category]=
a__c[ca_c.category]-1 else return false end end end;for aa_c,ba_c in pairs(dddb)do local ca_c=acca[ba_c.id]
if ca_c then a__c[ca_c.category]=
a__c[ca_c.category]+1 else return false end end
local d__c=ddba.copyTable(___c)local _a_c=ddba.copyTable(c__c.inventory)
while true do local aa_c=false
for ba_c,ca_c in
pairs(d__c)do local da_c=acca[ca_c.id]
if not ca_c.stacks then ca_c.stacks=1 end
if da_c then
if da_c.canStack then
for _b_c,ab_c in pairs(_a_c)do
if ab_c.id==ca_c.id and
ab_c.stacks<= (da_c.stackSize or cdda)then
local bb_c=math.clamp(ca_c.stacks,0,(da_c.stackSize or cdda)-ab_c.stacks)ca_c.stacks=ca_c.stacks-bb_c
ab_c.stacks=ab_c.stacks+bb_c
if ca_c.stacks==0 then table.remove(d__c,ba_c)aa_c=true;break end end end end end;if aa_c then break end end;if not aa_c then break end end
for aa_c,ba_c in pairs(d__c)do local ca_c=acca[ba_c.id]
if ca_c then
if ca_c.canStack then a__c[ca_c.category]=
a__c[ca_c.category]-1 else a__c[ca_c.category]=a__c[ca_c.category]-
ba_c.stacks end;b__c[ca_c.category]=true else return false end end
for aa_c,ba_c in pairs(b__c)do if a__c[aa_c]<0 then return false end end;return true end
local function b_ab(cddb,dddb)local ___c=cbba[cddb]local a__c=ddba.copyTable(dddb)
if ___c then local b__c=false
for c__c,d__c in
pairs(a__c)do local _a_c=acca[d__c.id]
if not d__c.stacks then d__c.stacks=1 end
if _a_c and _a_c.canStack then
for aa_c,ba_c in pairs(___c.inventory)do
if ba_c.id==d__c.id then
if(ba_c.stacks+
d__c.stacks)<= (_a_c.stackSize or cdda)then ba_c.stacks=
ba_c.stacks+d__c.stacks
cdba:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",cddb,"item-collected",{id=_a_c.id,amount=1})d__c.stacks=0;b__c=true;break elseif ba_c.stacks< (_a_c.stackSize or cdda)then local ca_c=(
_a_c.stackSize or cdda)-ba_c.stacks
if
d__c.stacks>=ca_c then ba_c.stacks=ba_c.stacks+ca_c
d__c.stacks=d__c.stacks-ca_c;b__c=true;if d__c.stacks==0 then
cdba:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",cddb,"item-collected",{id=_a_c.id,amount=1})break end end end end end end end
for c__c,d__c in pairs(a__c)do
if d__c.stacks>0 then local _a_c=acca[d__c.id]
if _a_c then d__c.id=_a_c.id
if
_a_c.canStack then local aa_c=_a_c.stackSize or 99;local ba_c=d__c.stacks
while ba_c>0 do
if ba_c>=aa_c then
local ca_c=ddba.copyTable(d__c)ca_c.stacks=aa_c;ba_c=ba_c-aa_c
table.insert(___c.inventory,ca_c)else local ca_c=ddba.copyTable(d__c)ca_c.stacks=ba_c;ba_c=0
table.insert(___c.inventory,ca_c)end end;d__c.stacks=0
cdba:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",cddb,"item-collected",{id=_a_c.id,amount=1})b__c=true else
for i=1,d__c.stacks or 1 do
local aa_c={id=d__c.id,stacks=1,modifierData=d__c.modifierData}
for ba_c,ca_c in pairs(d__c)do if not aa_c[ba_c]then
if type(ca_c)=="table"then
aa_c[ba_c]=ddba.copyTable(ca_c)elseif ba_c~="stacks"then aa_c[ba_c]=ca_c end end end;table.insert(___c.inventory,aa_c)
cdba:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",cddb,"item-collected",{id=_a_c.id,amount=1})b__c=true end end end end end;if b__c then
___c.nonSerializeData.playerDataChanged:Fire("inventory")end;return true end;return false end
local function c_ab(cddb,dddb)local ___c=cbba[cddb]local a__c=ddba.copyTable(dddb)
if ___c then local b__c=false
for c__c,d__c in
pairs(a__c)do local _a_c=acca[d__c.id]
if not d__c.stacks then d__c.stacks=1 end
if _a_c and _a_c.canStack then
while d__c.stacks>0 do local aa_c=false
for ba_c,ca_c in pairs(___c.inventory)do
if ca_c.id==
d__c.id then
if ca_c.stacks>d__c.stacks then
ca_c.stacks=ca_c.stacks-d__c.stacks;d__c.stacks=0 else d__c.stacks=d__c.stacks-ca_c.stacks
table.remove(___c.inventory,ba_c)end;b__c=true;aa_c=true;break end end;if not aa_c then break end end else d__c.stacks=1
for aa_c,ba_c in pairs(___c.inventory)do
if ba_c.position==d__c.position and ba_c.id==
d__c.id then
table.remove(___c.inventory,aa_c)d__c.stacks=0;b__c=true;break end end end end;if b__c then
___c.nonSerializeData.playerDataChanged:Fire("inventory")end;return true end;return false end
local function d_ab(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c,b__c=__ab(cddb,{dddb})
if not b__c then
for d__c,_a_c in pairs(a__c)do
local aa_c=acca[_a_c.id]if _a_c.questBound or(aa_c and aa_c.questBound)then
return false,"Item is quest bound"end end;c_ab(cddb,a__c)local c__c=ddba.copyTable(a__c)
while true do local d__c=false
for _a_c,aa_c in
pairs(c__c)do local ba_c=acca[aa_c.id]
if ba_c.canStack then
for ca_c,da_c in
pairs(___c.globalData.itemStorage)do local _b_c=ba_c.stackSize or cdda
if
aa_c.id==da_c.id and da_c.stacks<_b_c then local ab_c=(da_c.stacks+aa_c.stacks)-_b_c
if ab_c>0 then
da_c.stacks=ab_c;aa_c.stacks=_b_c else da_c.stacks=da_c.stacks+aa_c.stacks
aa_c.stacks=0;table.remove(c__c,_a_c)d__c=true;break end end end end;if d__c then break end end;if not d__c then break end end;for d__c,_a_c in pairs(c__c)do
table.insert(___c.globalData.itemStorage,_a_c)end
___c.nonSerializeData.playerDataChanged:Fire("inventory")
___c.nonSerializeData.playerDataChanged:Fire("globalData")return true,"Successfully transfered to storage."else return false,"Failed find item."end end;return false,"PlayerData not found."end
local function _aab(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c=a_ab(cddb,{},{dddb})
if a__c then
local b__c,c__c=false,nil
do
for d__c,_a_c in pairs(___c.globalData.itemStorage)do if _a_c.id==dddb.id and
d__c==dddb.position then
c__c=table.remove(___c.globalData.itemStorage,d__c)b__c=true end end end
if b__c then table.insert(___c.inventory,c__c)
___c.nonSerializeData.playerDataChanged:Fire("inventory")
___c.nonSerializeData.playerDataChanged:Fire("globalData")return true,"Successfully transfered to inventory."else
return false,"Failed to find in storage."end else return false,"Player does not have space in inventory."end end;return false,"PlayerData not found."end
local function aaab(cddb)local dddb=cbba[cddb]
if dddb then local ___c={}for i_category=1,#adda do
___c[adda[i_category]]={}
for i_slot=1,bdda do ___c[adda[i_category]][i_slot]=true end end
for b__c,c__c in
pairs(dddb.inventory)do local d__c=acca[c__c.id]
if d__c then
if not c__c.stacks then c__c.stacks=1 end
if ___c[d__c.category]then
if
c__c.position and ___c[d__c.category][c__c.position]then ___c[d__c.category][c__c.position]=false elseif
c__c.position then c__c.position=nil end else table.remove(dddb.inventory,b__c)end else table.remove(dddb.inventory,b__c)end end;local a__c={}
while true do local b__c=false
for c__c,d__c in pairs(dddb.inventory)do
if not d__c.position then
local _a_c=acca[d__c.id]local aa_c=cd_b(___c[_a_c.category])
if aa_c then d__c.position=aa_c
___c[_a_c.category][aa_c]=false else
warn("moving item to storage due to lack of inv space")local ba_c,ca_c=d_ab(cddb,d__c)warn("INV->STOR",ba_c,ca_c)
if not ba_c then
table.remove(dddb.inventory,c__c)warn("taking out and wiping it")end;b__c=true;break end end end;if not b__c then break end end
table.sort(dddb.inventory,function(b__c,c__c)if b__c.position and c__c.position then return
b__c.position>c__c.position end;return false end)end end
local function baab(cddb,dddb)local ___c=cbba[cddb]
if ___c then
for a__c,b__c in pairs(___c.quests.active)do
if b__c.id==dddb then local c__c=0
local d__c=0
for _a_c,aa_c in
pairs(b__c.objectives[b__c.currentObjective].steps)do c__c=c__c+1;if
aa_c.requirement.amount<=aa_c.completion.amount then d__c=d__c+1 end end
if d__c>0 and d__c==c__c and
b__c.objectives[b__c.currentObjective].started then
return b_ca.questState.objectiveDone else
if b__c.objectives[b__c.currentObjective].started then return
b_ca.questState.active else return b_ca.questState.unassigned end;return b_ca.questState.active end end end
for a__c,b__c in pairs(___c.quests.completed)do if b__c.id==dddb then
return b_ca.questState.completed end end;return b_ca.questState.unassigned end;return b_ca.questState.unassigned end
local function caab(cddb,dddb)local ___c=cbba[cddb]if ___c then
for a__c,b__c in pairs(___c.quests.active)do if b__c.id==dddb then return
b__c.currentObjective end end end end
local function daab(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then
for b__c,c__c in pairs(a__c.quests.active)do
if c__c.id==dddb then local d__c=0
local _a_c=0;for aa_c,ba_c in pairs(c__c.objectives[___c].steps)do _a_c=_a_c+1
if
ba_c.requirement.amount<=ba_c.completion.amount then d__c=d__c+1 end end
if#
c__c.objectives==___c then return _a_c>0 and _a_c==d__c else if
c__c.objectives[___c+1].started then return false end end;return _a_c>0 and _a_c==d__c end end end;return false end;local _bab=2
local function abab(cddb)
if

cddb.Parent~=game.Players or
cddb:FindFirstChild("DataLoaded")==nil or cddb:FindFirstChild("teleporting")or cbba[cddb]==nil then return false end
if cddb:FindFirstChild("entityGUID")then
local c__c=cdba:invoke("{D9E9266C-A8D0-478F-A0CF-A39D56B75ED8}",cddb)if c__c then cbba[cddb].packagedStatusEffects=c__c end end;local dddb=cddb.userId
local ___c,a__c,b__c=_cba:updatePlayerSaveFileData(dddb,cbba[cddb])
if ___c then if cddb:FindFirstChild("DataSaveFailed")then
cddb.DataSaveFailed:Destroy()end else
warn(cddb.Name,"'s data failed to save.",a__c)
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error","Failed to save player data: "..a__c)
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"data:fail:save")
if cddb:FindFirstChild("DataSaveFailed")==nil then
local c__c=Instance.new("BoolValue")c__c.Name="DataSaveFailed"c__c.Parent=cddb end
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Failed to save data: "..a__c,textColor3=Color3.fromRGB(255,57,60)})end
if cbba[cddb]then cbba[cddb].packagedStatusEffects=nil end;return ___c,b__c end;local bbab={"dex","int","vit","str"}
local function cbab(cddb,dddb)
local ___c={["0.05"]=1.0,["0.075"]=0.7,["0.1"]=0.1}
for a__c,b__c in pairs(cddb)do local c__c=1;local d__c=false
if
b__c.successfulUpgrades and b__c.successfulUpgrades>0 then local _a_c=acca[b__c.id]
if _a_c.baseDamage then
for aa_c,ba_c in pairs(b__c.modifierData)do
if ba_c.baseDamage then
local ca_c=tostring(math.floor(
ba_c.baseDamage/_a_c.baseDamage/0.025)*0.025)
if ___c[ca_c]then c__c=c__c*___c[ca_c]else
warn(b__c.id,"@",b__c.position,"has weird scaling (",ca_c,"% increase)",ba_c.baseDamage,"baseDamage increase")end end end end end
if c__c*100 <=0.5 or d__c then table.remove(cddb,a__c)
table.insert(dddb,b__c)
warn("id",b__c.id,"@",b__c.position,"was revoked","("..c__c*100 .."%)")end end end
local function dbab(cddb,dddb)dddb.level=1;dddb.exp=0;dddb.equipment={}dddb.inventory={}
dddb.abilities={}dddb.abilityBooks={}dddb.statistics={}dddb.gold=0
dddb.class="Adventurer"end
local function _cab(cddb,dddb)local ___c=cbba[cddb]if ___c then
___c.nonSerializeData.perksActivated[tostring(dddb)]=tick()end end
cdba:create("{B125A056-493B-4CC9-90B4-C908ECB0B94A}","BindableEvent","Event",_cab)
local function acab(cddb,dddb)
if not dddb.flags.arrowChangeXD then dddb.flags.arrowChangeXD=true;local ___c
do for a__c,b__c in
pairs(dddb.equipment)do
if b__c.position==b_ca.equipmentPosition.arrow then ___c=b__c end end end;if ___c and ___c.id==nil then ___c.id=87 elseif not ___c then
table.insert(dddb.equipment,{id=87,position=b_ca.equipmentPosition.arrow,stacks=0})end end
if not dddb.flags.abilityReset then dddb.flags.abilityReset=true
if game.PlaceId~=
2103419922 then dddb.abilities={}for ___c,a__c in pairs(dddb.abilityBooks)do
a__c.pointsAssigned=0 end
while true do local ___c=false
for a__c,b__c in pairs(dddb.hotbar)do if b__c.dataType==
b_ca.dataType.ability then ___c=true;table.remove(dddb.hotbar,a__c)
break end end;if not ___c then break end end;dddb.statistics.dex=0;dddb.statistics.int=0
dddb.statistics.str=0;dddb.statistics.vit=0 end end
if not dddb.flags.fixNightmareChickensEXPandInfinitePetPickup then
dddb.flags.fixNightmareChickensEXPandInfinitePetPickup=true;if dddb.gold>25000000 and not bcba:IsStudio()then
dddb.gold=0 end
if dddb.level==30 or dddb.exp>
a_ca.getEXPToNextLevel(dddb.level)then dddb.exp=0 end end
if not dddb.flags.statCheck then local ___c=false;local a__c=0
for b__c,c__c in pairs(bbab)do local d__c=
dddb.statistics[c__c]or 0;a__c=a__c+math.abs(d__c)end;if
a__c>a_ca.getStatPointsForLevel(dddb.level or 1)then ___c=true end;dddb.flags.statCheck=true;if
___c then for b__c,c__c in pairs(bbab)do dddb.statistics[c__c]=0 end
ccda(cddb,200)end end
if not dddb.flags.resetQuests then dddb.flags.resetQuests=true
dddb.quests={}dddb.quests.completed={}dddb.quests.active={}end
if c_ca.getConfigurationValue("doStartRevokingCheatWeapons")then
if not
dddb.flags.revokeCheatWeapons then dddb.flags.revokeCheatWeapons=true;dddb.holding={}
cbab(dddb.inventory,dddb.holding)cbab(dddb.equipment,dddb.holding)end end
if not dddb.flags.resetStatPointsForV23 then
dddb.flags.resetStatPointsForV23=true;dddb.statistics.dex=0;dddb.statistics.int=0
dddb.statistics.str=0;dddb.statistics.vit=0 end
if not dddb.flags.removeSpiderQueenCrown then
dddb.flags.removeSpiderQueenCrown=true
for ___c,a__c in pairs(dddb.inventory)do if a__c.id==68 then
table.remove(dddb.inventory,___c)end end
for ___c,a__c in pairs(dddb.equipment)do if a__c.id==68 then
table.remove(dddb.equipment,___c)end end end end
cdba:create("{2ECD2D2F-8941-4664-B665-7ED91347531F}","BindableEvent")
local function bcab(cddb,dddb)
if cbba[cddb]then for ___c,a__c in pairs(cbba[cddb].equipment)do
if a__c.position==dddb then return a__c end end end;return nil end
local function ccab(cddb,dddb)local ___c=cbba[cddb]
if ___c then dddb=string.lower(dddb)
if not
___c.abilityBooks[dddb]and adca[dddb]then local a__c={}a__c.pointsAssigned=0
___c.abilityBooks[dddb]=a__c
___c.nonSerializeData.playerDataChanged:Fire("abilityBooks")return true,"successfully granted"else if ___c.abilityBooks[dddb]then
return false,"already has book"else return false,"invalid book"end end end;return false,"invalid playerData"end
local function dcab(cddb)local dddb=cbba[cddb]
for ___c,a__c in pairs(dddb.quests.active)do
if a__c.QUEST_VERSION==nil then
if
a__c.id==2 or a__c.id==1 then
table.remove(dddb.quests.active,___c)else a__c.QUEST_VERSION=_dca[a__c.id].QUEST_VERSION end elseif a__c.QUEST_VERSION~=_dca[a__c.id].QUEST_VERSION then
table.remove(dddb.quests.active,___c)elseif
#a__c.objectives~=#_dca[a__c.id].objectives then table.remove(dddb.quests.active,___c)else end end
dddb.nonSerializeData.playerDataChanged:Fire("quests")end;local _dab=Instance.new("Folder")_dab.Name="spawnPoints"
local function adab(cddb)
if cddb then
local dddb=Instance.new("CFrameValue")
dddb.Name=
( (cddb.Name:lower()=="spawnpoint"or cddb.Name:lower()==
"spawnpart")and"default")or cddb.Name;dddb.Value=cddb.CFrame;if cddb:FindFirstChild("description")then
cddb.description:Clone().Parent=dddb end;dddb.Parent=_dab end end;for cddb,dddb in
pairs(game.CollectionService:GetTagged("spawnPoint"))do adab(dddb)end
game.CollectionService:GetInstanceAddedSignal("spawnPoint"):Connect(adab)local bdab={}
local function cdab(cddb)
if bdab[tostring(cddb)]then return bdab[tostring(cddb)]else
local dddb=game.MarketplaceService:GetProductInfo(cddb,Enum.InfoType.Asset)local ___c=dddb.Name;if ___c then ___c=string.gsub(___c," %(Demo%)","")
bdab[tostring(cddb)]=___c;return ___c end end;return"???"end
local function ddab(cddb)
if cddb and cddb:FindFirstChild("teleportDestination")then
local dddb=Instance.new("CFrameValue")
local ___c=ddba.placeIdForGame(cddb.teleportDestination.Value)dddb.Name=tostring(___c)dddb.Value=cddb.CFrame;dddb.Parent=_dab
local a__c=Instance.new("BoolValue")a__c.Name="isLoadBarrier"a__c.Value=true;a__c.Parent=dddb
if
cddb:FindFirstChild("ignore")==nil then
spawn(function()local b__c=Instance.new("StringValue")
b__c.Name="description"b__c.Value="Path to "..cdab(___c)b__c.Parent=dddb end)end end end;for cddb,dddb in
pairs(game.CollectionService:GetTagged("teleportPart"))do ddab(dddb)end
game.CollectionService:GetInstanceAddedSignal("teleportPart"):Connect(ddab)_dab.Parent=game.ReplicatedStorage
cdba:create("{723A57E9-71EF-444B-9AAC-EB43661ABF81}","RemoteEvent","OnServerEvent",function(cddb,dddb)
if
dddb=="xbox"or dddb=="mobile"or dddb=="pc"then if
cddb:FindFirstChild("input")then cddb.input.Value=dddb end end end)
local function __bb(cddb,dddb,___c,a__c)
if cddb:FindFirstChild("DataLoaded")or cbba[cddb]then
spawn(function()end)return false,nil,"Data already loaded"end;local b__c=cddb:GetJoinData()local c__c;if b__c and b__c.TeleportData then
c__c=
(
b__c.TeleportData.members and b__c.TeleportData.members[cddb.Name])or b__c.TeleportData end
if
not
(


(c__c and
c__c.destination==game.PlaceId)or game.PlaceId==2015602902 or game.PlaceId==2015602902 or
game.PlaceId==2376885433 or bcba:IsRunMode()or bcba:IsStudio())then
if cddb:GetRankInGroup(4238824)<250 then
if game.PlaceId~=2103419922 then
cddb:Kick("Not authorized")
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"debug","Player not authorized to join server")return false end end end;local d__c;local _a_c;local aa_c
if c__c then dddb=c__c.dataSlot;___c=c__c.dataTimestamp
if c__c.analyticsSessionId and
c__c.joinTime then d__c=c__c.analyticsSessionId;_a_c=c__c.joinTime end;if c__c.playerAccessories then a__c=c__c.playerAccessories end
if
c__c.partyData and c__c.partyData.guid then
cdba:invoke("{B72FD5E1-83AD-4FB2-A8A0-B93945527CE6}",cddb,c__c.partyData.guid,c__c.partyData.partyLeaderUserId)end;if c__c.wasReferred then aa_c=true end;local aaac=c__c.arrivingFrom
if aaac and
aaac~=2376885433 and aaac~=2015602902 then
spawn(function()local baac=cdab(aaac)
if
c__c.teleportType and c__c.teleportType=="rune"then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=
cddb.Name.." arrived from "..baac.." via a magical rune.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})elseif c__c.teleportType and c__c.teleportType=="death"then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=
cddb.Name.." escaped from "..baac..".",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})elseif c__c.teleportType and c__c.teleportType=="taxi"then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=
cddb.Name.." arrived from "..baac.." via Taximan Dave.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})else
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." arrived from "..baac..".",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end end)else
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." connected.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end end;dddb=dddb or 1
local ba_c,ca_c,da_c=_cba:getPlayerSaveFileData(cddb,dddb,___c)
if not ba_c then
warn("Failed to load "..cddb.Name..
"'s data from slot "..dddb.." ("..da_c..")")
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error","Failed to load player data: "..da_c)
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"data:fail:load")return false,nil,da_c end
if ca_c==nil then warn("Player data is nil???")end
if
game.PlaceId==2376885433 or game.PlaceId==2015602902 or game.PlaceId==4623219432 then return ca_c end;local _b_c=Instance.new("IntValue")_b_c.Name="professions"
spawn(function()
if

game.MarketplaceService:UserOwnsGamePassAsync(cddb.userId,7785243)or game:GetService("RunService"):IsStudio()then local aaac=Instance.new("BoolValue")aaac.Name="bountyHunter"
aaac.Parent=cddb end end)
if game.ReplicatedStorage.professionLookup then
for aaac,baac in
pairs(game.ReplicatedStorage.professionLookup:GetChildren())do
if baac:IsA("ModuleScript")then ca_c.professions[baac.Name]=
ca_c.professions[baac.Name]or{level=1,exp=0}
local caac=Instance.new("IntValue")caac.Name=baac.Name
caac.Value=ca_c.professions[baac.Name].level;caac.Parent=_b_c end end end;_b_c.Parent=cddb;local ab_c=Instance.new("IntValue")
ab_c.Name="level"ab_c.Value=ca_c.level;ab_c.Parent=cddb
local bb_c=Instance.new("NumberValue")bb_c.Name="gold"bb_c.Value=ca_c.gold;bb_c.Parent=cddb
spawn(function()
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,
"level:lvl"..tostring(ca_c.level),ca_c.level)end)local cb_c=Instance.new("StringValue")cb_c.Name="input"
cb_c.Parent=cddb;local db_c=Instance.new("StringValue")db_c.Name="class"
db_c.Value=ca_c.class;db_c.Parent=cddb;local _c_c=Instance.new("BoolValue")
_c_c.Name="isPVPEnabled"_c_c.Value=false;_c_c.Parent=cddb
local ac_c=Instance.new("BoolValue")ac_c.Name="isInPVP"ac_c.Value=false;ac_c.Parent=cddb
local bc_c=Instance.new("StringValue")bc_c.Name="entityGUID"bc_c.Value=_dba:GenerateGUID(false)
bc_c.Parent=cddb;local cc_c=Instance.new("IntValue")cc_c.Name="playerSpawnTime"
cc_c.Value=os.time()cc_c.Parent=cddb;local dc_c=Instance.new("BoolValue")
dc_c.Name="isPlayerSpawning"dc_c.Value=true;dc_c.Parent=cddb
local _d_c=Instance.new("BoolValue")_d_c.Name="isFirstTimeSpawning"_d_c.Value=true;_d_c.Parent=dc_c
local ad_c=Instance.new("ObjectValue")ad_c.Name="respawnPoint"ad_c.Value=nil;ad_c.Parent=cddb
if not
ca_c.flags.ancientsRevert then ca_c.flags.ancientsRevert=true;for aaac,baac in pairs(ca_c.inventory)do
if
baac.id==63 or baac.id==62 or baac.id==64 or
baac.id==17 then baac.id=200 end end
if ca_c.globalData and
ca_c.globalData.itemStorage then
if not ca_c.globalData.ancientsRevertStore then
ca_c.globalData.ancientsRevertStore=true
for aaac,baac in pairs(ca_c.globalData.itemStorage)do if
baac.id==63 or baac.id==62 or baac.id==64 or baac.id==17 then
baac.id=200 end end end end end
if not ca_c.flags.enchantWipe3 then ca_c.flags.enchantWipe3=true;if ca_c.gold>
50000 then ca_c.gold=50000 end
local function aaac(baac)if baac.modifierData then
baac.modifierData={}end;if baac.upgrades then baac.upgrades=0 end;if
baac.successfulUpgrades then baac.successfulUpgrades=0 end;if baac.blessed then
baac.blessed=nil end
if baac.enchantments then baac.enchantments=nil end end;for baac,caac in pairs(ca_c.equipment)do aaac(caac)end;for baac,caac in
pairs(ca_c.inventory)do aaac(caac)end
if
ca_c.globalData and ca_c.globalData.itemStorage then if not ca_c.globalData.enchantWipe3 then
ca_c.globalData.enchantWipe3=true
for baac,caac in pairs(ca_c.globalData.itemStorage)do aaac(caac)end end end;ca_c.treasureChests=nil end
if not ca_c.hasCustomizedCharacter then if a__c then ca_c.accessories=a__c else
ca_c.accessories=require(adba.defaultCharacterAppearance).accessories end
ca_c.hasCustomizedCharacter=true end
ca_c.accessories.skinColorId=ca_c.accessories.skinColorId or 1
ca_c.accessories.hairColorId=ca_c.accessories.hairColorId or 1
ca_c.accessories.shirtColorId=ca_c.accessories.shirtColorId or 1;ca_c.locations=ca_c.locations or{}
if game.PrivateServerId==""and
game.PrivateServerOwnerId==0 then ca_c.locations[tostring(game.PlaceId)]=
ca_c.locations[tostring(game.PlaceId)]or{}local aaac={}
do for caac,daac in
pairs(dcba:GetTagged("spawnPoint"))do aaac[daac.Name]=daac end end
local baac=ca_c.locations[tostring(game.PlaceId)]baac.visited=os.time()baac.spawns=baac.spawns or{}
for caac,daac in
pairs(baac.spawns)do if not aaac[caac]then baac.spawns[caac]=nil end end end;ca_c.treasure=ca_c.treasure or{}
ca_c.treasure["place-"..game.PlaceId]=ca_c.treasure[
"place-"..game.PlaceId]or{}
ca_c.treasure["place-"..game.PlaceId].chests=ca_c.treasure[
"place-"..game.PlaceId].chests or{}
for aaac,baac in
pairs(game.CollectionService:GetTagged("treasureChest"))do
ca_c.treasure["place-"..game.PlaceId].chests[baac.Name]=
ca_c.treasure[
"place-"..game.PlaceId].chests[baac.Name]or{open=false}end
if aa_c then
if not ca_c.globalData.recievedReferralGift then
ca_c.globalData.recievedReferralGift=true
ca_c.globalData.ethyr=(ca_c.globalData.ethyr or 0)+200
cdba:fireClient("{006F08C2-1541-41ED-90BE-192482E14530}",cddb,{Text="Recieved 200 Ethyr referral bonus.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(196,209,216)})
cdba:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",cddb,"ethyr",200,"gift:referral")end end;local bd_c=ca_c.lastPhysicalPosition
if
bd_c and(ca_c.lastLocation==nil or game.PlaceId==
ca_c.lastLocation)then local aaac=Instance.new("Vector3Value")
aaac.Name="lastPhysicalPosition"
aaac.Value=Vector3.new(bd_c[1],bd_c[2],bd_c[3])aaac.Parent=cddb end
local function cd_c(aaac,baac,caac)
if aaac=="class"then cddb.class.Value=caac;da_b(cddb)elseif aaac=="gold"then
cddb.gold.Value=caac elseif aaac=="exp"then
while ca_c.level<c_da do
local daac=a_ca.getEXPToNextLevel(ca_c.level)
if ca_c.exp>=daac then ca_c.exp=ca_c.exp-daac
ca_c.nonSerializeData.incrementPlayerData("level",1)cddb.level.Value=cddb.level.Value+1
spawn(function()
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,
"levelup:lvl"..tostring(cddb.level.Value))end)
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name..
" has reached Lvl."..cddb.level.Value.."!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,219,12)})
if cddb.Character and cddb.Character.PrimaryPart then
for bbac,cbac in
pairs(game.Players:GetPlayers())do local dbac=script.levelUp:Clone()
dbac.Adornee=cddb.Character.PrimaryPart;dbac.Parent=cbac.PlayerGui end;local _bac=Instance.new("Sound")_bac.Volume=0.7
_bac.MaxDistance=500;_bac.SoundId="rbxassetid://2066645345"
_bac.Parent=cddb.Character.PrimaryPart;_bac:Play()game.Debris:AddItem(_bac,10)
local abac=Instance.new("Attachment")abac.Parent=cddb.Character.PrimaryPart
abac.Orientation=Vector3.new(0,0,0)abac.Axis=Vector3.new(1,0,0)
abac.SecondaryAxis=Vector3.new(0,1,0)
for bbac,cbac in pairs(script.particles:GetChildren())do
local dbac=cbac:Clone()dbac.Enabled=false;dbac.Parent=abac;if dbac.Name=="Dust"then
dbac:Emit(40)else dbac:Emit(1)end end;game.Debris:AddItem(abac,10)_a_b(cddb)end else if ca_c.level>=c_da then ca_c.exp=0 end;break end end elseif aaac=="equipment"then da_b(cddb)cc_b(cddb)
cdba:fire("{04957DC0-5413-4615-AA71-FBE7E96AC10E}",cddb,ca_c.equipment)elseif aaac=="inventory"then aaab(cddb)
cdba:fire("{09C72219-6A16-49DD-8AD0-F17E13FAEDD9}",cddb)
table.sort(ca_c[aaac],function(daac,_bac)return daac.position>_bac.position end)elseif aaac=="quests"then
for daac,_bac in pairs(ca_c.quests.active)do if baab(cddb,_bac.id)==
b_ca.questState.handing then end end elseif aaac=="level"then elseif aaac=="statistics"then da_b(cddb)elseif aaac=="accessories"then cc_b(cddb)elseif
aaac=="nonSerializeData"then
cddb.isPVPEnabled.Value=ca_c.nonSerializeData.isPVPEnabled
cddb.isInPVP.Value=ca_c.nonSerializeData.isGlobalPVPEnabled or#
ca_c.nonSerializeData.whitelistPVPEnabled>0
if cddb.isInPVP.Value and cddb.Character then
__ca:setWholeCollisionGroup(cddb.Character,"pvpCharacters")elseif cddb.Character then
__ca:setWholeCollisionGroup(cddb.Character,"characters")end elseif aaac=="statusEffects"then da_b(cddb)elseif aaac=="internalData"then
warn("attempt to signal internalData changed.")end;bd_b(cddb,aaac)end
ca_c.nonSerializeData.playerDataChanged=Instance.new("BindableEvent")
ca_c.nonSerializeData.playerDataChanged.Event:connect(cd_c)if c__c and c__c.teleportType=="death"then
ca_c.condition={health=1,mana=1}end
if ca_c.packagedStatusEffects then
cdba:invoke("{717D2424-F19C-4CD6-B586-633A9D34A768}",cddb,ca_c.packagedStatusEffects)ca_c.packagedStatusEffects=nil end;da_b(cddb,true,ca_c)_d_b(cddb)cc_b(cddb,ca_c)
local function dd_c(aaac)
dc_c.Value=true;cc_c.Value=os.time()if cddb.Character~=aaac then end;if
aaac.Parent==nil then aaac.Parent=bbca end
if aaac.PrimaryPart==nil then repeat wait(0.1)until

aaac.PrimaryPart or aaac:FindFirstChild("hitbox")or aaac.Parent==nil end
if aaac.Parent==nil then if cddb.Character==aaac then aaac.Parent=bbca else
aaac:Destroy()return end end
if
aaac:FindFirstChild("hitbox")and aaac.PrimaryPart~=aaac.hitbox then aaac.PrimaryPart=aaac.hitbox end;cc_b(cddb,ca_c)_d_b(cddb,ca_c)local baac=aaac.PrimaryPart;pcall(function()
baac:SetNetworkOwner(cddb)end)local caac
do if
cddb:FindFirstChild("lastPhysicalPosition")then caac=cddb.lastPhysicalPosition.Value
cddb.lastPhysicalPosition:Destroy()end end;local daac
do
if caac then
daac=CFrame.new(caac)+Vector3.new(0,4,0)elseif adba:FindFirstChild("spawnPoints")then
local abac=
c__c and
( (c__c.spawnLocation and
adba.spawnPoints:FindFirstChild(c__c.spawnLocation))or c__c.arrivingFrom and
adba.spawnPoints:FindFirstChild(c__c.arrivingFrom))or adba.spawnPoints:FindFirstChild("default")
if
cddb:FindFirstChild("respawnPoint")and cddb.respawnPoint.Value then abac=cddb.respawnPoint.Value end
if abac then local bbac=abac.Value
local cbac=baac.CFrame-baac.CFrame.p+bbac.p+
bbac.lookVector*30 +Vector3.new(math.random()*3,4,
math.random()*3)
local dbac=(abac:FindFirstChild("isLoadBarrier")~=nil)
if not dbac then cbac=bbac+
Vector3.new(math.random(-3,3),math.random(3,5),math.random(-3,3))end;daac=cbac elseif
#adba.spawnPoints:GetChildren()>0 then
warn(">> spawn point missing!",c__c and c__c.arrivingFrom or"no default found")warn(">> using first spawnPoint")
local bbac=adba.spawnPoints:GetChildren()[1].Value
local cbac=
baac.CFrame-baac.CFrame.p+bbac.p+bbac.lookVector*30 +
Vector3.new(math.random()*3,4,math.random()*3)daac=cbac else warn(">> no spawn points at all.. ?")end else warn(">> no spawnPoints ?")end end;local _bac=cddb:FindFirstChild("resurrecting")if _bac~=nil then
_bac:Destroy()daac=nil end
if daac then
local abac=Ray.new(daac.p+Vector3.new(0,2,0),Vector3.new(0,
-999,0))local bbac,cbac=a_da.raycast(abac,{aaac,bbca})
if bbac then wait(0.1)for i=1,8 do
cdba:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",cddb,daac)wait(0.2)end end end;if
cddb.Character==aaac and baac.state.Value~="dead"then dc_c.Value=false end end;if cddb.Character then
spawn(function()dd_c(cddb.Character)end)end
cddb.CharacterAdded:connect(dd_c)cbba[cddb]=ca_c;acab(cddb,ca_c)aaab(cddb)dcab(cddb)
local __ac,a_ac=pcall(function()return
cddb:GetRankInGroup(4238824)end)
if
(bcba:IsStudio()or
(__ac and type(a_ac)=="number"and a_ac>=254))and not ca_c.abilityBooks.admin then warn("GRANTING ADMIN BOOK TO",cddb)
ccab(cddb,"admin")end;bc_b(cddb)
function ca_c.nonSerializeData.setPlayerData(aaac,baac)local caac=ca_c[aaac]
ca_c[aaac]=baac
ca_c.nonSerializeData.playerDataChanged:Fire(aaac,caac,ca_c[aaac])end
function ca_c.nonSerializeData.incrementPlayerData(aaac,baac,caac)if
aaac=="exp"and ca_c.level>=c_da then return end;local daac=ca_c[aaac]ca_c[aaac]=daac+baac
ca_c.nonSerializeData.playerDataChanged:Fire(aaac,daac,ca_c[aaac])
if aaac=="gold"then local _bac=aaac;local abac=baac;if abac~=0 and caac then
cdba:invoke("{DC1AA741-408D-49CF-87F9-CD63B55E82D7}",cddb,_bac,abac,caac)end end end
function ca_c.nonSerializeData.setNonSerializeDataValue(aaac,baac)
ca_c.nonSerializeData[aaac]=baac
ca_c.nonSerializeData.playerDataChanged:Fire("nonSerializeData")end
if cddb.Character and cddb.Character.PrimaryPart then spawn(function()
_c_b(cddb,cddb.Character)end)end
cddb.CharacterAdded:connect(function(aaac)while
not aaac.PrimaryPart and cddb.Parent==game.Players do wait(0.1)end;if aaac.PrimaryPart then
_c_b(cddb,aaac)end end)local b_ac=Instance.new("BoolValue")b_ac.Name="DataLoaded"
b_ac.Parent=cddb;local c_ac=Instance.new("IntValue")c_ac.Name="dataLoaded"
c_ac.Value=os.time()c_ac.Parent=cddb
cdba:fire("{2ECD2D2F-8941-4664-B665-7ED91347531F}",cddb,cbba[cddb])local d_ac=Instance.new("Vector3Value")
d_ac.Name="playerCharacterPosition"d_ac.Parent=cddb
spawn(function()
while cddb and cddb.Parent==game.Players do if
cddb.Character and cddb.Character.PrimaryPart then
d_ac.Value=cddb.Character.PrimaryPart.Position end;wait(3)end end)
spawn(function()local aaac=game:GetService("Players")
while
cddb and cddb.Parent==aaac do local baac=cbba[cddb]
if
baac and cddb.Character and cddb.Character.PrimaryPart then local caac=cddb.Character.PrimaryPart.Position
baac["lastPhysicalPosition"]={math.floor(caac.X),math.floor(caac.Y),math.floor(caac.Z)}end;wait(3)end end)
spawn(function()wait(60)local aaac=0
while cddb and cddb.Parent==game.Players and
cddb:FindFirstChild("DataLoaded")do local baac=180
if
cddb:FindFirstChild("teleporting")==nil and cbba[cddb]then
local caac,daac=abab(cddb)if not caac then if aaac==0 then baac=10 elseif aaac<=3 then baac=20 else baac=60 end;aaac=
aaac+1 end end;wait(baac)end end)
spawn(function()
if cddb:IsInGroup(1200769)then
local aaac="An admin ("..cddb.Name..") joined the game."
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"info",aaac)elseif cddb:IsInGroup(4199740)then
local aaac="A Star Creator ("..cddb.Name..") joined the game."
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"info",aaac)end
if cddb:IsInGroup(4484634)then
local aaac="A Red Manta ("..cddb.Name..") joined the game."
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"info",aaac)end end)if d__c then
cdba:invoke("{2622D1E7-1984-45B6-97E2-F64594348B36}",cddb,d__c,_a_c)else
cdba:invoke("{CE411E74-1334-428C-8E1A-9480BE291C52}",cddb)end
local _aac={}_aac.positions={}_aac.sketchyMovements={}dbba[cddb]=_aac
for aaac,baac in
pairs(ca_c.equipment)do local caac=acca[baac.id]
if caac.perks then
for daac,_bac in pairs(caac.perks)do local abac=ccca[daac]
if abac and
abac.onEquipped then
local bbac,cbac=pcall(function()
abac.onEquipped(cddb,caac,tostring(baac.position))end)if not bbac then
warn(string.format("item %s equip failed because: %s",caac.name,cbac))end end end end end
spawn(function()if game.PlaceId~=4409709778 then return end;local aaac=0
if ca_c.globalData then aaac=
ca_c.globalData.lastSaveTimestamp or 0 end
if not ca_c.flags.dataRecovery11_14 then
if aaac<1573760698 then
ca_c.flags.dataRecovery11_14=true else performDataRecovery(cddb,dddb,"dataRecovery11_14")end end end)return true,ca_c,da_c end
function performDataRecovery(cddb,dddb,___c)local a__c=cbba[cddb]
if game.PlaceId==4409709778 then while true do wait(1)
cdba:fireClient("{70D48E6D-FA55-4F16-AA91-62D20043AA2C}",cddb,a__c,dddb,___c)end else
a__c.dataRecoveryReturnPlaceId=game.PlaceId;repeat wait(1)until
cdba:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",cddb,4409709778)end end;local a_bb={"dataRecovery11_14"}
function onDataRecoveryRejected(cddb,dddb)local ___c=false;for b__c,c__c in pairs(a_bb)do if
c__c==dddb then ___c=true end end
if not ___c then return end;local a__c=cbba[cddb]if not a__c then return end
if a__c.flags[dddb]then return end;a__c.flags[dddb]=true;repeat wait(1)until
cdba:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",cddb,a__c.dataRecoveryReturnPlaceId)end
function onDataRecoveryRequested(cddb,dddb,___c,a__c)if game.PlaceId~=4409709778 then return end;local b__c=false;for ca_c,da_c in
pairs(a_bb)do if da_c==a__c then b__c=true end end;if not b__c then
return end;local c__c=cbba[cddb]if c__c.flags[a__c]then return end
local d__c=_cba:getLatestSaveVersion(cddb)local _a_c,aa_c,ba_c=_cba:getPlayerSaveFileData(cddb,dddb,___c)if not
_a_c then return end;aa_c.timestamp=c__c.timestamp
aa_c.globalData.version=c__c.globalData.version;aa_c.flags[a__c]=true;cbba[cddb]=aa_c
_cba:updatePlayerSaveFileData(cddb.UserId,aa_c)repeat wait(1)until
cdba:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",cddb,c__c.dataRecoveryReturnPlaceId)end
game:BindToClose(function()if acba then return false end;acba=true
local cddb=Instance.new("Message")
cddb.Text="Servers are shutting down for a Vesteria or Roblox client update. Your data is now saving..."cddb.Parent=workspace;if
game:GetService("RunService"):IsStudio()then return end;local dddb={}local ___c=0
for a__c,b__c in
pairs(game.Players:GetPlayers())do local c__c=b__c.Name;dddb[c__c]=b__c;___c=___c+1
spawn(function()
local d__c,_a_c=pcall(dbda,b__c)
if d__c then dddb[c__c]=nil;___c=___c-1;local aa_c=2376885433;if game.GameId==712031239 then
aa_c=2015602902 end
game:GetService("TeleportService"):Teleport(aa_c,b__c,{teleportReason="You were teleported back to the lobby because Vesteria your server was shutdown. This probably means we released an update for new content or bug fixes."},game.ReplicatedStorage.returnToLobby)else warn("Failed to save",c__c,"data")warn(_a_c)end end)end;repeat wait(0.1)until ___c<=0 end)local b_bb=game:GetService("TeleportService")
local function c_bb(cddb)
if not
cddb:FindFirstChild("teleporting")then local dddb=Instance.new("BoolValue")
dddb.Name="teleporting"dddb.Parent=cddb
cdba:invoke("{6A0193EE-9965-481B-BD03-C21883D9F0A2}",cddb,"teleport:attempt")local ___c=dbda(cddb)if ___c then return ___c end end end
cdba:create("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}","RemoteEvent")
local function d_bb(cddb,dddb)
if cddb:FindFirstChild("DataSaveFailed")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Cannot teleport during a DataStore outage.",textColor3=Color3.fromRGB(255,57,60)})return false end;if
cddb:FindFirstChild("Teleporting")or cddb:FindFirstChild("teleporting")then return false end;if
cddb:FindFirstChild("DataLoaded")==nil then return false end
dddb=ddba.placeIdForGame(dddb)local ___c=c_bb(cddb)
if ___c then local a__c={}a__c.arrivingFrom=game.PlaceId
a__c.destination=dddb;a__c.dataTimestamp=___c;a__c.dataSlot=cddb.dataSlot.Value
a__c.analyticsSessionId=cddb.AnalyticsSessionId.Value;a__c.joinTime=cddb.JoinTime.Value
a__c.partyData=cdba:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",cddb)return a__c else
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Failed to save your data. Teleportation canceled.",textColor3=Color3.fromRGB(255,57,60)})return false end end
cdba:create("{55BEAE08-C986-4797-ACCA-3BD3191B0161}","BindableFunction","OnInvoke",d_bb)
local function _abb(cddb,dddb,___c,a__c)for d__c,_a_c in pairs(cddb)do
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",_a_c,{text="Preparing to teleport party..."})end
local b__c={}b__c.members={}
for d__c,_a_c in pairs(cddb)do
if _a_c:FindFirstChild("teleporting")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",_a_c,{text=
"Party teleport failed: ".._a_c.Name.." is already teleporting.",textColor3=Color3.fromRGB(255,57,60)})return false end end;local c__c={}
for d__c,_a_c in pairs(cddb)do local aa_c=d_bb(_a_c,dddb)
warn(_a_c.Name,"teleport data",game.HttpService:JSONEncode(aa_c))
if aa_c and aa_c.partyData then aa_c.partyData.partyLeaderUserId=___c;if a__c then
aa_c.spawnLocation=a__c end;table.insert(c__c,_a_c)
b__c.members[_a_c.Name]=aa_c else
for ba_c,ca_c in pairs(cddb)do
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",ca_c,{text=_a_c.Name.." failed to teleport with the party.",textColor3=Color3.fromRGB(234,129,59)})end end end;if#c__c>0 then
warn("group data",game.HttpService:JSONEncode(b__c))return c__c,b__c else return false end end
local function aabb(cddb)cddb=ddba.placeIdForGame(cddb)local dddb
local ___c,a__c=pcall(function()
local b__c=game:GetService("DataStoreService"):GetDataStore(
"mirrorWorld"..c_ca.getConfigurationValue("mirrorWorldVersion"))dddb=b__c:GetAsync(tostring(cddb))
if dddb==nil then
dddb=b_bb:ReserveServer(cddb)b__c:SetAsync(tostring(cddb),dddb)end end)return dddb,___c,a__c end
local function babb(cddb,dddb,___c,a__c,b__c,c__c)dddb=ddba.placeIdForGame(dddb)b__c=b__c or"default"c__c=c__c or
b_bb:ReserveServer(dddb)
for d__c,_a_c in pairs(cddb)do
spawn(function()if
_a_c:FindFirstChild("teleporting")then return false end
if

_a_c:FindFirstChild("dataLoaded")==nil or os.time()-_a_c.dataLoaded.Value<=5 then return false,"Please wait before teleporting"end
cdba:fireClient("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}",_a_c,dddb)local aa_c=d_bb(_a_c,dddb)
if aa_c then if ___c then aa_c.spawnLocation=___c end
aa_c.teleportType=b__c
if game.ReplicatedStorage:FindFirstChild("mirrorWorld")or
a__c=="mirror"then local ba_c=aabb(dddb)
if ba_c then b_bb:TeleportToPrivateServer(dddb,ba_c,{_a_c},
nil,aa_c)else return false,
"Failed to find mirror world reserve server key"end else
b_bb:TeleportToPrivateServer(dddb,c__c,{_a_c},nil,aa_c)end end;return false,"Failed to prepare teleportData"end)end end
cdba:create("{B95C5E85-0C22-4055-B2AF-C8C75989CC05}","BindableFunction","OnInvoke",babb)
cdba:create("{BABBBE4B-021B-487B-B164-FC5BA4714DC7}","BindableFunction","OnInvoke",_abb)
local function cabb(cddb,dddb,___c,a__c)dddb=ddba.placeIdForGame(dddb)
local b__c,c__c=_abb(cddb,dddb,___c,a__c)
if b__c and c__c then local d__c=""local _a_c=#cddb;for aa_c,ba_c in pairs(cddb)do d__c=d__c..ba_c.Name
if _a_c>1 and
aa_c==_a_c-1 then d__c=d__c.." & "elseif aa_c<_a_c then d__c=d__c..","end end
if
game.ReplicatedStorage:FindFirstChild("mirrorWorld")then local aa_c=aabb(dddb)
if aa_c then
b_bb:TeleportToPrivateServer(dddb,aa_c,b__c,nil,c__c)else return false,"Failed to find key for mirror world teleport"end else b_bb:TeleportPartyAsync(dddb,b__c,c__c)end
spawn(function()
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=d__c..
" departed towards "..cdab(dddb)..".",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end)return true,"Teleporting"end;return false,"Failed to teleport"end
cdba:create("{3CF9481C-6B35-4D71-B2CE-FAD7DE6716B1}","BindableFunction","OnInvoke",cabb)
local function dabb(cddb,dddb,___c,a__c)dddb=ddba.placeIdForGame(dddb)local b__c="serverBrowser"if
cddb:FindFirstChild("teleporting")then return false end
if

cddb:FindFirstChild("dataLoaded")==nil or os.time()-cddb.dataLoaded.Value<=5 then return false,"Please wait before teleporting"end
cdba:fireClient("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}",cddb,dddb)local c__c=d_bb(cddb,dddb)
if c__c then if a__c then c__c.spawnLocation=a__c end
c__c.teleportType=b__c
spawn(function()
game:GetService("TeleportService"):TeleportToPlaceInstance(dddb,___c,cddb,nil,c__c)end)return true,"teleporting"end;return false,"failed to prepare teleportdata"end
cdba:create("{BFC58A69-50E2-4B4A-B15A-FB2B9E21BB21}","BindableFunction","OnInvoke",dabb)
local function _bbb(cddb,dddb,___c,a__c,b__c)dddb=ddba.placeIdForGame(dddb)local c__c=cddb.Name
b__c=b__c or"default"if cddb:FindFirstChild("teleporting")then return false end;if
cddb:FindFirstChild("dataLoaded")==nil or
os.time()-cddb.dataLoaded.Value<=5 then
return false,"Please wait before teleporting"end
cdba:fireClient("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}",cddb,dddb,b__c)local d__c=d_bb(cddb,dddb)
if d__c then if ___c then d__c.spawnLocation=___c end
d__c.teleportType=b__c
if game.ReplicatedStorage:FindFirstChild("mirrorWorld")or
a__c=="mirror"then local _a_c=aabb(dddb)
if _a_c then b_bb:TeleportToPrivateServer(dddb,_a_c,{cddb},
nil,d__c)
return true,"teleporting"else return false,"Failed to find key for mirror world teleport"end else
spawn(function()
game:GetService("TeleportService"):Teleport(dddb,cddb,d__c)end)
if
b__c=="death"and not cddb:FindFirstChild("disconnected")then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=c__c.." escaped to "..cdab(dddb)..".",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end;return true,"teleporting"end end;return false,"failed to prepare teleportdata"end
cdba:create("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}","BindableFunction","OnInvoke",_bbb)
cdba:create("{283E214A-12D2-429B-9945-85DFCC54DCEA}","BindableFunction","OnInvoke",function(cddb,dddb)
dddb=ddba.placeIdForGame(dddb)local ___c=cddb.Name;local a__c,b__c=_bbb(cddb,dddb,nil,nil,"rune")
if a__c then
spawn(function()
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=
___c..
" departed towards "..cdab(dddb).." using a magical rune.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end)end;return a__c,b__c end)
local function abbb(cddb,dddb)
if dddb and dddb:IsA("BasePart")and
game.CollectionService:HasTag(dddb,"teleportPart")and
dddb:FindFirstChild("teleportDestination")then
if cddb.Character and
cddb.Character.PrimaryPart and
cddb:DistanceFromCharacter(dddb.Position)<=50 then local ___c=cddb.Name
local a__c,b__c=_bbb(cddb,dddb.teleportDestination.Value)
if a__c then
spawn(function()
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=___c.." departed towards "..
cdab(dddb.teleportDestination.Value)..".",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(45,87,255)})end)end;return a__c,b__c end end;return false end
cdba:create("{E6EA6870-28C2-4310-AA18-85AF3489A3FF}","RemoteFunction","OnServerInvoke",abbb)
b_bb.TeleportInitFailed:connect(function(cddb,dddb,___c)
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"warning",
"Player failed to teleport: "..___c)end)
local function bbbb(cddb,dddb,___c)local a__c
if cbba[cddb]then
for b__c,c__c in pairs(cbba[cddb].inventory)do local d__c=acca[c__c.id]
if


c__c.id==dddb and(not a__c or c__c.position<a__c.position)and(not ___c or
(c__c.stacks and c__c.stacks< (d__c.stackSize or cdda)))then a__c=c__c end end end;return a__c end
local function cbbb(cddb,dddb,___c)if not cddb or not cbba[cddb]then return nil end
for a__c,b__c in
pairs(cbba[cddb].inventory)do local c__c=acca[b__c.id]
if c__c and c__c.category==dddb then if
b__c.position==___c then return b__c,a__c end end end;return nil end
local function dbbb(cddb,dddb,___c,a__c,b__c,c__c,d__c)local _a_c=cbba[cddb]
if cddb and _a_c and dddb and a__c then
local aa_c,ba_c=__ab(cddb,dddb)local ca_c=a_ab(cddb,aa_c,a__c)
if not ba_c and ca_c then
if
not ___c or _a_c.gold>=___c then c_ab(cddb,aa_c)if ___c and ___c~=0 then
_a_c.nonSerializeData.incrementPlayerData("gold",-___c,c__c)end;b_ab(cddb,a__c)if
b__c and b__c~=0 then
_a_c.nonSerializeData.incrementPlayerData("gold",b__c,c__c)end;if not
(d__c and d__c.overrideItemsRecieved)then
cdba:fireClient("{2ABFAB8F-ADB5-403F-B04E-FBFAD43EE8D4}",cddb,a__c,b__c)end;return true else return false,
cddb.Name.." does not have enough gold"end else return false,
ba_c and"Player inventory was modified"or"Not enough space in inventory!"end end;return false,"denied straight-up"end
local function _cbb(cddb,dddb,___c,a__c,b__c,c__c)local d__c=cbba[cddb]local _a_c=cbba[a__c]
if

cddb:FindFirstChild("DataSaveFailed")or a__c:FindFirstChild("DataSaveFailed")then return false,"player is experiencing a DataStore outage"end
if d__c and _a_c then local aa_c=a_ab(cddb,dddb,b__c)
if aa_c then
local ba_c=a_ab(a__c,b__c,dddb)
if ba_c then c_ab(cddb,dddb)c_ab(a__c,b__c)b_ab(cddb,b__c)
b_ab(a__c,dddb)local ca_c="player:trade"
d__c.nonSerializeData.incrementPlayerData("gold",-___c,ca_c)
d__c.nonSerializeData.incrementPlayerData("gold",c__c*0.7,ca_c)
_a_c.nonSerializeData.incrementPlayerData("gold",-c__c,ca_c)
_a_c.nonSerializeData.incrementPlayerData("gold",___c*0.7,ca_c)
d__c.nonSerializeData.playerDataChanged:Fire("inventory")
_a_c.nonSerializeData.playerDataChanged:Fire("inventory")return true,"ALL GOOD!!!"else
return false,a__c.Name.." does not have inventory space."end else
return false,cddb.Name.." does not have inventory space."end end;return false,"ERROR!"end
local function acbb(cddb,dddb,___c,a__c,b__c,c__c)
if
not c_ca.getConfigurationValue("isTradingEnabled",cddb)or
not c_ca.getConfigurationValue("isTradingEnabled",a__c)then return false,
"This feature has been disabled"end
if cddb:FindFirstChild("DataSaveFailed")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Cannot trade during DataStore outage.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end
if cddb and a__c and dddb and b__c then
do local ca_c={}for _b_c,ab_c in pairs(dddb)do
table.insert(ca_c,ab_c)end;local da_c={}for _b_c,ab_c in pairs(b__c)do
table.insert(da_c,ab_c)end;dddb=ca_c;b__c=da_c end
if cddb:FindFirstChild("DataSaveFailed")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Cannot trade during DataStore outage. Trade canceled.",textColor3=Color3.fromRGB(255,57,60)})
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",a__c,{text="Other player is experiencing a DataStore outage. Trade canceled.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end
if a__c:FindFirstChild("DataSaveFailed")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",a__c,{text="Cannot trade during DataStore outage. Trade canceled.",textColor3=Color3.fromRGB(255,57,60)})
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Other player is experiencing a DataStore outage. Trade canceled.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end;local d__c,_a_c=__ab(cddb,dddb)local aa_c,ba_c=__ab(a__c,b__c)
if not _a_c then
if not ba_c then
local ca_c,da_c=_cbb(cddb,d__c,___c,a__c,aa_c,c__c)if ca_c then end;return ca_c,da_c else
return false,a__c.Name.." has invalid data"end else return false,cddb.Name.." has invalid data"end end;return false,"invalid data"end
local function bcbb(cddb,dddb)local ___c=cbba[cddb]
if ___c then for a__c,b__c in pairs(___c.quests.active)do
if b__c.id==dddb then return true end end end;return false end
local function ccbb(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then local b__c={}
if dddb=="monster-killed"then
if
cddb:FindFirstChild("bountyHunter")then local c__c=___c.monsterName;a__c.bountyBook[c__c]=(a__c.bountyBook[c__c])or
{kills=0,lastBounty=0}a__c.bountyBook[c__c].kills=
a__c.bountyBook[c__c].kills+1
bd_b(cddb,"bountyBook")end
for c__c,d__c in pairs(a__c.quests.active)do local _a_c=false
for aa_c,ba_c in pairs(d__c.objectives)do if aa_c>
d__c.currentObjective then break end;if not ba_c.started then break end
for ca_c,da_c in
pairs(ba_c.steps)do
if
da_c.triggerType==dddb and
(not da_c.requirement.monsterName or
da_c.requirement.monsterName==___c.monsterName)and
da_c.completion.amount<da_c.requirement.amount then
if da_c.requirement.isGiant and
not(
___c.monster.giant or ___c.monster.superGiant or ___c.monster.gigaGiant)then break end
da_c.completion.amount=da_c.completion.amount+1
if not _a_c then table.insert(b__c,d__c)_a_c=true end
local _b_c=da_c.requirement.monsterName or"Any monster"
if da_c.hideAlert==nil then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{id=d__c.id.."s".._b_c,text=
(_b_c)..": "..

math.clamp(da_c.completion.amount,0,da_c.requirement.amount).." / "..da_c.requirement.amount})end
if da_c.completion.amount>=da_c.requirement.amount then local ab_c=d__c
local bb_c={text=
"Task complete: "..ab_c.objectives[ab_c.currentObjective].objectiveName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,255,162),backgroundTransparency=0,id=
ab_c.id.."s"}if da_c.hideAlert==nil then end end end end end end elseif dddb=="item-collected"or dddb=="item-lost"then
for c__c,d__c in
pairs(a__c.quests.active)do local _a_c=false
for aa_c,ba_c in pairs(d__c.objectives)do
if aa_c>d__c.currentObjective then break end;if not ba_c.started then break end
for ca_c,da_c in pairs(ba_c.steps)do
if

da_c.triggerType==dddb and(da_c.requirement.id==___c.id)and
da_c.completion.amount<da_c.requirement.amount then
da_c.completion.amount=c__b(cddb,da_c.requirement.id)
if not _a_c then table.insert(b__c,d__c)_a_c=true end
local _b_c=acca[___c.id]and acca[___c.id].name or"Unknown"
if da_c.hideAlert==nil then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{id=d__c.id.."s".._b_c,text=
(_b_c)..": "..

math.clamp(da_c.completion.amount,0,da_c.requirement.amount).." / "..da_c.requirement.amount})end
if da_c.completion.amount>=da_c.requirement.amount then local ab_c=d__c
local bb_c={text=
"Task complete: "..ab_c.objectives[ab_c.currentObjective].objectiveName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,255,162),backgroundTransparency=0,id=
ab_c.id.."s"}if da_c.hideAlert==nil then end end end end end end else
for c__c,d__c in pairs(a__c.quests.active)do local _a_c=false
for aa_c,ba_c in pairs(d__c.objectives)do if aa_c>
d__c.currentObjective then break end;if not ba_c.started then break end
for ca_c,da_c in
pairs(ba_c.steps)do
if da_c.triggerType==dddb and
da_c.completion.amount<da_c.requirement.amount then local _b_c=true;for ab_c,bb_c in pairs(da_c.requirement)do
if ab_c~=
"amount"and bb_c~=___c[ab_c]then _b_c=false end end
if _b_c then da_c.completion.amount=
da_c.completion.amount+1;if not _a_c then
table.insert(b__c,d__c)_a_c=true end
if da_c.requirement.amount>1 then
if
___c.objectiveTitle then
if da_c.hideAlert==nil then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{id=d__c.id..
"s"..___c.objectiveTitle,text=(___c.objectiveTitle)..": "..

math.clamp(da_c.completion.amount,0,da_c.requirement.amount).." / "..da_c.requirement.amount})end end else
if ___c.objectiveTitle then
if da_c.hideAlert==nil then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{id=d__c.id.."s"..
___c.objectiveTitle,text=(___c.objectiveTitle)..": ".."Completed"})end end end
if da_c.completion.amount>=da_c.requirement.amount then local ab_c=d__c
local bb_c={text=
"Task complete: "..ab_c.objectives[ab_c.currentObjective].objectiveName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,255,162),backgroundTransparency=0,id=
ab_c.id.."s"}if da_c.hideAlert==nil then end end end end end end end end
if#b__c>0 then
for c__c,d__c in pairs(b__c)do local _a_c=d__c.currentObjective
if baab(cddb,d__c.id)==
b_ca.questState.objectiveDone or
baab(cddb,d__c.id)==b_ca.questState.handing then local aa_c=_dca[d__c.id]
local ba_c={text=
"Quest complete: "..d__c.objectives[_a_c].objectiveName.."! "..
d__c.objectives[_a_c].completedText,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(0,255,162),backgroundTransparency=0,id=
d__c.id.."s"}if d__c.objectives[_a_c].hideAlert==nil then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,ba_c,6,"questComplete")end end end
a__c.nonSerializeData.playerDataChanged:Fire("quests")end end end
local function dcbb(cddb,dddb)local ___c=cbba[cddb]if not ___c then return nil end;local a__c=_dca[dddb.id]
local b__c={}b__c.id=dddb.id;b__c.objectives={}b__c.currentObjective=1;b__c.handerName=
dddb.handerName or""
b__c.QUEST_VERSION=a__c.QUEST_VERSION or 1
for c__c,d__c in pairs(dddb.objectives)do local _a_c={}_a_c.steps={}
_a_c.completedText=d__c.completedText;_a_c.started=false;_a_c.objectiveName=d__c.objectiveName;if d__c.hideAlert then
_a_c.hideAlert=true end
for aa_c,ba_c in pairs(d__c.steps)do local ca_c={}
ca_c.triggerType=ba_c.triggerType;ca_c.requirement={}ca_c.completion={}ca_c.completion.amount=0;if
ba_c.hideAlert then ca_c.hideAlert=true end;for da_c,_b_c in pairs(ba_c.requirement)do
ca_c.requirement[da_c]=_b_c end
if ca_c.triggerType=="item-collected"and
ca_c.requirement.id then
warn("scanning for items already owned")
for da_c,_b_c in pairs(___c.inventory)do
if _b_c.id==ca_c.requirement.id then warn("+1")ca_c.completion.amount=
ca_c.completion.amount+ (_b_c.stacks or 1)end end end;table.insert(_a_c.steps,ca_c)end;table.insert(b__c.objectives,_a_c)end;return b__c end
local function _dbb(cddb,dddb,___c)local a__c=cbba[cddb]
for b__c,c__c in pairs(a__c.quests.completed)do
if c__c.id==dddb then if

_dca[dddb].repeatableData~=nil and _dca[dddb].repeatableData.value then else return false end end end
if a__c and dddb and type(dddb)=="number"then
local b__c=baab(cddb,dddb)local c__c=caab(cddb,dddb)or 1
if
b__c==b_ca.questState.unassigned or b__c==b_ca.questState.completed then
local d__c=_dca[dddb]
if d__c then local _a_c=false
if ___c then local ba_c=dcba:GetTagged("interact")
for ca_c,da_c in pairs(ba_c)do
if
da_c.Parent and da_c.Parent.Name==___c then if
(
cddb.Character.PrimaryPart.Position-da_c.Position).magnitude>25 then return false end else _a_c=true end end end;if not _a_c then return false end;if ___c==nil then return false end;if a__c.level<
d__c.objectives[c__c].requireLevel then return false end
for ba_c,ca_c in
pairs(d__c.requireQuests)do local da_c=false;for _b_c,ab_c in pairs(a__c.quests.completed)do
if ab_c.id==ca_c then da_c=true end end;if not da_c then return false end end;if
d__c.requireClass and not cada(cddb,d__c.requireClass)then return false end
for ba_c,ca_c in
pairs(a__c.quests.active)do
if ca_c.id==dddb and ca_c.canStartAfterTime then if
not d__c.repeatableData.value then return end
if os.time()<ca_c.canStartAfterTime then return end end end;local aa_c=false;for ba_c,ca_c in pairs(a__c.quests.active)do
if ca_c.id==dddb then aa_c=true end end
if aa_c then
for ba_c,ca_c in
pairs(a__c.quests.active)do
if ca_c.id==dddb then
local da_c={text="Quest started: "..
ca_c.objectives[ca_c.currentObjective].objectiveName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(172,172,172),backgroundTransparency=0}
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,da_c,4)
if ca_c.currentObjective-1 >0 then local _b_c=true;for ab_c,bb_c in
pairs(ca_c.objectives[ca_c.currentObjective-1].steps)do
if bb_c.completion.amount<bb_c.requirement.amount then _b_c=false end end
if _b_c then
ca_c.objectives[ca_c.currentObjective].started=true
for ab_c,bb_c in
pairs(ca_c.objectives[ca_c.currentObjective].steps)do
if
ca_c.currentObjective>1 and bb_c.triggerType=="item-collected"and bb_c.requirement.id then
warn("scanning for items already owned")
for cb_c,db_c in pairs(a__c.inventory)do
if db_c.id==bb_c.requirement.id then warn("+1")bb_c.completion.amount=
bb_c.completion.amount+ (db_c.stacks or 1)end end end end
a__c.nonSerializeData.playerDataChanged:Fire("quests")return true,b_ca.questState.accepted end elseif ca_c.currentObjective==1 then
ca_c.objectives[ca_c.currentObjective].started=true
for _b_c,ab_c in
pairs(ca_c.objectives[ca_c.currentObjective].steps)do
if
ab_c.triggerType=="item-collected"and ab_c.requirement.id then warn("scanning for items already owned")
for bb_c,cb_c in
pairs(a__c.inventory)do
if cb_c.id==ab_c.requirement.id then warn("+1")ab_c.completion.amount=
ab_c.completion.amount+ (cb_c.stacks or 1)end end end end
a__c.nonSerializeData.playerDataChanged:Fire("quests")return true,b_ca.questState.accepted end end end else
for ca_c,da_c in pairs(a__c.quests.active)do if da_c.id==dddb then return false end end;local ba_c=dcbb(cddb,d__c)
if ba_c then
table.insert(a__c.quests.active,ba_c)
ba_c.objectives[ba_c.currentObjective].started=true
a__c.nonSerializeData.playerDataChanged:Fire("quests")local ca_c=_dca[d__c.id]
local da_c={text="Quest started: "..
ba_c.objectives[ba_c.currentObjective].objectiveName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(172,172,172),backgroundTransparency=0}
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,da_c,4)return true,b_ca.questState.accepted else
return false,b_ca.questState.denied end end end end end;return false,b_ca.questState.denied end
local function adbb(cddb,dddb)local ___c=_dca[dddb]local a__c=cbba[cddb]local b__c=caab(cddb,dddb)
if
___c and a__c then
if ___c.objectives then local c__c={}
for d__c,_a_c in pairs(___c.objectives[b__c].steps)do
if
_a_c.triggerType=="item-collected"then local aa_c=false
for ba_c,ca_c in pairs(a__c.inventory)do
if
ca_c.id==
_a_c.requirement.id and(ca_c.stacks or 1)>=_a_c.requirement.amount then
table.insert(c__c,{id=ca_c.id,stacks=_a_c.requirement.amount or 1,position=ca_c.position,modifierData=ca_c.modifierData})aa_c=true;break end end;if not aa_c then return{},false end end end;warn("forquest",#c__c)return c__c,true end end;return{},false end
local function bdbb(cddb)
if cddb then local dddb={}
for ___c,a__c in pairs(cddb)do local b__c=acca[a__c.id]if b__c then
table.insert(dddb,{id=a__c.id,modifierData=a__c.modifierData,stacks=a__c.stacks})end end;return dddb end;return nil end
local function cdbb(cddb,dddb)local ___c=cbba[cddb]
if ___c and dddb and type(dddb)=="number"then
local a__c=_dca[dddb]
for b__c,c__c in pairs(___c.quests.active)do
if c__c.id==dddb then
table.remove(___c.quests.active,b__c)local d__c=_dca[a__c.id]
local _a_c={text="Quest Failed: "..a__c.questLineName,textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,88,66),backgroundTransparency=0,id=
a__c.id.."s"}local aa_c=true;for ba_c,ca_c in pairs(___c.quests.completed)do
if ca_c.id==dddb then aa_c=false end end;if aa_c then
table.insert(___c.quests.completed,{id=dddb,completionTime=tick(),completionTimeUTC=os.time(),failed=true})end
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,_a_c,6,"questFailed")
___c.nonSerializeData.playerDataChanged:Fire("quests")break end end end end
local function ddbb(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c and dddb and type(dddb)=="number"then
local b__c=_dca[dddb]local c__c=false
for _a_c,aa_c in pairs(a__c.quests.active)do
if aa_c.id==dddb then
if
#aa_c.objectives~=#
b__c.objectives or(aa_c.currentObjective and
aa_c.currentObjective>#b__c.objectives)then table.remove(a__c.quests.active,_a_c)
local ba_c={text="Could not turn in quest: out of date quest version",textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,88,66),backgroundTransparency=0,id=
b__c.id.."s"}
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,ba_c,6)
a__c.nonSerializeData.playerDataChanged:Fire("quests")return false end end end;local d__c=baab(cddb,dddb)
if d__c==b_ca.questState.objectiveDone or d__c==
b_ca.questState.handing then
local _a_c=caab(cddb,dddb)
if daab(cddb,dddb,_a_c)then local aa_c=false;local ba_c
for ca_c,da_c in pairs(a__c.quests.active)do
if
da_c.id==dddb then
if b__c.objectives[_a_c].rewards then
local _c_c=b__c.objectives[_a_c].rewards;local ac_c=b__c.objectives[_a_c].goldMulti
local bc_c=b__c.objectives[_a_c].expMulti;local cc_c=b__c.objectives[_a_c].level;local dc_c=bdbb(_c_c)
local _d_c,ad_c=adbb(cddb,dddb)local bd_c=false
if ___c then local cd_c=dcba:GetTagged("interact")
for dd_c,__ac in pairs(cd_c)do
if
__ac.Parent and __ac.Parent.Name==___c then if
(
cddb.Character.PrimaryPart.Position-__ac.Position).magnitude>25 then return false else bd_c=true end end end end;if not bd_c then return false end;if ___c==nil then return false end
if ad_c then
local cd_c="npc:quest"
local dd_c,__ac=dbbb(cddb,_d_c,0,dc_c,a_ca.getQuestGoldFromLevel(cc_c or 1)* (ac_c or 1),cd_c)
if dd_c then
a__c.nonSerializeData.playerDataChanged:Fire("inventory")else
local a_ac={text="Could not accept reward: not enough inventory space.",textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,88,66),backgroundTransparency=0,id=
b__c.id.."s"}
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,a_ac,6)return false,"Failed to execute trade."end else
local cd_c={text="Could not accept reward: you lack the required items.",textColor3=Color3.fromRGB(0,0,0),textStrokeTransparency=1,backgroundColor3=Color3.fromRGB(255,88,66),backgroundTransparency=0,id=
b__c.id.."s"}
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,cd_c,6)return false,"does not own all needed items"end end;if b__c.objectives[_a_c].serverOnFinish then
spawn(function()
b__c.objectives[_a_c].serverOnFinish(cddb)end)end
local _b_c=b__c.objectives[_a_c].expMulti;local ab_c=b__c.objectives[_a_c].level;local bb_c=
a_ca.getQuestEXPFromLevel(ab_c or 1)* (_b_c or 1)
a__c.nonSerializeData.incrementPlayerData("exp",bb_c)local cb_c={}cb_c[cddb.Name]=bb_c
baca:fireEventAll("playersXpGained",cb_c)local db_c=false
if da_c.currentObjective<#b__c.objectives then da_c.currentObjective=
da_c.currentObjective+1 else aa_c=true end;ba_c=da_c.currentObjective end end
for ca_c,da_c in pairs(a__c.quests.active)do
if da_c.id==dddb then
if aa_c then
table.remove(a__c.quests.active,ca_c)
if b__c.repeatableData.value then local _b_c=dcbb(cddb,b__c)_b_c.canStartAfterTime=os.time()+
b__c.repeatableData.timeInterval
table.insert(a__c.quests.active,_b_c)local ab_c=true;for bb_c,cb_c in pairs(a__c.quests.completed)do
if cb_c.id==dddb then ab_c=false end end;if ab_c then
table.insert(a__c.quests.completed,{id=dddb,completionTime=tick(),completionTimeUTC=os.time()})end else
table.insert(a__c.quests.completed,{id=dddb,completionTime=tick(),completionTimeUTC=os.time()})end;if dddb==1 then
spawn(function()
game.BadgeService:AwardBadge(cddb.userId,2124445667)end)end end end end else return false end
a__c.nonSerializeData.playerDataChanged:Fire("quests")return true,"GREAT JOB"end end;return false,"straight up deny"end
local function __cb(cddb,dddb)local ___c=cbba[cddb]
if ___c and(
dddb=="dex"or dddb=="int"or dddb=="str"or dddb=="vit")then
local a__c=

___c.statistics.dex+___c.statistics.int+___c.statistics.str+___c.statistics.vit
if
a_ca.getStatPointsForLevel(___c.level)-a__c>=1 then
___c.statistics[dddb]=___c.statistics[dddb]+1
___c.nonSerializeData.playerDataChanged:Fire("statistics")_a_b(cddb,true)return true,"All good"else return false,"not enough"end end;return false,"nope"end;local function a_cb()end
local function b_cb(cddb,dddb,___c,a__c,b__c)b__c=b__c or 1;b__c=math.floor(b__c)
if b__c>0 then
local c__c,d__c=cbbb(cddb,dddb,___c)
if c__c then local _a_c=acca[c__c.id]
if _a_c and _a_c.canStack then
local aa_c=cbbb(cddb,dddb,a__c)
if not aa_c then
local ba_c=math.min((_a_c.stackSize or cdda),c__c.stacks)local ca_c=math.clamp(b__c,1,ba_c)local da_c=ba_c-ca_c
local _b_c={id=c__c.id,count=ca_c}table.insert(cbba[cddb].inventory,_b_c)
if da_c==0 then
table.remove(cbba[cddb].inventory,d__c)else c__c.stacks=c__c.stacks-ca_c end;aaab(cddb)bd_b(cddb,"inventory")return true else
if
aa_c.id==c__c.id and
aa_c.stacks and aa_c.stacks< (_a_c.stackSize or cdda)then
local ba_c=math.clamp(b__c,1,math.min(c__c.stacks,(_a_c.stackSize or cdda)))
if c__c.stacks>=ba_c then
ba_c=math.clamp(ba_c,1,(_a_c.stackSize or cdda)-aa_c.stacks)
if c__c.stacks-ba_c==0 then
table.remove(cbba[cddb].inventory,d__c)else c__c.stacks=c__c.stacks-ba_c end;aa_c.stacks=aa_c.stacks+ba_c;aaab(cddb)
bd_b(cddb,"inventory")return true end end end end end else ccda(cddb,100)end;return false end
local function c_cb(cddb,dddb,___c,a__c)___c=___c or 1
if cbba[cddb]and acca[dddb]then local b__c=acca[dddb]
if b__c then
if
b__c.canStack then
while ___c>0 do local c__c=bbbb(cddb,dddb,true)
if c__c then
local d__c=math.clamp(___c,1,(b__c.stackSize or cdda)-
c__c.stacks)c__c.stacks=c__c.stacks+d__c;___c=___c-d__c else local d__c=math.clamp(___c,1,(b__c.stackSize or
cdda))
table.insert(cbba[cddb].inventory,{id=dddb,stacks=d__c})___c=___c-d__c end end;aaab(cddb)bd_b(cddb,"inventory")return true else ___c=___c or 1
local c__c={}do
for i=1,___c do local _a_c={id=dddb}
for aa_c,ba_c in pairs(a__c or{})do _a_c[aa_c]=ba_c end;table.insert(c__c,_a_c)end end
local d__c=a_ab(cddb,{},c__c)if d__c then b_ab(cddb,c__c)aaab(cddb)bd_b(cddb,"inventory")
return true end end end end;return false end
local function d_cb(cddb,dddb,___c,a__c)
if cbba[cddb]and ___c and a__c then
if
___c>0 and a__c>0 and ___c~=a__c and dddb then
local b__c=ddba.copyTable(cbba[cddb].inventory)local c__c;local d__c
for _a_c,aa_c in pairs(b__c)do local ba_c=acca[aa_c.id]if
ba_c and ba_c.category==dddb then
if aa_c.position==___c then c__c=_a_c elseif aa_c.position==a__c then d__c=_a_c end end end
if c__c and d__c then b__c[c__c].position=a__c
b__c[d__c].position=___c elseif c__c and not d__c then b__c[c__c].position=a__c elseif not c__c and d__c then
b__c[d__c].position=___c else bd_b(cddb,"inventory")return false end
cbba[cddb].nonSerializeData.setPlayerData("inventory",b__c)return true end end;bd_b(cddb,"inventory")return false end
local function _acb(cddb,dddb)
for ___c,a__c in pairs(cddb)do if a__c.position==dddb then return a__c,___c end end;return nil,nil end
local function aacb(cddb,dddb,___c,a__c)
if cbba[cddb]and ___c and a__c then
if ___c>0 and a__c>0 then local b__c=cbba[cddb]
local c__c=ddba.copyTable(b__c.inventory)local d__c=ddba.copyTable(b__c.equipment)local _a_c
for da_c,_b_c in pairs(c__c)do
local ab_c=acca[_b_c.id]
if ab_c and ab_c.category==dddb then
if _b_c.position==___c and dddb then
if not
ab_c.minLevel or b__c.level>=ab_c.minLevel then if
not ab_c.minimumClass or cada(cddb,ab_c.minimumClass)then _a_c=da_c else
return false,"incorrect class"end else
return false,"not high enough level"end end else end end;local aa_c
for da_c,_b_c in pairs(d__c)do if _b_c.position==a__c then aa_c=da_c end end
if _a_c then local da_c=acca[c__c[_a_c].id]
if da_c.equipmentPosition==
b_ca.equipmentPosition.arrow then print("in arrow exception")
if not aa_c then
table.insert(d__c,{position=b_ca.equipmentPosition.arrow,id=da_c.id,stacks=0})else d__c[aa_c].id=da_c.id end
cbba[cddb].nonSerializeData.setPlayerData("equipment",d__c)
baca:fireEventLocal("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",cddb)return end;local _b_c=da_c.equipmentSlot==1
local ab_c=(a__c==1)or(a__c==11)local bb_c=_b_c and ab_c;local cb_c=da_c.equipmentSlot==a__c
local db_c=bb_c or cb_c
if da_c.equipmentType=="sword"and a__c==11 then db_c=db_c and
cada(cddb,"berserker")end;if da_c.equipmentType=="shield"and a__c==11 then db_c=db_c and
cada(cddb,"knight")end
if
da_c.equipmentType=="dagger"or da_c.equipmentType=="bow"then
if a__c==
1 then local _c_c=_acb(d__c,11)if _c_c then _c_c=acca[_c_c.id]
if _c_c then db_c=db_c and(_c_c.equipmentType~=
da_c.equipmentType)end end elseif a__c==11 then
local _c_c=_acb(d__c,1)
if _c_c then _c_c=acca[_c_c.id]if _c_c then
db_c=db_c and(_c_c.equipmentType~=da_c.equipmentType)end end end end;if a__c==11 then local _c_c=da_c.equipmentType
if
_c_c=="staff"or _c_c=="greatsword"or _c_c=="fishing-rod"then db_c=false end end
if a__c==11 then
local _c_c=_acb(d__c,1)
if _c_c then _c_c=acca[_c_c.id]if _c_c then
if _c_c.equipmentType=="greatsword"and da_c.equipmentType~=
"amulet"then db_c=false end end end end
if a__c==1 and da_c.equipmentType=="greatsword"then
local _c_c=_acb(d__c,11)
if _c_c then _c_c=acca[_c_c.id]if
_c_c and(_c_c.equipmentType~="amulet")then db_c=false end end end
if not db_c then return false,"attempt to equip illegal item"end end
local function ba_c(da_c,_b_c)local ab_c=acca[da_c]
if ab_c.perks then
for bb_c,cb_c in pairs(ab_c.perks)do local db_c=ccca[bb_c]
if db_c and
db_c.onEquipped then
local _c_c,ac_c=pcall(function()
db_c.onEquipped(cddb,ab_c,tostring(_b_c))end)if not _c_c then
warn(string.format("item %s equip failed because: %s",ab_c.name,ac_c))end end end end end
local function ca_c(da_c,_b_c)local ab_c=acca[da_c]
if ab_c.perks then
for bb_c,cb_c in pairs(ab_c.perks)do local db_c=ccca[bb_c]
if db_c and
db_c.onUnequipped then
local _c_c,ac_c=pcall(function()
db_c.onUnequipped(cddb,ab_c,tostring(_b_c))end)if not _c_c then
warn(string.format("item %s unequip failed because: %s",ab_c.name,ac_c))end end end end end
if a__c==b_ca.equipmentPosition.arrow then return false end
if not _a_c and aa_c then if not a_ab(cddb,{},{d__c[aa_c]})then
bd_b(cddb,"inventory")bd_b(cddb,"equipment")
warn("inventory is full, no go")return false end
local da_c=table.remove(d__c,aa_c)da_c.position=___c;table.insert(c__c,da_c)
cbba[cddb].nonSerializeData.setPlayerData("inventory",c__c)
cbba[cddb].nonSerializeData.setPlayerData("equipment",d__c)
baca:fireEventLocal("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",cddb)ca_c(da_c.id,a__c)return true elseif _a_c and aa_c then
local da_c=table.remove(c__c,_a_c)da_c.position=a__c;local _b_c=table.remove(d__c,aa_c)
_b_c.position=___c;table.insert(c__c,_b_c)table.insert(d__c,da_c)
cbba[cddb].nonSerializeData.setPlayerData("inventory",c__c)
cbba[cddb].nonSerializeData.setPlayerData("equipment",d__c)
baca:fireEventLocal("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",cddb)ca_c(_b_c.id,a__c)ba_c(da_c.id,a__c)return true elseif
_a_c and not aa_c then local da_c=table.remove(c__c,_a_c)da_c.position=a__c
table.insert(d__c,da_c)
cbba[cddb].nonSerializeData.setPlayerData("inventory",c__c)
cbba[cddb].nonSerializeData.setPlayerData("equipment",d__c)
baca:fireEventLocal("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",cddb)ba_c(da_c.id,a__c)return true else bd_b(cddb,"inventory")
bd_b(cddb,"equipment")return false end end end;warn("straight up denial")bd_b(cddb,"inventory")
bd_b(cddb,"equipment")return false end
local function bacb(cddb)local dddb=cbba[cddb]if not dddb then return end;local ___c=dddb.equipment
if not ___c then return end;local a__c=ddba.copyTable(___c)local b__c,c__c,d__c,_a_c
for ca_c,da_c in pairs(a__c)do if
da_c.position==1 then b__c=acca[da_c.id]c__c=ca_c elseif da_c.position==11 then
d__c=acca[da_c.id]_a_c=ca_c end end;if(not b__c)or(not d__c)then return end;local aa_c=false
if
b__c.equipmentType=="dagger"then aa_c=d__c.equipmentType=="bow"elseif b__c.equipmentType=="bow"then aa_c=
d__c.equipmentType=="dagger"end;if not aa_c then return end;a__c[c__c].position=11
a__c[_a_c].position=1
dddb.nonSerializeData.setPlayerData("equipment",a__c)
local function ba_c(ca_c,da_c,_b_c)
if ca_c.perks then
for ab_c,bb_c in pairs(ca_c.perks)do local cb_c=ccca[ab_c]if cb_c and cb_c.onUnequipped then
cb_c.onUnequipped(cddb,ca_c,da_c)end;if cb_c and cb_c.onEquipped then
cb_c.onEquipped(cddb,ca_c,_b_c)end end end end;ba_c(b__c,"1","11")ba_c(d__c,"11","1")
baca:fireEventLocal("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}",cddb)end
cdba:create("{F0DA6712-143E-4B1A-AF07-76CEA9F67F46}","RemoteEvent","OnServerEvent",bacb)
cdba:create("{56442647-1FBF-41E3-96CF-6908E65BE3DB}","RemoteFunction","OnServerInvoke",bacb)
local function cacb(cddb,dddb,___c)local a__c=_ada(cddb)
if a__c and a__c.userSettings then if type(dddb)=="string"and
#dddb<40 then a__c.userSettings[dddb]=___c
bd_b(cddb,"userSettings")return true end end end
cdba:create("{824567B5-00A7-4537-A369-8994740B7212}","RemoteFunction","OnServerInvoke",cacb)
cdba:create("{BEA65892-45C0-4844-8304-F7C8619FCE8A}","BindableFunction","OnInvoke",cacb)
local function dacb(cddb,dddb,___c)
if type(___c)=="string"and#___c<40 then local a__c=_ada(cddb)local b__c=
a__c.userSettings.keybinds or{}for c__c,d__c in pairs(b__c)do
if d__c==___c then b__c[c__c]=nil end end;b__c[dddb]=___c
a__c.userSettings.keybinds=b__c;bd_b(cddb,"userSettings")return true end end
cdba:create("{134272B3-131D-418B-8574-31B002C7571C}","RemoteFunction","OnServerInvoke",dacb)
local function _bcb(cddb,dddb)cddb.Character.PrimaryPart.health.Value=
cddb.Character.PrimaryPart.health.Value-dddb end
local function abcb(cddb,dddb)local ___c=cbba[cddb]
if ___c then for a__c,b__c in pairs(___c.inventory)do
if b__c.position==dddb.position and
b__c.id==dddb.id then return a__c,b__c end end end;return nil,nil end
local function bbcb(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c=acca[dddb.id]
for b__c,c__c in pairs(___c.equipment)do
local d__c=acca[c__c.id]if
c__c.position==dddb.position and d__c.category==a__c.category then return b__c,c__c end end end;return nil,nil end
cdba:create("{5F04834B-A4C5-4006-9375-D69A8D6AD983}","RemoteEvent")local cbcb
local dbcb,_ccb=pcall(function()
cbcb=game:GetService("MessagingService"):SubscribeAsync("megaphone",function(cddb)
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Data,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(196,209,216)})end)end)
if not dbcb then warn("Failed to enable MessagingService",_ccb)end;local accb=Random.new()
local function bccb(cddb,dddb,___c,a__c,b__c)a__c=a__c or"inventory"local c__c=cbba[cddb]
if

c__c and ___c.id and(a__c=="inventory"or a__c=="equipment")then local d__c,_a_c
do if(a__c=="inventory")then d__c,_a_c=abcb(cddb,___c)elseif(a__c=="equipment")then
d__c,_a_c=bbcb(cddb,___c)end end
if not _a_c then return false,"could not find equipment to encahnt"end
if
typeof(dddb)=="Instance"and dddb:FindFirstChild("itemEnchanted")then local aa_c=acca[_a_c.id]local ba_c=aaca.enchantmentPrice(_a_c)if
not ba_c then return false,"invalid enchantment item"end;if not
(c__c.gold>=ba_c)then return false,"not enough monies"end;if(
_a_c.upgrades or 0)>= (_a_c.maxUpgrades or 7)then
return false,"max upgraded"end
local ca_c=aaca.applyEnchantment(_a_c)
if ca_c then local da_c=dbbb(cddb,{},ba_c,{},0,"etc:enchant")if not da_c then
cdba:invoke("{79598458-CED2-488B-A719-1E295449F68E}",cddb,"error","Enchantment went through but money wasn't spent??")end;if a__c==
"equipment"then
c__c.nonSerializeData.playerDataChanged:Fire("equipment")else
c__c.nonSerializeData.playerDataChanged:Fire("inventory")end
dddb.itemEnchanted:Play()
if dddb:FindFirstChild("steady")then dddb.steady:Emit(50)end
if _a_c.blessed then
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.."'s ".. (aa_c.name or"equipment")..
" is blessed by The Orb.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(0,81,255)})end;return true end;return false,"idk what went wrong"elseif dddb.id then local aa_c=acca[dddb.id]
local ba_c=acca[___c.id]if not _a_c.enchantments then _a_c.enchantments={}end
if
aa_c and
aa_c.enchantsEquipment and aa_c.applyScroll and ba_c then local ca_c,da_c=abcb(cddb,dddb)
if da_c and _a_c then
local _b_c=aa_c.upgradeCost or 1
local ab_c,bb_c=aaca.enchantmentCanBeAppliedToItem(da_c,_a_c)
if ab_c then local cb_c=accb:NextNumber()<=aa_c.successRate
local db_c,_c_c,ac_c=aa_c.applyScroll(cddb,_a_c,cb_c,b__c,aa_c)ac_c=ac_c or{}if ac_c.successfullyApplied~=nil then
cb_c=ac_c.successfullyApplied end;local bc_c
if db_c then
table.remove(c__c.inventory,ca_c)local cc_c
if cb_c then
if aa_c.enchantments then local dc_c={}
for cd_c,dd_c in pairs(aa_c.enchantments)do if dd_c.selectionWeight and
dd_c.selectionWeight>0 then
if not dd_c.manual then table.insert(dc_c,dd_c)end end end;local _d_c,ad_c=ddba.selectFromWeightTable(dc_c)local bd_c;for cd_c,dd_c in
pairs(aa_c.enchantments)do if dd_c==_d_c then bd_c=cd_c end end
if
_d_c and bd_c then local cd_c=Color3.fromRGB(112,241,255)
bc_c={Text="The magic scroll lights up and its power is transferred to your equipment.",Color=
ac_c.textColor3 or cd_c,Font=Enum.Font.SourceSansBold}
if bb_c then
bc_c={Text="The scroll lights up and its power replaces an existing upgrade on your equipment.",Color=ac_c.textColor3 or cd_c,Font=Enum.Font.SourceSansBold}table.remove(_a_c.enchantments,bb_c)end
table.insert(_a_c.enchantments,{id=aa_c.id,state=bd_c})else error("Enchantment data state not found!")end end else
if aa_c.destroyItemOnFail and
accb:NextNumber()<= (aa_c.destroyItemRate or 1)then
if(a__c=="inventory")then
d__c,_a_c=abcb(cddb,___c)elseif(a__c=="equipment")then d__c,_a_c=bbcb(cddb,___c)end
bc_c={Text="The magic scroll's curse destroys your equipment.",Color=ac_c.textColor3 or Color3.fromRGB(255,96,99),Font=Enum.Font.SourceSansBold}
if a__c=="inventory"then table.remove(c__c.inventory,d__c)elseif a__c==
"equipment"then table.remove(c__c.equipment,d__c)end;cc_c=true else if aa_c.enchantments then
table.insert(_a_c.enchantments,{id=aa_c.id,state=-1})end
bc_c={Text="The magic scroll lights up and explodes into tiny shreds.",Color=
ac_c.textColor3 or Color3.fromRGB(167,167,167),Font=Enum.Font.SourceSansBold}end end
if not cc_c then local dc_c=0;local _d_c=0
for ad_c,bd_c in pairs(_a_c.enchantments or{})do
local cd_c=acca[bd_c.id]local dd_c=cd_c.upgradeCost or 1
local __ac=cd_c.enchantments[bd_c.state]if __ac and __ac.manual then dd_c=0 end;dc_c=dc_c+dd_c;if
bd_c.state>=0 then _d_c=_d_c+dd_c end end;_a_c.upgrades=dc_c;_a_c.successfulUpgrades=_d_c end;if _c_c then
bc_c={Text=_c_c,Color=ac_c.textColor3 or Color3.fromRGB(190,190,190),Font=Enum.Font.SourceSansBold}end
c__c.nonSerializeData.playerDataChanged:Fire("inventory")if a__c=="equipment"then
c__c.nonSerializeData.playerDataChanged:Fire("equipment")end
cdba:fireAllClients("{5F04834B-A4C5-4006-9375-D69A8D6AD983}",cddb,aa_c.id,cb_c)return true,cb_c,_a_c,bc_c end
if _c_c then
bc_c={Text=_c_c,Color=ac_c.textColor3 or Color3.fromRGB(255,60,60),Font=Enum.Font.SourceSansBold}return false,false,nil,bc_c end;return false end end end end end;return false end
cdba:create("{5FDEEFB3-EF88-4117-9480-ABF7D716D38E}","RemoteFunction","OnServerInvoke",bccb)
cdba:create("{0C546A4B-A00A-4ED8-B6AF-B838D53734EA}","RemoteFunction","OnServerInvoke",function(cddb)local dddb=cbba[cddb]
if
dddb and dddb.globalData then
if
( (not dddb.globalData.alphaGiftClaimed2)and(not dddb.alphaGiftClaimed2))or
( (not dddb.globalData.alphaGiftClaimed)and(not dddb.alphaGiftClaimed))then
if
game:GetService("BadgeService"):UserHasBadgeAsync(cddb.userId,2124445897)then
if dbbb(cddb,{},0,{{id=158,stacks=1}},50000,"gift:alpha")then
dddb.globalData.alphaGiftClaimed2=true;dddb.alphaGiftClaimed2=true;dddb.globalData.alphaGiftClaimed=true
dddb.alphaGiftClaimed=true;return true else return false,"Hmm, is your inventory full or something?"end end end
if
( (not dddb.globalData.spiderGiftClaimed)and(not dddb.spiderGiftClaimed))then
if cddb.Name=="berezaa"or
game:GetService("MarketplaceService"):PlayerOwnsAsset(cddb,4027043310)then
if
dbbb(cddb,{},0,{{id=177,stacks=1}},50000,"gift:spider")then dddb.globalData.spiderGiftClaimed=true
dddb.spiderGiftClaimed=true;return true else return false,"Hmm, is your inventory full or something?"end end end end;return false end)
local function cccb(cddb,dddb,___c)if not cddb or not cbba[cddb]then return nil end
___c=___c or 1;local a__c=cbba[cddb].inventory[dddb]
if a__c then
local b__c=math.clamp(___c,0,a__c.stacks)
if a__c.stacks and a__c.stacks>=___c then
a__c.stacks=a__c.stacks-___c;if a__c.stacks<=0 then
table.remove(cbba[cddb].inventory,dddb)end else b__c=a__c.stacks
table.remove(cbba[cddb].inventory,dddb)end;bd_b(cddb,"inventory")return b__c end;return 0 end
local function dccb(cddb,dddb,___c)
if not cddb or not cbba[cddb]or not dddb then return nil end;local a__c=acca[dddb.id]
___c=math.clamp(___c or 1,1,(a__c.stackSize or cdda))local b__c=cbba[cddb]local c__c=acca[dddb.id]
if c__c then
if c__c.canStack then
for d__c,_a_c in
pairs(b__c.inventory)do
if _a_c.position==dddb.position and _a_c.id==dddb.id then local aa_c=( (
_a_c.stacks or 1)-___c)>=0
if aa_c then if _a_c.stacks then
_a_c.stacks=_a_c.stacks else end else return false end end end else
if ___c<=1 then
for d__c,_a_c in pairs(b__c.inventory)do
if _a_c.position==dddb.position and
_a_c.id==dddb.id then
table.remove(b__c.inventory,d__c)bd_b(cddb,"inventory")return true end end else return false,"attempt to remove more than 1 stack from non-stackable item"end end end;warn("just nothing found")return false,0 end
local function _dcb(cddb,dddb,___c,a__c)if not cbba[cddb]then end
if not ___c or not dddb then
if a__c then local b__c=false
for c__c,d__c in
pairs(cbba[cddb].hotbar)do if d__c.position==a__c then
table.remove(cbba[cddb].hotbar,c__c)b__c=true end end;if b__c then bd_b(cddb,"hotbar")return true end end elseif a__c then
for b__c,c__c in pairs(cbba[cddb].hotbar)do if c__c.position==a__c then
table.remove(cbba[cddb].hotbar,b__c)end end
table.insert(cbba[cddb].hotbar,{dataType=dddb,id=___c,position=a__c})bd_b(cddb,"hotbar")return true end end;local adcb={}local function bdcb(cddb)
for dddb,___c in pairs(adcb)do if ___c==cddb then return true end end end
local function cdcb(cddb,dddb,___c,a__c)
if dddb=="dead"then return false end;___c=___c or""
if

cddb.Character and cddb.Character.PrimaryPart and
(
cddb.Character.PrimaryPart.state.Value~=dddb or
cddb.Character.PrimaryPart.state.variant.Value~=___c)and
cddb.Character.PrimaryPart.state.Value~="dead"then
local b__c=cddb.Character.PrimaryPart.state.Value;cddb.Character.PrimaryPart.state.variant.Value=
___c or""
cddb.Character.PrimaryPart.state.Value=dddb
if dddb=="sitting"and a__c then local c__c=adcb[cddb.Name]if c__c then
game.CollectionService:AddTag(c__c,"interact")adcb[cddb.Name]=nil end
if
bdcb(a__c)then cddb.Character.PrimaryPart.Anchored=false
cddb.Character.PrimaryPart:SetNetworkOwner(cddb)return false else
cddb.Character.PrimaryPart:SetNetworkOwner(nil)cddb.Character.PrimaryPart.Anchored=true
adcb[cddb.Name]=a__c
game.CollectionService:RemoveTag(a__c,"interact")end
if adcb[cddb.Name]==a__c then
cddb.Character.PrimaryPart.grounder.Position=
a__c.CFrame.p+Vector3.new(0,0.5,0)
cddb.Character.PrimaryPart.hitboxVelocity.Velocity=Vector3.new()
cddb.Character.PrimaryPart.hitboxGyro.CFrame=CFrame.new(
a__c.CFrame.p+Vector3.new(0,0.5,0),
a__c.CFrame.p+Vector3.new(0,0.5,0)+a__c.CFrame.lookVector)
cddb.Character.PrimaryPart.CFrame=a__c.CFrame+Vector3.new(0,0.5,0)end elseif b__c=="sitting"then
if a__c and a__c=="override"then return false end;cddb.Character.PrimaryPart.Anchored=false
cddb.Character.PrimaryPart:SetNetworkOwner(cddb)
for c__c,d__c in pairs(adcb)do
if c__c==cddb.Name or
game.Players:FindFirstChild(c__c)==nil then
game.CollectionService:AddTag(d__c,"interact")adcb[cddb.Name]=nil end end elseif dddb=="gettingUp"and a__c then local c__c=30;local d__c=120;local _a_c=100;local aa_c=400
local ba_c=cbba[cddb]local ca_c=math.clamp(math.abs(a__c),_a_c,aa_c)
local da_c=
math.floor(
c__c+ (d__c-c__c)* ( (ca_c-_a_c)/ (aa_c-_a_c)))*
math.clamp(1 -ba_c.nonSerializeData.statistics_final.featherFalling,0,1)
cddb.Character.PrimaryPart.health.Value=math.clamp(
cddb.Character.PrimaryPart.health.Value-da_c,0,cddb.Character.PrimaryPart.maxHealth.Value)end end end
local function ddcb(cddb,dddb)
if

cddb.Character and cddb.Character.PrimaryPart and
cddb.Character.PrimaryPart.weaponState.Value~=dddb and
cddb.Character.PrimaryPart.state.Value~="dead"then
local ___c=cddb.Character.PrimaryPart.weaponState.Value;local a__c=cbba[cddb]local b__c=bcab(cddb,1)
local c__c=b__c and acca[b__c.id]or nil
if dddb~=nil and dddb~=""then if not c__c then return false elseif c__c.equipmentType=="bow"then if
dddb~="stretched"and dddb~="firing"then return false end else
return false end end
cddb.Character.PrimaryPart.weaponState.Value=dddb or""end end
local function __db(cddb,dddb)
local ___c=cdba:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cddb)local a__c=bdca[dddb]if ___c and ___c.abilities and a__c then
for b__c,c__c in
pairs(___c.abilities)do if c__c.id==dddb then return c__c.rank end end end;return 0 end
cdba:create("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}","BindableFunction","OnInvoke",__db)
cdba:create("{0C0EEF90-BA4F-4748-B975-DC45211987CF}","RemoteFunction","OnServerInvoke")
local function a_db(cddb,dddb)if not dddb or type(dddb)~="number"then return end
if cddb and
cddb.Character and cddb.Character.PrimaryPart and
cddb.Character.PrimaryPart:FindFirstChild("castingAbilityId")then
if dddb>0 then
local ___c=cbba[cddb]local a__c=bdca[dddb](___c)
if a__c then if a__c.castingType=="skill-shot"and
__db(cddb,dddb)>0 then
cddb.Character.PrimaryPart.castingAbilityId.Value=dddb end end elseif dddb==0 then
cddb.Character.PrimaryPart.castingAbilityId.Value=0 end end end
cdba:create("{DDD7BB3E-AD30-44E6-A361-68F8466358E7}","RemoteEvent","OnServerEvent",a_db)
local function b_db(cddb,dddb,___c,a__c)
if cddb.Character and cddb.Character.PrimaryPart and
cddb.Character.PrimaryPart.state.Value~="dead"then
if
cbba[cddb]and
(dddb=="swordAnimations"or dddb=="staffAnimations"or dddb==
"daggerAnimations"or dddb=="bowAnimations")then
a__c=a__c or{}a__c.attackSpeed=
cbba[cddb].nonSerializeData.statistics_final.attackSpeed or 0 end
if dddb=="staffAnimations"and a__c then
if

cddb.Character.PrimaryPart.mana.Value<c_ca.getConfigurationValue("mageManaDrainFromBasicAttack")then a__c.noRangeManaAttack=true end end
cdba:fire("{A70A2E4A-A8B4-4ED2-B528-8FC0B0F6A192}",cddb,dddb,___c,a__c)
cdba:fireAllClientsExcludingPlayer("{721D8B67-F3EC-4074-949F-32BC2FA6A069}",cddb,cddb,dddb,___c,a__c)end end
local function c_db(cddb,dddb)local ___c=cbba[cddb]
if ___c then
if ___c.abilityBooks[dddb]and adca[dddb]then ___c.abilityBooks[dddb]=
nil
___c.nonSerializeData.playerDataChanged:Fire("abilityBooks")return true,"successfully revoked"else
if not ___c.abilityBooks[dddb]then return false,
"doesnt have book"else return false,"invalid book"end end end;return false,"invalid playerData"end
local function d_db(cddb,dddb)local ___c=cbba[cddb]
if ___c then
if
___c.class=="Adventurer"and ___c.level>=10 and
(dddb=="Hunter"or dddb=="Mage"or dddb=="Warrior")then
local a__c,b__c=ccab(cddb,dddb)
if a__c then
___c.nonSerializeData.setPlayerData("class",dddb)local c__c={}
if dddb=="Hunter"then table.insert(c__c,{id=15})
table.insert(c__c,{id=57,stacks=1})
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." has joined the ranks of the Hunters! Huzzah!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(12,255,0)})elseif dddb=="Mage"then table.insert(c__c,{id=21})
table.insert(c__c,{id=58,stacks=1})
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." has been welcomed into the order of the Mages.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(0,59,255)})elseif dddb=="Warrior"then table.insert(c__c,{id=19})
table.insert(c__c,{id=56,stacks=1})
cdba:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=cddb.Name.." has pledged themselves to the the Warriors!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,0,4)})end;if not ___c.flags.firstClassReward then ___c.flags.firstClassReward=true
local d__c=dbbb(cddb,{},0,c__c,0,"etc:treasure")end;return true,
"successfully changed class"else return a__c,b__c end elseif
___c.class=="Hunter"and ___c.level>=30 and(dddb=="Assassin"or dddb==
"Ranger"or dddb=="Trickster")then if game.GameId==712031239 then return false end
local a__c,b__c=ccab(cddb,dddb)
if a__c then
___c.nonSerializeData.setPlayerData("class",dddb)return true,nil else return false,b__c end elseif
___c.class=="Mage"and ___c.level>=30 and(dddb=="Sorcerer"or
dddb=="Warlock"or dddb=="Cleric")then if game.GameId==712031239 then return false end
local a__c,b__c=ccab(cddb,dddb)
if a__c then
___c.nonSerializeData.setPlayerData("class",dddb)return true,nil else return false,b__c end elseif
___c.class=="Warrior"and ___c.level>=30 and(dddb=="Knight"or dddb==
"Paladin"or dddb=="Berserker")then if game.GameId==712031239 then return false end
local a__c,b__c=ccab(cddb,dddb)
if a__c then
___c.nonSerializeData.setPlayerData("class",dddb)return true,nil else return false,b__c end else return false,"unsupported class change attempt"end end;return false,"invalid playerData"end
cdba:create("{9153DB74-655D-43A8-A914-831321A69663}","BindableFunction","OnInvoke",d_db)
cdba:create("{94741213-7397-4D4E-8DDA-C2C1DC44A423}","RemoteFunction","OnServerInvoke",d_db)
local function _adb(cddb)local dddb=cddb.Character;if not dddb then return false end
local ___c=dddb.PrimaryPart;if not ___c then return false end
local a__c=game:GetService("CollectionService"):GetTagged("resetCharacter")if#a__c==0 then return false end
for b__c,c__c in pairs(a__c)do local d__c=c__c.PrimaryPart;if d__c then local _a_c=(
___c.Position-d__c.Position).Magnitude;if _a_c<=8 then return
true end end end;return false end
local function aadb(cddb)
if not _adb(cddb)then return false,"notNearResetCharacter"end;local dddb=cbba[cddb]if not dddb then return false,"invalidData"end;if
dddb.level<10 then return false,"levelTooLow"end
if not
a_ab(cddb,{},dddb.equipment)then return false,"notEnoughSpace"end
dddb.nonSerializeData.setPlayerData("abilityBooks",{adventurer={pointsAssigned=0}})
dddb.nonSerializeData.setPlayerData("class","Adventurer")
dddb.nonSerializeData.setPlayerData("level",10)
dddb.nonSerializeData.setPlayerData("exp",0)local ___c=dddb.statistics;___c.str=0;___c.vit=0;___c.int=0;___c.dex=0
dddb.nonSerializeData.setPlayerData("statistics",___c)
dddb.nonSerializeData.setPlayerData("abilities",{})
dddb.nonSerializeData.setPlayerData("hotbar",{})dbbb(cddb,{},0,dddb.equipment,0)
dddb.nonSerializeData.setPlayerData("equipment",{})return true,""end
cdba:create("{C8251F1E-7AB3-44A1-9872-14FB822C8FFE}","RemoteFunction","OnServerInvoke",aadb)
cdba:create("{413B4AFE-5864-4F47-9061-FB1D80CD5478}","RemoteFunction","OnServerInvoke",function(cddb,dddb)
if
cddb.Character and cddb.Character.PrimaryPart then
if dddb and dddb.PrimaryPart then
local ___c=(dddb.PrimaryPart.Position-
cddb.Character.PrimaryPart.Position).magnitude
if ___c>=40 then local a__c=math.floor(___c/40)
cdba:invoke("{2946EC53-992A-45AE-A777-8F7438CE89A5}",cddb,
c_ca.getConfigurationValue("server_TPExploitScoreToFail")* (a__c/5))return false end end end
if game.CollectionService:HasTag(dddb,"treasureChest")then
local ___c=cbba[cddb]
if ___c then
local a__c=___c.treasure["place-"..game.PlaceId].chests[dddb.Name]if a__c==nil or a__c.open or a__c.blocked then
return false,"Invalid chest"end;local b__c=
cdba:invoke("{B47E205D-B7C4-42D4-BA5E-7977796C6571}",cddb,dddb)or{}
local c__c=
dddb:FindFirstChild("inventory")or dddb:FindFirstChild("ironChest")or
dddb:FindFirstChild("goldChest")
if c__c then b__c=require(c__c)
if b__c.prereq then
local ca_c,da_c=b__c.prereq(cddb,{network=cdba,utilities=ddba})if not ca_c then return false,da_c end end
if c__c.Name=="ironChest"then
spawn(function()
game.BadgeService:AwardBadge(cddb.userId,2124445628)end)elseif c__c.Name=="goldChest"then
spawn(function()
game.BadgeService:AwardBadge(cddb.userId,2124445630)end)end end;local d__c=b__c.rewards or{}local _a_c=b__c.gold or 0
if
dddb:FindFirstChild("minLevel")then
if cddb.level.Value<dddb.minLevel.Value then return false,
"This chest is too sturdy to for you to break right now!"end else local ca_c=dddb:FindFirstChild("chestLevel")
if ca_c then if cddb.level.Value<
ca_c.Value-10 then
return false,"This chest is too sturdy to for you to break right now!"end else return false,
"This chest is broken! Let a dev know!"end end;local aa_c=ddba.copyTable(d__c)if _a_c>0 then
table.insert(aa_c,{id=1,value=_a_c})end;a__c.open=true
___c.nonSerializeData.playerDataChanged:Fire("treasure")
local ba_c=dbbb(cddb,{},0,d__c,_a_c,"treasure:"..dddb.Name,{overrideItemsRecieved=true})
if not ba_c then
spawn(function()
for ca_c,da_c in pairs(aa_c)do
local _b_c={lootDropData=da_c,dropPosition=(dddb.PrimaryPart.CFrame*CFrame.new(0,
dddb.PrimaryPart.Size.Y*2,0)).Position,itemOwners={cddb}}
local ab_c=cdba:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",_b_c.lootDropData,_b_c.dropPosition,_b_c.itemOwners)if ab_c==nil then break end;local bb_c;local cb_c=Random.new()
local db_c=Vector3.new((
cb_c:NextNumber()-0.5)*30,cb_c:NextNumber()*65,(cb_c:NextNumber()-
0.5)*30)
if ab_c:IsA("BasePart")then ab_c.Velocity=db_c;bb_c=ab_c elseif
ab_c:IsA("Model")and(
ab_c.PrimaryPart or ab_c:FindFirstChild("HumanoidRootPart"))then
local _c_c=ab_c.PrimaryPart or ab_c:FindFirstChild("HumanoidRootPart")if _c_c then _c_c.Velocity=db_c;bb_c=_c_c end end
if bb_c then local _c_c=Instance.new("Attachment",bb_c)_c_c.Position=Vector3.new(0,
bb_c.Size.Y/2,0)
local ac_c=Instance.new("Attachment",bb_c)
ac_c.Position=Vector3.new(0,-bb_c.Size.Y/2,0)local bc_c=script.Trail:Clone()bc_c.Attachment0=_c_c
bc_c.Attachment1=ac_c;bc_c.Enabled=true;bc_c.Parent=bb_c end;wait(2 /5)end end)return{}else return aa_c end end;return false,"Not a chest"end end)
local function badb(cddb,dddb)local ___c=cbba[cddb]
if ___c then for a__c,b__c in pairs(___c.abilities)do
if b__c.id==dddb then return b__c end end end;return nil end
local function cadb(cddb,dddb)local ___c=adca[cddb]
if ___c then for a__c,b__c in pairs(___c.abilities)do
if b__c.id==dddb then return b__c end end end;return nil end
local function dadb(cddb,dddb)local ___c=cbba[cddb]local a__c=bdca[dddb](___c)
if ___c and a__c then
if a__c.prerequisite then
local b__c=0
for c__c,d__c in pairs(a__c.prerequisite)do if __db(cddb,d__c.id)>=d__c.rank then
b__c=b__c+1 end end;return b__c==#a__c.prerequisite else return true end end;return false end
local function _bdb(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then
if a__c.abilityBooks[dddb]then local b__c=badb(cddb,___c)
if
not b__c then local c__c=cadb(dddb,___c)
if c__c then b__c={id=___c,rank=0}
table.insert(a__c.abilities,b__c)else return false,"this should never happen"end end
if b__c then local c__c=bdca[___c](a__c)
if dadb(cddb,___c)then
if
(c__c.maxRank or 1)>b__c.rank then
local d__c=d_ca.getUnusedAbilityBookPoints(dddb,a__c.level,a__c.abilityBooks[dddb].pointsAssigned)
if d__c>0 then a__c.abilityBooks[dddb].pointsAssigned=
a__c.abilityBooks[dddb].pointsAssigned+1
b__c.rank=b__c.rank+1
a__c.nonSerializeData.playerDataChanged:Fire("abilityBooks")
a__c.nonSerializeData.playerDataChanged:Fire("abilities")return true,"successfully assigned points"else return false,"not enough points"end else return false,"ability is max rank"end else return false,"ability preq not met"end else return false,"invalid ability"end else return false,"invalid ability book"end end;return false,"invalid playerData"end
local function abdb(cddb)local dddb=0
for ___c,a__c in pairs(cddb.abilities)do
if a__c.rank~=0 then
local b__c=bdca[a__c.id](cddb)
if b__c and b__c.metadata then dddb=dddb+b__c.metadata.cost end;local c__c=a__c.rank-1;if
c__c>0 and b__c.metadata and b__c.metadata.upgradeCost then
dddb=dddb+b__c.metadata.upgradeCost*c__c end;if a__c.variant then
local d__c=b__c.metadata.variants[a__c.variant]dddb=dddb+d__c.cost end end end;return dddb end
function playerRequest_learnAbility(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c
for c__c,d__c in pairs(___c.abilities)do
if
d__c.id==dddb then if d__c.rank==0 or d__c.rank==nil then a__c=d__c else
return false,"ability already learned"end end end;local b__c=bdca[dddb](___c)
if

b__c and b__c.metadata and b__c.metadata.requirement and b__c.metadata.requirement(___c)then local c__c=___c.level-1
if
b__c.metadata.cost<=c__c-abdb(___c)then if a__c==nil then a__c={id=dddb,rank=1}
table.insert(___c.abilities,a__c)end;a__c.rank=1
___c.nonSerializeData.playerDataChanged:Fire("abilities")return true,"ability learned"end;return false,"not enough AP to learn"end;return false,"ability cannot be learned"end;return false,"invalid playerData"end
cdba:create("{4C2EA395-81A8-4F25-BDE8-DD916F41B890}","RemoteFunction","OnServerInvoke",playerRequest_learnAbility)
local function bbdb(cddb,dddb,___c)local a__c=cbba[cddb]
if a__c then
if
typeof(dddb)=="Instance"and
dddb:FindFirstChild("itemEnchanted")and dddb:IsDescendantOf(workspace)then
if cddb.Character and cddb.Character.PrimaryPart and
(
cddb.Character.PrimaryPart.Position-dddb.Position).magnitude<=100 then local b__c
for d__c,_a_c in
pairs(a__c.abilities)do if _a_c.id==___c.id then b__c=_a_c;break end end;local c__c=bdca[b__c.id](a__c)
if b__c and c__c then local d__c=c__c.metadata
if d__c then local _a_c=
a__c.level-1;local aa_c=_a_c-abdb(a__c)
if ___c.request=="upgrade"then
if

d__c.upgradeCost and d__c.maxRank and aa_c>=d__c.upgradeCost then
if b__c.rank>0 and b__c.rank<d__c.maxRank then
b__c.rank=b__c.rank+1
a__c.nonSerializeData.playerDataChanged:Fire("abilities")dddb.itemEnchanted:Play()if
dddb:FindFirstChild("steady")then dddb.steady:Emit(50)end;return true,
"upgrade applied"end end elseif ___c.request=="variant"then
if b__c.variant==nil or
d__c.variants[b__c.variant].default then
local ba_c=d__c.variants[___c.variant]
if ba_c and ba_c.cost and aa_c>=ba_c.cost then
if ba_c.requirement and
ba_c.requirement(a__c)then b__c.variant=___c.variant
a__c.nonSerializeData.playerDataChanged:Fire("abilities")dddb.itemEnchanted:Play()if
dddb:FindFirstChild("steady")then dddb.steady:Emit(50)end;return true,
"variant applied"end;return false,"requirements not fufilled"end;return false,"not enough points"end;return false,"ability already has variant"end;return false,"invalid request"end;return false,"unsupported ability"end;return false,"no data for ability"end;return false,"too far from orb"end;return false,"invalid orb"end end
cdba:create("{1027F153-81C2-4933-9BAE-25D65DC9F81D}","RemoteFunction","OnServerInvoke",bbdb)
local function cbdb(cddb,dddb)local ___c=cbba[cddb]
if cddb:FindFirstChild("DataSaveFailed")then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Cannot drop items during DataStore outage.",textColor3=Color3.fromRGB(255,57,60)})return false,"This feature is temporarily disabled"end
if cddb:FindFirstChild("DataLoaded")==nil then return false end;if
not c_ca.getConfigurationValue("isTradingEnabled",cddb)then return false end
if
___c and cddb and cddb.Character and cddb.Character.PrimaryPart then local a__c,b__c=false,nil
for c__c,d__c in
pairs(___c.inventory)do if d__c.id==dddb.id and d__c.position==dddb.position then
a__c=true;b__c=c__c end end
if a__c then local c__c=table.remove(___c.inventory,b__c)
local d__c=acca[c__c.id]if dddb.id==138 then cdbb(cddb,10)end
if
c__c.soulbound or d__c.soulbound then
___c.nonSerializeData.playerDataChanged:Fire("inventory")return false,"Item is soulbound"end
local _a_c=cdba:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",c__c,cddb.Character.PrimaryPart.Position+
cddb.Character.PrimaryPart.CFrame.lookVector*5,nil)
if _a_c then local aa_c=Instance.new("NumberValue")
aa_c.Name="playerDropSource"aa_c.Value=cddb.userId;aa_c.Parent=_a_c
___c.nonSerializeData.playerDataChanged:Fire("inventory")else table.insert(___c.inventory,c__c)end end end;return false,"invalid player data"end
cdba:create("{FCCADF22-0B79-446B-930B-55313877CCCA}","BindableEvent","Event",cdbb)
local function dbdb()
if#dbca:GetChildren()==0 and not
adba:FindFirstChild("isPVPGloballyEnabled")then return end
while not acba do
for cddb,dddb in pairs(cbba)do local ___c=dddb.nonSerializeData.isGlobalPVPEnabled
if
adba:FindFirstChild("isPVPGloballyEnabled")and adba.isPVPGloballyEnabled.Value then
if
___c==false then dddb.nonSerializeData.isGlobalPVPEnabled=true
dddb.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Entered global pvp map.",id="pvp"},nil,"pvp")end else local a__c=false;local b__c=false;for c__c,d__c in pairs(dbca:GetChildren())do
if _b_b(d__c,cddb)then
a__c=true;if d__c.Name=="unsafe"then b__c=true end;break end end
if ___c~=a__c then
dddb.nonSerializeData.isGlobalPVPEnabled=a__c;dddb.nonSerializeData.isPVPZoneUnsafe=b__c
dddb.nonSerializeData.playerDataChanged:Fire("nonSerializeData")
if a__c then
if b__c then
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Entered unsafe global PVP zone.",id="pvp"},
nil,"pvp")else
cdba:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",cddb,{text="Entered safe global PVP zone.",id="pvp"},nil,"pvp")end end end end end;wait(1 /3)end end
local function _cdb(cddb,dddb)local ___c=cbba[cddb]if ___c then
for a__c,b__c in
pairs(___c.nonSerializeData.whitelistPVPEnabled)do if b__c==dddb then return true,a__c end end end end
local function acdb(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c,b__c=_cdb(cddb,dddb)if not a__c then
table.insert(___c.nonSerializeData.whitelistPVPEnabled,dddb)
___c.nonSerializeData.playerDataChanged:Fire("nonSerializeData")end end end
local function bcdb(cddb,dddb)local ___c=cbba[cddb]
if ___c then local a__c,b__c=_cdb(cddb,dddb)if a__c then
table.remove(___c.nonSerializeData.whitelistPVPEnabled,b__c)
___c.nonSerializeData.playerDataChanged:Fire("nonSerializeData")end end end
local function ccdb(cddb,dddb)
if
not c_ca.getConfigurationValue("isTradingEnabled",cddb)then return false,"Storage has been disabled."end;if math.floor(dddb.stacks)~=dddb.stacks then
return false,"MagicRebirthed... BAD!"end
if not
c_ca.getConfigurationValue("isStorageEnabled",cddb)then return false,"Storage is currently disabled"end;local ___c=cbba[cddb]
if ___c and
#___c.globalData.itemStorage<ddda then return d_ab(cddb,dddb)elseif ___c then return false,"Inventory full."end;return false,"PlayerData not found."end
local function dcdb(cddb,dddb)
if
not c_ca.getConfigurationValue("isTradingEnabled",cddb)then return false,"Storage has been disabled."end;if math.floor(dddb.stacks)~=dddb.stacks then
return false,"MagicRebirthed... BAD!"end
if not
c_ca.getConfigurationValue("isStorageEnabled",cddb)then return false,"Storage is currently disabled"end;local ___c=cbba[cddb]if ___c then return _aab(cddb,dddb)end;return false,
"PlayerData not found."end
local function _ddb(cddb,dddb)local ___c=cbba[cddb]
if not ___c then return false,"PlayerData not found."end;if not cddb:FindFirstChild("bountyHunter")then
return false,"Not a bounty hunter."end;local a__c=dcca[dddb]
if a__c then
local b__c=a__c.monsterBookPage;local c__c=___c.bountyBook[dddb]
if b__c and c__c then
local d__c=a_ca.bountyPageInfo[tostring(b__c)]local _a_c=c__c.lastBounty or 0;local aa_c=d__c[_a_c+1]
if aa_c and c__c.kills>=
aa_c.kills then
local ba_c=a_ca.getBountyGoldReward(aa_c,a__c)local ca_c={}
local da_c=dbbb(cddb,{},0,ca_c,math.floor(ba_c),"etc:bounty")
if da_c then c__c.lastBounty=_a_c+1;bd_b(cddb,"bountyBook")return true end;return false,"No room in inventory."end;return false,"No bounty available."end;return false,"Invalid monster."end end
cdba:create("{F4710E12-07F5-4EAB-9644-5F83D5057E54}","RemoteFunction","OnServerInvoke",_ddb)local function addb(cddb,dddb,___c)end
local function bddb()
cdba:create("{33C3266F-0D28-4523-A9E1-A10C24C28C1B}","RemoteEvent","OnServerEvent",cbda)
cdba:create("{1CB180D8-192B-4A5B-A375-7DEF18393276}","RemoteFunction","OnServerInvoke",__bb)
cdba:create("{64CA3A94-0D25-40D0-9E41-02391DED4AE7}","RemoteFunction","OnServerInvoke",__bb)
cdba:create("{FD1E6717-D161-49D9-94DB-999748FE7D5F}","RemoteFunction","OnServerInvoke",d_cb)
cdba:create("{6D8301FF-17D5-45BC-B0F7-91D6373FAD91}","RemoteFunction","OnServerInvoke",d_cb)
cdba:create("{3C6F1D95-B0DA-424B-8023-9F91B7EEAB5A}","RemoteFunction","OnServerInvoke",addb)
cdba:create("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}","RemoteFunction","OnServerInvoke",aacb)
cdba:create("{5AF87E7A-2468-4606-999A-2751515C823E}","RemoteFunction","OnServerInvoke",aacb)
cdba:create("{9B6A6C02-E725-410F-8A3D-E553FD395A27}","RemoteFunction","OnServerInvoke",ccdb)
cdba:create("{D8C69E55-8192-43C2-9C8F-38D98BEF2E96}","RemoteFunction","OnServerInvoke",dcdb)
cdba:create("{D139FFE8-4215-4F17-96E1-BC8BB20C7B5F}","RemoteFunction","OnServerInvoke",c_bb)
cdba:create("{A9270EA2-5D2F-44F1-AE54-D239A94137D8}","RemoteFunction","OnServerInvoke",c_bb)
cdba:create("{78456430-FD3B-4465-AAF2-AD31CABCADDC}","BindableFunction","OnInvoke",c_cb)
cdba:create("{1FF0D39B-3160-4598-B23E-F04DC5CBCF09}","RemoteFunction","OnServerInvoke",_dbb)
cdba:create("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}","BindableFunction","OnInvoke",function(cddb,dddb)
if dbba[cddb]and cddb.Character and
cddb.Character.PrimaryPart then
dbba[cddb].positions={{position=dddb.p,velocity=Vector3.new()}}cddb.Character.PrimaryPart.CFrame=dddb end end)
cdba:create("{70D48E6D-FA55-4F16-AA91-62D20043AA2C}","RemoteEvent","OnServerEvent",onDataRecoveryRequested)
cdba:create("{54E0CB0C-03DC-4132-BEF0-39CBD750342D}","RemoteFunction","OnServerInvoke",function(cddb,dddb,___c)
local a__c,b__c,c__c=_cba:getPlayerSaveFileData(cddb,dddb,___c)if not a__c then return false,nil,c__c else return true,b__c,""end end)
cdba:create("{1EF9400C-348E-43E7-B7E2-50A3A2BFF1ED}","RemoteEvent","OnServerEvent",onDataRecoveryRejected)
cdba:create("{73CDB750-FC4E-4308-B763-4FE043D23ED6}","RemoteFunction","OnServerInvoke",ad_b)
cdba:create("{9658901E-8F65-43C2-AC62-1A0E2E55839B}","RemoteEvent","OnServerEvent",bd_b)
cdba:create("{52DBE4DB-B72C-4132-B3D1-D3D3255E271A}","RemoteEvent","OnServerEvent",bc_b)
cdba:create("{1532F156-9610-4883-B56F-D2DC318B9192}","RemoteFunction","OnServerInvoke",a__b)
cdba:create("{F109B44C-5FFF-4686-B3CD-4F5E8B582C18}","RemoteFunction","OnServerInvoke",a__b)
cdba:create("{0AF3C28A-B615-4B15-B2E3-3BDFF5E28CB0}","RemoteEvent")
cdba:create("{6917E7D5-3893-4ADF-8FEF-BA77CCBDD1C3}","RemoteFunction","OnServerInvoke",b_cb)
cdba:create("{877F979C-EBD3-44B6-9CF6-AF59C77A00D6}","RemoteFunction","OnServerInvoke",b_cb)
cdba:create("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}","RemoteFunction","OnServerInvoke",_dcb)
cdba:create("{E753ECCC-5528-48D9-819E-3E750D93FA5E}","RemoteFunction","OnServerInvoke",_dcb)
cdba:create("{AE5C9ED5-A3D2-4192-BF39-21F2FD69D483}","RemoteEvent","OnServerEvent",cdcb)
cdba:create("{47698457-5C5F-4C3C-BAC3-957D52D44B30}","RemoteEvent","OnServerEvent",ddcb)
cdba:create("{E0ED0936-7244-4BF4-AD33-EF5F37DB7845}","RemoteFunction","OnServerInvoke",dc_b)
cdba:create("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}","BindableFunction","OnInvoke",_ada)
cdba:create("{976D2A97-5FEC-4155-9F1A-06471B334029}","RemoteFunction","OnServerInvoke",aada)
cdba:create("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}","BindableFunction","OnInvoke",bcab)
cdba:create("{2C5A5D42-77F2-4839-B960-1C1D5AAB73AA}","BindableFunction","OnInvoke",cbbb)
cdba:create("{BA5F24F5-21F2-438D-A2A6-753742231899}","BindableFunction","OnInvoke",dccb)
cdba:create("{9485849D-EE15-40A1-B8BB-780E42059ED2}","BindableEvent","Event",ccbb)
cdba:create("{072CF981-BF20-4709-8880-300A11E9A695}","BindableFunction","OnInvoke",ccab)
cdba:create("{04957DC0-5413-4615-AA71-FBE7E96AC10E}","BindableEvent")
cdba:create("{64BA54DA-B49A-4738-9938-FAD92EB33267}","BindableFunction","OnInvoke",a_ab)
cdba:create("{721D8B67-F3EC-4074-949F-32BC2FA6A069}","RemoteEvent","OnServerEvent",b_db)
cdba:create("{4B5C35A0-C7D0-4269-8782-C5C7CB30B14A}","BindableEvent")
cdba:create("{798B395E-3EE4-4AD0-B0AE-FA56E9713C52}","RemoteFunction","OnServerInvoke",ddbb)
cdba:create("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}","RemoteEvent")
cdba:create("{BB20B0DB-ED66-4464-A0FD-C2F315DEA6DC}","RemoteFunction","OnServerInvoke",_bdb)
cdba:create("{33BDB595-15EE-4F8C-B99E-DE9BC605CF67}","RemoteFunction","OnServerInvoke",__cb)
cdba:create("{9928EED8-32C2-49B0-8C6A-30D599B6414B}","RemoteEvent")
cdba:create("{1D8F2EEC-0866-44D6-83BE-18595E9DA420}","RemoteFunction","OnServerInvoke",ba_b)
cdba:create("{2A007D14-8D6B-4DF7-96F6-A6F3A0B71EFC}","RemoteFunction","OnServerInvoke",aa_b)
cdba:create("{4C29D9FD-2312-4C1B-92EB-5CF5E5F20177}","BindableFunction","OnInvoke",acbb)
cdba:create("{7920C078-60F4-43D3-981E-8A4E3113CEC5}","RemoteFunction","OnServerInvoke",cbdb)
cdba:create("{669C024B-B819-48D3-AC3D-84873A639D84}","BindableFunction","OnInvoke",dbbb)
cdba:create("{64E568DA-DD76-4950-9FB2-7C38E03F50D2}","BindableFunction","OnInvoke",acdb)
cdba:create("{D7050FA4-2A8B-426F-97E8-604BFE01A579}","BindableFunction","OnInvoke",bcdb)
cdba:create("{A70A2E4A-A8B4-4ED2-B528-8FC0B0F6A192}","BindableEvent")
cdba:create("{E68719DC-5D55-4EF3-B970-EAACE3A872AB}","RemoteEvent")
cdba:create("{64244B09-51CA-49FE-9129-BB0281828AB0}","RemoteEvent")
cdba:create("{006F08C2-1541-41ED-90BE-192482E14530}","RemoteEvent")
cdba:create("{D5401345-3E55-471E-972D-4660C27D729B}","RemoteEvent")
cdba:create("{09C72219-6A16-49DD-8AD0-F17E13FAEDD9}","BindableEvent")
cdba:create("{955F2AFD-1B68-4304-841F-472796A574E0}","RemoteEvent","OnServerEvent",function()end)
game.Players.PlayerRemoving:connect(dbda)spawn(dbdb)spawn(dcda)end;spawn(bddb)return bbba