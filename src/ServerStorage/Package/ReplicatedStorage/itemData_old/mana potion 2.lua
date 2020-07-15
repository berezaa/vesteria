
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=279,name="Big Blue Potion",rarity="Common",image="rbxassetid://4776205306",description="A magical potion that restores 75 MP.",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and

_a.Character.PrimaryPart.mana.Value<_a.Character.PrimaryPart.maxMana.Value then
local aa,ba=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,
nil,75,"item",279)return aa,ba end;return false,"Character is invalid."end,stackSize=32,buyValue=100,sellValue=40,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}