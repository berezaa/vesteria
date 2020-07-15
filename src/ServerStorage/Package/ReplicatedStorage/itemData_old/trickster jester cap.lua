
return
{id=82,name="Mimic's Jester Cap",rarity="Legendary",image="rbxassetid://2744225153",description="Fool your enemies.\n\nObtained in 2019 April Fools Event.",perkData={title="",description="",modifierData={maxHealth=100,maxMana=100,stamina=3},apply=function(a)
a.jesterperktest=true end,onBeforeDamageDealt=function(a,b,c,d,_a,aa)end,onAfterDamageDealt=function(a,b,c,d,_a,aa)end,onBeforeDamageReceived=function(a,b,c,d,_a,aa)end,onAfterDamageReceived=function(a,b,c,d,_a,aa)
if aa>60 then
if
d and
d:FindFirstChild("health")and d:FindFirstChild("maxHealth")then
if d.health.Value>0 and
d.health.Value/d.maxHealth.Value<=0.4 then
local ba,ca=require(game.ReplicatedStorage.modules.network):invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",d,"stealth",{duration=3},d,"perk",82)return true end end end end},isEquippable=true,equipmentSlot=2,equipmentType="hat",equipmentHairType=2,buyValue=999999999,sellValue=1,modifierData=
nil,canStack=false,canBeBound=false,canAwaken=true,isImportant=true,category="equipment"}