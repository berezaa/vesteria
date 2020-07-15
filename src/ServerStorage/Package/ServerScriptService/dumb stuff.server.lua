if true then return false end
local cdc={["rbxgameasset://Images/whitecirclecropped2"]="rbxassetid://2920343923",["rbxgameasset://Images/whitecirclecropped2"]="rbxassetid://2920343923",[""]="",[""]=""}
local ddc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local __d=ddc.load("network")local a_d=game.Players.berezaa
for _dba,adba in
pairs(game.Players:GetPlayers())do
if adba.Character and adba.Character.PrimaryPart then
local bdba,cdba=__d:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",adba.Character.PrimaryPart,"empower",{duration=600,modifierData={wisdom=1,stamina=3,maxHealth=500,maxMana=500}},adba.Character.PrimaryPart,"item",82)end end;local b_d=game.Players.berezaa
for _dba,adba in
pairs(game.Players:GetPlayers())do
if
adba and adba.Character and adba.Character.PrimaryPart and
(
adba.Character.PrimaryPart.Position-b_d.Character.PrimaryPart.Position).magnitude<=30 then
spawn(function()wait()
__d:invoke("{283E214A-12D2-429B-9945-85DFCC54DCEA}",adba,4544425669)end)end end
__d:invoke("{283E214A-12D2-429B-9945-85DFCC54DCEA}",player,4544425669)
local c_d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d_d=c_d.load("network")
for _dba,adba in
pairs(game.Players:GetPlayers())do
local bdba=d_d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",adba)if bdba then print(bdba["goldwipe3/19"])end end;local _ad={}
for _dba,adba in
pairs(game.ReplicatedStorage.monsterLookup:GetChildren())do local bdba=require(adba)
_ad[adba.Name]={level=tostring(bdba.level),baseEXP=tostring(bdba.baseEXP),baseHealth=tostring(bdba.baseHealth),baseDamage=tostring(bdba.baseDamage),attackSpeed=tostring(bdba.attackSpeed)}end;warn("----------")
print(game.HttpService:JSONEncode(_ad))warn("----------")
local function aad(_dba)
_dba=string.gsub(string.gsub(_dba," ","_"),"[^a-zA-Z0-9 - _ :]","")if#_dba>40 then _dba=string.sub(_dba,1,40)end
return _dba end;local bad={}local cad=game.ReplicatedStorage.abilityLookup
for _dba,adba in
pairs(cad:GetChildren())do local bdba=require(adba)local cdba={}
cdba.Key="abilityName_"..aad(adba.Name)print(cdba.Key)cdba.Source=bdba.name;cdba.Example=""
cdba.Values={}table.insert(bad,cdba)local ddba={}
ddba.Key="abilityDescription_"..aad(adba.Name)print(ddba.Key)ddba.Source=bdba.description;ddba.Example=""
ddba.Values={}table.insert(bad,ddba)end
game.LocalizationService.AbilityTable:SetEntries(bad)
local dad=game.Players.berezaa.Character.PrimaryPart.Position;local _bd=game:GetService("ReplicatedStorage")
local abd=require(_bd.modules)local bbd=abd.load("network")
for _dba,adba in
pairs(game.Players:GetPlayers())do
if adba.Character and adba.Character.PrimaryPart and
(
adba.Character.PrimaryPart.Position-dad).magnitude<=20 then
bbd:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",adba,2064647391)end end
if
workspace.placeFolders.spawnRegionCollections:FindFirstChild("Spider Queen-0")==nil then
local _dba=Instance.new("Folder",workspace.placeFolders.spawnRegionCollections)_dba.Name="Spider Queen-0"end;local cbd=game:GetService("ReplicatedStorage")
local dbd=require(cbd.modules)local _cd=dbd.load("network")
local acd=game:GetService("ReplicatedStorage")local bcd=require(acd.modules)local ccd=bcd.load("network")
for i=1,1 do
wait(0.3)
ccd:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Shroom",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*20 +Vector3.new(math.random(-5,5),00,math.random(-5,5)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{level=50,scale=1.3,baseSpeed=100,baseHealth=20,damageMulti=999,specialName="r e d  m u s h r o o m",dye={r=255,g=0,b=0}})end;local dcd=game:GetService("ReplicatedStorage")
local _dd=require(dcd.modules)local add=_dd.load("network")
for i=1,1 do wait(0.3)
add:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Trickster Spirit",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*20 +Vector3.new(math.random(-5,5),00,math.random(-5,5)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{baseHealth=1000,lootDrops={}})end;wait(5)local bdd=game:GetService("ReplicatedStorage")
local cdd=require(bdd.modules)local ddd=cdd.load("network")
ddd:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Scarab",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*20 +
Vector3.new(math.random(-40,40),00,math.random(-40,40)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{giant=true})local ___a=game:GetService("TeleportService")
local a__a,b__a,c__a,d__a=pcall(function()return
___a:GetPlayerPlaceInstanceAsync(70347205)end)print(a__a,b__a,c__a,d__a)if a__a then print(c__a,d__a)
___a:TeleportToPlaceInstance(c__a,d__a,game.Players.Polymorphic,
nil,{destination=c__a,saveSlot=2,dataSlot=2})end
local _a_a=workspace.placeFolders.monsterManifestCollection:GetChildren()local aa_a;for _dba,adba in pairs(_a_a)do
if adba:FindFirstChild("monsterScale")and
adba.monsterScale.Value>1.5 then aa_a=adba end end
Instance.new("PointLight",aa_a).Brightness=3;local ba_a=Instance.new("Hint",workspace)
ba_a.Text="Big Chicken HP: "..
aa_a.health.Value.." / "..aa_a.maxHealth.Value
aa_a.health.Changed:connect(function()
ba_a.Text="Big Chicken HP: "..aa_a.health.Value.." / "..
aa_a.maxHealth.Value end)
local ca_a=workspace.placeFolders.monsterManifestCollection:GetChildren()local da_a=ca_a[#ca_a]
local _b_a=game:GetService("ReplicatedStorage")local ab_a=require(_b_a.modules)local bb_a=ab_a.load("network")
for _dba,adba in
pairs(game.Players:GetPlayers())do local bdba={}bdba.damage=100000000;bdba.sourcePlayerId=adba.userId
bdba.damageTime=os.time()wait()local cdba=Instance.new("Explosion",workspace)
cdba.BlastPressure=1000;cdba.DestroyJointRadiusPercent=0;cdba.Position=da_a.Position
successfullyDealtDamage=bb_a:invoke("{031BE66E-62B6-4583-B409-DCB61C0DA077}",adba,da_a,bdba)end;wait(5)local cb_a=game:GetService("ReplicatedStorage")
local db_a=require(cb_a.modules)local _c_a=db_a.load("network")
_c_a:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","The Yeti",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*40 +
Vector3.new(math.random(-30,30),00,math.random(-30,30)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{dye={r=0,g=255,b=0},specialName="The Incredible Hulk"})wait(5)local ac_a=game:GetService("ReplicatedStorage")
local bc_a=require(ac_a.modules)local cc_a=bc_a.load("network")
for i=1,1 do
pcall(function()
cc_a:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Spiderling",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*40 +
Vector3.new(math.random(-30,30),00,math.random(-30,30)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{giant=true})end)end;local dc_a=3112029149;local _d_a=game.Players.berezaa;local ad_a=3
game:GetService("TeleportService"):Teleport(dc_a,_d_a,{destination=dc_a,dataSlot=ad_a})local bd_a=game:GetService("ReplicatedStorage")
local cd_a=require(bd_a.modules)local dd_a=cd_a.load("network")local __aa=game.Players.berezaa
dd_a:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",__aa,{},0,{{id=135,stacks=1}},0,"etc:vincent")
for _dba,adba in pairs(game.Players:GetPlayers())do
dd_a:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",adba,{},0,{{id=135,stacks=1}},0,"etc:vincent")end;wait()
for i=1,1 do
dd_a:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Chicken",

game.Players.Polymorphic.Character.PrimaryPart.Position+
game.Players.Polymorphic.Character.PrimaryPart.CFrame.lookVector*30 +Vector3.new(0,10,0),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{gigaGiant=true,maxhealth=100000,health=100000,id=
nil,passive=nil,lootDrops={{itemName="fish",spawnChance=0.9},{itemName="yellow puffer fish",spawnChance=0.5},{itemName="big brown fish",spawnChance=0.7},{itemName="pretty pink fish",spawnChance=0.7},{itemName="tall blue fish",spawnChance=0.7}}})end;local a_aa=game:GetService("ReplicatedStorage")
local b_aa=require(a_aa.modules)local c_aa=b_aa.load("network")wait()
for i=1,1 do wait()
c_aa:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Shroom",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*30 +Vector3.new(0,10,0),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{giant=true,goldMulti=1,specialName=[[mÍÌªÌ¥Ì»ÍuÌ³ÍÌ¦shÌÍÌ¯ÌªÌ°rÍÍÌ«oÌ´Ì²Ì©Ì©ÌÌªoÌ¤Ì¼Ì¼ÍÌÍÍmÌµÍÌ»ÍÌ­]],dye={r=255,g=0,b=0},level=30})end;local d_aa=game:GetService("ReplicatedStorage")
local _aaa=require(d_aa.modules)local aaaa=_aaa.load("network")wait(10)
for i=1,10 do
aaaa:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Terror of the Deep",

game.Players.berezaa.Character.PrimaryPart.Position+
game.Players.berezaa.Character.PrimaryPart.CFrame.lookVector*50 +Vector3.new(0,10,0),workspace.placeFolders.spawnRegionCollections["Spider-0"],{})end;local baaa=game:GetService("ReplicatedStorage")
local caaa=require(baaa.modules)local daaa=caaa.load("network")
for i=1,1 do
daaa:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}","Baby Shroom",
game.Players.berezaa.Character.PrimaryPart.Position+
Vector3.new(math.random(-10,10),math.random(25,35),math.random(-10,10)),workspace.placeFolders.spawnRegionCollections:GetChildren()[1],{lootDropMulti=30,lootDrops={{itemName="mogomelon",spawnChance=0.8}}})end;local _baa=2 *math.pi
local function abaa(_dba,adba)if _dba==0 and adba==0 then return nil end
local bdba=Vector2.new(_dba,adba)local cdba=bdba.magnitude
local ddba,__ca,a_ca=math.asin(adba),math.acos(_dba),math.atan2(adba,_dba)end;local bbaa=game:GetService("ReplicatedStorage")
local cbaa=require(bbaa.modules)local dbaa=cbaa.load("network")
local _caa=dbaa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",game.Players.berezaa)
_caa.nonSerializeData.setPlayerData("gold",70e6)local acaa=game:GetService("ReplicatedStorage")
local bcaa=require(acaa.modules)local ccaa=bcaa.load("network")
local dcaa=ccaa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",game.Players.Polymorphic)
dcaa.nonSerializeData.setPlayerData("class","Hunter")local _daa="ihnc"local adaa=60 *60 *2
local bdaa="Exploiting is not allowed in Vesteria."if not game.Players:FindFirstChild(_daa)then
warn("NO PLAYER FOR BAN")return false end
local cdaa=game:GetService("ReplicatedStorage")local ddaa=require(cdaa.modules)local __ba=ddaa.load("network")
__ba:invoke("{7F950F67-EB33-446A-83AE-F154B23F1CFE}",game.Players:FindFirstChild(_daa),adaa,bdaa,"manual")
if game.Players:FindFirstChild(_daa)then
local _dba=Instance.new("Hint")_dba.Text=_daa.." was banned for "..bdaa
_dba.Parent=workspace;game.Debris:AddItem(_dba,4)end;local a_ba=21;local b_ba=game:GetService("HttpService")
local function c_ba(_dba,adba,bdba,cdba)local ddba={}local __ca="-slot"..
tostring(adba)
local a_ca,b_ca=pcall(function()
local _aca=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(_dba),
"PlayerSaveTimes"..a_ba..__ca)local aaca=_aca:GetSortedAsync(false,bdba)for baca,caca in
pairs(aaca:GetCurrentPage())do
if not cdba or cdba(caca)then table.insert(ddba,caca)end end end)local c_ca={}
local d_ca=pcall(function()
if a_ca then
local _aca=game:GetService("DataStoreService"):GetDataStore(tostring(_dba),
"PlayerData"..a_ba..__ca)for aaca,baca in pairs(ddba)do local caca=_aca:GetAsync(tostring(baca))
table.insert(c_ca,caca)end end end)return d_ca,c_ca end;local d_ba,_aba=c_ba(75233545,1,1)if d_ba then print(_aba[1])end
local aaba=require(game.ReplicatedStorage.GameAssets)
for _dba,adba in pairs(game.StarterGui:GetDescendants())do
if
adba:IsA("LuaSourceContainer")then local bdba=adba.Source
for cdba,ddba in pairs(aaba)do bdba=bdba:gsub(cdba,ddba)end;adba.Source=bdba end end
local function baba(_dba,adba,bdba,cdba)
itemHoverFrame.header.itemName.Position=UDim2.new(0,18,0,3)
itemHoverFrame.header.itemName.cuteDecor.Visible=true
itemHoverFrame.header.itemName.cuteDecor.Image="rbxassetid://2528902611"
itemHoverFrame.main.thumbnailBG.Visible=true
Modules.input.setCurrentFocusFrame(script.Parent)
itemHoverFrame.main.mainContents.abilityInfo.Visible=false;itemHoverFrame.main.Visible=true;adba=adba or"pickup"
module.source=adba
if _dba==nil then script.Parent.Visible=false
script.Parent.contents.Visible=false;module.source="none"return false end
script.Parent.Size=UDim2.new(0,320 +10,0,40 +10)if not script.Parent.Visible then
script.Parent.contents.Visible=false end
itemHoverFrame.header.itemName.AutoLocalize=false
if bdba and bdba.customName then
itemHoverFrame.header.itemName.Font=Enum.Font.SourceSansItalic else
itemHoverFrame.header.itemName.Font=Enum.Font.SourceSansBold end;cleanup()
local ddba=_dba.name and
localization.translate(_dba.name,itemHoverFrame.header.itemName)
local __ca=bdba and bdba.customName or ddba or"???"local a_ca=bdba.attribute
if a_ca then local a_da=itemAttributes[a_ca]
if a_da then if a_da.color then
itemHoverFrame.main.thumbnailBG.ImageColor3=a_da.color end
if
a_da.prefix and not bdba.customName then
local b_da=localization.translate(a_da.prefix,itemHoverFrame.header.itemName)__ca=b_da.." "..__ca end end end
__ca=__ca.. (
(bdba and bdba.upgrades and bdba.upgrades>0 and" +".. (
bdba.successfulUpgrades or 0))or"")itemHoverFrame.header.itemName.Text=__ca
itemHoverFrame.main.mainContents.itemDescription.AutoLocalize=false
local b_ca=_dba.description and
localization.translate(_dba.description,itemHoverFrame.main.mainContents.itemDescription)itemHoverFrame.main.mainContents.itemDescription.Text=
b_ca or"Unknown"
itemHoverFrame.header.itemType.Text=
_dba.category and string.upper(_dba.category:sub(1,1))..
_dba.category:sub(2)or"Unknown"
local c_ca=textService:GetTextSize(itemHoverFrame.header.itemName.Text,titleTextSize,itemHoverFrame.header.itemName.Font,Vector2.new())
local d_ca=textService:GetTextSize(itemHoverFrame.main.mainContents.itemDescription.Text,itemHoverFrame.main.mainContents.itemDescription.TextSize,itemHoverFrame.main.mainContents.itemDescription.Font,Vector2.new())local _aca=0;if(bdba and bdba.soulbound)or _dba.soulbound then
itemHoverFrame.soulbound.Visible=true;_aca=_aca+24 end
if _dba.perks then
for a_da,b_da in
pairs(_dba.perks)do
if b_da then local c_da=perkLookup[a_da]
if c_da then local d_da=script.perk:Clone()
d_da.title.Text=c_da.title;d_da.description.Text=c_da.description;if c_da.color then
d_da.ImageColor3=c_da.color end;d_da.Visible=true;d_da.Parent=itemHoverFrame;_aca=_aca+
46 end end end end;if cdba and cdba.notOwned then
itemHoverFrame.notOwned.Visible=true;_aca=_aca+24 end;local aaca=1
local baca=math.ceil(d_ca.X/
itemHoverFrame.main.mainContents.itemDescription.AbsoluteSize.X)
itemHoverFrame.main.thumbnail.Image=_dba.image
itemHoverFrame.main.mainContents.equippableClasses.Visible=
_dba.category and _dba.category=="equipment"
itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible=false
if _dba.minLevel then
itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Visible=true
itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.Text=
"REQ Lvl. ".._dba.minLevel or 0
local a_da=__ba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")or 1
itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3=Color3.fromRGB(203,203,203)if _dba.minLevel>a_da then
itemHoverFrame.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3=Color3.fromRGB(203,69,71)end end;local caca=false;local daca=_dba.minimumClass or"adventurer"
daca=daca:lower()
if daca=="adventurer"then caca=true else
local a_da=__ba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilityBooks")caca=a_da[daca]~=nil end
local _bca={["hunter"]="hunter",["assassin"]="hunter",["trickster"]="hunter",["ranger"]="hunter",["mage"]="mage",["sorcerer"]="mage",["warlock"]="mage",["cleric"]="mage",["warrior"]="warrior",["paladin"]="warrior",["knight"]="warrior",["berserker"]="warrior"}local abca=_bca[daca]abca=abca or daca
for a_da,b_da in
pairs(itemHoverFrame.main.mainContents.equippableClasses:GetChildren())do
if b_da:IsA("ImageLabel")then
if abca and abca==b_da.Name then
b_da.ImageTransparency=0;b_da.Image="rbxgameasset://Images/emblem_"..daca else
b_da.ImageTransparency=0.7
b_da.Image="rbxgameasset://Images/emblem_"..b_da.Name end;if caca then b_da.ImageColor3=Color3.fromRGB(173,173,173)else
b_da.ImageColor3=Color3.fromRGB(203,69,71)end end end;for a_da,b_da in
pairs(itemHoverFrame.stats.container:GetChildren())do
if not b_da:IsA("UIListLayout")then b_da:Destroy()end end;local bbca=0
local cbca,dbca=getItemInfo(_dba,bdba)local _cca
local acca=__ba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")local bcca;for a_da,b_da in pairs(acca)do
if _dba.equipmentSlot and b_da.position and
_dba.equipmentSlot==b_da.position then bcca=b_da;break end end
if adba~=
"equipment"then if bcca then local a_da=itemLookup[bcca.id]if a_da then
_cca=getItemInfo(a_da,bcca)end end end
for a_da,b_da in pairs(cbca)do
if b_da~=0 then
local c_da=#a_da<=3 and a_da:upper()or
a_da:sub(1,1):upper()..a_da:sub(2)local d_da;local _ada=Color3.new(160,160,160)local aada=5
if a_da=="baseDamage"then
c_da="Weapon Attack"aada=1 elseif a_da=="defense"then aada=1 elseif a_da=="damageTakenMulti"then c_da="Damage Taken"aada=2
d_da=
b_da*100 .."\%"..
(dbca[a_da]and dbca[a_da]>0 and" (+"..
dbca[a_da]*100 .."\%)"or"")elseif a_da=="magicalDamage"then c_da="Magic Attack"aada=2 elseif a_da=="rangedDamage"then
c_da="Ranged Attack"aada=2 elseif a_da=="physicalDamage"then c_da="Physical Attack"aada=2 elseif a_da=="magicalDefense"then
c_da="Magic Defense"aada=2 elseif a_da=="rangedDefense"then c_da="Projectile Defense"aada=2 elseif
a_da=="physicalDefense"then c_da="Physical Defense"aada=2 elseif a_da=="maxMana"then c_da="Max MP"aada=3 elseif
a_da=="maxHealth"then c_da="Max HP"aada=3 elseif a_da=="healthRegen"then c_da="HP Recovery"aada=4
d_da=b_da.."\%".. (
dbca[a_da]and
dbca[a_da]>0 and" (+"..dbca[a_da].."\%)"or"")elseif a_da=="manaRegen"then c_da="MP Recovery"aada=4
d_da=b_da.."\%"..
(
dbca[a_da]and dbca[a_da]>0 and" (+"..dbca[a_da].."\%)"or"")elseif a_da=="criticalStrikeChance"then c_da="Critical Chance"
d_da=b_da*100 .."\%".. (
dbca[a_da]and
dbca[a_da]>0 and" (+"..dbca[a_da]*100 .."\%)"or"")aada=4 elseif a_da=="blockChance"then c_da="Block Chance"
d_da=b_da*100 .."\%".. (
dbca[a_da]and
dbca[a_da]>0 and" (+"..dbca[a_da]*100 .."\%)"or"")aada=4 elseif a_da=="greed"then c_da="Greed"aada=5
d_da=b_da*100 .."\%".. (

dbca[a_da]and dbca[a_da]>0 and" (+"..dbca[a_da]*100 .."\%)"or"")elseif a_da=="wisdom"then c_da="XP"aada=5
d_da=b_da*100 .."\%".. (

dbca[a_da]and dbca[a_da]>0 and" (+"..dbca[a_da]*100 .."\%)"or"")end;if not d_da then
d_da=(b_da..
(dbca[a_da]and
(
(dbca[a_da]>0 and" (+"..dbca[a_da]..")")or(dbca[a_da]<0 and" ("..dbca[a_da]..")"))or""))end;local bada
if
_cca and _cca[a_da]and _cca[a_da]~=0 then local dada=( (b_da-_cca[a_da])/
_cca[a_da])
if a_da=="damageTakenMulti"then dada=-dada end
if dada==dada then local _bda;local abda
if
b_da==_cca[a_da]or math.abs(dada)<=0.01 then _bda="="elseif dada>=0 then _bda="↑"abda=Color3.fromRGB(150,255,150)if dada>=1 then
_bda="↑↑↑"elseif dada>=0.25 then _bda="↑↑"end else _bda="↓"
abda=Color3.fromRGB(255,150,150)
if dada<=-0.5 then _bda="↓↓↓"elseif dada<=-0.2 then _bda="↓↓"end end;if _bda then
bada={text=_bda,textSize=20,font=Enum.Font.SourceSansBold,textColor3=abda or Color3.new(0.6,0.6,0.6),autoLocalize=false}end end end;if b_da>0 then d_da="+"..d_da end
c_da=localization.translate(c_da,itemHoverFrame.stats.container)
local cada=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text=c_da,textColor3=_ada,textSize=19,autoLocalize=false},{text=d_da,font=Enum.Font.SourceSansBold,textSize=23,textColor3=_ada,autoLocalize=false},bada})cada.LayoutOrder=aada;bbca=bbca+1
if dbca[a_da]and dbca[a_da]>0 then
if a_da==
"baseDamage"then local dada=cbca["baseDamage"]or 0.1
local _bda=dbca["baseDamage"]or 0;local abda=dada/ (dada-_bda)end end end end
if bdba and bdba.upgrades then
local a_da=(_dba.maxUpgrades or 0)+ (bdba.bonusUpgrades or 0)local b_da=a_da-bdba.upgrades;local c_da=b_da==1 and"upgrade attempt remaining"or
"upgrade attempts remaining"
local d_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text=(
tostring(b_da).." "..c_da),font=Enum.Font.SourceSans,textColor3=Color3.new(1,1,1),textTransparency=0.5,autoLocalize=true}})d_da.LayoutOrder=7;bbca=bbca+1 end;local ccca
if bdba then ccca=getTitleColorForInventorySlotData(bdba)end
ccca=ccca or _dba.nameColor or Color3.new(1,1,1)
itemHoverFrame.header.itemName.TextColor3=ccca
itemHoverFrame.header.itemName.cuteDecor.ImageColor3=ccca;local dcca=_dba.itemType;itemHoverFrame.header.itemName.cuteDecor.Image=
"rbxgameasset://Images/category_"..dcca;local _dca=
_dba.maxUpgrades or 0
itemHoverFrame.main.thumbnailBG.frame.ImageColor3=ccca
itemHoverFrame.main.thumbnailBG.shine.ImageColor3=ccca
itemHoverFrame.main.thumbnail.BorderColor3=ccca
itemHoverFrame.main.thumbnail.ImageColor3=Color3.new(1,1,1)
local adca=(bdba and bdba.customTag)or(_dba and _dba.customTag)
if adca then
local a_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{adca})a_da.LayoutOrder=9;bbca=bbca+1 end;local bdca={}
if _dba.perkData then table.insert(bdca,_dba.perkData)end
if bdba.perkData then table.insert(bdca,bdba.perkData)end
for a_da,b_da in pairs(bdca)do
local c_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text=_dba.perkData.title,font=Enum.Font.SourceSansBold,textColor3=module.tierColors[
b_da.tier or 1],textTransparency=0,autoLocalize=true}})c_da.LayoutOrder=9;bbca=bbca+1 end
if bdba and bdba.dye then
itemHoverFrame.main.thumbnail.ImageColor3=Color3.fromRGB(bdba.dye.r,bdba.dye.g,bdba.dye.b)
local a_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text="Dyed",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(bdba.dye.r,bdba.dye.g,bdba.dye.b),textTransparency=0}})a_da.LayoutOrder=10;bbca=bbca+1 end
if bdba and bdba.customStory then
local a_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text="",font=Enum.Font.SourceSans,textTransparency=1,autoLocalize=false}})a_da.LayoutOrder=11
local b_da=uiCreator.createTextFragmentLabels(itemHoverFrame.stats.container,{{text=
"\""..bdba.customStory.."\"",font=Enum.Font.Antique,textColor3=Color3.new(1,1,1),textTransparency=0.2,autoLocalize=false}})b_da.LayoutOrder=11;bbca=bbca+2 end;local cdca=c_ca.Y*aaca
itemHoverFrame.header.Size=UDim2.new(1,0,0,cdca)
itemHoverFrame.header.itemName.Size=UDim2.new(0,c_ca.X,0,c_ca.Y*aaca)
itemHoverFrame.stats.container.Size=UDim2.new(1,0,0,bbca*20)
itemHoverFrame.stats.Size=UDim2.new(1,0,0,bbca*20)itemHoverFrame.stats.Visible=bbca>0
itemHoverFrame.main.mainContents.itemDescription.Size=UDim2.new(1,0,0,
d_ca.Y*baca+10)local ddca=10
for a_da,b_da in pairs(itemHoverFrame:GetChildren())do
if
b_da:IsA("GuiObject")and b_da.Visible then ddca=ddca+b_da.AbsoluteSize.Y+
itemHoverFrame.UIListLayout.Padding.Offset end end;local __da=UDim2.new(0,320 +10,0,ddca+10)
script.Parent.Size=__da;script.Parent.contents.Visible=true;if
module.source~="pickup"and module.source~="none"then reposition()
script.Parent.Visible=true end end;local caba=21;local daba=3;local _bba=5000861;local abba
for _dba,adba in
pairs(workspace:GetDescendants())do
if
adba:IsA("MeshPart")and adba.Parent:IsA("Model")and not adba.Parent.PrimaryPart then
if
adba.MeshId=="rbxassetid://1280289624"and
string.find(adba.Parent.Name:lower(),"pine")then adba.Parent.Name="Pine"
adba.Name="Log"adba.Parent.PrimaryPart=adba elseif adba.MeshId=="rbxassetid://1280289624"and
string.find(adba.Parent.Parent.Name:lower(),"pine")and
adba.Parent.Name=="Model"then
adba.Parent.Name="Pine"adba.Name="Log"adba.Parent.PrimaryPart=adba
local bdba=adba.Parent.Parent;adba.Parent.Parent=bdba.Parent;bdba:Destroy()elseif

string.find(adba.Name:lower(),"tree")and#adba.Parent:GetChildren()<=20 then adba.Parent.Name=adba.Name;adba.Name="Log"
adba.Parent.PrimaryPart=adba elseif

adba.Name=="Rock"and adba.Parent:FindFirstChild("Leaf")and#adba.Parent:GetChildren()<=20 then adba.Parent.Name="Tree"adba.Name="Log"
adba.Parent.PrimaryPart=adba elseif adba.MeshId=="rbxassetid://1301715800"and
string.find(adba.Parent.Name:lower(),"oak")then adba.Parent.Name="Oak"
adba.Name="Log"adba.Parent.PrimaryPart=adba elseif adba.Name=="Stump"and
string.find(adba.Parent.Name:lower(),"tree")and
#adba.Parent:GetChildren()<=5 then
adba.Parent.Name="SmallPine"adba.Name="Log"adba.Parent.PrimaryPart=adba elseif

adba.MeshId=="rbxassetid://2473655248"and#adba.Parent:GetChildren()<=5 then adba.Parent.Name="BigPalm"adba.Name="Log"
adba.Parent.PrimaryPart=adba elseif adba.MeshId=="rbxassetid://2473781473"and
#adba.Parent:GetChildren()<=5 then
adba.Parent.Name="Palm"adba.Name="Log"adba.Parent.PrimaryPart=adba end end end;local function bbba(_dba)
for adba,bdba in pairs(_dba:GetCurrentPage())do return bdba.value end end
local cbba="-slot"..tostring(daba)local dbba
local _cba,acba=pcall(function()
local _dba=game:GetService("DataStoreService"):GetOrderedDataStore(tostring(_bba),
"PlayerSaveTimes"..caba..cbba)local adba=_dba:GetSortedAsync(false,1)
dbba=bbba(adba)or 0 end)if not _cba then return false,nil,"(ODS): "..acba end;local bcba,ccba
if
dbba>1 then
bcba,ccba=pcall(function()
local _dba=game:GetService("DataStoreService"):GetDataStore(tostring(_bba),
"PlayerData"..caba..cbba)abba=_dba:GetAsync(tostring(dbba))end)end
local dcba=game:GetService("HttpService"):JSONEncode(abba)print(#dcba,dcba)