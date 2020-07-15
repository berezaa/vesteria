
return
{id=16,name="Great Weapon ATK Scroll (70%)",rarity="Rare",image="rbxassetid://2528903561",description="A risky scroll that has a good chance to significantly increase a weapon's attack power.",tier=3,enchantments={[1]={modifierData={baseDamage=2},selectionWeight=1,tier=2}},validation=function(a,b)
if
a.category=="equipment"and a.equipmentSlot==1 then return true end;return false end,successRate=0.7,applyScroll=function(a,b,c,d,_a)
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local ba=aa[b.id]if
ba.category=="equipment"and ba.equipmentSlot==1 then return true end;return false end,buyValue=40000,sellValue=3000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}