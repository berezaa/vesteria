
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=80,name="Spider's Essence",rarity="Rare",image="rbxassetid://2684647467",description="Gain great power from the Spider Queen at the cost of some of your life.",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa,ba=d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",_a.Character.PrimaryPart,"empower",{duration=
5 *60,modifierData={equipmentDamage=30,maxHealth=-100,str=1,dex=1,int=1,vit=1}},_a.Character.PrimaryPart,"item",item.id)return aa,ba end;return false,"Character is invalid."end,stackSize=16,buyValue=5000,sellValue=1000,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item