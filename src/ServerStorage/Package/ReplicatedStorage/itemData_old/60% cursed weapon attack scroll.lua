local _a=Random.new()local aa
local ba=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ca=ba.load("utilities")
aa={id=112,name="Cursed Weapon ATK Scroll (60%)",nameColor=Color3.fromRGB(170,170,170),rarity="Legendary",image="rbxassetid://2866512997",description="A forbidden scroll that can do almost anything. Dire consequences can await should this evil scroll fail.",tier=5,validation=function(da,_b)
if
da.category=="equipment"and da.equipmentSlot==1 then return true end;return false end,enchantments={[01]={modifierData={baseDamage=3},selectionWeight=7,tier=2},[02]={modifierData={baseDamage=4},selectionWeight=5,tier=3},[03]={modifierData={baseDamage=5},selectionWeight=3,tier=3},[04]={modifierData={baseDamage=6},selectionWeight=2,tier=4},[05]={modifierData={baseDamage=7},selectionWeight=1,tier=5},[06]={modifierData={baseDamage=2},selectionWeight=4,tier=2},[07]={selectionWeight=0},[08]={modifierData={baseDamage=
-1},selectionWeight=1,tier=-1},[09]={modifierData={baseDamage=-2},selectionWeight=1,tier=-2},[10]={modifierData={str=1},manual=true,selectionWeight=3,tier=1},[11]={modifierData={int=1},manual=true,selectionWeight=3,tier=1},[12]={modifierData={dex=1},manual=true,selectionWeight=3,tier=1},[13]={modifierData={vit=1},manual=true,selectionWeight=3,tier=1},[14]={modifierData={str=2},manual=true,selectionWeight=5,tier=2},[15]={modifierData={int=2},manual=true,selectionWeight=5,tier=2},[16]={modifierData={dex=2},manual=true,selectionWeight=5,tier=2},[17]={modifierData={vit=2},manual=true,selectionWeight=5,tier=2},[18]={modifierData={str=3},manual=true,selectionWeight=1,tier=3},[19]={modifierData={int=3},manual=true,selectionWeight=1,tier=3},[20]={modifierData={dex=3},manual=true,selectionWeight=1,tier=3},[21]={modifierData={vit=3},manual=true,selectionWeight=1,tier=3},[22]={modifierData={str=
-1},manual=true,selectionWeight=3,tier=-1},[23]={modifierData={int=-1},manual=true,selectionWeight=3,tier=-1},[24]={modifierData={dex=
-1},manual=true,selectionWeight=3,tier=-1},[25]={modifierData={vit=-1},manual=true,selectionWeight=3,tier=-1},[26]={modifierData={str=1,int=1,vit=1,dex=1},selectionWeight=1,manual=true,selectionWeight=1,tier=3},[27]={selectionWeight=0},[28]={selectionWeight=0},[29]={selectionWeight=0},[30]={modifierData={maxHealth=20},manual=true,selectionWeight=7,tier=1},[31]={modifierData={maxMana=20},manual=true,selectionWeight=7,tier=1},[32]={modifierData={maxHealth=40},manual=true,selectionWeight=1,tier=2},[33]={modifierData={maxMana=40},manual=true,selectionWeight=1,tier=2},[34]={modifierData={maxHealth=
-20},manual=true,selectionWeight=4,tier=-1},[35]={modifierData={maxMana=-20},manual=true,selectionWeight=4,tier=-1},[37]={modifierData={stamina=1},manual=true,selectionWeight=1,tier=3},[38]={modifierData={stamina=
-1},manual=true,selectionWeight=1,tier=-1},[39]={modifierData={healthRegen=10},manual=true,selectionWeight=2,tier=2},[40]={modifierData={healthRegen=
-10},manual=true,selectionWeight=1,tier=-1},[41]={modifierData={manaRegen=10},manual=true,selectionWeight=2,tier=2},[42]={modifierData={manaRegen=
-10},manual=true,selectionWeight=1,tier=-1},[43]={selectionWeight=0},[44]={selectionWeight=0},[45]={modifierData={criticalStrikeChance=0.05},manual=true,selectionWeight=3,tier=2},[46]={modifierData={criticalStrikeChance=0.1},manual=true,selectionWeight=1,tier=3}},destroyItemOnFail=true,successRate=0.6,destroyItemRate=0.5,applyScroll=function(da,_b,ab,bb,cb)
local db=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local _c=db[_b.id]
if
_c.category=="equipment"and _c.equipmentSlot==1 then
if ab then local ac={}for _d,ad in pairs(aa.enchantments)do
if ad.manual and ad.selectionWeight and
ad.selectionWeight>0 then table.insert(ac,ad)end end
local bc,cc=ca.selectFromWeightTable(ac)local dc
for _d,ad in pairs(aa.enchantments)do if ad==bc then dc=_d end end
if dc then local _d=0.2;local ad=Random.new()local bd=require(script.Parent)
local cd=require(game.ReplicatedStorage.itemAttributes)local dd={}local __a
for a_a,b_a in pairs(_b.enchantments)do local c_a=bd[b_a.id]
if
c_a and c_a.enchantments then local d_a=c_a.enchantments[b_a.state]if d_a and d_a.modifierData then
for _aa,aaa in
pairs(d_a.modifierData)do dd[_aa]=(dd[_aa]or 0)+aaa end end
if b_a.id==aa.id and
b_a.state==dc then _d=math.max(_d,0.95)__a=true;break end end end
if not __a then
if _b.attribute then local a_a=cd[_b.attribute]
if a_a and a_a.modifier then
local b_a=a_a.modifier(_c,_b)if b_a then
for c_a,d_a in pairs(b_a)do dd[c_a]=(dd[c_a]or 0)+d_a end end end end end;if _c.modifierData then
for a_a,b_a in pairs(_c.modifierData)do for c_a,d_a in pairs(b_a)do
dd[c_a]=(dd[c_a]or 0)+d_a end end end
if bc.modifierData and
not __a then for a_a,b_a in pairs(bc.modifierData)do
if dd[a_a]then _d=math.max(_d,0.45)break end end end;if ad:NextNumber()<=_d then
table.insert(_b.enchantments,{id=aa.id,state=dc})end end end;return true end;return false end,buyValue=1000000,sellValue=5000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}return aa