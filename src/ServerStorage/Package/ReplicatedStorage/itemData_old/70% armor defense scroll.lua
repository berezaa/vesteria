
return
{id=150,name="Great Armor DEF Scroll (70%)",rarity="Rare",image="rbxassetid://2528903561",description="A risky scroll that has a good chance to significantly increase an armor's defense.",tier=3,enchantments={[1]={modifierData={defense=2},selectionWeight=1,tier=2}},validation=function(a,b)
if
a.category=="equipment"and a.equipmentSlot==8 then return true end;return false end,successRate=.7,applyScroll=function(a,b,c)
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local _a=d[b.id]if
_a.category=="equipment"and _a.equipmentSlot==8 then return true end;return false end,buyValue=35000,sellValue=3000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}