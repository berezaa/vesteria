local _b={}local ab=game:GetService("ReplicatedStorage")
local bb=require(ab.modules)local cb=bb.load("network")local db=bb.load("utilities")
local _c=require(ab.abilityLookup)
local function ac(dc,_d)
local ad=cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dc)local bd=_c[_d]if not ad then return false,"invalid_data"end;if not bd then return false,
"invalid_ability"end;if ad.abilities[_d]~=nil then return false,
"ability_locked"end;if
ad.level<bd.prerequisites.playerLevel then return false,"low_level"end
if
bd.prerequisites.classRestriction==true then if
not ad.class==bd.prerequisites.playerClass then return false,"wrong_class"end end;return true end
local function bc(dc,_d)if not dc.Character or not dc.Character.Humanoid or not
dc.Character.HumanoidRootPart then
return false,"invalid_character"end
if not
db.isEntityManifestValid(dc.Character.PrimaryPart)then return false,"invalid_character"end
local ad=cb:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",dc)local bd=_c[_d]local cd,dd=ac(dc,_d)if not cd then return false,dd end
if
dc.Character.PrimaryPart.mana.Value<bd.statistics.manaCost then return false,"lacking_mana"end;local __a=cb:invoke("returnAbilityCooldown",dc,_d)if __a~=nil and(
tick()-__a)<bd.statistics.cooldown then return false,
"on_cooldown"end;return true end
local function cc(dc,_d)
if type(dc)==type(CFrame)and tonumber(_d)then local ad={}
for bd,cd in
pairs(game.Players:GetPlayers())do local dd=cd.Character;if dd and dd.PrimaryPart then
if
(dc.p-dd.PrimaryPart.CFrame.p).magnitude<_d then table.insert(ad,cd)end end end;if#ad>=1 then return ad end end end
function _b.getCastingPlayer(dc)return
game:GetService("Players"):GetPlayerByUserId(dc["cast-player-userId"])end;function _b.getAbilityStatisticsForRank(dc,_d)end
function _b.calculateStats(dc,_d)local ad=_c[_d]if
not ad or not dc then return nil end
if not dc.abilities[_d]then return nil end;local bd=ad.statistics.increasingStat
local cd=ad.statistics.increaseExponent;local dd=dc.abilities[_d].level
if not bd or not cd then return nil end;local __a=dd*cd;return bd,__a end;return _b