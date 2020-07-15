
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=278,name="Magenta Potion",rarity="Common",image="rbxassetid://4786893404",description="A powerful tincture that restores 600 HP.",useSound="potion",activationEffect=function(_a)
if

_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,600,nil,"item",278)return aa,"You feel refreshed."end;return false,"Character is invalid."end,stackSize=32,buyValue=1000,sellValue=300,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}