
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=253,name="Pear",rarity="Common",image="rbxassetid://2661683979",description="A ripe pear bustling with flavor.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,50,nil,"item",226)
local ba,ca=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=60,modifierData={stamina=1}},_a.Character.PrimaryPart,"item",item.id)return ba and"You feel refreshed."or"ERRORRRR"end;return false,"Character is invalid."end,consumeTime=1,stackSize=44,buyValue=500,sellValue=100,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item