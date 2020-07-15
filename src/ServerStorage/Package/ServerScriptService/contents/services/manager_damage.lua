local _bb={}local abb=game:GetService("Debris")
local bbb=game:GetService("HttpService")local cbb=game:GetService("ReplicatedStorage")
local dbb=require(cbb.modules)local _cb=dbb.load("network")local acb=dbb.load("placeSetup")
local bcb=dbb.load("physics")local ccb=dbb.load("utilities")local dcb=dbb.load("mapping")
local _db=dbb.load("levels")local adb=dbb.load("damage")local bdb=dbb.load("detection")
local cdb=dbb.load("configuration")local ddb=dbb.load("projectile")local __c=dbb.load("events")
local a_c=game:GetService("ServerStorage")local b_c=cbb.itemData;local c_c=require(b_c)
local d_c=require(cbb.perkLookup)local _ac=require(cbb.abilityLookup)
local aac=require(cbb.monsterLookup)local bac=acb.getPlaceFolder("entityManifestCollection")
local cac=Random.new()local dac=Random.new()local _bc=Random.new()local abc={}local bbc={}local cbc={}
local dbc={}local _cc={}local acc={}
local bcc={"dagger","staff","sword","greatsword","dual","swordAndShield"}local ccc=5;local dcc=3.5;local _dc=0.3;local adc=0.125;local bdc=2;local cdc=100;local ddc
do
local dcd={{threshold=1.0,value=0.0 /3},{threshold=0.4,value=0.5 /3},{threshold=0.2,value=
1.0 /3},{threshold=0.1,value=2.0 /3}}
local function _dd(cdd)local ddd
for ___a,a__a in ipairs(dcd)do if not ddd or cdd<=a__a.threshold then ddd=a__a.threshold else
break end end;return ddd end
local function add(cdd)
for ddd,___a in ipairs(dcd)do if ___a.threshold==cdd then return
dcd[ddd+1]and dcd[ddd+1].threshold end end;return nil end
local function bdd(cdd)
for ddd,___a in ipairs(dcd)do if ___a.threshold==cdd then return
dcd[ddd-1]and dcd[ddd-1].threshold end end;return nil end
function ddc(cdd,ddd,___a,a__a)local b__a=math.clamp(cdd/ddd,0,1)local c__a=_dd(b__a)local d__a=math.clamp(
(cdd-___a)/ddd,0,1)local _a_a=_dd(d__a)
local aa_a=math.clamp(cdd-___a,0,ddd)local ba_a={}
for cb_a,db_a in ipairs(dcd)do
if
db_a.threshold<=c__a and db_a.threshold>=_a_a then
table.insert(ba_a,{threshold=db_a.threshold,damageMarker=db_a.threshold*ddd,value=db_a.value})end end;local ca_a=cdd;local da_a=___a;local _b_a=0;local ab_a=a__a
for i=#ba_a,1,-1 do local cb_a=ba_a[i]
if ab_a>0 then
if i==#ba_a then
local db_a=math.abs(
ddd*cb_a.threshold- (cdd-___a))local _c_a=math.clamp(db_a/cb_a.value,0,ab_a)
ab_a=ab_a-_c_a;_b_a=_b_a+_c_a*cb_a.value elseif i==1 then
local db_a=add(cb_a.threshold)local _c_a=cdd-ddd*db_a
local ac_a=math.clamp(_c_a/cb_a.value,0,ab_a)ab_a=ab_a-ac_a;_b_a=_b_a+ac_a*cb_a.value else
local db_a=add(cb_a.threshold)local _c_a=cb_a.threshold*ddd-db_a*ddd;local ac_a=math.clamp(_c_a/
cb_a.value,0,ab_a)ab_a=ab_a-ac_a;_b_a=_b_a+ac_a*
cb_a.value end end end;local bb_a=math.clamp(___a-_b_a,0,math.huge)return _b_a end end;local __d={}do function __d:isEquipmentPerkActivable(dcd,_dd)end
function __d:flagPerkAsActivated(dcd,_dd)end end
_cb:create("{B33B9240-BBA5-42E2-B26D-B758C980B5EE}","BindableEvent")
_cb:create("{9B043874-1259-453E-8E06-187B17931220}","RemoteEvent")
local function a_d(dcd,_dd,add)local bdd;local cdd
if dcd.entityType.Value=="monster"then
bdd=_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",dcd)elseif dcd.entityType.Value=="character"then
cdd=game.Players:GetPlayerFromCharacter(dcd.Parent)end;if _dd==nil then return end;local ddd;if _dd.entityType.Value=="character"then
ddd=game.Players:GetPlayerFromCharacter(_dd.Parent)end;local ___a=true
if
cdd or(bdd and
(
bdd.boss or bdd.resilient or bdd.giant or bdd.superGiant or bdd.gigaGiant))then
local a__a={"defeated","felled","purged","vanquished","ended","wiped","finished"}
if dcd and dcd:FindFirstChild("maxHealth")and add.damage>=
dcd.maxHealth.Value*0.5 then
a__a={"absolutely obliterated","completely demolished","undeniably destroyed","OOF`d"}elseif add.damageType=="magical"then
a__a={"disintegrated","melted","burned to a crisp","blasted","vaporized"}elseif add.damageType=="ranged"then
a__a={"sniped","popped","silenced","struck"}end;local b__a=a__a[cac:NextInteger(1,#a__a)]
b__a=b__a or"defeated"if add.isCritical then b__a="critically "..b__a end
if _dd then
local c__a="???"
if _dd.entityType.Value=="character"then c__a=_dd.Parent.Name elseif
_dd.entityType.Value=="monster"then c__a=_dd.Name
local aa_a=_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd)if not aa_a then return end
if aa_a.specialName then c__a=aa_a.specialName end
if aa_a.gigaGiant then c__a="Colossal "..c__a elseif aa_a.superGiant then
c__a="Super Giant "..c__a elseif aa_a.giant then c__a="Giant "..c__a end end
if _dd.state.Value=="dead"or _dd.health.Value<=0 or
_dd.Parent==nil then c__a="the late "..c__a end;local d__a
if cdd then d__a=cdd.Name elseif bdd then d__a=dcd.Name
if bdd.specialName then d__a=bdd.specialName end
if bdd.gigaGiant then d__a="Colossal "..d__a elseif bdd.superGiant then
d__a="Super Giant "..d__a elseif bdd.giant then d__a="Giant "..d__a end end;local _a_a="☠ "..
d__a.." was "..b__a.." by "..c__a.." ☠"
if
ddd and cdd and ddd==cdd then local aa_a=ddd:FindFirstChild("deathTrapKillMessage")if aa_a then
___a=false;_a_a=aa_a.Value;aa_a:Destroy()end end
_cb:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=_a_a,Font=Enum.Font.SourceSansBold,Color=cdd and
Color3.fromRGB(255,130,100)or Color3.fromRGB(0,255,170)})end
if
___a and _dd.entityType.Value=="character"and cdd then
_cb:fire("{B33B9240-BBA5-42E2-B26D-B758C980B5EE}",cdd,ddd,add)
if game.PlaceId==2103419922 then
local c__a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cdd)local d__a=(c__a and c__a.gold or 0)+
(c__a and c__a.level or 1)*100
local _a_a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ddd)local aa_a=_db.getEXPToNextLevel(_a_a.level)_a_a.nonSerializeData.incrementPlayerData("exp",
aa_a+1)
pcall(function()
if
_a_a.level==10 then
game.BadgeService:AwardBadge(ddd.userId,2124528259)
_cb:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=ddd.Name.." is in purgatory.",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(200,200,100)})elseif _a_a.level==100 then
game.BadgeService:AwardBadge(ddd.userId,2124528261)
_cb:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=ddd.Name.." is ALIVE!",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(150,255,30)})ddd:Kick("YOU ARE ALIVE!")end end)
_a_a.nonSerializeData.incrementPlayerData("gold",d__a)end
_cb:fireAllClients("{9B043874-1259-453E-8E06-187B17931220}",cdd,ddd,add,b__a)end end end
_cb:create("{430575B2-B79C-432A-981D-C30B502B774B}","BindableEvent","Event",a_d)
local function b_d(dcd,_dd,add)
if not _dd:FindFirstChild("health")or not
_dd:FindFirstChild("maxHealth")then return false end
if _dd.health.Value>0 and
_dd:FindFirstChild("killingBlow")==nil then
local bdd=game.Players:GetPlayerFromCharacter(_dd.Parent)if bdd then
__c:fireEventLocal("playerWillTakeDamage",bdd,add)end
__c:fireEventLocal("entityWillDealDamage",dcd,_dd,add)local cdd=_dd.health.Value-add.damage
if cdd<=0 then
local ddd=add.sourceEntityGUID;local ___a=ccb.getEntityManifestByEntityGUID(ddd)
local a__a=Instance.new("StringValue")a__a.Name="killingBlow"a__a.Value="damage"
local b__a=Instance.new("ObjectValue")b__a.Name="source"b__a.Value=___a;b__a.Parent=a__a;a__a.Parent=_dd
a_d(_dd,___a,add)end;_dd.health.Value=cdd;if _dd.health.Value<=0 then
__c:fireEventLocal("entityDiedTakingDamage",dcd,_dd,add)end
_cb:fireAllClients("{94EA4964-9682-4133-B150-B6EE2056FD70}",_dd,add)end;return true end;local function c_d(dcd,_dd,add,bdd)bdd=bdd or 1
return dcd/bdd>=_dd/bdd and dcd/bdd<=add/bdd end
local function d_d(dcd,_dd)return true end
local function _ad(dcd,_dd,add)if tick()-dcd.timestamp>=dcc then return false end
local bdd=dcd.serverCharacterPosition;local cdd=dcd.executionData["cast-origin"]
local ddd,___a=ddb.getUnitVelocityToImpact_predictiveByAbilityExecutionData(cdd,
dcd.sourceWeaponBaseData.projectileSeeed or 50,dcd.executionData,0.0001)
local a__a=math.deg(math.acos(((add-cdd).unit):Dot(ddd.unit)))
local b__a=math.deg(math.acos(((___a-cdd).unit):Dot(ddd.unit)))
local c__a=math.deg(math.acos(((___a*Vector3.new(1,0,1)-
cdd*Vector3.new(1,0,1)).unit):Dot((
ddd*Vector3.new(1,0,1)).unit)))return b__a<=7 end
local function aad(dcd,_dd,add)if tick()-dcd.timestamp>=dcc then return false end
local bdd=dcd.serverCharacterPosition;local cdd=dcd.executionData["cast-origin"]
local ddd,___a=ddb.getUnitVelocityToImpact_predictiveByAbilityExecutionData(cdd,(
dcd.sourceWeaponBaseData.projectileSeeed or 200)*
math.clamp(dcd.executionData.bowChargeTime/
cdb.getConfigurationValue("maxBowChargeTime"),0.1,1),dcd.executionData,false)
local a__a=math.deg(math.acos(((add-cdd).unit):Dot(ddd.unit)))
local b__a=math.deg(math.acos(((___a-cdd).unit):Dot(ddd.unit)))
local c__a=math.deg(math.acos(((___a*Vector3.new(1,0,1)-
cdd*Vector3.new(1,0,1)).unit):Dot((
ddd*Vector3.new(1,0,1)).unit)))return b__a<=7 end
local function bad(dcd,_dd,add,bdd)
local cdd=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)local ddd=(cdd.level or 0)-add
local ___a=math.clamp((10 + (ddd/2))/10,0.2,2)local a__a=cac:NextInteger(95,105)/100
local b__a=cdd.nonSerializeData.statistics_final;if
bdd and cdb.getConfigurationValue("doNotApplyLevelMultiToPVP",dcd)then ___a=1 end
local c__a=b__a[_dd.."Damage"]return math.ceil(c__a*___a*a__a)end;local cad={}
local function dad(dcd,_dd,add,bdd,cdd,ddd,___a)
local a__a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)if not a__a then return false end
local b__a=a__a.nonSerializeData.statistics_final
if

dcd.Character and dcd.Character.PrimaryPart and a__a and _dd and(_dd:IsDescendantOf(bac)or
_dd:IsDescendantOf(bac))then if
bdd~="monster"and not adb.canPlayerDamageTarget(dcd,_dd)then return false end
if
_dd:FindFirstChild("isDamageImmune")and _dd.isDamageImmune.Value then return false end;local c__a,d__a,_a_a;local aa_a=(_dd.entityType.Value=="character")
local ba_a=1;local ca_a=0;local da_a
if bdd=="ability"or bdd=="equipment"then da_a=true
if
bdd=="ability"then
local _b_a=_cb:invoke("{701E50EC-EF85-469A-BB2F-D17735863DCE}",dcd,cdd,___a)
if _b_a then
local ab_a=_cb:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",dcd,cdd)
if ab_a and ab_a>0 then local bb_a=_ac[cdd](a__a)
if bb_a._serverValidateDamageRequest then
local _aaa=bb_a._serverValidateDamageRequest(_b_a.player,_b_a.executionData)if not _aaa then return false end end
local cb_a,db_a=_cb:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",bb_a,ab_a)local _c_a=0;local ac_a=bb_a.damageType or"physical"
d__a=a__a.nonSerializeData.statistics_final;d__a.level=a__a.level;local bc_a,cc_a,dc_a,_d_a,ad_a,bd_a,cd_a,dd_a=0,0,0,0,0.1,0.1,nil,nil
do
if aa_a then
bc_a=_dd.health.Value;cc_a=_dd.maxHealth.Value
cd_a=game.Players:GetPlayerFromCharacter(_dd.Parent)
if cd_a then
dd_a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cd_a)if dd_a then _a_a=dd_a.nonSerializeData.statistics_final
_a_a.level=dd_a.level end;dc_a=cd_a.level.Value end else
bc_a=_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"health")
cc_a=_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"maxHealth")dc_a=_dd.level.Value
_a_a={level=_dd.level.Value,dex=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"dex")or 0,vit=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"vit")or 0,str=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"str")or 0,int=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"int")or 0,defense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0,physicalDefense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0,magicalDefense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0}end end;ba_a=cb_a.damageMultiplier or 1
local __aa=bad(dcd,ac_a,dc_a,aa_a)local a_aa=math.ceil(__aa*ba_a)local b_aa="direct"local c_aa;local d_aa
do
for _aaa,aaaa in
pairs(_b_a.previousEntityHits)do if bb_a.securityData and bb_a.securityData.isDamageContained then
c_aa=aaaa.hitData[1]end;if aaaa.entityManifest==_dd then
for baaa,caaa in
pairs(aaaa.hitData)do if caaa.sourceTag==ddd then ca_a=ca_a+1 end end;break end end end
if cdb.getConfigurationValue("doUseAbilitySecurityData",dcd)then
if bb_a.securityData then
local _aaa=bdb.projection_Box(_dd.CFrame,_dd.Size,dcd.Character.PrimaryPart.Position)
if bb_a.securityData.maxHitLockout then local aaaa=0
do for baaa,caaa in pairs(_b_a.previousEntityHits)do aaaa=aaaa+#
caaa.hitData end end;if aaaa>=bb_a.securityData.maxHitLockout then
warn(dcd,bb_a.name,"hit maxHitLockout")return false end end
if bb_a.projectileSpeed and bb_a.securityData.projectileOrigin then
local aaaa=0
do if bb_a.securityData.projectileOrigin=="character"then
aaaa=(_aaa-
dcd.Character.PrimaryPart.Position).magnitude end end;if aaaa>
3 *bb_a.projectileSpeed* (tick()-_b_a.timestamp)then
warn(dcd,bb_a.name,"projectile hit way too fast")return false end end
if
(bb_a.securityData.playerHitMaxPerTag or math.huge)<=ca_a then
warn(dcd,bb_a.name,"hit same entity too many times")return false end
if bb_a.securityData.isDamageContained and c_aa then
local aaaa=(_aaa-c_aa.hitPosition).magnitude
local baaa=
cb_a["blast radius"]or cb_a["range"]or cb_a["radius"]or cb_a["distance"]or 20;if aaaa> (baaa)*3 then
warn(dcd,bb_a.name,"hit entity outside of containDamage")return false end end end end
for _aaa,aaaa in pairs(cb_a)do local baaa=string.match(_aaa,"(%w+)_scaling")
if baaa and
a__a.nonSerializeData.statistics_final[baaa]then
a_aa=a_aa+
a__a.nonSerializeData.statistics_final[baaa]*aaaa elseif _aaa=="enemy_missing_health"then a_aa=a_aa+ (cc_a-bc_a)*aaaa elseif
_aaa=="enemy_current_health"then a_aa=a_aa+bc_a*aaaa elseif
_aaa=="enemy_max_health"then a_aa=a_aa+cc_a*aaaa elseif _aaa=="user_missing_health"then
warn(_aaa.." not yet implemented.")elseif _aaa=="user_current_health"then
warn(_aaa.." not yet implemented.")elseif _aaa=="user_max_health"then
warn(_aaa.." not yet implemented.")end end;c__a={}c__a.damage=a_aa;c__a.sourceType=bdd;c__a.sourceId=cdd
c__a.damageType=ac_a;c__a.isDamageDirect=false;c__a.sourcePlayerId=dcd.userId
c__a.damageTime=os.time()c__a.category=b_aa
c__a.sourceEntityGUID=ccb.getEntityGUIDByEntityManifest(dcd.Character.PrimaryPart)end end elseif bdd=="equipment"then
local _b_a=_cb:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",dcd,dcb.equipmentPosition.weapon)
if _b_a then local ab_a=c_c[_b_a.id]
if ab_a and ab_a.module then local bb_a;local cb_a,db_a=false,{}
do
if
ab_a.equipmentType=="bow"then
if dbc[dcd]and#dbc[dcd]>0 then
local _c_a=dcd.Character.PrimaryPart.Position;local ac_a=_dd.Position
for bc_a,cc_a in pairs(dbc[dcd])do
if aad(cc_a,_c_a,ac_a)then cb_a=true;db_a=cc_a
if not
cc_a.canAOE then
if cc_a.piercesRemaining<=0 then
table.remove(dbc[dcd],bc_a)else cc_a.piercesRemaining=cc_a.piercesRemaining-1 end else bb_a="magical"end;if(tick()-cc_a.timestamp)>5 then
table.remove(dbc[dcd],bc_a)end;break end end end elseif ab_a.equipmentType=="staff"and ddd=="magic-ball"then
if acc[dcd]and#
acc[dcd]>0 then
local _c_a=dcd.Character.PrimaryPart.Position;local ac_a=_dd.Position
for bc_a,cc_a in pairs(acc[dcd])do if _ad(cc_a,_c_a,ac_a)then cb_a=true;db_a=cc_a
table.remove(acc[dcd],bc_a)break end end end else local _c_a=ab_a.module:FindFirstChild("manifest")
if not _c_a and
ab_a.module:FindFirstChild("container")then
local ac_a=
ab_a.module.container:FindFirstChild("RightHand")or ab_a.module.container:FindFirstChild("LeftHand")if ac_a then
_c_a=ac_a:FindFirstChild("manifest")or ac_a.PrimaryPart end end
if _c_a then
local ac_a=math.max(_c_a.Size.X,_c_a.Size.Y,_c_a.Size.Z)+6
local bc_a=bdb.projection_Box(_dd.CFrame,_dd.Size,dcd.Character.PrimaryPart.Position)
local cc_a=(bc_a-dcd.Character.PrimaryPart.Position).magnitude
if cc_a<=ac_a*
(1.75 +a__a.nonSerializeData.statistics_final.attackRangeIncrease)and
d_d(dcd,_dd)then cb_a=true end end end end
if cb_a then local _c_a=bb_a or"physical"local ac_a,bc_a,cc_a,dc_a=0,0,nil
do
if aa_a then
cc_a=game.Players:GetPlayerFromCharacter(_dd.Parent)
if cc_a then
dc_a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cc_a)if dc_a then
bc_a=dc_a.nonSerializeData.statistics_final["defense"]_a_a=dc_a.nonSerializeData.statistics_final
_a_a.level=dc_a.level end
ac_a=cc_a.level.Value end else ac_a=_dd.level.Value
_a_a={level=_dd.level.Value,dex=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"dex")or 0,vit=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"vit")or 0,str=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"str")or 0,int=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"int")or 0,defense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0,physicalDefense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0,magicalDefense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0}end end;local _d_a=a__a.level-ac_a
local ad_a=a__a.nonSerializeData.statistics_final;d__a=ad_a;d__a.level=a__a.level;c__a={}c__a.damage=0;c__a.damageType=
ddd=="magic-ball"and"magical"or _c_a
c__a.sourceType=bdd;c__a.sourceId=cdd;c__a.sourcePlayerId=dcd.userId
c__a.damageTime=os.time()
c__a.category=ab_a.equipmentType=="bow"and"projectile"or"direct"
c__a.sourceEntityGUID=ccb.getEntityGUIDByEntityManifest(dcd.Character.PrimaryPart)c__a.equipmentType=ab_a.equipmentType end end end end elseif bdd=="monster"then
if
dcd.Character.PrimaryPart.health.Value>0 then local _b_a=a__a.nonSerializeData.statistics_final;_a_a=_b_a
_a_a.level=a__a.level
local ab_a=_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"damage")
d__a={level=_dd.level.Value,dex=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"dex")or 0,vit=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"vit")or 0,str=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"str")or 0,int=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"int")or 0,defense=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"defense")or 0,damage=
_cb:invoke("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}",_dd,"damage")or 0,damageMulti=1,magicalDamage=nil,physicalDamage=nil}c__a={}c__a.damage=d__a.damage;c__a.sourceType="monster"
c__a.sourceId=cdd;c__a.damageType=nil;c__a.category=nil
c__a.sourceEntityGUID=ccb.getEntityGUIDByEntityManifest(_dd)end end
if c__a then local _b_a=d__a.damage;local ab_a=_a_a.defense;local bb_a=1;if d__a.damageMulti then
bb_a=bb_a*d__a.damageMulti end
c__a.damage=math.max(0,math.floor(bb_a* (_b_a-ab_a)))
if bdd=="monster"then local ad_a,bd_a,cd_a
do
if aac[_dd.Name]then
local dd_a=aac[_dd.Name].statesData;if dd_a.processDamageRequest then
ad_a,bd_a,cd_a=dd_a.processDamageRequest(cdd,c__a.damage)end end end
if ad_a then c__a.damage=ad_a;c__a.damageType=bd_a;c__a.category=cd_a else
c__a.damageType="physical"c__a.category="direct"end elseif bdd=="ability"then local ad_a=_ac[cdd](a__a)
if ad_a._serverProcessDamageRequest then
local bd_a,cd_a,dd_a=ad_a._serverProcessDamageRequest(ddd,c__a.damage,_dd,ca_a,dcd)
if not bd_a then warn("FAILED TO PASS VALID SOURCE-TAG")return false else
c__a.damage=bd_a;c__a.damageType=cd_a;c__a.category=dd_a end end end;c__a.position=add
if bdd=="equipment"then
local ad_a=_cb:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",dcd,dcb.equipmentPosition.weapon)if ad_a then local bd_a=c_c[ad_a.id]
if bd_a and bd_a.equipmentType=="bow"then c__a.damage=
c__a.damage+ (d__a.rangedDamage or 0)end end end
if
d__a.criticalStrikeChance and d__a.criticalStrikeChance>0 and
d__a.criticalStrikeChance>=dac:NextNumber()then c__a.damage=c__a.damage*bdc;c__a.isCritical=true end;if ba_a then c__a.damage=c__a.damage*ba_a end
if c__a.damageType~=
"magical"then
if
_a_a.blockChance and _bc:NextNumber()<=_a_a.blockChance then c__a.damage=c__a.damage*0.25;c__a.supressed=true
_cb:fireAllClients("{721D8B67-F3EC-4074-949F-32BC2FA6A069}",dcd,"emoteAnimations","block")end end
if bdd=="ability"or bdd=="equipment"then if _dd.health.Value==
_dd.maxHealth.Value then elseif
_dd.health.Value/_dd.maxHealth.Value<=0.3 then end
if
bdd=="equipment"and cbc[dcd]and cbc[dcd].state=="strike2"then elseif bdd=="equipment"and
cbc[dcd]and cbc[dcd].state=="strike3"then
local ad_a=false
local bd_a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)if bd_a and bd_a.abilities then
for cd_a,dd_a in pairs(bd_a.abilities)do if dd_a.id==3 and
dd_a.variant=="tripleSlash"then ad_a=true end end end
if ad_a then
if
_cb:invoke("{07B904D8-B25D-4390-B4E3-CF54AF8F7D86}",dcd,"berserker")then c__a.damage=c__a.damage*2 end;c__a.damage=c__a.damage*1.4 end end end
if c__a.category then
local ad_a=bdd=="monster"and dcd or
game.Players:GetPlayerFromCharacter(_dd.Parent)
if ad_a then
local bd_a,cd_a=ccb.safeJSONDecode(ad_a.Character.PrimaryPart.activeAbilityExecutionData.Value)
if bd_a then
if cd_a.id==8 then
if
c__a.category=="direct"or c__a.category=="projectile"then c__a.damage=c__a.damage*0.5;c__a.supressed=true end elseif cd_a.id==17 then
if
c__a.category=="direct"or c__a.category=="projectile"then c__a.damage=c__a.damage*0.35;c__a.supressed=true
_cb:fireAllClients("{03A1736D-FB27-4236-AD23-82B12E8C9785}",ad_a,cd_a.id,c__a,dcd.Character.PrimaryPart)end end end end end;local cb_a=da_a and a__a
local db_a=da_a and dcd.Character.PrimaryPart or _dd
local _c_a=bdd=="monster"and dcd.Character.PrimaryPart or _dd
local ac_a=bdd=="monster"and dcd or
game.Players:GetPlayerFromCharacter(_dd.Parent)
local bc_a=ac_a and _cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ac_a)local cc_a=
cb_a and cb_a.nonSerializeData.statistics_final.activePerks or{}
for ad_a,bd_a in
pairs(cc_a)do
if bd_a then local cd_a=d_c[ad_a]if cd_a.onDamageGiven then
cd_a.onDamageGiven(db_a,bdd,cdd,_c_a,c__a)end
if c__a.isCritical then if cd_a.onCritGiven then
cd_a.onCritGiven(db_a,bdd,cdd,_c_a,c__a)end end end end
if
cb_a and cb_a.nonSerializeData.statistics_final.damageGivenMulti then
c__a.damage=c__a.damage*cb_a.nonSerializeData.statistics_final.damageGivenMulti end;local dc_a=
bc_a and bc_a.nonSerializeData.statistics_final.activePerks or{}for ad_a,bd_a in
pairs(dc_a)do
if bd_a then local cd_a=d_c[ad_a]if cd_a.onDamageTaken then
cd_a.onDamageTaken(db_a,bdd,cdd,_c_a,c__a)end end end
if bc_a and
bc_a.nonSerializeData.statistics_final.damageTakenMulti then c__a.damage=c__a.damage*
bc_a.nonSerializeData.statistics_final.damageTakenMulti end
if c__a.damageType=="magical"then c__a.damage=c__a.damage*
(1 + (d__a.int*1 /160))else c__a.damage=c__a.damage* (1 +
(d__a.str*1 /160))end
if ___a and(c__a.equipmentType=="bow")then local ad_a=0.5
if not cad[___a]then
cad[___a]={}delay(5,function()cad[___a]=nil end)end
if not cad[___a][_c_a]then cad[___a][_c_a]=0 end;cad[___a][_c_a]=cad[___a][_c_a]+1;local bd_a=ad_a^ (
cad[___a][_c_a]-1)
c__a.damage=c__a.damage*bd_a end
if(c__a.equipmentType=="bow")and ddd=="ranger stance"then if not
dcd.Character then return end;local ad_a=dcd.Character.PrimaryPart;if not ad_a then
return end
local bd_a=ccb.getEntityGUIDByEntityManifest(ad_a)if not bd_a then return end
local cd_a=_cb:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",bd_a)local dd_a=nil;for __aa,a_aa in pairs(cd_a)do
if a_aa.statusEffectType=="ranger stance"then dd_a=a_aa;break end end
if dd_a then c__a.damage=c__a.damage*
dd_a.statusEffectModifier.damageBonus end end;c__a.target=_dd
__c:fireEventLocal("playerWillDealDamage",dcd,c__a)local _d_a
do
if bdd=="monster"then
_d_a=_cb:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",nil,dcd.Character.PrimaryPart,c__a)else
if aa_a then
c__a.damage=c__a.damage*cdb.getConfigurationValue("abilityPVPDampening")
_d_a=_cb:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",dcd,_dd,c__a)else
_d_a=_cb:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",dcd,_dd,c__a)end end end
if _d_a then if bdd=="ability"then
_cb:fire("{CDAE72AC-EFED-4B26-9F40-98C8E2978E1A}",dcd,cdd,___a,_dd,ddd)end
if bdd=="equipment"then
local ad_a=_cb:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",dcd,dcb.equipmentPosition.weapon)
if ad_a then local bd_a=c_c[ad_a.id]
if bd_a and bd_a.equipmentType=="bow"then
local cd_a=0;if b__a.vit>=30 then cd_a=25 end;if b__a.vit>=70 then cd_a=40 end;if
b__a.vit>=120 then cd_a=100 end
if
math.random()<1 /10 and cd_a~=0 then local dd_a=dcd.Character;if not dd_a then return end;local __aa=dd_a.PrimaryPart
if not __aa then return end;local a_aa=__aa:FindFirstChild("health")if not a_aa then return end
local b_aa=__aa:FindFirstChild("maxHealth")if not b_aa then return end
a_aa.Value=math.min(a_aa.Value+cd_a,b_aa.Value)
_cb:fireAllClients("{CE48DECD-5222-4973-B0AB-89B662749171}","bloodHeal",{player=dcd,playerManifest=__aa,target=_dd})end end
if
a__a.class=="Warrior"or a__a.class=="Knight"or a__a.class==
"Paladin"or a__a.class=="Berserker"then local cd_a=0;local dd_a=0;local __aa=0;if b__a.vit>=30 then cd_a=2 end
if b__a.vit>=70 then cd_a=4 end;if b__a.vit>=120 then cd_a=6 end;if b__a.int>=30 then dd_a=1 end;if
b__a.int>=70 then dd_a=2 end;if b__a.int>=150 then dd_a=3 end;if
b__a.dex>=50 then __aa=0.5 end;if b__a.dex>=120 then __aa=1 end
local a_aa=dcd.Character;if not a_aa then return end;local b_aa=a_aa.PrimaryPart;if not b_aa then return end
local c_aa=b_aa:FindFirstChild("health")if not c_aa then return end
local d_aa=b_aa:FindFirstChild("maxHealth")if not d_aa then return end;local _aaa=b_aa:FindFirstChild("mana")if
not _aaa then return end;local aaaa=b_aa:FindFirstChild("maxMana")if not aaaa then
return end;local baaa=b_aa:FindFirstChild("stamina")
if not baaa then return end;local caaa=b_aa:FindFirstChild("maxStamina")
if not caaa then return end
c_aa.Value=math.min(c_aa.Value+cd_a,d_aa.Value)
_aaa.Value=math.min(_aaa.Value+dd_a,aaaa.Value)
baaa.Value=math.min(baaa.Value+__aa,caaa.Value)end end end
a__a.nonSerializeData.setNonSerializeDataValue("lastTimeInCombat",tick())end;return _d_a or false end end end;local function _bd(dcd,_dd,add)local bdd end
local function abd(dcd)for _dd,add in pairs(bcc)do
if dcd==add.."Animations"then return true end end;return false,nil end
local function bbd(dcd,_dd,add,bdd)local cdd=cbc[dcd]
local ddd=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)
if cdd then
if bbc[_dd]then
if bdd=="strike1"or bdd=="strike2"then
if
tick()-cdd.timestamp>=bbc[_dd][
bdd.."_animationLength"]/ (1 +
ddd.nonSerializeData.statistics_final.attackSpeed)then return true end end end
if bdd=="strike1"then
if cdd.state=="strike2"then
if bbc[_dd]then
local ___a=c_d(tick()-cdd.timestamp,
bbc[_dd].strike1_slash2PeriodStart_time-adc,bbc[_dd].strike1_slash2PeriodStart_time+_dc+adc,
1 +ddd.nonSerializeData.statistics_final.attackSpeed)return ___a end;return true elseif cdd.state=="strike3"then
if bbc[_dd]then
local ___a=c_d(tick()-cdd.timestamp,
bbc[_dd].strike3_stopDamageSequence_time-adc,bbc[_dd].strike3_stopDamageSequence_time+_dc+
adc,1 +
ddd.nonSerializeData.statistics_final.attackSpeed)return ___a end;return true end elseif bdd=="strike2"then
if cdd.state=="strike1"then
if bbc[_dd]then
local ___a=c_d(tick()-cdd.timestamp,
bbc[_dd].strike2_slash1PeriodStart_time-adc,bbc[_dd].strike2_slash1PeriodStart_time+_dc+adc,
1 +ddd.nonSerializeData.statistics_final.attackSpeed)return ___a end;return true elseif cdd.state=="strike2"then return false end elseif bdd=="strike3"then if cdd.state=="strike2"then return true end end else return true end;return false end
local function cbd(dcd)
local _dd=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)local add;do
for bdd,cdd in pairs(_dd.equipment)do if
cdd.position==dcb.equipmentPosition.arrow then add=cdd end end end
if add then for bdd,cdd in
pairs(_dd.inventory)do
if cdd.id==add.id and cdd.stacks>=1 then return true,add.id end end else
return false,"arrow not primed"end end
local function dbd(dcd)dcd=dcd<0 and 0 or dcd;local _dd,add
if dcd<
cdb.getConfigurationValue("maxBowChargeTime")then
local cdd=cdb.getConfigurationValue("maxBowChargeTime")local ddd=1;local ___a=0;local a__a=0;_dd=(a__a-ddd)/ (___a-cdd)
add=ddd-_dd*cdd else local cdd=cdb.getConfigurationValue("maxBowChargeTime")
local ddd=1;local ___a=cdb.getConfigurationValue("bowPullBackTime")
local a__a=cdb.getConfigurationValue("bowMaxChargeDamageMultiplier")_dd=(a__a-ddd)/ (___a-cdd)add=ddd-_dd*cdd end
local bdd=math.clamp(dcd*_dd+add,0.1,cdb.getConfigurationValue("bowMaxChargeDamageMultiplier"))return bdd end;local _cd={}
local function acd(dcd,_dd,add,bdd)
if not dcd or not dcd.Character or
not dcd.Character.PrimaryPart then return false end;local cdd=abd(_dd)
if cdd or _dd=="bowAnimations"then
local ddd=_cb:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",dcd,dcb.equipmentPosition.weapon)
if ddd then local ___a=c_c[ddd.id]
if ___a.category=="equipment"then
local a__a=___a.equipmentType
if a__a=="bow"then local b__a,c__a=cbd(dcd)
if b__a then
if add=="stretching_bow"then
_cd[dcd]={weaponType=a__a,state=add,timestamp=tick(),damageBlacklist={}}elseif add=="firing_bow_stance"then
local d__a=_cb:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",dcd,{{id=87,stacks=1}},0,{},0,nil)
if d__a then if not dbc[dcd]then dbc[dcd]={}end
table.insert(dbc[dcd],{serverCharacterPosition=dcd.Character.PrimaryPart.Position,executionData=bdd,timestamp=tick(),chargeTimeMultiplier=1,piercesRemaining=999,canAOE=false,sourceWeaponBaseData=___a})end elseif add=="firing_bow"then
if not bdd.canceled then
if _cd[dcd]and
_cd[dcd].state=="stretching_bow"then
local d__a=_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)local _a_a=d__a.nonSerializeData.statistics_final
local aa_a=_a_a.int>=30
local ba_a=1 +d__a.nonSerializeData.statistics_final.attackSpeed;local ca_a=(tick()-_cd[dcd].timestamp)*ba_a
local da_a=cdb.getConfigurationValue("minBowChargeTime")local _b_a=cdb.getConfigurationValue("maxBowChargeTime")
if
ca_a>=da_a then local ab_a=dcd.Character.PrimaryPart.Position
_cd[dcd]=nil;local bb_a={needsArrow=true}
__c:fireEventLocal("playerWillUseArrow",dcd,bb_a)local cb_a=ccb.calculateNumArrowsFromDex(_a_a.dex)
local db_a=(
_cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dcd)or{}).inventory or{}local _c_a=0
for dc_a,_d_a in pairs(db_a)do if _d_a.id==87 then _c_a=_d_a.stacks end end;local ac_a=math.min(_c_a,cb_a)local bc_a,cc_a=cbd(dcd)if
bc_a and bb_a.needsArrow then
bc_a=_cb:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",dcd,{{id=cc_a,stacks=ac_a}},0,{},0,nil)end
if bc_a then if
not dbc[dcd]then dbc[dcd]={}end
for i=1,ac_a do
table.insert(dbc[dcd],{serverCharacterPosition=ab_a,executionData=bdd,timestamp=tick(),chargeTimeMultiplier=dbd(ca_a),piercesRemaining=ccb.calculatePierceFromStr(_a_a.str),canAOE=aa_a,sourceWeaponBaseData=___a,arrowId=cc_a,damageMultiplier=math.clamp(
1 - ( (ac_a-1)*0.15),0.10,1)})end else warn("failed to take arrow(s) from player!")end end end else _cd[dcd]=nil end else _cd[dcd]=nil end else _cd[dcd]=nil end else if not cbc or bbd(dcd,a__a,_dd,add)then
cbc[dcd]={weaponType=a__a,state=add,timestamp=tick(),damageBlacklist={}}end end end end end end
local function bcd(dcd)_cc=nil;_cd[dcd]=nil;cbc[dcd]=nil;dbc[dcd]=nil;acc[dcd]=nil
for _dd,add in pairs(dbc)do for ii=#add,1,
-1 do if tick()-add[ii].timestamp>=dcc then
table.remove(add,ii)end end end
for _dd,add in pairs(acc)do for ii=#add,1,-1 do if tick()-add[ii].timestamp>=dcc then
table.remove(add,ii)end end end end
local function ccd()
_cb:create("{03A1736D-FB27-4236-AD23-82B12E8C9785}","RemoteEvent")
_cb:create("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}","RemoteEvent","OnServerEvent",dad)
_cb:create("{9AF17239-FE35-48D5-B980-F2FA7DF2DBBC}","BindableEvent","Event",dad)
_cb:create("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}","BindableFunction","OnInvoke",b_d)
_cb:create("{0ECADB4F-CE34-446A-807A-F62F8A0DF437}","BindableEvent","Event",_bd)
spawn(function()
_cb:connect("{A70A2E4A-A8B4-4ED2-B528-8FC0B0F6A192}","Event",acd)
game.Players.PlayerRemoving:connect(bcd)
local dcd=game.StarterPlayer.StarterPlayerScripts.assets.animations;local _dd=cbb.playerBaseCharacter:Clone()
_dd.Parent=workspace
for add,bdd in pairs(_dd:GetChildren())do
if bdd.Name=="HumanoidRootPart"then
bdd.Anchored=true;bdd.CanCollide=true;bdd.Transparency=0.75 elseif bdd:IsA("BasePart")then
bdd.Anchored=false;bdd.CanCollide=true;bdd.Transparency=0.75 end end
for add,bdd in pairs(bcc)do local cdd=dcd[bdd.."Animations"]
local ddd=require(cdd)local ___a={}
for a__a,b__a in pairs(ddd)do local c__a=Instance.new("Animation")
c__a.AnimationId=b__a.animationId
local d__a=_dd.AnimationController:LoadAnimation(c__a)d__a:Play()while d__a.Length==0 do wait(0.1)end
if
a__a=="strike1"then ___a.strike1_animationLength=d__a.Length
___a.strike1_startDamageSequence_time=d__a:GetTimeOfKeyframe("startDamageSequence")
___a.strike1_stopDamageSequence_time=d__a:GetTimeOfKeyframe("stopDamageSequence")
___a.strike1_slash2PeriodStart_time=d__a:GetTimeOfKeyframe("slash2PeriodStart")elseif a__a=="strike2"then ___a.strike2_animationLength=d__a.Length
___a.strike2_startDamageSequence_time=d__a:GetTimeOfKeyframe("startDamageSequence")
___a.strike2_stopDamageSequence_time=d__a:GetTimeOfKeyframe("stopDamageSequence")
___a.strike2_slash1PeriodStart_time=d__a:GetTimeOfKeyframe("slash1PeriodStart")elseif a__a=="strike3"then ___a.strike3_animationLength=d__a.Length
___a.strike3_startDamageSequence_time=d__a:GetTimeOfKeyframe("startDamageSequence")
___a.strike3_stopDamageSequence_time=d__a:GetTimeOfKeyframe("stopDamageSequence")end end;bbc[bdd]=___a end
do local add=dcd.bowToolAnimations_noChar;local bdd=require(add)end
for add,bdd in pairs(aac)do local cdd=bdd.entity:Clone()
for ddd,___a in
pairs(cdd:GetChildren())do
if ___a.Name=="HumanoidRootPart"then ___a.Anchored=true;___a.CanCollide=true
___a.Transparency=0.75 elseif ___a:IsA("BasePart")then ___a.Anchored=false;___a.CanCollide=true
___a.Transparency=0.75 end end;cdd.Parent=workspace
cdd:SetPrimaryPartCFrame(CFrame.new(0,100,0))abc[add]={}
if cdd:FindFirstChild("animations")then local ddd=cdd.animations
local ___a=
bdd.module:FindFirstChild("states")and require(bdd.module:FindFirstChild("states"))if ___a==nil or not ___a.states then
___a=require(cbb.defaultMonsterState)end
for a__a,b__a in pairs(___a.states)do
if b__a.animationTriggersDamage then local c__a=
b__a.animationEquivalent or a__a
if ddd:FindFirstChild(c__a)then
local d__a=cdd.AnimationController:LoadAnimation(cdd.animations[c__a])local _a_a=d__a.Length*0.3;local aa_a=d__a.Length*0.7;local ba_a={}
local ca_a=false;local da_a=tick()local _b_a={}
local function ab_a()da_a=tick()
local bb_a=d__a.Length*0.7 -d__a.Length*0.3;local cb_a={}local db_a
for i=1,db_a or ccc do cb_a[i]=d__a.Length*0.3 +
bb_a* (i-1)/ ( (db_a or ccc)-1)end;local _c_a
while d__a.IsPlaying do
for ac_a,bc_a in pairs(cb_a)do
if tick()-da_a>=bc_a then
for cc_a,dc_a in
pairs(bdd.damageHitboxCollection)do local _d_a,ad_a=cdd:GetBoundingBox()
local bd_a=cdd[dc_a.partName].CFrame* (
dc_a.originOffset or CFrame.new())
if not _b_a[dc_a.partName]then _b_a[dc_a.partName]={}end
table.insert(_b_a[dc_a.partName],bd_a:toObjectSpace(_d_a))table.remove(cb_a,cc_a)end end end;wait()end;for ac_a,bc_a in pairs(ba_a)do bc_a:disconnect()end;ca_a=true end
table.insert(ba_a,cdd.AnimationController.AnimationPlayed:connect(ab_a))while not(d__a.Length>0)do wait(0.25)end
d__a.Looped=false;wait()d__a:Play()while not ca_a do wait(0.25)end
abc[add]=_b_a;wait(3)end end end else warn("invalid monster",add)end;cdd:Destroy()end;_dd:Destroy()end)end;ccd()return _bb