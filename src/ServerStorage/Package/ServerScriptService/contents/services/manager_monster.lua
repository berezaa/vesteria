local bcc={}local ccc={}local dcc={}dcc.isAggressive=true;dcc.aggressionRange=35
dcc.attackRange=10;dcc.attackSpeed=10
dcc.detectionFromOutOfVisionRange=dcc.attackRange*1.5;dcc.visionAngle=math.rad(75)dcc.sightRange=200
dcc.attackType="physical"dcc.level=1;dcc.playerFollowDistance=50;dcc.baseSpeed=10;dcc.burstSpeed=9
dcc.burstDuration=0;dcc.burstCooldown=0;local _dc=tick()local adc=tick()
local function bdc(caba,...)if
caba.manifest:FindFirstChild("ParticleEmitter")then print("***",...)end end;local cdc=game:GetService("HttpService")
local ddc=game:GetService("ReplicatedStorage")local __d=require(ddc.modules)local a_d=__d.load("network")
local b_d=__d.load("utilities")local c_d=__d.load("physics")local d_d=__d.load("placeSetup")
local _ad=__d.load("projectile")local aad=__d.load("mapping")local bad=__d.load("levels")
local cad=__d.load("pathfinding")local dad=__d.load("configuration")
local _bd=__d.load("events")local abd=require(ddc.itemData)
local bbd=require(ddc.monsterLookup)local cbd=require(ddc.defaultMonsterState)dcc.__index=dcc
local dbd=1 /10;local _cd=150;local acd=10;local bcd=3;local ccd=1;local dcd=5;local _dd=0.96;local add=10;local bdd={}local cdd=true
local ddd=ddc.itemData;local ___a=require(ddd)local a__a=game:GetService("RunService")
local b__a=game:GetService("ServerStorage")local c__a=game:GetService("ReplicatedStorage")
local d__a=game:GetService("PathfindingService")local _a_a=game:GetService("CollectionService")local aa_a=false
local ba_a=require(b__a.spawnRegionCollectionData)local ca_a=d_d.getPlaceFolder("spawnRegionCollections")
local da_a=d_d.getPlaceFolder("entityManifestCollection")local _b_a=d_d.getPlaceFolder("entityRenderCollection")
local ab_a=d_d.getPlaceFolder("items")local bb_a=d_d.getPlaceFolder("entities")
local cb_a=d_d.getPlaceFolder("foilage")local db_a=d_d.getPlaceFolder("activeMonsterLures")
local _c_a={ca_a,da_a,_b_a,ab_a,bb_a,cb_a}local ac_a={}local bc_a={}
a_d:create("{94EA4964-9682-4133-B150-B6EE2056FD70}","RemoteEvent")
a_d:create("{D8402E91-2473-4E38-9AA0-6D6D324AB8E7}","RemoteEvent","OnServerEvent",function(caba,daba)for _bba,abba in pairs(da_a:GetChildren())do
if
abba:FindFirstChild("ParticleEmitter")then abba.ParticleEmitter:Destroy()end end
Instance.new("ParticleEmitter",daba)end)
local function cc_a(caba)local daba=caba.targetEntity or caba.closestEntity;if not daba then return false,
"no HRP"end
local _bba=CFrame.new(caba.manifest.Position,daba.Position).lookVector
local abba=math.acos(_bba:Dot(caba.manifest.CFrame.lookVector))return abba<=caba.visionAngle end
function dcc:isTargetEntityInLineOfSight(caba,daba,_bba)
if self.targetEntity and
(self.targetEntityLockType or 0)>=1 then return true end;local abba=self.targetEntity or self.closestEntity;do if _bba then
abba=_bba end end
local function bbba(dbba)
if not dbba then return false,"no target HRP"end
if
daba and not cc_a(self)and
b_d.magnitude(dbba.Position-self.manifest.Position)>self.detectionFromOutOfVisionRange then return false,"vision cone fail"end
if dbba:FindFirstChild("isStealthed")then return false,"player stealthed"end;local _cba=self.manifest.Position;local acba=dbba.Position-_cba
local bcba=Ray.new(_cba,
acba.unit*
math.min(acba.magnitude,caba and caba or self.sightRange))
local ccba,dcba=_ad.raycast(bcba,{ca_a,da_a,_b_a,ab_a,bb_a,cb_a})
return ccba==nil or ccba==dbba,tostring(ccba).."was hit"end;if abba then
if bbba(abba)then self.closestEntity=abba;self.targetEntity=abba;return true end end
local cbba=self.aggressionRange
for dbba,_cba in pairs(self.nearbyTargets)do
if
b_d.magnitude(_cba.Position-self.manifest.Position)<=cbba then if bbba(_cba)then self.closestEntity=_cba
self.targetEntity=_cba;return true end end end end;function dcc:isTargetEntityValid()end
local function dc_a(caba)local daba={}for _bba,abba in pairs(caba)do if typeof(_bba)~="string"then
table.insert(daba,_bba)end
if typeof(abba)=="table"then dc_a(abba)end end;for _bba,abba in
pairs(daba)do local bbba=caba[abba]caba[abba]=nil
caba[tostring(abba)]=bbba end end
local function _d_a(caba,daba)
for _bba,abba in pairs(bdd)do if abba.manifest==caba then
if daba then return abba[daba]else return abba end end end;return nil end
local function ad_a(caba)local daba=0;for _bba,abba in pairs(bdd)do
if abba.__SPAWN_REGION_COLLECTION==caba then daba=daba+1 end end;return daba end
local function bd_a(caba)local daba={}
for _bba,abba in pairs(caba:GetChildren())do if abba:IsA("BasePart")then
table.insert(daba,{spawnRegion=abba,selectionWeight=math.floor(
abba.Size.X*abba.Size.Z+0.5)})end end;return b_d.selectFromWeightTable(daba)end;local cd_a=Random.new()
local function dd_a(caba)local daba,_bba
for i=1,5 do
local abba=Ray.new((caba.CFrame*
CFrame.new(0.9 *cd_a:NextInteger(-
caba.Size.X/2,caba.Size.X/2),
caba.Size.Y/2,0.9 *
cd_a:NextInteger(-caba.Size.Z/2,caba.Size.Z/2))).p,Vector3.new(0,
-caba.Size.Y,0))
daba,_bba=workspace:FindPartOnRayWithIgnoreList(abba,_c_a)if daba then break end end;return _bba end
local function __aa(caba)local daba=Vector3.new()local _bba=0;local abba=caba.manifest.Position
local bbba=caba.nearbyTargets
for cbba,dbba in pairs(bbba)do local _cba=dbba.position
local acba=CFrame.new(abba,Vector3.new(_cba.X,abba.Y,_cba.Z))daba=daba+acba.LookVector
_bba=_bba+ (abba-_cba).Magnitude end;daba=daba/#bbba
return{density=daba.Magnitude,direction=daba,distance=_bba}end;local function a_aa(caba,daba)end;function dcc:getRoamPositionInSpawnRegion()
return dd_a(self.__SPAWN_REGION)end;local b_aa=Random.new()
function dcc:dropItem(caba,daba,_bba)daba=
daba or nil;_bba=_bba or 1
local abba=a_d:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",caba.lootDropData,caba.dropPosition,caba.itemOwners)if abba==nil then return false end;if caba.lootDropData.id==181 then
local dbba=Instance.new("StringValue")dbba.Name="monsterName"dbba.Value=self.module.Name
dbba.Parent=abba end;if
_bba>1 then end;local bbba
local cbba=Vector3.new((b_aa:NextNumber()-0.5)*24,(2 +
b_aa:NextNumber())*30,(b_aa:NextNumber()-0.5)*24)cbba=cbba* (1 + ( (_bba-1)/27))
if
abba:IsA("BasePart")then abba.Velocity=cbba;bbba=abba elseif abba:IsA("Model")and(abba.PrimaryPart or
abba:FindFirstChild("HumanoidRootPart"))then
local dbba=
abba.PrimaryPart or abba:FindFirstChild("HumanoidRootPart")if dbba then dbba.Velocity=cbba;bbba=dbba end end;return true,abba end
function dcc:setTargetEntity(caba,daba,_bba,abba)if daba then self.closestEntity=nil end;self.targetEntityLockType=
self.targetEntityLockType or 0
if self.targetEntityLockType>=3 and
self.targetEntityLockType> (abba or 0)then return false end
if
self.targetEntityLockType<=2 and abba and abba>=2 then self.defaultTargetEntity=caba end
if not caba and self.defaultTargetEntity then
self.targetEntity=self.defaultTargetEntity else self.targetEntity=caba end;self.targetEntitySetSource=_bba or nil;if abba then
self.targetEntityLockType=abba end
self.manifest.targetEntity.Value=caba end
function dcc:setState(caba,daba)if self.state=="dead"then return end
if self.state~=caba then local _bba,abba=b_d.safeJSONEncode(
daba or{})self.manifest.stateData.Value=
_bba and abba or"[]"
self.manifest.state.Value=caba;self.state=caba end
if caba=="dead"then
a_d:fire("{32937BC1-CC17-495B-B878-D4F114692178}",self.manifest)self.manifest.Anchored=true;self.manifest.CanCollide=false;if
self.stateMachine and self.stateMachine.onTransition then
self.stateMachine.onTransition:Destroy()end;if

self.stateMachine.states.dead and self.stateMachine.states.dead.step then
self.stateMachine.states.dead.step(self)end
for _bba,abba in pairs(bdd)do
if
abba==self then table.remove(bdd,_bba)for bbba,cbba in pairs(abba.__EVENTS)do
cbba:disconnect()end;abba.__EVENTS=nil
delay(dcd,function()
self.stateMachine.states=nil;wait(30)self.manifest:Destroy()for bbba,cbba in pairs(self)do
self[bbba]=nil end end)break end end end end
function dcc:getMass(caba)return self.manifest:GetMass()end
function dcc:resetPathfinding()if self.pathfindingTrigger=="roaming"then
self.__LAST_ROAM_TIME=tick()end;self.isProcessingPath=false;self.pathfindingTrigger=
nil;self.path=nil;self.currentNode=1 end;local c_aa={}local d_aa={}d_aa.__index=d_aa
local function _aaa(caba)local daba=caba.manifest
local _bba=b_d.getEntityGUIDByEntityManifest(daba)if not _bba then return false end
local abba=a_d:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",_bba)for bbba,cbba in pairs(abba)do
if cbba.statusEffectType=="stunned"then return true end end;return false end
local function aaaa(caba)if _aaa(caba)then
caba.manifest.BodyVelocity.Velocity=Vector3.new()return end;local daba=caba.stateMachine;if(not daba)or(not
daba.states)then return end
local _bba=daba.states[daba.currentState]
local abba=(not _bba.lockTimeForPreventStateTransition or tick()-_bba.__START_TIME>
_bba.lockTimeForPreventStateTransition)local bbba,cbba=_bba.step(caba,abba)
if bbba and abba then
local dbba=daba.states[bbba]
if
dbba and
(not _bba.lockTimeForLowerTransition or
dbba.transitionLevel>=_bba.transitionLevel or tick()-_bba.__START_TIME>=
_bba.lockTimeForLowerTransition)then
daba.onTransition:Fire(daba.currentState,bbba,cbba)
if _bba.verify then
if

caba.targetEntity and caba.targetEntity:FindFirstChild("entityType")and caba.targetEntity.entityType.Value=="monster"then _bba.verify(caba)end end;dbba.__START_TIME=tick()daba.previousState=daba.currentState
daba.currentState=bbba end end end
function d_aa:forceStateChange(caba)
if self.states[caba]then
self.onTransition:Fire(self.currentState,caba)self.states[caba].__START_TIME=tick()
self.previousState=self.currentState;self.currentState=caba end end
function c_aa.create(caba,daba,_bba)local abba={}
abba.states=_bba and b_d.copyTable(_bba)or{}abba.previousState="initializing"abba.currentState=daba
abba.onTransition=Instance.new("BindableEvent")
local bbba=b_d.copyTable(require(c__a.defaultMonsterState))
setmetatable(abba.states,{__index=function(cbba,dbba)return bbba.states[dbba]end})daba=daba or"idling"
abba.states[daba].__START_TIME=tick()return setmetatable(abba,d_aa)end;local baaa
do baaa=Instance.new("Part")
baaa.TopSurface=Enum.SurfaceType.Smooth;baaa.BottomSurface=Enum.SurfaceType.Smooth
baaa.Shape=Enum.PartType.Ball;baaa.Transparency=1;baaa.CanCollide=true;baaa.Anchored=false
local caba=Instance.new("BodyVelocity",baaa)caba.MaxForce=Vector3.new(100000,0,100000)
caba.Velocity=Vector3.new(0,0,0)local daba=Instance.new("BodyGyro",baaa)
daba.MaxTorque=Vector3.new(1e5,1e5,1e5)daba.P=7000;daba.D=500
local _bba=Instance.new("BodyForce",baaa)local abba=Instance.new("StringValue",baaa)abba.Name="state"
abba.Value="sleeping"local bbba=Instance.new("ObjectValue",baaa)
bbba.Name="targetEntity"bbba.Value=nil;local cbba=Instance.new("StringValue",baaa)
cbba.Name="stateData"cbba.Value="[]"local dbba=Instance.new("StringValue",baaa)
dbba.Name="entityType"dbba.Value="monster"
local _cba=Instance.new("StringValue",baaa)_cba.Name="entityId"_cba.Value=""
local acba=Instance.new("StringValue",baaa)acba.Name="statusEffectsV2"acba.Value="{}"
local bcba=Instance.new("StringValue",baaa)bcba.Name="stance"
local ccba=Instance.new("NumberValue",baaa)ccba.Name="maxHealth"ccba.Value=100
local dcba=Instance.new("NumberValue",baaa)dcba.Name="health"dcba.Value=100
local _dba=Instance.new("IntValue",baaa)_dba.Name="level"_dba.Value=1;_a_a:AddTag(baaa,"monster")
c_d:setWholeCollisionGroup(baaa,"monsters")end;local caaa={}local function daaa(caba,daba)caaa[caba.Name]=daba end
function ccc:getSpawnRegionCollectionsUnderPopulated()
local caba={}
for daba,_bba in pairs(ca_a:GetChildren())do
if _bba.Name~="Pets"and
not caaa[_bba.Name]then
local abba,bbba=string.match(_bba.Name,"(.+)-(%d+)")local cbba=false;local dbba=1;if a__a:IsRunMode()or a__a:IsStudio()then
dbba=0.75 end
if game.Lighting.ClockTime<5.9 or
game.Lighting.ClockTime>18.6 then dbba=dbba*1.5 end
if abba and bbba then
bbba=math.ceil(tonumber(bbba)*dbba)if ad_a(_bba)<bbba then cbba=true end end;if cbba then
table.insert(caba,{monsterNameToSpawn=abba,spawnRegionCollection=_bba})end end end;return caba end;function ccc.getRealClientEntity(caba)if bbd[caba]then
return bbd[caba].entity:Clone()end end
local _baa={}
function ccc.getMonsterManifestFromClientEntity(caba,daba,_bba)
if caba and daba then local abba=baaa:Clone()abba.Name=_bba
local bbba=_baa[_bba]
if bbba==nil then bbba=caba:GetExtentsSize()_baa[_bba]=bbba end
abba.Size=Vector3.new(bbba.Y,bbba.Y,bbba.Y)* (daba.hitboxDilution or _dd)return abba else
warn("realMonsterClientEntity",caba,"baseStats",daba)end end;function ccc.getMonsterBaseStats(caba)return bbd[caba]end
local abaa=Random.new(os.time())
local function bbaa(caba)if
game.Lighting.ClockTime<5.9 or game.Lighting.ClockTime>18.6 then return true end
if not caba and not
dad.getConfigurationValue("doUseNightTimeGiantSpawn")then return true elseif caba and not
dad.getConfigurationValue(caba)then return true end;return
game.Lighting.ClockTime>18.3 or game.Lighting.ClockTime<6 end
function ccc.new(caba,daba,_bba,abba,bbba,cbba)if not caba then return end
local dbba=ccc.getMonsterBaseStats(caba)local _cba=ccc.getRealClientEntity(caba)
local acba=ccc.getMonsterManifestFromClientEntity(_cba,dbba,caba)if not acba then
warn("no manifest for "..tostring(caba))return end;if not dbba then dbba={}end;if not _cba then
return false end;acba.Name=caba;acba.entityId.Value=caba;local bcba={}
bcba.monsterName=caba;bcba.__LAST_UPDATE=tick()bcba.__LAST_ATTACK_TIME=0
bcba.__LAST_GRAVITY_RAYCAST_UPDATE=0;bcba.__LAST_POSITION_SEEN=nil;bcba.__LAST_MOVE_DIRECTION=nil
bcba.__SPAWN_REGION_COLLECTION=_bba;bcba.__SPAWN_REGION=abba;bcba.__LAST_ROAM_TIME=0
bcba.__IS_WAITING_FOR_PATH_FINDING=false;bcba.__EVENTS={}
bcba.__MONSTER_EVENTS=dbba.monsterEvents or{}bcba.__STATE_OVERRIDES=dbba.stateOverrides or{}
bcba.currentNode=1;bcba.specialsUsed=0;bcba.isProcessingPath=false;bcba.origin=nil
bcba.state="sleeping"bcba.roamingTargetPosition=nil;bcba.targetEntity=nil
bcba.maxHealth=dbba.maxHealth;bcba.health=dbba.maxHealth;bcba.level=dbba.level;bcba.manifest=acba
bcba.clientEntity=ccc.getRealClientEntity(caba)
for ddba,__ca in pairs(dbba)do bcba[ddba]=__ca;bcba["_"..ddba]=__ca end;if
(not bbba or not bbba.variation)and bbaa("doSpawnNightTimeVariants")then end
if bbba then local ddba=bbba.variation;local __ca=ddba and
dbba.variations[ddba]bcba.variation=ddba;if __ca then for a_ca,b_ca in pairs(__ca)do
bcba[a_ca]=b_ca end end;for a_ca,b_ca in pairs(bbba)do
bcba[a_ca]=b_ca end end;local ccba=bbd[caba].statesData
local dcba=c_aa.create(bcba,ccba.default,ccba.states)bcba.stateMachine=dcba;local _dba
if daba then
if typeof(daba)=="CFrame"then _dba=daba+
Vector3.new(0,bcba.manifest.Size.Y,0)elseif typeof(daba)=="Vector3"then
_dba=
CFrame.new(daba)+Vector3.new(0,bcba.manifest.Size.Y,0)elseif typeof(daba)=="Instance"and daba:IsA("BasePart")then
_dba=
daba.CFrame+Vector3.new(0,bcba.manifest.Size.Y,0)end;_dba=_dba else warn("spawnLocation was nil")end;_dba=_dba*
CFrame.Angles(0,math.rad(math.random(1,360)),0)
if _dba then
bcba.manifest.CFrame=_dba;bcba.origin=_dba else warn("invalid spawnLocation given")end
local adba=dcba.onTransition.Event:connect(function(ddba,__ca,a_ca)if
acba:FindFirstChild("ParticleEmitter")then end;if dcba.states[__ca].execute_server then
spawn(function()
dcba.states[__ca].execute_server(bcba)end)end
bcba:setState(__ca,a_ca)if dbba.monsterEvents and dbba.monsterEvents.onStateChanged then
dbba.monsterEvents.onStateChanged(bcba,ddba,__ca)end end)table.insert(bcba.__EVENTS,adba)
setmetatable(bcba,dcc)aaaa(bcba)bcba.healthMulti=bcba.healthMulti or 1;bcba.bonusXPMulti=
bcba.bonusXPMulti or 1
bcba.damageMulti=bcba.damageMulti or 1;bcba.goldMulti=bcba.goldMulti or 1
bcba.bonusLootMulti=bcba.bonusLootMulti or 1;bcba.attackRange=bcba.attackRange or 1;local bdba
if
game.Lighting.ClockTime<
5.9 or game.Lighting.ClockTime>18.6 then
if not(bbba and bbba.level)then bcba.nightboosted=true
bcba.level=bcba.level+1;bcba.healthMulti=bcba.healthMulti*1.25
bcba.damageMulti=bcba.damageMulti*1.25;bcba.bonusXPMulti=bcba.bonusXPMulti*1.25;bcba.bonusLootMulti=
bcba.bonusLootMulti*1.25
bcba.goldMulti=bcba.goldMulti*1.25;bcba.aggressionRange=bcba.aggressionRange*2;bcba.attackSpeed=
bcba.attackSpeed*0.8
bcba.playerFollowDistance=bcba.playerFollowDistance*2;bcba.baseSpeed=bcba.baseSpeed*1.1
bcba.attackRange=bcba.attackRange*1.1
bcba.detectionFromOutOfVisionRange=bcba.detectionFromOutOfVisionRange*2;bcba.visionAngle=bcba.visionAngle*1.25 end end
if bcba.gigaGiant then
if not(bbba and bbba.level)then bcba.level=bcba.level+3 end;bcba.scale=5;bcba.IS_MONSTER_ENRAGED=true;local ddba=bcba.manifest;ddba.Size=
ddba.Size*5;local __ca=Instance.new("NumberValue")
__ca.Name="monsterScale"__ca.Value=5;__ca.Parent=ddba
bcba.healthMulti=bcba.healthMulti*1000;bcba.bonusLootMulti=30
bcba.bonusXPMulti=bcba.bonusXPMulti*500;bcba.goldMulti=(bcba.goldMulti or 1)*3.5
ddba.maxHealth.Value=bcba.maxHealth;ddba.health.Value=bcba.health
bcba.damageMulti=(bcba.damageMulti or 1)*5;bcba.attackRange=(bcba.attackRange or 0)*5.1 elseif
bcba.superGiant or
( (not bcba.dontScale and not bcba.boss)and(bbaa()and
abaa:NextInteger(1,7500)==13))then bcba.scale=3
bcba.superGiant=true;bcba.IS_MONSTER_ENRAGED=true;if not(bbba and bbba.level)then bcba.level=bcba.level+
2 end;local ddba=bcba.manifest;ddba.Size=
ddba.Size*3;local __ca=Instance.new("NumberValue")
__ca.Name="monsterScale"__ca.Value=3;__ca.Parent=ddba
bcba.healthMulti=bcba.healthMulti*250;bcba.bonusLootMulti=20
bcba.bonusXPMulti=bcba.bonusXPMulti*125;bcba.goldMulti=(bcba.goldMulti or 1)*3
ddba.maxHealth.Value=bcba.maxHealth;ddba.health.Value=bcba.health
bcba.damageMulti=(bcba.damageMulti or 1)*2.5;bcba.attackRange=(bcba.attackRange or 0)*3 elseif
bcba.giant or( (not
bcba.dontScale and not bcba.boss)and(bbaa()and
abaa:NextInteger(1,750)==13))then bcba.giant=true;bcba.IS_MONSTER_ENRAGED=true;if
not(bbba and bbba.level)then bcba.level=bcba.level+1 end;bcba.scale=2
local ddba=bcba.manifest;ddba.Size=ddba.Size*2
local __ca=Instance.new("NumberValue")__ca.Name="monsterScale"__ca.Value=2;__ca.Parent=ddba;bcba.healthMulti=
bcba.healthMulti*70;bcba.bonusLootMulti=10
bcba.bonusXPMulti=bcba.bonusXPMulti*35;bcba.goldMulti=(bcba.goldMulti or 1)*2.5
ddba.maxHealth.Value=bcba.maxHealth;ddba.health.Value=bcba.health
bcba.damageMulti=(bcba.damageMulti or 1)*1.75;bcba.attackRange=(bcba.attackRange or 0)*2 elseif bcba.scale then
local ddba=bcba.scale;local __ca=bcba.manifest;__ca.Size=__ca.Size*ddba
local a_ca=Instance.new("NumberValue")a_ca.Name="monsterScale"a_ca.Value=ddba;a_ca.Parent=__ca;bcba.attackRange=(
bcba.attackRange or 0)*ddba else local ddba=1 +
abaa:NextInteger(-5,5)/100;bcba.scale=ddba
local __ca=bcba.manifest;__ca.Size=__ca.Size*ddba
local a_ca=Instance.new("NumberValue")a_ca.Name="monsterScale"a_ca.Value=ddba;a_ca.Parent=__ca;bcba.attackRange=(
bcba.attackRange or 0)*ddba end
if
bcba.giant or bcba.superGiant or bcba.gigaGiant or bcba.boss or bcba.resilient then
local ddba=Instance.new("BoolValue")ddba.Name="resilient"ddba.Value=true;ddba.Parent=bcba.manifest end;if cbba then cbba(bcba)end
bcba.maxHealth=bcba.maxHealth* (bcba.healthMulti or 1)
bcba.health=bcba.maxHealth* (bcba.healthMulti or 1)
bcba.damage=bcba.damage* (bcba.damageMulti or 1)
acba.BodyForce.Force=Vector3.new(0,bcba.floats and 0 or
-196.2 *acba:getMass(),0)
acba.BodyVelocity.MaxForce=
Vector3.new(100 *acba:getMass(),bcba.flies and 100 *
acba:getMass()or 0,100 *acba:getMass())*100 *
(dbba.velocityMaxForceMultiplier or 1)
acba.CustomPhysicalProperties=PhysicalProperties.new(bcba.density or 5,bcba.friction or 0.4,
bcba.elasticity or 0.2)
if bcba.specialName then local ddba=Instance.new("StringValue")
ddba.Name="specialName"ddba.Value=bcba.specialName;ddba.Parent=acba end
if bcba.notGiant then local ddba=Instance.new("BoolValue")
ddba.Name="notGiant"ddba.Value=true;ddba.Parent=acba end
if bcba.alwaysRendered then local ddba=Instance.new("BoolValue")
ddba.Name="alwaysRendered"ddba.Value=true;ddba.Parent=acba end
if bcba.isPassive then local ddba=Instance.new("BoolValue")
ddba.Name="isPassive"ddba.Value=true;ddba.Parent=acba end
if bcba.hideLevel then local ddba=Instance.new("BoolValue")
ddba.Name="hideLevel"ddba.Value=true;ddba.Parent=acba end
if bcba.isDamageImmune then local ddba=Instance.new("BoolValue")
ddba.Name="isDamageImmune"ddba.Value=true;ddba.Parent=acba end
if bcba.dye then local ddba=Instance.new("Color3Value")
ddba.Name="colorVariant"
ddba.Value=Color3.fromRGB(bcba.dye.r,bcba.dye.g,bcba.dye.b)ddba.Parent=acba end
if bcba.isTargetImmune then local ddba=Instance.new("BoolValue")
ddba.Name="isTargetImmune"ddba.Value=true;ddba.Parent=acba end;acba.maxHealth.Value=bcba.maxHealth
acba.health.Value=bcba.health;acba.level.Value=bcba.level
local cdba=Instance.new("StringValue")cdba.Name="entityGUID"cdba.Value=cdc:GenerateGUID(false)
cdba.Parent=acba;acba.Parent=da_a;acba:SetNetworkOwner(nil)if(bcba.scale>=1.4)and(not
bcba.notGiant)then
game.CollectionService:AddTag(acba,"giantEnemy")end
if dbba.boss then
acba.BodyForce.Force=Vector3.new()
local ddba,__ca=_ad.raycastForProjectile(Ray.new(_dba.p,Vector3.new(0,-300,0)),{workspace.placeFolders})end
if dbba.useAccurateMonsterHitbox then acba:SetNetworkOwner(nil)end;_bd:fireEventLocal("monsterEntitySpawning",bcba)
table.insert(bdd,bcba)return bcba end
function ccc.new_Pet(caba,daba,_bba)if not daba then return end;if not ___a[daba]then return end
local abba=___a[daba]local bbba=___a[daba].entity
local cbba=ccc.getMonsterManifestFromClientEntity(bbba,abba,bbba.Name)if not cbba then
warn("no manifest for pet "..tostring(abba.name))return end;if not abba then abba={}end;if not bbba then return
false end;cbba.Name=abba.name
cbba.entityId.Value=daba;local dbba={}dbba.monsterName=abba.name;dbba.__LAST_UPDATE=tick()
dbba.__EVENTS={}dbba.owner=caba;dbba.isMonsterPet=true;dbba.manifest=cbba
dbba.clientEntity=bbba
cbba.BodyForce.Force=Vector3.new(0,-196.2 *cbba:getMass(),0)
cbba.BodyVelocity.MaxForce=Vector3.new(100 *cbba:getMass(),0,100 *
cbba:getMass())*100 * (
abba.velocityMaxForceMultiplier or 1)local _cba=abba.statesData
local acba=c_aa.create(dbba,_cba.default,_cba.states)dbba.stateMachine=acba
cbba.CustomPhysicalProperties=PhysicalProperties.new(dbba.density or 5,
dbba.friction or 0.4,dbba.elasticity or 0.2)
local bcba=acba.onTransition.Event:connect(function(_dba,adba,bdba)dbba:setState(adba,bdba)end)table.insert(dbba.__EVENTS,bcba)
setmetatable(dbba,dcc)local ccba=Instance.new("IntValue")ccba.Name="pet"
ccba.Value=daba;ccba.Parent=cbba;cbba.entityType.Value="pet"
c_d:setWholeCollisionGroup(cbba,"passthrough")
if _bba and _bba.customName then local _dba=Instance.new("StringValue")
_dba.Name="nickname"_dba.Value=_bba.customName;_dba.Parent=cbba.entityId end
if _bba and _bba.dye then local _dba=Instance.new("Color3Value")
_dba.Name="colorVariant"
_dba.Value=Color3.fromRGB(_bba.dye.r,_bba.dye.g,_bba.dye.b)_dba.Parent=cbba end;aaaa(dbba)local dcba=Instance.new("StringValue")
dcba.Name="entityGUID"dcba.Value=cdc:GenerateGUID(false)dcba.Parent=cbba
cbba.Parent=da_a;cbba:SetNetworkOwner(nil)table.insert(bdd,dbba)
return dbba end;local cbaa=2
local dbaa={["1"]=5,["2"]=10,["3"]=15,["4"]=20,["5"]=25,["6"]=30,["99"]=15}
function ccc.spawn(caba,daba,_bba,abba,bbba)
if daba then local cbba=bd_a(daba)
if cbba then local dbba=cbba.spawnRegion;abba=abba or{}
for bcba,ccba in
pairs(daba:GetChildren())do
if ccba:IsA("ValueBase")then
if ccba:FindFirstChild("JSON")then
abba[ccba.Name]=game.HttpService:JSONDecode(ccba.Value)else abba[ccba.Name]=ccba.Value end end end;local _cba=_bba or dd_a(dbba)
local acba=ccc.new(caba,_cba,daba,dbba,abba,bbba)return acba end elseif _bba then local cbba=ccc.new(caba,_bba,nil,nil,abba,bbba)return cbba end end
function ccc.spawnPet(caba,daba,...)return ccc.new_Pet(caba,daba,...)end
local function _caa(caba,daba,_bba,abba,bbba)return ccc.spawn(caba,_bba,daba,abba,bbba)end
a_d:create("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","BindableFunction","OnInvoke",_caa)
local function acaa(caba,daba,...)local _bba=ccc.spawnPet(caba,daba,...)return _bba.manifest end;local bcaa=Instance.new("Folder")
bcaa.Name="monsterIdolModelCache"bcaa.Parent=game.ReplicatedStorage
local function ccaa(caba)
for daba,_bba in pairs(bdd)do
if _bba.manifest==caba then
table.remove(bdd,daba)if _bba.__EVENTS then
for abba,bbba in pairs(_bba.__EVENTS)do bbba:disconnect()end end;if _bba.stateMachine and
_bba.stateMachine.onTransition then
_bba.stateMachine.onTransition:Destroy()end;_bba.__EVENTS=nil;_bba.stateMachine.states=
nil;for abba,bbba in pairs(_bba)do _bba[abba]=nil end;break end end end;local dcaa=Random.new(os.time())local _daa={}
local function adaa(caba)
return
{["previous-state"]=caba.stateMachine.previousState,["current-state"]=caba.stateMachine.currentState,["name"]=caba.monsterName,["target-player"]=
caba.targetPlayer and caba.targetPlayer.Name,["closest-player"]=caba.closestPlayer and
caba.closestPlayer.Name,["last-updated"]=math.floor(
(tick()-caba.__LAST_UPDATE)*1000 *100)/100}end;local bdaa={}bdaa.phase="init"bdaa.monster=""bdaa.stateBefore=""
local function cdaa()
local caba=math.floor((tick()-
_dc)*1000 *100)/100
local daba=math.floor((tick()-adc)*1000 *100)/100;local _bba=#bdd;warn("MONSTER-MANAGER-DEBUG-DUMP")
warn("MONSTERS IN MEMORY:",_bba)warn("TIME SINCE LAST UPDATE CYCLE:",caba,"ms")
warn("TIME SINCE LAST UPDATE CYCLE:",daba,"ms")
warn("CURRENT STATE DATA --","phase:",bdaa.phase,"|","monster:",bdaa.monster,"|","stateBefore:",bdaa.stateBefore)warn("MONSTER SPECIFIC INFORMATION")
for abba,bbba in pairs(bdd)do
local cbba=adaa(bbba)
warn(cbba["name"],"|","cState:",cbba["current-state"],"|","target:",bbba.targetPlayer,bbba.targetEntity,bbba.targetEntity.Parent,"|","last updated:",cbba["last-updated"],"ms")end end
local function ddaa(caba,daba)local _bba=_d_a(daba)
if _bba then
if _daa[caba]then _daa[caba]:disconnect()end
_daa[caba]=_bba.stateMachine.onTransition.Event:connect(function(abba,bbba)
a_d:fireClient("{32FD9E0E-7C7D-4B5C-AEE9-78A7E26CE528}",caba,adaa(_bba))if bbba=="dead"then if _daa[caba]then end end end)return true,adaa(_bba)end;return false,nil end
local function __ba(caba,daba,_bba)if caba.deathRewardsApplied then return end;caba.deathRewardsApplied=true;if daba then
a_d:fire("{AB123BAD-136A-4C15-8F68-EC88EF38D4A9}",daba,caba.manifest,_bba.sourceType,_bba.sourceId)end;local abba
if daba then abba=
daba.Character and daba.Character.PrimaryPart end
a_d:fire("{430575B2-B79C-432A-981D-C30B502B774B}",caba.manifest,abba,_bba)caba.deathRewardsApplied=true;local bbba=1;local cbba=1;local dbba=1;local _cba=0;local acba=0;local bcba=0
for b_ca,c_ca in
pairs(caba.damageTable)do
if b_ca and c_ca>1 then
local d_ca=b_ca.Character and b_ca.Character.PrimaryPart
if d_ca and d_ca:FindFirstChild("state")and
d_ca.state.Value~="dead"then _cba=_cba+c_ca
acba=acba+c_ca^ (1 /2)bcba=bcba+1 end end end;local ccba=bcba^ (1 /3)bbba=bbba*ccba;dbba=dbba*ccba
cbba=cbba*ccba;local dcba=caba.EXP*bbba;local _dba={}local adba={}
for b_ca,c_ca in pairs(caba.damageTable)do
if
b_ca and b_ca.Parent and c_ca>0 then
local d_ca=a_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_ca)
if d_ca then
if dcba>0 then
local aaca=(dcba/bcba)*d_ca.nonSerializeData.statistics_final.wisdom
local baca=a_d:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",b_ca)
if baca and baca.members then if#baca.members>=6 then aaca=aaca*1.2 elseif
#baca.members>1 then aaca=aaca*1.1 end end;aaca=math.ceil(aaca)
d_ca.nonSerializeData.incrementPlayerData("exp",aaca)adba[b_ca.Name]=aaca end;local _aca={}
for aaca,baca in pairs(caba)do if
typeof(aaca)=="string"and typeof(baca)~="table"then _aca[aaca]=baca end end
a_d:fire("{9485849D-EE15-40A1-B8BB-780E42059ED2}",b_ca,"monster-killed",{["monsterName"]=caba.monsterName,["monster"]=_aca})if caba.module.Name=="Spider Queen"then
spawn(function()
game.BadgeService:AwardBadge(b_ca.userId,2124454074)end)end
table.insert(_dba,b_ca)end end end;if dcba>0 then end;local bdba=caba.damageTable
local cdba=b_d.copyTable(caba.lootDrops)local ddba=caba.level;local __ca=caba.manifest.Position
local a_ca=caba.manifest.Name
if caba.additionalLootDrops then for b_ca,c_ca in pairs(caba.additionalLootDrops)do
table.insert(cdba,c_ca)end end
if not caba.dropsDisabled then
spawn(function()
for n=1,math.ceil(cbba)do
for b_ca,c_ca in pairs(cdba)do
if

n<=math.floor(cbba)or dcaa:NextNumber()< (cbba-math.floor(cbba))then local d_ca=c_ca.spawnChance or 0.001
while d_ca>dcaa:NextNumber()do d_ca=
d_ca-1;local _aca
if c_ca.itemName then
local bbca=game.ReplicatedStorage.itemData:FindFirstChild(c_ca.itemName)if bbca then _aca=require(bbca)c_ca.id=_aca.id end end;if _aca==nil then _aca=___a[c_ca.id]end;local aaca={}local baca=#_dba;for bbca,cbca in
pairs(_dba)do table.insert(aaca,cbca)end
local caca=_aca and
(_aca.rarity and(
_aca.rarity=="Rare"or _aca.rarity=="Legendary"))or
(_aca.category and _aca.category=="equipment")if caca then
aaca={aaca[dcaa:NextInteger(1,#aaca)]}end;if c_ca.id==1 then local bbca=(dbba or 1)c_ca.value=math.ceil(bbca*
caba.gold)
c_ca.source="monster:"..a_ca:lower()end
local daca=b_d.copyTable(c_ca)daca.itemName=nil;daca.spawnChance=nil
local _bca={itemOwners=aaca,dropPosition=__ca,lootDropData=daca}if c_ca.dropCircumstance then
_bca=c_ca.dropCircumstance(_bca,{network=a_d})end;local abca
if c_ca.id==181 then
local bbca=bcaa:FindFirstChild(caba.module.Name)
if bbca==nil then
if
game.ReplicatedStorage.monsterLookup:FindFirstChild(caba.module.Name):FindFirstChild("displayEntity")then
bbca=game.ReplicatedStorage.monsterLookup:FindFirstChild(caba.module.Name).displayEntity:Clone()else
bbca=game.ReplicatedStorage.monsterLookup:FindFirstChild(caba.module.Name).entity:Clone()end;local cbca=bbca:GetExtentsSize()
local dbca=math.min(cbca.X,cbca.Y,cbca.Z)local _cca=math.max(cbca.X,cbca.Y,cbca.Z)
local acca=4 / (dbca+_cca)b_d.scale(bbca,acca)local bcca=bbca.PrimaryPart;bcca.Name="manifest"
for dcca,_dca in
pairs(bbca:GetChildren())do
if _dca:IsA("BasePart")then _dca.Material=Enum.Material.Glass;_dca.Reflectance=
_dca.Reflectance+0.2;_dca.Transparency=0
_dca.Color=Color3.new(0,0,0)if _dca~=bcca then _dca.Parent=bcca;_dca.Massless=true end end end;local ccca=bbca;bcca.Size=Vector3.new(2.2,2.2,2.2)
bcca.Name=caba.module.Name;bcca.Parent=bcaa;bbca=bcca;ccca:Destroy()end;abca=bbca:Clone()end;if#_bca.itemOwners>0 then
local bbca=caba:dropItem(_bca,abca,cbba)if not bbca then break end end end end end end;wait()end)end end;function dcc:dropRewards(caba,daba)if self.deathRewardsApplied then return false end
__ba(self,caba,daba)return true end
local function a_ba(caba,daba,_bba)local abba
for bbba,cbba in
pairs(bdd)do if cbba.manifest==daba then abba=cbba;break end end
if abba then
if abba.health>0 then local bbba=bbd[abba.monsterName]
local cbba=bbba.statesData
do local bcba=abba.manifest
local ccba=b_d.getEntityGUIDByEntityManifest(bcba)
if ccba then
local dcba=a_d:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",ccba)
for _dba,adba in pairs(dcba)do for bdba,cdba in
pairs(adba.statusEffectModifier.modifierData or{})do
if bdba=="damageTakenMulti"then _bba.damage=_bba.damage* (1 +cdba)end end end end end;if cbba.processDamageRequestToMonster then
_bba=cbba.processDamageRequestToMonster(abba,_bba)or _bba end
_bd:fireEventLocal("entityWillDealDamage",caba,daba,_bba)
local dbba=math.clamp(abba.health-_bba.damage,-99999999,abba.maxHealth)local _cba=abba.health-dbba
local acba=abba.health-math.clamp(dbba,0,abba.maxHealth)abba.health=dbba
abba.manifest.health.Value=abba.health;abba.manifest.maxHealth.Value=abba.maxHealth;abba.damageTable=
abba.damageTable or{}if abba.__MONSTER_EVENTS.onMonsterDamaged then
abba.__MONSTER_EVENTS.onMonsterDamaged(abba,_bba.damage,caba)end
if caba then
if
_bba.sourceType=="ability"then
if not abba.playersWithAbilityUse then abba.playersWithAbilityUse={}end;abba.playersWithAbilityUse[caba.userId]=true end;if cbba.onDamageReceived then
cbba.onDamageReceived(abba,"player",caba,_bba.damage)end
if _bba.damage>0 then
if caba.Character and
caba.Character.PrimaryPart then
if abba.targetEntity and
abba.targetEntity~=caba.Character.PrimaryPart then
local bcba=abba.entity:IsA("BasePart")and
abba.entity.Position or abba.entity:IsA("Model")and
abba.entity.PrimaryPart.Position
local ccba=
abba.targetEntity:IsA("BasePart")and abba.targetEntity.Position or abba.targetEntity:IsA("Model")and
abba.targetEntity.PrimaryPart.Position
if
(caba.Character.PrimaryPart.Position-bcba).magnitude< (ccba-bcba).magnitude or
dcaa:NextNumber()<=0.3 then
abba.targetEntity=caba.Character.PrimaryPart;abba.entityMonsterWasAttackedBy=caba.Character.PrimaryPart end end end
abba.damageTable[caba]=(abba.damageTable[caba]or 0)+acba
if not abba.targetEntity and caba.Character.PrimaryPart then
if
cbba.states["attacked-by-player"]and cbba.states["idling"]and
cbba.states["following"]then
abba.entityMonsterWasAttackedBy=caba.Character.PrimaryPart;print("FORCE STATE CHANGE! :D")
abba.stateMachine:forceStateChange("attacked-by-player")end elseif abba.manifest.Name=="Bandit Skirmisher"then
abba.entityMonsterWasAttackedBy=caba.Character.PrimaryPart;if abba.state~="attacking"then
abba.stateMachine:forceStateChange("attacked-by-player")end end end end end
a_d:fireAllClients("{94EA4964-9682-4133-B150-B6EE2056FD70}",abba.manifest,_bba)
if abba.health<=0 then
if not abba.deathRewardsApplied then __ba(abba,caba,_bba)end;abba.stateMachine:forceStateChange("dead")else
if
abba.stateMachine.states.hurt then abba.stateMachine:forceStateChange("hurt")end end;return true,abba.health<=0 end;return false,false end;local b_ba=Instance.new("Message")
local function c_ba()_dc=tick()bdaa.phase="start"
bdaa.monster=""bdaa.stateBefore=""local caba=nil;local daba=nil;local _bba=tick()
for abba,bbba in pairs(bdd)do
local cbba,dbba=pcall(function()
if
bbba.manifest and
bbba.manifest.Parent==da_a and bbba.state~="dead"then caba=bbba
if not bbba.isMonsterPet then local _cba
do local dcba=bbd[bbba.monsterName]
local _dba=dcba.statesData;if _dba.getClosestEntities then _cba=_dba.getClosestEntities(bbba)else
_cba=cbd.getClosestEntities(bbba)end end;local acba={}local bcba;local ccba=999
for dcba,_dba in pairs(_cba)do
if

(not _dba:FindFirstChild("isStealthed"))and(not _dba:FindFirstChild("isTargetImmune"))then
if

_dba.state.Value~="dead"and _dba.state.Value~="sitting"and _dba.entityType.Value~="pet"then
local adba=(_dba.Position-bbba.manifest.Position).magnitude;if adba<bbba.sightRange then acba[#acba+1]=_dba;if adba<=ccba then bcba=_dba
ccba=adba end end end end end
if
bbba.closestEntity and(bbba.closestEntity.Parent==nil or
bbba.closestEntity.state.Value=="dead")then bbba.closestEntity=nil end
bbba.closestEntity=
(bbba.closestEntity==bbba.targetEntity and bbba.closestEntity)or bcba;bbba.nearbyTargets=acba;bbba.entityDensityData=__aa(bbba)if bbba.targetEntity and
(
bbba.targetEntity.Parent==nil or bbba.targetEntity.state.Value=="dead")then
bbba:setTargetEntity(nil,nil)end
if
ccba>=100 and bbba.nightBoosted and
not(game.Lighting.ClockTime<5.9 or
game.Lighting.ClockTime>18.6)then
if bbba and bbba.manifest and
bbba.manifest.Parent then bbba.manifest:Destroy()end end end;bdaa.phase="before-stateUpdate"bbba.__LAST_UPDATE=_bba
daba=bbba.stateMachine.currentState;aaaa(bbba)bdaa.phase="after-stateUpdate"end end)
if not cbba then
warn("manager_monster::"..
tostring(caba.monsterName).."::"..
tostring(caba.stateMachine.currentState).."::",dbba)warn("killing entity")
if
bbba and bbba.manifest and bbba.manifest.Parent then bbba.manifest:Destroy()end end end;bdaa.phase="end"bdaa.monster=""bdaa.stateBefore=""adc=tick()end
local function d_ba(caba)if
not caba.Character or not caba.Character.PrimaryPart then return end
for daba,_bba in pairs(bdd)do if _bba.targetEntity==
caba.Character.PrimaryPart then _bba:setTargetEntity(nil,nil,true)
aaaa(_bba)end end end;local function _aba(caba)bcc[caba]=nil end
local function aaba(caba,daba)if daba=="enraged"then return not
not caba.IS_MONSTER_ENRAGED end;return
caba.variation==daba end
local function baba()
_bd:registerForEvent("entityDiedTakingDamage",function(daba,_bba,abba)if not
dad.getConfigurationValue("doSpawnNightTimeVariants")then return end
local bbba=b_d.getEntityManifestByEntityGUID(abba.sourceEntityGUID)if bbba then local cbba=_d_a(bbba)if cbba then end end end)
_bd:registerForEvent("monsterEntitySpawning",function(daba)if not
dad.getConfigurationValue("doSpawnNightTimeVariants")then return end
if
aaba(daba,"stalker")then daba.autoStealthTimer=tick()
local _bba,abba=a_d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",daba.manifest,"stealth",{duration=9999},daba.manifest,"autoStealth_stealth",0)end end)
_bd:registerForEvent("entityWillDealDamage",function(daba,_bba,abba)if not
dad.getConfigurationValue("doSpawnNightTimeVariants")then return end
local bbba=b_d.getEntityManifestByEntityGUID(abba.sourceEntityGUID)
if bbba then local cbba=_d_a(bbba)local dbba=_bba and _d_a(_bba)
if cbba then
if
aaba(cbba,"cursed")then
if math.random()< (1 /3)then
local _cba,acba=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_bba,"poison",{duration=3,healthLost=
0.2 *abba.damage},bbba,"monster-variant","poison")end elseif
aaba(cbba,"stalker")or(dbba and aaba(dbba,"stalker"))then
local _cba=aaba(cbba,"stalker")and cbba or dbba
if
a_d:invoke("{92229A3F-1BDF-4320-B433-0C162EC3491D}",_cba.manifest,"autoStealth_stealth")then
a_d:invoke("{2A1ACCC4-EEC3-4808-A491-9E1808FE42A3}",_cba.manifest,"autoStealth_stealth")_cba.autoStealthTimer=tick()
delay(5,function()
if

tick()-_cba.autoStealthTimer>=5 and _cba.manifest.Parent and not
a_d:invoke("{92229A3F-1BDF-4320-B433-0C162EC3491D}",_cba.manifest,"autoStealth_stealth")then
local acba,bcba=a_d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_cba.manifest,"stealth",{duration=9999},_cba.manifest,"autoStealth_stealth",0)end end)end end end
if dbba and aaba(dbba,"short-fused")then
local _cba,acba=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_bba,"explode",{duration=1},bbba,"monster-variant","explosion")end
if dbba and aaba(dbba,"enraged")then if not dbba.ENRAGED_AGGRO_TIMER then
dbba.ENRAGED_AGGRO_TIMER=0 end
if
tick()-dbba.ENRAGED_AGGRO_TIMER>5 then dbba.ENRAGED_AGGRO_TIMER=tick()
for _cba,acba in pairs(bdd)do if acba.manifest and
(acba.manifest.Position-
dbba.manifest.Position).magnitude<100 then
acba:setTargetEntity(bbba)end end end end end end)
game.Players.PlayerRemoving:connect(_aba)da_a.ChildRemoved:connect(ccaa)
a_d:create("{4672D40D-1D10-415C-A444-4D25828A6BBE}","BindableFunction","OnInvoke",daaa)
a_d:create("{031BE66E-62B6-4583-B409-DCB61C0DA077}","BindableFunction","OnInvoke",a_ba)
a_d:create("{400F2DEB-8BE0-4AB9-A232-7D733FF63F52}","BindableFunction","OnInvoke",function(daba,_bba)
if _bba then return _d_a(daba,_bba)else
local abba=_d_a(daba)if not abba then return nil end;abba=b_d.copyTable(abba)
dc_a(abba)return abba end end)
a_d:create("{0814EB37-C329-4C35-A1DD-0C1515FABD4B}","RemoteFunction","OnServerInvoke",ddaa)
a_d:create("{32FD9E0E-7C7D-4B5C-AEE9-78A7E26CE528}","RemoteEvent")
a_d:create("{AB123BAD-136A-4C15-8F68-EC88EF38D4A9}","BindableEvent")
a_d:create("{4761ABD9-42FB-4130-AB77-2EC70CD83955}","BindableFunction","OnInvoke",acaa)
a_d:create("{04BD620F-30BC-43E7-932C-37CD0A34911B}","BindableFunction","OnInvoke",cdaa)
a_d:connect("{4B5C35A0-C7D0-4269-8782-C5C7CB30B14A}","Event",d_ba)
a_d:create("{9F5B4847-D9C8-4A8A-BE21-E0CA2494CB50}","BindableFunction","OnInvoke",function(daba,_bba)local abba
do for bbba,cbba in pairs(bdd)do if cbba.manifest==daba then
abba=cbba end end end;if abba then return abba[_bba]end end)
a_d:create("{865FC765-9523-4146-BE7E-0CA54C4A3508}","BindableFunction","OnInvoke",function(daba,_bba,abba)local bbba
do for cbba,dbba in pairs(bdd)do if dbba.manifest==daba then
bbba=dbba end end end;if bbba then bbba[_bba]=abba end end)
a_d:create("{32CCFE53-543A-4794-AD57-82DE027EA7E4}","BindableFunction","OnInvoke",function(daba,_bba,abba,bbba)local cbba
do for dbba,_cba in pairs(bdd)do if _cba.manifest==daba then
cbba=_cba end end end
if cbba and _bba then cbba:setTargetEntity(_bba,nil,abba,bbba)end end)
local function caba()return
game.Lighting.ClockTime<5.9 or game.Lighting.ClockTime>18.6 end
spawn(function()
while wait(caba()and add*0.5 or add)do for daba,_bba in
pairs(ccc:getSpawnRegionCollectionsUnderPopulated())do
ccc.spawn(_bba.monsterNameToSpawn,_bba.spawnRegionCollection)end end end)while wait(1 /5)do c_ba()end end;spawn(baba)return ccc