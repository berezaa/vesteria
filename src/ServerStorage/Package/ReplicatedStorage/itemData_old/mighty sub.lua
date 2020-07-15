
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=75,name="Mighty Sub",rarity="Common",image="rbxassetid://2661683887",description="A deluxe sub that's sure to satisfy. Restores 1,000 HP.",useSound="eat_food",activationEffect=function(_a)
if

_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,1000,nil,"item",6)return aa,"You feel refreshed."end;return false,"Character is invalid."end,stackSize=16,buyValue=2200,sellValue=300,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}