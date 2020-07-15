
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=144,name="Hog Meat",rarity="Common",image="rbxassetid://3164395419",description="Mmm, fresh hog. Restores 70 HP and boosts Attack for 3 minutes.",canStack=true,canBeBound=true,canAwaken=false,sellValue=200,buyValue=2000,activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,70,
nil,"item",6)if not aa then return false,"failed to give health"end
local ba,ca=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=
3 *60,modifierData={equipmentDamage=5}},_a.Character.PrimaryPart,"item",item.id)return ba,ca end;return false,"Character is invalid."end,stackSize=32,isImportant=false,category="consumable"}return item