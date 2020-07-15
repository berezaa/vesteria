
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=76,name="Muffin",rarity="Common",image="rbxassetid://2661683954",description="A tasty treat that heals 100 HP and grants a 50 Max HP boost.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,100,
nil,"item",6)
local ba,ca=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=3 *60,modifierData={maxHealth=50}},_a.Character.PrimaryPart,"item",item.id)return aa,ca end;return false,"Character is invalid."end,stackSize=32,buyValue=700,sellValue=250,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item