local aa=game:GetService("RunService")
local ba=game:GetService("ReplicatedStorage")local ca=require(ba.modules)local da=ca.load("network")local _b={}
function _b.getEXPForLevel(ab)return
7 +5 * (ab-2)+4 * (ab-2)^2 end;function _b.getTotalAP(ab)return ab.level-1 end
function _b.getQuestGoldFromLevel(ab)return 100 +math.floor(
ab^1.18 *300)end
function _b.getEXPToNextLevel(ab)return _b.getEXPForLevel(ab+1)end
function _b.getQuestEXPFromLevel(ab)return 10 +
(_b.getEXPToNextLevel(ab)* (1 /1.5)*ab^ (-1 /6))end
function _b.getMonsterEXPFromLevel(ab)local bb=7 * (1 +ab^1.21 -ab^1.1)return
_b.getEXPToNextLevel(ab)*bb^-1 end
function _b.getBaseStatInfoForMonster(ab)ab=0;return{str=ab*1,int=ab*1,dex=ab*1,vit=ab*1}end
function _b.getEquipmentInfo(ab)
if ab then local bb=ab.level or ab.minLevel
if bb then
local cb=getStatForLevel(bb)
local function db(cc)local dc=2.7182818284590452353602874713527;return 15 / (1 +
dc^ (-1 * (0.25 *cc-9)))end
local _c=
1.35 *_b.getQuestGoldFromLevel(bb)*bb^ (1 /3)*math.max(db(bb),1)local ac=ab.rarity or"Common"if ac=="Legendary"then _c=_c*2 elseif ac=="Rare"then
_c=_c*1.5 end;local bc
if ab.equipmentSlot then
if ab.equipmentSlot==1 then local cc=cb
_c=_c*0.7;if ac=="Legendary"then cc=cc+10 elseif ac=="Rare"then cc=cc+5 end;return
{damage=math.ceil(cc),cost=math.floor(_c)}elseif ab.equipmentSlot==11 then return
{cost=math.floor(_c*0.6)}else local cc;local dc
if ab.equipmentSlot==8 then dc=cb;if ac=="Legendary"then dc=dc+10 elseif
ac=="Rare"then dc=dc+5 end;_c=_c*1
dc=dc* (ab.defenseModifier or 1)elseif ab.equipmentSlot==9 then dc=0;_c=_c*0.35 elseif ab.equipmentSlot==2 then dc=0;_c=_c*0.5
local _d=cb/5;local ad=ab.statDistribution
if ab.minimumClass=="hunter"then
ad=ad or{str=0,dex=1,int=0,vit=0}cc={str=0,dex=1,int=0,vit=0}elseif ab.minimumClass=="warrior"then
ad=ad or{str=1,dex=0,int=0,vit=0}cc={str=1,dex=0,int=0,vit=0}elseif ab.minimumClass=="mage"then
ad=ad or{str=0,dex=0,int=1,vit=0}cc={str=0,dex=0,int=1,vit=0}end;if ad then bc={}
for bd,cd in pairs(ad)do bc[bd]=math.floor(_d*cd)end end end;if dc then
return{defense=math.ceil(dc),cost=math.floor(_c),modifierData=bc,statUpgrade=cc}end;return false end end end end;return false end
function _b.getPlayerTickHealing(ab)
if
ab and ab.Character and ab:FindFirstChild("level")and ab.Character.PrimaryPart then
local bb=ab.level.Value;local cb=ab.vit.Value;return(0.24 *bb)+ (0.1 *cb)end;return 0 end;function _b.calculateCritChance(ab,bb)return 0 end
function _b.getPlayerCritChance(ab)
if aa:IsServer()then
local bb=da:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ab)
if bb then
return
_b.calculateCritChance(bb.nonSerializeData.statistics_final.dex,bb.level)+
(bb.nonSerializeData.statistics_final.criticalStrikeChance or 0)end else
warn("attempt to call getPlayerCritChance on client")end;return 0 end;function _b.getAttackSpeed(ab)return ab*0.5 /2 end;function _b.getMonsterGoldForLevel(ab)return 10 +
(3 * (ab-1))end;function _b.getStatPointsForLevel(ab)return
3 * (ab-1)end;function _b.getLevelForEXP(ab)return
math.floor((5 *ab/10)^ (1 /3))end
function _b.getEXPPastCurrentLevel(ab)return ab end;function _b.getFractionForNextLevel(ab)
return _b.getEXPPastCurrentLevel(ab)/
_b.getEXPToNextLevel(math.floor(_b.getLevelForEXP(ab)))end;return _b