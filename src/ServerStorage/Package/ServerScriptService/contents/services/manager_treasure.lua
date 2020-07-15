local db={}local _c=game:GetService("ReplicatedStorage")
local ac=game:GetService("RunService")local bc=require(_c.itemData)local cc=require(_c.modules)
local dc=cc.load("network")local _d=cc.load("utilities")local ad=cc.load("configuration")
local bd=cc.load("levels")local cd=Random.new()
local dd={{id="health potion",stacks=10,chance=30,minLevel=0,maxLevel=5},{id="mana potion",stacks=10,chance=30,minLevel=0,maxLevel=5},{id="health potion",stacks=20,chance=5,minLevel=0,maxLevel=5},{id="mana potion",stacks=20,chance=5,minLevel=0,maxLevel=5},{id="100% armor defense scroll",stacks=1,chance=15,minLevel=0,maxLevel=100},{id="100% weapon attack scroll",stacks=1,chance=15,minLevel=0,maxLevel=100},{id="megaphone",stacks=1,chance=1,minLevel=10,maxLevel=100}}
local __a={["3303140173"]={{id="crystal beetle",stacks=3,chance=10},{id="broken crystal beetle",stacks=6,chance=30},{id="broken crystal beetle",stacks=7,chance=30},{id="broken crystal beetle",stacks=8,chance=30},{id="cactus fruit",stacks=15,chance=25},{id="item dye yellow",stacks=1,chance=1}},["2546689567"]={{id="rune hunter",stacks=3,chance=25},{id="health potion chalice",stacks=10,chance=80},{id="dexterity potion",stacks=1,chance=10},{id="arrow",stacks=50,chance=20},{id="banana",stacks=15,chance=25},{id="mighty sub",stacks=16,chance=3},{id="wayfarer ticket",stacks=1,chance=2},{id="item dye green",stacks=1,chance=1},{id="wooden bow",attribute="pristine",stacks=1,chance=5},{id="hunter bandit vest",attribute="pristine",stacks=1,chance=5},{id="hunter bandit mask",attribute="pristine",stacks=1,chance=5}},["3207211233"]={{id="spider fang",stacks=30,chance=80},{id="royal spider egg",stacks=1,chance=20},{id="spider potion",stacks=1,chance=10},{id="spider fang dagger",stacks=1,chance=3},{id="spider bow",stacks=1,chance=3},{id="spider staff",stacks=1,chance=3},{id="spider sword",stacks=1,chance=3},{id="item dye purple",stacks=1,chance=1}},["2471035818"]={{id="rune hunter",stacks=3,chance=25},{id="dexterity potion",stacks=1,chance=10},{id="tomahawk",attribute="pristine",stacks=1,chance=5},{id="arrow",stacks=50,chance=20},{id="item dye green",stacks=1,chance=1}},["3232913902"]={{id="snel snel shell",stacks=1,chance=1},{id="snelleth shell",stacks=1,chance=1},{id="snelly shell",stacks=1,chance=1},{id="snelvin shell",stacks=1,chance=1}},["2093766642"]={{id="rune hunter",stacks=3,chance=25},{id="fish",stacks=10,chance=80},{id="tall blue fish",stacks=10,chance=20},{id="yellow puffer fish",stacks=3,chance=10}},["2496503573"]={{id="rune colosseum",stacks=3,chance=25},{id="health potion horn",stacks=10,chance=80}},["2470481225"]={{id="rune warrior",stacks=3,chance=25},{id="health potion flagon",stacks=10,chance=80},{id="strength potion",stacks=1,chance=10},{id="item dye red",stacks=1,chance=1},{id="bronze helmet",attribute="pristine",stacks=1,chance=5},{id="bronze armor",attribute="pristine",stacks=1,chance=5},{id="bronze mace",attribute="pristine",stacks=1,chance=5}},["2376890690"]={{id="rune warrior",stacks=3,chance=25},{id="strength potion",stacks=1,chance=10}},["2260598172"]={{id="rune mage",stacks=3,chance=25},{id="health potion silver",stacks=10,chance=80}},["3112029149"]={{id="rune mage",stacks=3,chance=25},{id="health potion silver",stacks=10,chance=80},{id="item dye blue",stacks=1,chance=1},{id="mage hat 2",attribute="pristine",stacks=1,chance=5},{id="mage robes 2",attribute="pristine",stacks=1,chance=5},{id="willow staff",attribute="pristine",stacks=1,chance=5}},["2060556572"]={{id="oak axe",attribute="pristine",stacks=1,chance=10}},["2119298605"]={{id="rune nilgarf",stacks=3,chance=25},{id="pear",stacks=15,chance=25},{id="item renamer",stacks=1,chance=1},{id="item lore",stacks=1,chance=1},{id="item dye grey",stacks=1,chance=1}},["3273679677"]={{id="mushroom soup",stacks=1,chance=5},{id="rune mushtown",stacks=3,chance=25},{id="golden mushroom",stacks=5,chance=35}},["2060360203"]={{id="mushroom beard",stacks=30,chance=20},{id="mushroom mini",stacks=30,chance=40},{id="mushroom soup",stacks=1,chance=1},{id="rune mushtown",stacks=3,chance=25}},["2064647391"]={{id="rune mushtown",stacks=3,chance=25},{id="mushroom mini",stacks=30,chance=25},{id="apple",stacks=15,chance=25},{id="mushroom soup",stacks=1,chance=1}},["2035250551"]={{id="rune mushtown",stacks=3,chance=25},{id="mushroom mini",stacks=30,chance=40},{id="mushroom soup",stacks=1,chance=1}}}local a_a
do for b_a,c_a in pairs(dd)do
if type(c_a.id)=="string"then c_a.id=bc[c_a.id].id end end
for b_a,c_a in pairs(__a)do
for d_a,_aa in pairs(c_a)do
if type(_aa.id)==
"string"then local aaa=bc[_aa.id]
if(aaa)then _aa.id=bc[_aa.id].id else if
ac:IsStudio()and game.PlaceId==b_a then
warn("Treasure manager: Item \""..
_aa.id.." does not exist in itemLookup!")end end end end end end;for b_a,c_a in pairs(__a)do
if
tonumber(b_a)==_d.originPlaceId(game.PlaceId)then for d_a,_aa in pairs(c_a)do table.insert(dd,_aa)end end end
function main()
dc:create("{B47E205D-B7C4-42D4-BA5E-7977796C6571}","BindableFunction","OnInvoke",function(b_a,c_a)
local d_a=_d.originPlaceId(game.PlaceId)assert(c_a,"Chest cannot be nil!")
local _aa=c_a.chestLevel.Value;local aaa=0
local baa=dc:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",b_a)local caa=__a[tostring(d_a)]local daa={}
local function _ba()local aba;local bba=baa.globalData
if bba then local cba=math.floor(
os.time()/ (60 *60 *24))bba.ethyrRewards=
bba.ethyrRewards or 0
if bba.lastEthyrReward==nil or
bba.lastEthyrReward<cba then bba.ethyrRewards=0;bba.lastEthyrReward=cba end
if bba.ethyrRewards<5 then local dba=0.025;if _aa>=40 then dba=0.15 elseif _aa>=25 then dba=0.1 elseif _aa>=18 then dba=0.075 elseif _aa>=7 then
dba=0.04 end
if dba and
cd:NextNumber()<=dba then bba.ethyrRewards=bba.ethyrRewards+1;aba=true end end
baa.nonSerializeData.setPlayerData("globalData",bba)end
if aba then local cba={id="ethyr pile",stacks=1}
table.insert(daa,{id=cba.id,stacks=cba.stacks})elseif cd:NextInteger(1,5)==4 then aaa=(aaa or 0)+bd.getQuestGoldFromLevel(_aa or 1)*
0.5 else
local cba={}
for dba,_ca in pairs(dd)do
if(_aa>= (_ca.minLevel or 0))and
(_aa<= (_ca.maxLevel or 999999))then for i=1,(_ca.chance or 0)do
table.insert(cba,_ca)end end end
if caa then
for dba,_ca in pairs(caa)do
if(_aa>= (_ca.minLevel or 0))and
(_aa<= (_ca.maxLevel or 999999))then for i=1,(_ca.chance or 0)do
table.insert(cba,_ca)end end end end
if#cba>0 then local dba=cba[cd:NextInteger(1,#cba)]local _ca={}
for aca,bca in
pairs(dba)do if
aca~="minLevel"and aca~="maxLevel"and aca~="chance"then _ca[aca]=bca end end;table.insert(daa,_ca)end end end;_ba()if cd:NextNumber()>=0.85 then _ba()end
for aba,bba in
pairs(baa.quests.active)do
if bba.id==10 then local cba=false;for dba,_ca in pairs(baa.inventory)do
if _ca.id==138 then cba=true end end;if not cba then local dba=cd:NextInteger(1,3)
if
dba==1 then table.insert(daa,{id=138,stacks=1})end end end end;return{rewards=daa,gold=aaa}end)end;main()return db