local aa={}local ba=game:GetService("RunService")
local ca=game:GetService("ReplicatedStorage")local da=require(ca.modules)local _b=da.load("network")function aa.getEXPForLevel(ab)return
70 + (
10 *ab^ (3.35))- (10 * (ab-1)^ (3.35))end;function aa.getMonsterHealthForLevel(ab)return
100 + (70 * (ab-1))end;function aa.getMonsterDamageForLevel(ab)return
8 + (12 * (ab-1))end
function aa.getPlayerTickHealing(ab)
if
ab and ab.Character and ab:FindFirstChild("level")and
ab.Character.PrimaryPart then local bb=ab.level.Value
local cb=ab.vit.Value;return(0.24 *bb)+ (0.1 *cb)end;return 0 end;function aa.calculateCritChance(ab,bb)
return math.clamp(0.4 * (ab/ (3 *bb)),0,1)end
function aa.getPlayerCritChance(ab)
if ba:IsServer()then
local bb=_b:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ab)
if bb then
return
aa.calculateCritChance(bb.nonSerializeData.statistics_final.dex,bb.level)+
(bb.nonSerializeData.statistics_final.criticalStrikeChance or 0)end else
warn("attempt to call getPlayerCritChance on client")end;return 0 end;function aa.getAttackSpeed(ab)return ab*0.5 /2 end;function aa.getMonsterGoldForLevel(ab)return 10 +
(3 * (ab-1))end;function aa.getStatPointsForLevel(ab)
return 3 *ab end;function aa.getLevelForEXP(ab)return
math.floor((5 *ab/10)^ (1 /3))end;function aa.getEXPToNextLevel(ab)return aa.getEXPForLevel(ab+
1)end;function aa.getQuestEXPFromLevel(ab)return

30 + ( (7 *ab^ (3.35))- (7 * (ab-1)^ (3.35)))end;function aa.getQuestGoldFromLevel(ab)return
ab*50 end
function aa.getEXPPastCurrentLevel(ab)return ab end;function aa.getFractionForNextLevel(ab)
return aa.getEXPPastCurrentLevel(ab)/
aa.getEXPToNextLevel(math.floor(aa.getLevelForEXP(ab)))end
function aa.getEXPGainedFromMonsterKill(ab,bb,cb)local db=
cb-bb;local _c=math.clamp(1 -db/10,0.1,1.5)return ab*_c end;return aa