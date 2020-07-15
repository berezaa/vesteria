
local c_c=script.Parent.Parent:WaitForChild("assets")local d_c={}local _ac=game.Players.LocalPlayer
local aac=game:GetService("UserInputService")local bac=game:GetService("CollectionService")
local cac=game:GetService("HttpService")local dac=game:GetService("ReplicatedStorage")
local _bc=require(dac.modules)local abc=_bc.load("network")local bbc=_bc.load("utilities")
local cbc=_bc.load("placeSetup")local dbc=_bc.load("mapping")local _cc=_bc.load("detection")
local acc=_bc.load("damage")local bcc=_bc.load("projectile")
local ccc=_bc.load("client_utilities")local dcc=_bc.load("events")local _dc=_bc.load("tween")
local adc=_bc.load("effects")local bdc=_bc.load("ability_utilities")
local cdc=require(dac.itemData)local ddc=require(dac.abilityLookup)
local __d=require(script.Parent.Resources)local a_d=cbc.awaitPlaceFolder("entityRenderCollection")
local b_d=cbc.awaitPlaceFolder("entityManifestCollection")local c_d=cbc.awaitPlaceFolder("items")
local d_d=cbc.awaitPlaceFolder("entities")local _ad;local aad;local bad;local cad=true;local dad=false;local _bd=false;local function abd(_aaa)cad=_aaa
if not cad and dad then if
_ad and _ad.release then dad=false;_ad:release()end end end
local function bbd()
local _aaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")if _aaa then
for aaaa,baaa in pairs(_aaa)do if baaa.position==1 then return baaa end end end;return nil end
local function cbd(_aaa,aaaa)local baaa=_aaa.equipmentType;if baaa==aaaa then return true end;if aaaa=="sword"and baaa==
"greatsword"then return true end;local caaa=
(aaaa=="dagger")or(aaaa=="bow")
local daaa=(baaa=="dagger")or(baaa=="bow")
if caaa and daaa then
local _baa=abc:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if not _baa then return false end
local abaa=abc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",_baa.entity)if not abaa then return false end;local bbaa=abaa["11"]if(not bbaa)or
(not bbaa.baseData)then return false end;if bbaa.baseData.equipmentType==
aaaa then
abc:invokeServer("{56442647-1FBF-41E3-96CF-6908E65BE3DB}")return true end end;return false end
local function dbd(_aaa,aaaa,baaa,caaa)
if _aaa then local daaa=bbd()local _baa=daaa and cdc[daaa.id]
for abaa,bbaa in pairs(_aaa)do
if
bbaa.id==aaaa and bbaa.rank>0 then local cbaa=ddc[bbaa.id](caaa,baaa)
if cbaa and
(not
cbaa.equipmentTypeNeeded or(_baa and cbd(_baa,cbaa.equipmentTypeNeeded)))then return true end end end end;return false end
local function _cd(_aaa,aaaa)if _aaa then local baaa=bbd()local caaa=baaa and cdc[baaa.id]
for daaa,_baa in pairs(_aaa)do if
_baa.id==aaaa then return _baa.rank,_baa end end end;return 0,
nil end
local function acd(_aaa)
if _aaa.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then return
_aaa.Parent.clientHitboxToServerHitboxReference.Value end end
local function bcd(_aaa)
for aaaa,baaa in pairs(a_d:GetChildren())do
if

baaa:FindFirstChild("clientHitboxToServerHitboxReference")and baaa.clientHitboxToServerHitboxReference.Value==_aaa then return baaa.PrimaryPart end end end
local function ccd(_aaa,aaaa,baaa,caaa,daaa,_baa)
if acc.canPlayerDamageTarget(_ac,_aaa)then
abc:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",aaaa)
abc:fireServer("{EC14DAC8-3DE8-48EE-9A64-B26C37A5EF5A}",_aaa,aaaa,baaa,caaa,daaa,_baa)end end;local dcd
local function _dd(_aaa)local aaaa=cdc[_aaa.id]
if

aaaa and aaaa.isEquippable and aaaa.equipmentType and aaaa.equipmentSlot==dbc.equipmentPosition.weapon then
if
not _ad and c_c.damageInterfaces:FindFirstChild(aaaa.equipmentType)then dcd=aaaa.equipmentType
if bad and bad:FindFirstChild("entity")then
local baaa=abc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",bad.entity)
if baaa["1"]and baaa["11"]then
if

baaa["1"].baseData.equipmentType=="sword"and baaa["11"].baseData.equipmentType=="sword"then dcd="dual"elseif baaa["1"].baseData.equipmentType=="sword"and
baaa["11"].baseData.equipmentType=="shield"then
dcd="swordAndShield"end end end end;if dcd then _ad=require(c_c.damageInterfaces[dcd])
_ad:equip()end end end
local function add()if _ad then _ad:unequip()_ad=nil;dcd=nil end end
local function bdd(_aaa)
if _aaa then local aaaa
for baaa,caaa in pairs(_aaa)do if caaa.position==dbc.equipmentPosition.weapon then
aaaa=caaa end end
if aaaa then if _ad then add()end;_dd(aaaa)else if _ad then add()end end else end end
local function cdd(_aaa,aaaa)if _aaa=="equipment"then bdd(aaaa)end end
local function ddd(_aaa)aad=_aaa;if _aaa:IsA("BasePart")then
_aaa.Touched:Connect(function()end)end end;local ___a={id=0}local a__a=cac:JSONEncode(___a)
local function b__a(_aaa,aaaa,baaa,caaa)
if aaaa=="end"then baaa={id=0}end;baaa["step"]=(baaa["step"]or 0)+1
if aaaa=="update"then baaa["times-updated"]=(
baaa["times-updated"]or 0)+1 end;local daaa,_baa=bbc.safeJSONEncode(baaa)
if daaa then
if aaaa=="end"then
abc:fireServer("{51A91F3B-9019-471D-A6C9-79833B23B075}",_aaa,aaaa,
nil,caaa)else
abc:fireServer("{51A91F3B-9019-471D-A6C9-79833B23B075}",_aaa,aaaa,baaa,caaa)end
local abaa=
game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character.PrimaryPart
if abaa then abaa.activeAbilityExecutionData.Value=_baa end end end
abc:create("{C8F2171C-1C77-4D97-89FD-DBA03550755B}","BindableFunction","OnInvoke",b__a)
local function c__a(_aaa,aaaa)local baaa=aaaa or{}
local caaa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local daaa;if _aaa then daaa=ddc[_aaa](caaa,baaa)end;local _baa=_aaa and
abc:invoke("{037FE164-CCF7-41A0-87B1-D384E9A16236}")do if daaa and
daaa.disableAutoaim then _baa=nil end end
local abaa,bbaa,cbaa=ccc.raycastFromCurrentScreenPoint({a_d,a_d,c_d,d_d})local dbaa={}for acaa,bcaa in pairs(baaa)do dbaa[acaa]=bcaa end
dbaa["mouse-screen-position"]=aac:GetMouseLocation()dbaa["mouse-world-position"]=bbaa
dbaa["absolute-mouse-world-position"]=bbaa
do
local acaa,bcaa,ccaa=ccc.raycastFromCurrentScreenPoint({c_d,d_d})dbaa["mouse-target-position"]=bcaa end;dbaa["mouse-target"]=abaa;dbaa["ability-state"]="begin"dbaa["times-updated"]=
dbaa["times-updated"]or 0;local _caa=bbd()if _caa then
dbaa["cast-weapon-id"]=_caa.id end
if
_baa and _ac.Character and _ac.Character.PrimaryPart then dbaa["target-position"]=_baa.Position
dbaa["target-velocity"]=_baa.Velocity
dbaa["target-distance-away"]=(_baa.Position-_ac.Character.PrimaryPart.Position).magnitude end
if _ac.Character and _ac.Character.PrimaryPart then
dbaa["cast-origin"]=_ac.Character.PrimaryPart.Position
if dbaa["target-position"]then
local acaa=dbaa["target-position"]-dbaa["cast-origin"]
if acaa.magnitude>35 then
dbaa["target-position"]=dbaa["cast-origin"]+
Vector3.new(acaa.X,0,acaa.Z).unit*35;dbaa["target-distance-away"]=35 end end
if dbaa["mouse-world-position"]then
local acaa=dbaa["mouse-world-position"]-dbaa["cast-origin"]if acaa.magnitude>35 then
dbaa["mouse-world-position"]=dbaa["cast-origin"]+
Vector3.new(acaa.X,acaa.Y,acaa.Z).unit*35 end end end
if abaa then local acaa,bcaa;do
if abaa:IsDescendantOf(b_d)then
acaa=game.Players:GetPlayerFromCharacter(abaa.Parent)elseif abaa:IsDescendantOf(b_d)then bcaa=abaa end end
if acaa then
dbaa["target-player-userId"]=acaa.userId
if
acaa and acaa.Character and acaa.Character.PrimaryPart and
_ac.Character and _ac.Character.PrimaryPart then
dbaa["target-position"]=acaa.Character.PrimaryPart.Position
dbaa["target-velocity"]=acaa.Character.PrimaryPart.Velocity
dbaa["target-distance-away"]=(acaa.Character.PrimaryPart.Position-
_ac.Character.PrimaryPart.Position).magnitude end elseif bcaa and not _baa then dbaa["target-position"]=bcaa.Position
dbaa["target-velocity"]=bcaa.Velocity
if bcaa and _ac.Character and _ac.Character.PrimaryPart then
dbaa["target-distance-away"]=(
bcaa.Position-_ac.Character.PrimaryPart.Position).magnitude end end end
if _aaa then if daaa and daaa.executionData then
for cdaa,ddaa in pairs(daaa.executionData)do dbaa[cdaa]=ddaa end end
local acaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")local bcaa=_cd(acaa,_aaa)
if bcaa and bcaa>0 then
local cdaa=bdc.getAbilityStatisticsForRank(daaa,bcaa,_ac,_aaa)if cdaa then
dbaa["ability-statistics"]=dbaa["ability-statistics"]or cdaa end end
local ccaa=daaa.targetingData and daaa.targetingData.range or
dbaa["ability-statistics"].range or daaa.statistics.range
if typeof(ccaa)=="string"then ccaa=dbaa["ability-statistics"].range or
daaa.statistics.range elseif typeof(ccaa)==
"function"then error("Not yet implemented!")end
local dcaa,_daa,adaa=ccc.raycastFromCurrentScreenPoint({c_d,d_d},ccaa)dbaa["mouse-inrange"]=_daa;local bdaa=daaa
if bdaa then
local cdaa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")
dbaa["_dex"]=dbaa["_dex"]or cdaa and
cdaa.nonSerializeData.statistics_final.dex or 0
dbaa["_int"]=dbaa["_int"]or cdaa and
cdaa.nonSerializeData.statistics_final.int or 0
dbaa["_vit"]=dbaa["_vit"]or cdaa and
cdaa.nonSerializeData.statistics_final.vit or 0
dbaa["_str"]=dbaa["_str"]or cdaa and
cdaa.nonSerializeData.statistics_final.str or 0;if bdaa._abilityExecutionDataCallback then
bdaa._abilityExecutionDataCallback(cdaa,dbaa)end
dbaa.IS_ENHANCED=bdaa._doEnhanceAbility and
bdaa._doEnhanceAbility({nonSerializeData=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData")})end end
dbaa["camera-cframe"]=workspace.CurrentCamera.CFrame;dbaa["nearest-player"]=nil;dbaa["nearest-player"]=nil
dbaa["id"]=_aaa;dbaa["cast-player-userId"]=_ac.userId
dbaa["manual-aim"]=false;return dbaa end
abc:create("{0659F187-209D-48FD-AE95-040A0C31DB94}","BindableFunction","OnInvoke",c__a)local d__a={}local _a_a={}
local function aa_a(_aaa)d__a[_aaa]=nil;local aaaa=_a_a[_aaa]if aaaa then
abc:invoke("{57B7F861-701C-4A01-A7A9-5696208852A4}",aaaa,0)end end
local function ba_a(_aaa,aaaa,baaa,caaa)if _bd then return false end;local daaa=ddc[_aaa](caaa,aaaa)if not daaa then
return false end
local _baa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")local abaa=_cd(_baa,_aaa)
if not abaa or abaa<1 then return false end;local bbaa=bdc.getAbilityStatisticsForRank(daaa,abaa)local cbaa=
bbaa.manaCost or 20
if
_ac.Character.PrimaryPart.mana.Value<cbaa then return false,"missing-mana"end;if
_ac.Character.PrimaryPart.health.Value<=0 then return false end;if

_ac.Character.PrimaryPart.state.Value=="dead"or
_ac.Character.PrimaryPart.state.Value=="gettingUp"then return false end;if
abc:invoke("{BF956380-404B-41BA-8742-E8FD573AD12E}")then return end
local dbaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData")if not dbaa then return false end
if not dbd(_baa,_aaa,aaaa,caaa)then return false end;local _caa=true
if not d__a[_aaa]or
tick()-d__a[_aaa]>= (bbaa.cooldown or 5)* (1 -
dbaa.statistics_final.abilityCDR)then _caa=false end;if _caa then return false end;return true end
local function ca_a(_aaa,aaaa,baaa)
local caaa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")if not ba_a(_aaa,aaaa,baaa,caaa)then return end
local daaa=ddc[_aaa](caaa,aaaa)
local _baa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")local abaa=_cd(_baa,_aaa)
local bbaa=bdc.getAbilityStatisticsForRank(daaa,abaa)
local cbaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData")d__a[_aaa]=tick()_a_a[_aaa]=baaa
abc:invoke("{57B7F861-701C-4A01-A7A9-5696208852A4}",baaa,
bbaa.cooldown* (1 -cbaa.statistics_final.abilityCDR))
local dbaa=abc:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if dbaa then local _caa=cac:GenerateGUID(false)
aaaa["ability-guid"]=_caa;local acaa,bcaa=bbc.safeJSONEncode(aaaa)
if not acaa then return false end;_bd=true;abd(false)
abc:invoke("{239414C2-E250-4BB6-8E25-D15DAD420362}",false)
abc:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",false)
if not daaa.dontDisableSprinting then
abc:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",false)
abc:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSprinting",false)end;if daaa.faceTowardsCastingDirection and aaaa.castingDirection then
abc:invoke("{ACB01AD9-CBB1-46ED-8062-F2A62AF8A5A8}",true,aaaa.castingDirection)end
abc:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",_aaa,true,aaaa,_caa)repeat wait()until not _bd;abd(true)
abc:invoke("{239414C2-E250-4BB6-8E25-D15DAD420362}",true)
abc:invoke("{B30EB314-CDF0-4ED4-B056-C19256A25390}",true)
abc:invoke("{8CDB267C-DC11-4E51-BEB5-EB2A7A4790CE}",true)if daaa.faceTowardsCastingDirection then
abc:invoke("{ACB01AD9-CBB1-46ED-8062-F2A62AF8A5A8}",false)end;return true end end;local da_a={}da_a.executionData=nil;da_a.id=nil;local _b_a
local function ab_a(_aaa,aaaa,baaa)
if not
abc:invoke("{CB505807-178C-4E8F-AE40-B0B823BF476E}")then baaa=baaa
local caaa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local daaa=ddc[_aaa](caaa,baaa)baaa=baaa or c__a(_aaa)if daaa then if
baaa["manual-aim"]then
baaa["target-casting-position"]=baaa["mouse-world-position"]end
return ca_a(_aaa,baaa,aaaa)end end end;local function bb_a(_aaa)end
local function cb_a(_aaa)bad=_aaa
local aaaa=_aaa.entity:WaitForChild("AnimationController")
while not aaaa:IsDescendantOf(workspace)do wait()end;if _ad then _ad:equip()end
_b_a=aaaa:LoadAnimation(game.ReplicatedStorage.abilityAnimations.rock_throw_upper_loop)end;local function db_a(_aaa)
local aaaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")bdd(aaaa)end
local _c_a={dual=.15,dagger=.15,sword=.23,staff=.23,bow=0}local ac_a
local function bc_a(_aaa,aaaa)
if cad and _ad and not aaaa and not
abc:invoke("{CB505807-178C-4E8F-AE40-B0B823BF476E}")then
if



_aaa.UserInputType==Enum.UserInputType.Touch or _aaa.UserInputType==
Enum.UserInputType.MouseButton1 or _aaa.KeyCode==Enum.KeyCode.LeftControl or _aaa.KeyCode==Enum.KeyCode.ButtonR2 then
if abc:invoke("{BF956380-404B-41BA-8742-E8FD573AD12E}")then return end;if ac_a then return end
abc:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSprinting",false)dcc:fireEventAll("playerWillUseBasicAttack",_ac)
_ad:attack(_aaa)
abc:fire("{CB527931-903D-443E-9010-9C92D87E9BE2}","attack")
abc:fire("{E7FC437C-0080-4CDD-A9D5-BC1E7A0FE7BF}",true)
local baaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final;local caaa=.25;if _c_a[dcd]then
caaa=_c_a[dcd]/ (1 +baaa.attackSpeed)end end end end
local function cc_a(_aaa,aaaa)
if dad and _ad and not aaaa and _ad.release then
if

_aaa.UserInputType==
Enum.UserInputType.MouseButton1 or _aaa.KeyCode==Enum.KeyCode.LeftControl or _aaa.KeyCode==Enum.KeyCode.ButtonR2 then _ad:release()dad=false end elseif dad and _ad then
if

_aaa.UserInputType==Enum.UserInputType.MouseButton1 or
_aaa.KeyCode==Enum.KeyCode.LeftControl or _aaa.KeyCode==Enum.KeyCode.ButtonR2 then dad=false
abc:fire("{E7FC437C-0080-4CDD-A9D5-BC1E7A0FE7BF}",false)end end end
local function dc_a(_aaa,aaaa)
if not _aaa then _aaa=_ac.Character.PrimaryPart.Position end;bbc.playSound(aaaa,_aaa)end
abc:connect("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}","OnClientEvent",dc_a)
local function _d_a(_aaa,aaaa,baaa)local caaa=aaaa:FindFirstChild("attackableScript")
if not caaa then return end
abc:fire("{E29E22FB-E00A-4D5C-924C-01172195752D}",baaa,_aaa~=_ac)caaa=require(caaa)caaa.onAttackedClient(_aaa)end
abc:connect("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}","OnClientEvent",_d_a)
local function ad_a(_aaa)
if _aaa and _aaa:IsA("Model")then
if _aaa.PrimaryPart then
local aaaa=_aaa:FindFirstChild("originalCFrame")
if aaaa==nil then aaaa=Instance.new("CFrameValue")
aaaa.Name="originalCFrame"aaaa.Value=_aaa.PrimaryPart.CFrame;aaaa.Parent=_aaa end;local baaa=aaaa.Value;local caaa=_aaa.PrimaryPart
local daaa=baaa*
CFrame.new(0,-caaa.Size.Y/2,0)*
CFrame.Angles(0,math.pi*2 *math.random(),0)local _baa=daaa:ToObjectSpace(baaa)
local abaa=Instance.new("Part")abaa.CFrame=daaa;local bbaa=0.2;local cbaa=Enum.EasingStyle.Quad
_dc(abaa,{"CFrame"},
daaa*CFrame.Angles(0.075,0,0),bbaa,cbaa,Enum.EasingDirection.Out)
delay(bbaa,function()
_dc(abaa,{"CFrame"},daaa,bbaa,cbaa,Enum.EasingDirection.In)end)
adc.onHeartbeatFor(bbaa*2,function()
_aaa:SetPrimaryPartCFrame(abaa.CFrame:ToWorldSpace(_baa))end)end end end;local bd_a={}
local function cd_a(_aaa,aaaa)local baaa=aaaa.Name:lower()
if

(baaa=="grass")or(baaa=="leaf")or(baaa=="bush")or(baaa=="green")then
if not _aaa["strikeFoliage"]then
local caaa="bush"..math.random(1,3)dc_a(aaaa.Position,caaa)
abc:fireServer("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}",aaaa,caaa)ad_a(aaaa.Parent)end end;if(baaa=="stump")or(baaa=="log")or(baaa=="wood")then
ad_a(aaaa.Parent)end
if bac:HasTag(aaaa,"attackable")then
if
aaaa:IsDescendantOf(cbc.getPlaceFolder("resourceNodes"))then local caaa=aaaa:FindFirstAncestorWhichIsA("Model")
ad_a(caaa)local daaa=abc:invokeServer("HarvestResource",caaa)
__d:DoEffect(caaa,"Harvest")if daaa then daaa.Transparency=1 end else
local caaa=_cc.projection_Box(aaaa.CFrame,aaaa.Size,aad.Position)_d_a(_ac,aaaa,caaa)
abc:fireServer("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}",aaaa,caaa)end end end
local function dd_a(_aaa)local aaaa=bd_a[_aaa]if not aaaa then aaaa={}bd_a[_aaa]=aaaa
delay(5,function()bd_a[_aaa]=nil end)end;for baaa,caaa in
pairs(aad:GetTouchingParts())do
if not aaaa[caaa]then aaaa[caaa]=true;cd_a(aaaa,caaa)end end end;local __aa={}
local function a_aa(_aaa,aaaa,baaa)
if(_aaa=="equipment"and aad)then
if not __aa[baaa]then __aa[baaa]={}delay(5,function()__aa[baaa]=
nil end)end;dd_a(baaa)
local caaa=1 +
abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final.attackRangeIncrease
for daaa,_baa in pairs(bbc.getEntities())do
if _baa~=_ac.Character.PrimaryPart then
if not
__aa[baaa][_baa]then local abaa=aad.CFrame
local bbaa=_cc.projection_Box(_baa.CFrame,_baa.Size,abaa.p)
if
_cc.boxcast_singleTarget(abaa,aad.Size*Vector3.new(3 +caaa,2 +caaa,3 +caaa),bbaa)then __aa[baaa][_baa]=true
abc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_baa,bbaa,_aaa,aaaa,baaa)end end end end else end end
local function b_aa()local _aaa=bbd()return cdc[_aaa.id].equipmentType end
local function c_aa(_aaa,aaaa,...)
local baaa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local caaa=ddc[aaaa](baaa,_aaa)if not caaa then return nil end;if not
caaa.execute_client then return nil end
return caaa:execute_client(_aaa,...)end
local function d_aa()
abc:create("{86F81874-E106-420D-B215-D322A8D18B96}","BindableFunction","OnInvoke",b_aa)
abc:create("{7312D87A-2CEB-427E-9FC9-78CB6711E469}","BindableFunction","OnInvoke",abd)
abc:create("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}","BindableEvent","Event",ccd)
abc:create("{7A60EE45-884C-4454-8518-F0B368D30D75}","BindableFunction","OnInvoke",ab_a)
abc:create("{2AF94E4D-BAA6-4C38-9DB3-E0E8E3C71685}","BindableFunction","OnInvoke",function(baaa,caaa,daaa)daaa=daaa or c__a(baaa)
local _baa=abc:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")return ba_a(baaa,daaa,caaa,_baa)end)
abc:create("{5F5D5BE5-27D1-4783-ABB2-4C83A1E617AE}","BindableFunction","OnInvoke",a_aa)
abc:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",cdd)
abc:create("{ECE1FD54-A4D4-47DD-8A4C-B250EE03FB43}","BindableEvent","Event",bb_a)
aad=abc:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")
abc:connect("{7C64A511-FF4D-4ADC-B9A2-2E5EDDB8E412}","Event",ddd)
local _aaa=abc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")
local aaaa=abc:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if aaaa then cb_a(aaaa)end
abc:connect("{8BABF769-4B51-49E3-9501-B715DD0790C7}","Event",cb_a)
abc:connect("{B62079C1-52DB-4F8A-8629-2288C1E97E3D}","OnClientEvent",aa_a)
abc:connect("{BE1205CC-1952-4C32-BE72-9A9C3C53E41C}","OnClientInvoke",c_aa)
abc:connect("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}","OnClientEvent",c_aa)
abc:create("{D4CB0603-73AC-434F-B92F-809E1FBF589B}","BindableFunction","OnInvoke",function()return _bd end)
abc:create("{51252262-788E-447C-A950-A8E92643DAEA}","BindableEvent","Event",function(baaa)_bd=baaa end)if _ac.Character then db_a(_ac.Character)end
_ac.CharacterAdded:connect(db_a)aac.InputBegan:connect(bc_a)
aac.InputEnded:connect(cc_a)end;d_aa()return d_c