
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=30,name="Fresh Fish",rarity="Common",image="rbxassetid://2528901664",description="A tasty freshly-caught fish that restores 100 HP & MP.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
if
(

_a.Character.PrimaryPart.mana.Value<_a.Character.PrimaryPart.maxMana.Value or _a.Character.PrimaryPart.health.Value<
_a.Character.PrimaryPart.maxHealth.Value)then
d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,100,100,"item",6)end;return true,"You feel refreshed."end;return false,"Character is invalid."end,buyValue=300,sellValue=80,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}