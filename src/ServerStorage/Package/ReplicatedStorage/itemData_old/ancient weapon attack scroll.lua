
return
{id=200,name="Ancient Weapon ATK Scroll (10%)",rarity="Rare",image="rbxassetid://2528903538",description="A very old scroll that will most likely fail. Rumored to have once increased attack power enormously.",tier=4,enchantments={[1]={modifierData={baseDamage=4},selectionWeight=5,tier=3}},validation=function(a,b)
if
a.category=="equipment"and a.equipmentSlot==1 then return true end;return false end,successRate=0.1,applyScroll=function(a,b,c,d,_a)
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local ba=aa[b.id]if
ba.category=="equipment"and ba.equipmentSlot==1 then return true end;return false end,buyValue=100000,sellValue=4000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}