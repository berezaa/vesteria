
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=131,name="Mushroom Soup",rarity="Common",image="rbxassetid://3164341819",description="A hearty bowl of delicious mushroom soup. Fully recovers all HP and MP.",itemType="food",useSound="potion",tier=3,activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,
_a.Character.PrimaryPart.maxHealth.Value-_a.Character.PrimaryPart.health.Value,
_a.Character.PrimaryPart.maxMana.Value-_a.Character.PrimaryPart.mana.Value,"item",6)return aa,"You feel refreshed."end;return false,"Character is invalid."end,buyValue=50000,sellValue=5000,stackSize=8,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}