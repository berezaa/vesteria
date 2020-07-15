local ba=game:GetService("RunService")
local ca=game:GetService("ReplicatedStorage")local da=require(ca.modules)local _b=da.load("network")local ab={}
function ab.getBaseEXPForLevel(cb)return( (
0.08 /cb)*cb^6)/1.15 end;function ab.getEXPForLevel(cb)
return
70 +100 * (cb-1)^1.3 +ab.getBaseEXPForLevel(cb)-ab.getBaseEXPForLevel(cb-1)end
local function bb(cb)return 0.008 *cb^2 +13 *cb^
(1 /2.1)+cb end;function ab.getMonsterHealthForLevel(cb)
return math.floor(70 + (60 * (cb-1)^1.07))end;function ab.getMonsterDefenseForLevel(cb)
return bb(cb^1.02)end;function ab.getMonsterDamageForLevel(cb)
return bb(cb^1.02)-7 end
ab.bountyPageInfo={["1"]={{kills=10},{kills=30},{kills=80}},["2"]={{kills=20},{kills=70},{kills=150}},["3"]={{kills=30},{kills=100},{kills=250}},["99"]={{kills=1},{kills=3},{kills=10}}}function ab.getBountyGoldReward(cb,db)
return cb.kills* (ab.goldMulti or 1)*
ab.getQuestGoldFromLevel(db.level or 1)/25 end
function ab.getQuestGoldFromLevel(cb)return
100 +math.floor(cb^1.18 *300)end
function ab.getEXPToNextLevel(cb)return ab.getEXPForLevel(cb+1)end
function ab.getQuestEXPFromLevel(cb)return 10 +
(ab.getEXPToNextLevel(cb)* (1 /1.5)*cb^ (-1 /6))end
function ab.getBaseStatInfoForMonster(cb)cb=0;return{str=cb*1,int=cb*1,dex=cb*1,vit=cb*1}end
function ab.getEquipmentInfo(cb)
if cb then local db=cb.level or cb.minLevel
if db then local _c=bb(db)
local ac=1.35 *
ab.getQuestGoldFromLevel(db)*db^ (1 /3)local bc
if cb.equipmentSlot then
if cb.equipmentSlot==1 then local cc=_c;ac=ac*0.7;return
{damage=math.ceil(cc),cost=math.floor(ac)}elseif cb.equipmentSlot==11 then return
{cost=math.floor(ac*0.6)}else local cc;local dc
if cb.equipmentSlot==8 then dc=_c;ac=ac*1;if cb.noDefense==true then
dc=0 end elseif cb.equipmentSlot==9 then dc=0;ac=ac*0.35 elseif cb.equipmentSlot==2 then dc=0;ac=
ac*0.5;local _d=_c/5;local ad=cb.statDistribution
if cb.minimumClass=="hunter"then ad=ad or
{str=0,dex=1,int=0,vit=0}cc={str=0,dex=1,int=0,vit=0}elseif
cb.minimumClass=="warrior"then ad=ad or{str=1,dex=0,int=0,vit=0}
cc={str=1,dex=0,int=0,vit=0}elseif cb.minimumClass=="mage"then ad=ad or{str=0,dex=0,int=1,vit=0}
cc={str=0,dex=0,int=1,vit=0}end;if ad then bc={}
for bd,cd in pairs(ad)do bc[bd]=math.floor(_d*cd)end end end;if dc then
return{defense=math.ceil(dc),cost=math.floor(ac),modifierData=bc,upgradeStat=cc}end;return false end end end end;return false end
function ab.getPlayerTickHealing(cb)
if
cb and cb.Character and cb:FindFirstChild("level")and cb.Character.PrimaryPart then
local db=cb.level.Value;local _c=cb.vit.Value;return(0.24 *db)+ (0.1 *_c)end;return 0 end;function ab.calculateCritChance(cb,db)return 0 end
function ab.getPlayerCritChance(cb)
if ba:IsServer()then
local db=_b:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cb)
if db then
return
ab.calculateCritChance(db.nonSerializeData.statistics_final.dex,db.level)+
(db.nonSerializeData.statistics_final.criticalStrikeChance or 0)end else
warn("attempt to call getPlayerCritChance on client")end;return 0 end;function ab.getAttackSpeed(cb)return cb*0.5 /2 end;function ab.getMonsterGoldForLevel(cb)return 10 +
(3 * (cb-1))end;function ab.getStatPointsForLevel(cb)return
3 * (cb-1)end;function ab.getLevelForEXP(cb)return
math.floor((5 *cb/10)^ (1 /3))end
function ab.getEXPPastCurrentLevel(cb)return cb end;function ab.getFractionForNextLevel(cb)
return ab.getEXPPastCurrentLevel(cb)/
ab.getEXPToNextLevel(math.floor(ab.getLevelForEXP(cb)))end
function ab.getEXPGainedFromMonsterKill(cb,db,_c)local ac=
_c-db;local bc=math.clamp(1 -ac/7,0.25,1.5)return cb*bc end;return ab