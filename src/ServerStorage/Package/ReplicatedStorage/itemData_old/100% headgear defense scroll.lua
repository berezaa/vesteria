
return
{id=61,name="Basic Headgear Scroll (100%)",rarity="Rare",image="rbxassetid://2528903584",description="A magical scroll that has the ability to increase a headgear's stats.",enchantments={[1]={modifierData={},statUpgrade=1,selectionWeight=1,tier=1}},tier=2,successRate=1,validation=function(a,b)
if
a.category=="equipment"and a.equipmentSlot==2 then return true end;return false end,applyScroll=function(a,b,c)
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local _a=d[b.id]if
_a.category=="equipment"and _a.equipmentSlot==2 then return true end;return false end,buyValue=10000,sellValue=700,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}