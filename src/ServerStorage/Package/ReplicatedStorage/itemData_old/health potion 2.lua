
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=8,name="Big Red Potion",rarity="Common",image="rbxassetid://2528903757",description="A magical potion that restores 100 HP",useSound="potion",activationEffect=function(_a)
if

_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa,ba=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,100,nil,"item",6)return aa,aa and"You feel refreshed."or ba end;return false,"Character is invalid."end,stackSize=32,buyValue=125,sellValue=50,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}