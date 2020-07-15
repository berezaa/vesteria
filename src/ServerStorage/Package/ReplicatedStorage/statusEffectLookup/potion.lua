
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("projectile")local cb=ab.load("placeSetup")
local db=ab.load("client_utilities")local _c=ab.load("network")
local ac=cb.awaitPlaceFolder("monsterManifestCollection")local bc=game:GetService("HttpService")
local cc={id=1,name="Potion",activeEffectName="Potioning",styleText="Activated a potion.",description="",image="rbxassetid://2528902271"}
function cc.execute(dc,_d,ad)
local bd=dc.statusEffectModifier.healthToHeal or 0
local cd=dc.statusEffectModifier.manaToRestore or 0;local dd=dc.statusEffectModifier.duration or 5
if

_d:FindFirstChild("health")and _d:FindFirstChild("maxHealth")and bd>0 then
_d.health.Value=math.clamp(_d.health.Value+bd/dd/ad,0,_d.maxHealth.Value)end;if
_d:FindFirstChild("mana")and _d:FindFirstChild("maxMana")and cd>0 then
_d.mana.Value=math.clamp(_d.mana.Value+cd/dd/ad,0,_d.maxMana.Value)end end;function cc.onStatusEffectApplied_server(dc)end
function cc.onStatusEffectRemoved_server(dc)end;function cc.onStatusEffectApplied_client(dc)end
function cc.onStatusEffectRemoved_client(dc)end;return cc