
return
{id=176,name="Reset Scroll",rarity="Legendary",image="rbxassetid://3405284363",description="A magical scroll that returns an item to its natural state, removing ALL modifications and upgrade attempts.",tier=2,successRate=1,upgradeCost=0,applyScroll=function(a,b,c)
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local _a=d[b.id]local aa=false;local ba="This item is already in it's natural state."
for ca,da in
pairs(b)do
if
ca~="stacks"and ca~="position"and ca~="id"and
ca~="soulbound"and ca~="questbound"then b[ca]=nil;aa=true;ba="The item was returned to its natural state."end end;return aa,ba end,buyValue=50000,sellValue=4000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}