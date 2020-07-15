
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=70,name="Flagon of Red Potion",rarity="Common",image="rbxassetid://2661683775",description="A speciality of the Warrior Stronghold. Restores 200 HP & grants +1 STR.",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,200,
nil,"item",6)
if aa then
local ba,ca=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=1 *60,modifierData={str=1}},_a.Character.PrimaryPart,"item",item.id)return ba,ca end;return aa,"failed to give health"end;return false,"Character is invalid."end,stackSize=32,buyValue=400,sellValue=100,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item