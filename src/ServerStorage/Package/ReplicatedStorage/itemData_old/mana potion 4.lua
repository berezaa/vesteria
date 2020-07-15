
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=183,name="Mana Elixir",rarity="Common",image="rbxassetid://3376408955",description="A magical potion of great potency that restores 300 MP.",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and

_a.Character.PrimaryPart.mana.Value<_a.Character.PrimaryPart.maxMana.Value then
local aa,ba=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,
nil,300,"item",183)return aa,ba end;return false,"Character is invalid."end,stackSize=32,buyValue=420,sellValue=170,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}