local ca={}local da=game:GetService("RunService")
local _b=game:GetService("ReplicatedStorage")local ab=require(_b.modules)local bb=ab.load("network")
local cb=require(game.ReplicatedStorage:WaitForChild("itemData"))
ca.tierColors={[-1]=Color3.new(0.7,0.7,0.7),[1]=Color3.new(1,1,1),[2]=Color3.fromRGB(112,241,255),[3]=Color3.fromRGB(165,55,255),[4]=Color3.fromRGB(235,42,87),[5]=Color3.fromRGB(255,238,0),[6]=Color3.fromRGB(0,255,0)}
function ca.enchantmentCanBeAppliedToItem(_c,ac)local bc=cb[_c.id]local cc=cb[ac.id]if
ac.notUpgradable or cc.notUpgradable then return false end;if bc.validation then if
not bc.validation(cc,ac)then return false end end;local dc=
bc.upgradeCost or 1
local _d=(cc.maxUpgrades or 0)+ (ac.bonusUpgrades or 0)local ad=ac.enchantments or{}local bd=ac.upgrades or 0;if bd+dc<=_d then
return true end end;local db={2 /3,3 /2,3,5,8,10,15}
ca.enchantmentPrice=function(_c)
if not _c then return false end;local ac=_c.enchantments or 0
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local cc=bc[_c.id]
if _c.upgrades and _c.upgrades>=7 then return false end;if not cc.buyValue then return false end;if cc.category=="equipment"then return
math.ceil(
cc.buyValue*db[(_c.upgrades or 0)+1])end end
ca.applyEnchantment=function(_c)
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local bc=ac[_c.id]
if _c.upgrades and _c.upgrades>=7 then return false end
if bc.category=="equipment"then
if not _c.modifierData then _c.modifierData={}end;if not bc.buyValue then return false end;local cc=
bc.modifierData and bc.modifierData[1]or{}local dc={}local _d=_c.enchantments and
(_c.enchantments+1)==7;if
not _c.modifierData then _c.modifierData={}end
if bc.equipmentSlot==1 then local ad=bc.modifierData and
bc.modifierData[1]or{}
local bd=


(bc.baseDamage and
bc.baseDamage>0 and bc.baseDamage or 1)+ (ad.rangedDamage or 0)*0.65 + (ad.magicalDamage or 0)*0.65 + (ad.physicalDamage or 0)*0.65;local cd=0.06
if _d and not bc.blessedUpgrade then _c.blessed=true;cd=0.09 end
local dd=math.clamp(math.floor((bd or 1)*cd),1,math.huge)dc["baseDamage"]=dd elseif
bc.equipmentSlot==2 or bc.equipmentSlot==8 or bc.equipmentSlot==9 then local ad=bc.modifierData and
bc.modifierData[1]or{}
local bd=




(ad.defense and
ad.defense>0 and ad.defense or 1)+ (
ad.rangedDefense or 0)*0.65 + (
ad.magicalDefense or 0)*0.65 + (ad.physicalDefense or 0)*0.65 + (ad.rangedDamage or 0)*0.55 + (ad.magicalDamage or 0)*0.55 + (ad.physicalDamage or 0)*0.55 + (ad.equipmentDamage or 0)*0.75;local cd=0.06
if _d and not bc.blessedUpgrade then _c.blessed=true;cd=0.09 end
local dd=math.clamp(math.floor((bd or 1)*cd),1,math.huge)dc["defense"]=dd else return false end
if _d and bc.blessedUpgrade then for ad,bd in pairs(bc.blessedUpgrade)do
dc[ad]=(dc[ad]or 0)+bd end;_c.blessed=true end;table.insert(_c.modifierData,dc)
_c.upgrades=(_c.upgrades or 0)+1
_c.successfulUpgrades=(_c.successfulUpgrades or 0)+1;_c.enchantments=(_c.enchantments or 0)+1;return _c end;return nil end;return ca