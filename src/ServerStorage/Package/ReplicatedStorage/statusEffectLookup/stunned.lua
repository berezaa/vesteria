
local _b=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bb=ab.load("projectile")local cb=ab.load("placeSetup")
local db=ab.load("client_utilities")local _c=ab.load("network")
local ac=cb.awaitPlaceFolder("monsterManifestCollection")local bc=game:GetService("HttpService")
local cc={id=13,name="Stunned",activeEffectName="Stunned",styleText="Stunned.",description="",image="rbxassetid://2528902271"}function cc:execute()end;return cc