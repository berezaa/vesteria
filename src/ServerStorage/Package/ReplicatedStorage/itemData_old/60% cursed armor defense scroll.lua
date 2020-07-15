local _a=Random.new()local aa
local ba=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ca=ba.load("utilities")
aa={id=118,name="Cursed Armor DEF Scroll (60%)",nameColor=Color3.fromRGB(170,170,170),rarity="Legendary",image="rbxassetid://2866512997",description="A forbidden scroll that can do almost anything. Dire consequences can await should this evil scroll fail.",tier=5,validation=function(da,_b)
if
da.category=="equipment"and da.equipmentSlot==8 then return true end;return false end,enchantments={[01]={modifierData={defense=3},selectionWeight=7,tier=2},[02]={modifierData={defense=4},selectionWeight=5,tier=3},[03]={modifierData={defense=5},selectionWeight=3,tier=3},[04]={modifierData={defense=6},selectionWeight=2,tier=4},[05]={modifierData={defense=7},selectionWeight=1,tier=5},[06]={modifierData={defense=2},selectionWeight=4,tier=2},[07]={selectionWeight=0},[08]={modifierData={defense=
-1},selectionWeight=1,tier=-1},[09]={modifierData={defense=-2},selectionWeight=1,tier=-2},[10]={modifierData={str=1},manual=true,selectionWeight=3,tier=1},[11]={modifierData={int=1},manual=true,selectionWeight=3,tier=1},[12]={modifierData={dex=1},manual=true,selectionWeight=3,tier=1},[13]={modifierData={vit=1},manual=true,selectionWeight=3,tier=1},[14]={modifierData={str=2},manual=true,selectionWeight=5,tier=2},[15]={modifierData={int=2},manual=true,selectionWeight=5,tier=2},[16]={modifierData={dex=2},manual=true,selectionWeight=5,tier=2},[17]={modifierData={vit=2},manual=true,selectionWeight=5,tier=2},[18]={modifierData={str=3},manual=true,selectionWeight=1,tier=3},[19]={modifierData={int=3},manual=true,selectionWeight=1,tier=3},[20]={modifierData={dex=3},manual=true,selectionWeight=1,tier=3},[21]={modifierData={vit=3},manual=true,selectionWeight=1,tier=3},[22]={modifierData={str=
-1},manual=true,selectionWeight=3,tier=-1},[23]={modifierData={int=-1},manual=true,selectionWeight=3,tier=-1},[24]={modifierData={dex=
-1},manual=true,selectionWeight=3,tier=-1},[25]={modifierData={vit=-1},manual=true,selectionWeight=3,tier=-1},[26]={modifierData={str=1,int=1,vit=1,dex=1},selectionWeight=1,manual=true,selectionWeight=1,tier=3},[27]={selectionWeight=0},[28]={selectionWeight=0},[29]={selectionWeight=0},[30]={modifierData={maxHealth=20},manual=true,selectionWeight=7,tier=1},[31]={modifierData={maxMana=20},manual=true,selectionWeight=7,tier=1},[32]={modifierData={maxHealth=40},manual=true,selectionWeight=1,tier=2},[33]={modifierData={maxMana=40},manual=true,selectionWeight=1,tier=2},[34]={modifierData={maxHealth=
-20},manual=true,selectionWeight=4,tier=-1},[35]={modifierData={maxMana=-20},manual=true,selectionWeight=4,tier=-1},[37]={modifierData={stamina=1},manual=true,selectionWeight=1,tier=3},[38]={modifierData={stamina=
-1},manual=true,selectionWeight=1,tier=-1},[39]={modifierData={healthRegen=10},manual=true,selectionWeight=2,tier=2},[40]={modifierData={healthRegen=
-10},manual=true,selectionWeight=1,tier=-1},[41]={modifierData={manaRegen=10},manual=true,selectionWeight=2,tier=2},[42]={modifierData={manaRegen=
-10},manual=true,selectionWeight=1,tier=-1},[43]={selectionWeight=0},[44]={selectionWeight=0},[45]={modifierData={blockChance=0.05},manual=true,selectionWeight=3,tier=2},[46]={modifierData={blockChance=0.1},manual=true,selectionWeight=1,tier=3}},destroyItemOnFail=true,successRate=0.6,destroyItemRate=0.5,applyScroll=function(da,_b,ab)
local bb=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local cb=bb[_b.id]
if
cb.category=="equipment"and cb.equipmentSlot==8 then
if ab then local db={}for cc,dc in pairs(aa.enchantments)do
if dc.manual and dc.selectionWeight and
dc.selectionWeight>0 then table.insert(db,dc)end end
local _c,ac=ca.selectFromWeightTable(db)local bc
for cc,dc in pairs(aa.enchantments)do if dc==_c then bc=cc end end
if bc then local cc=0.2;local dc=Random.new()local _d=require(script.Parent)
local ad=require(game.ReplicatedStorage.itemAttributes)local bd={}local cd
for dd,__a in pairs(_b.enchantments)do local a_a=_d[__a.id]
if
a_a and a_a.enchantments then local b_a=a_a.enchantments[__a.state]if b_a and b_a.modifierData then
for c_a,d_a in
pairs(b_a.modifierData)do bd[c_a]=(bd[c_a]or 0)+d_a end end
if __a.id==aa.id and
__a.state==bc then cc=math.max(cc,0.95)cd=true;break end end end
if not cd then
if _b.attribute then local dd=ad[_b.attribute]
if dd and dd.modifier then
local __a=dd.modifier(cb,_b)if __a then
for a_a,b_a in pairs(__a)do bd[a_a]=(bd[a_a]or 0)+b_a end end end end end;if cb.modifierData then
for dd,__a in pairs(cb.modifierData)do for a_a,b_a in pairs(__a)do
bd[a_a]=(bd[a_a]or 0)+b_a end end end
if _c.modifierData and
not cd then for dd,__a in pairs(_c.modifierData)do
if bd[dd]then cc=math.max(cc,0.45)break end end end;if dc:NextNumber()<=cc then
table.insert(_b.enchantments,{id=aa.id,state=bc})end end end;return true end;return false end,buyValue=1000000,sellValue=5000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}return aa