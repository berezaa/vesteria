local b={1,0.8,0.6,0.4,0.2,0.1,0.05}
return
{id=185,name="Holy Scroll",rarity="Legendary",image="rbxassetid://3405284231",description="A wonderful scroll, the warmth of which can burn away failed upgrade attempts. Its light diminishes with each use...",tier=5,successRate=1,upgradeCost=0,validation=function(c,d)local _a=
d.successfulUpgrades or 0;local aa=d.upgrades or 0;if aa<=0 then return false,
"Item has not been upgraded"end;if _a>=aa then return false,
"Item does not have any failed slots to restore"end
return true end,applyScroll=function(c,d,_a)
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local ba=aa[d.id]local ca=d.successfulUpgrades or 0
local da=d.upgrades or 0;local _b=d.restorations or 0
if da<=0 then return false,"Item has not been upgraded"end
if ca>=da then return false,"Item does not have any failed slots to restore"end;local ab=b[_b+1]or b[#b]local bb=Random.new()
local cb=bb:NextNumber()<=ab
if cb then local db=d.enchantments;local _c=1;repeat local ac=db[_c]if ac==nil then break end
if ac.state and
ac.state==-1 then table.remove(db,_c)else _c=_c+1 end until _c>#db;d.restorations=(
d.restorations or 0)+1
return true,
"The Holy Scroll lights up and you feel a burden lifted from your equipment.",{successfullyApplied=true,textColor3=Color3.fromRGB(255,230,102)}else
return true,"The Holy Scroll lights up, but its warmth could not reach your item.",{successfullyApplied=false}end end,buyValue=50000,sellValue=4000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}