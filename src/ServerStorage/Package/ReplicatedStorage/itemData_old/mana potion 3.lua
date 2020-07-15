
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=88,name="Purple Potion",rarity="Common",image="rbxassetid://2744385347",description="A great magical potion that replenishes 100 MP",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and

_a.Character.PrimaryPart.mana.Value<_a.Character.PrimaryPart.maxMana.Value then
d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,
nil,100,"item",88)return true,"You feel recharged."end;return false,"Character is invalid."end,stackSize=32,buyValue=140,sellValue=60,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}