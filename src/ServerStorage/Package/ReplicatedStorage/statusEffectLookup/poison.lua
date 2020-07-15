
local ab=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cb=bb.load("projectile")local db=bb.load("placeSetup")
local _c=bb.load("client_utilities")local ac=bb.load("network")local bc=bb.load("utilities")
local cc=db.awaitPlaceFolder("monsterManifestCollection")local dc=game:GetService("HttpService")
local _d={id=3,name="Poisoned",activeEffectName="Poisoned",styleText="Poisoned and taking damage over time.",description="",image="rbxassetid://2528902271"}
function _d.execute(ad,bd,cd)local dd=ad.statusEffectModifier.healthLost
local __a=ad.statusEffectModifier.duration;local a_a=dd/__a;local b_a=a_a/cd
local c_a=bd:FindFirstChild("entityType")if not c_a then return end;c_a=c_a.Value;local d_a=ad.sourceEntityGUID
if not d_a then return end;local _aa=bc.getEntityManifestByEntityGUID(d_a)
if not _aa then return end;local aaa=_aa:FindFirstChild("entityType")if not aaa then return end
aaa=aaa.Value;if aaa~="character"then return end;local baa=_aa.Parent
local caa=game.Players:GetPlayerFromCharacter(baa)if not caa then return end
local daa={damage=b_a,sourceType="status",sourceId=_d.id,damageType="magical",sourcePlayerId=caa.UserId}
if c_a=="monster"then
ac:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",caa,bd,daa)else
ac:invoke("{AC8B16AA-3BD2-4B7F-B12C-5558B8857745}",caa,bd,daa)end end
function _d.__clientApplyStatusEffectOnCharacter(ad)if
not ad or not ad:FindFirstChild("entity")then return false end end;function _d.__clientRemoveStatusEffectOnCharacter(ad)end;return _d