
return
{id=14,name="Basic Weapon ATK Scroll (100%)",rarity="Rare",image="rbxassetid://2528903584",description="A magical scroll that has the ability to increase a weapon's attack power.",enchantments={[1]={modifierData={baseDamage=1},selectionWeight=1,tier=1}},tier=2,validation=function(a,b)
if
a.category=="equipment"and a.equipmentSlot==1 then return true end;return false end,successRate=1,applyScroll=function(a,b,c,d,_a)
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local ba=aa[b.id]if
ba.category=="equipment"and ba.equipmentSlot==1 then return true end;return false end,buyValue=15000,sellValue=1000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}