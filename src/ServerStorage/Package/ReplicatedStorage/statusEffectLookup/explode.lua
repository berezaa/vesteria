
local bb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("projectile")local _c=cb.load("placeSetup")
local ac=cb.load("client_utilities")local bc=cb.load("network")local cc=cb.load("events")
local dc=_c.awaitPlaceFolder("monsterManifestCollection")local _d=_c.awaitPlaceFolder("entities")
local ad=game:GetService("HttpService")
local bd={id=5,name="Explode",activeEffectName="Exploding",styleText="This unit is exploding.",description="",image="rbxassetid://2528902271",statusEffectApplicationData={duration=8}}
function bd.__clientApplyStatusEffectOnCharacter(cd)if
not cd or not cd:FindFirstChild("entity")then return false end end;function bd.__clientApplyTransitionEffectOnCharacter(cd)end;function bd.__clientRemoveStatusEffectOnCharacter(cd)
if
not cd or not cd:FindFirstChild("entity")then return false end end;function bd._serverExecutionFunction(cd,dd)
end;function bd._serverCleanupFunction(cd,dd)end;function bd.onStarted_server(cd,dd)
if dd then end end;function bd.onEnded_server(cd,dd)if dd then end end
return bd