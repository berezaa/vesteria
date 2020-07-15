
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=47,name="Intelligence Potion",rarity="Common",image="rbxassetid://2535600195",description="A powerful potion that empowers its user with +4 INT for 10 minutes.",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa,ba=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=
10 *60,modifierData={int=4}},_a.Character.PrimaryPart,"item",item.id)return aa,ba end;return false,"Character is invalid."end,stackSize=32,buyValue=2500,sellValue=400,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item