
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=226,name="Red Apple",rarity="Common",image="rbxassetid://4574376530",description="A crisp apple fresh from the tree.",itemType="food",useSound="eat_food",activationEffect=function(_a)
if

_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,30,nil,"item",226)return aa,aa and"You feel refreshed."or"ERRORRRR"end;return false,"Character is invalid."end,consumeTime=1,stackSize=44,buyValue=200,sellValue=50,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item