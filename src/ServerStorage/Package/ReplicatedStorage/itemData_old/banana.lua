
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=116,name="Banana",rarity="Common",image="rbxassetid://2661683923",description="A healthy treat that boosts your movement speed and jump.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,100,
nil,"item",6)
local aa,ba=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=60,modifierData={walkspeed=6,jump=2}},_a.Character.PrimaryPart,"item",item.id)return aa,ba end;return false,"Character is invalid."end,consumeTime=1,stackSize=44,buyValue=1000,sellValue=200,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item