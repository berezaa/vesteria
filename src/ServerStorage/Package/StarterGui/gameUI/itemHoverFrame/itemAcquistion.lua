local _aa={}
local aaa=require(game.ReplicatedStorage.modules)local baa=aaa.load("network")local caa=aaa.load("tween")
local daa=aaa.load("placeSetup")local _ba=aaa.load("utilities")
local aba=aaa.load("ability_utilities")local bba=aaa.load("enchantment")local cba=aaa.load("mapping")
local dba=require(game.ReplicatedStorage.abilityLookup)local _ca=game:GetService("UserInputService")
local aca=game:GetService("CollectionService")local bca=game:GetService("ReplicatedStorage")
local cca=bca:WaitForChild("itemData")local dca=require(cca)
local _da=require(bca:WaitForChild("perkLookup"))
local ada=require(bca:WaitForChild("itemAttributes"))local bda=game:GetService("TextService")
local cda=game:GetService("TweenService")local dda=game.Players.LocalPlayer
local __b=daa.awaitPlaceFolder("items")local a_b=script.Parent.contents;local b_b=script.Parent.Parent
script.Parent.Visible=false
local c_b=require(b_b:WaitForChild("uiCreator"))local d_b=nil;local _ab=5
local aab=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
local bab={prompt=c_b.createInteractionPrompt({promptId="pickupInteractionPrompt"},{text="Pick up"}),item=
nil}_aa.getTitleColorForInventorySlotData=function()end;local cab=20
_aa.tierColors=bba.tierColors;bab.prompt.manifest.LayoutOrder=3
bab.prompt:hide(true)
function _aa.init(dab)local _bb=dda:GetMouse()
local function abb()
local bbc=workspace.CurrentCamera.ViewportSize;local cbc,dbc
if dab.input.mode.Value=="pc"then local _cc=_bb.X+15
local acc=_bb.Y-5;if
_cc+script.Parent.AbsoluteSize.X>bbc.X then
_cc=_bb.X-15 -script.Parent.AbsoluteSize.X end
local bcc=(acc+
script.Parent.AbsoluteSize.Y)- (bbc.Y-36)if bcc>-115 then acc=acc-bcc-115 end
local ccc=UDim2.new(0,_cc,0,acc)script.Parent.Position=ccc elseif dab.input.mode.Value=="xbox"then
local _cc=game.GuiService.SelectedObject
if _cc then
local acc=_cc.AbsolutePosition.X+_cc.AbsoluteSize.X+15
if
acc+script.Parent.AbsoluteSize.X>bbc.X then acc=
_cc.AbsolutePosition.X-script.Parent.AbsoluteSize.X-15 end
local bcc=_cc.AbsolutePosition.Y+_cc.AbsoluteSize.Y/2 -
script.Parent.AbsoluteSize.Y/2
local ccc=(bcc+script.Parent.AbsoluteSize.Y)- (bbc.Y-36)if ccc>-115 then bcc=bcc-ccc-115 end
local dcc=UDim2.new(0,acc,0,bcc)script.Parent.Position=dcc end end end
game:GetService("RunService").Heartbeat:connect(abb)local bbb=dab.localization
local function cbb(bbc,cbc)
if dda.Character and dda.Character.PrimaryPart then
local dbc=workspace.CurrentCamera:ScreenPointToRay(bbc,cbc)
local _cc=Ray.new(dbc.Origin,dbc.Direction.unit*50)
local acc,bcc=workspace:FindPartOnRayWithWhitelist(_cc,{daa.awaitPlaceFolder("items")})return acc,bcc,
(acc and
_ba.magnitude(acc.Position-dda.Character.PrimaryPart.Position)or nil)end end;_aa.source="none"
local function dbb()for bbc,cbc in pairs(a_b:GetChildren())do if cbc.Name=="perk"then
cbc:Destroy()end end
a_b.main.thumbnailBG.ImageColor3=Color3.new(1,1,1)a_b.soulbound.Visible=false;a_b.enchantments.Visible=false
a_b.notOwned.Visible=false;script.Parent.UIScale.Scale=1 end
local function _cb(bbc,cbc)local dbc={}local _cc={}if bbc.baseDamage then
_cc["baseDamage"]=(_cc["baseDamage"]or 0)+bbc.baseDamage end
if bbc.attackSpeed then _cc["attackSpeed"]=(
_cc["attackSpeed"]or 0)+bbc.attackSpeed end;if bbc.modifierData then
for bcc,ccc in pairs(bbc.modifierData)do for dcc,_dc in pairs(ccc)do
_cc[dcc]=(_cc[dcc]or 0)+_dc end end end
if cbc and
cbc.modifierData then for bcc,ccc in pairs(cbc.modifierData)do
for dcc,_dc in pairs(ccc)do
dbc[dcc]=(dbc[dcc]or 0)+_dc;_cc[dcc]=(_cc[dcc]or 0)+_dc end end end
if cbc and cbc.attribute then local bcc=ada[cbc.attribute]
if bcc and bcc.modifier then
local ccc=bcc.modifier(bbc,cbc)
if ccc then for dcc,_dc in pairs(ccc)do dbc[dcc]=(dbc[dcc]or 0)+_dc;_cc[dcc]=
(_cc[dcc]or 0)+_dc end end end end;local acc=0
if cbc and cbc.enchantments then
for bcc,ccc in pairs(cbc.enchantments)do local dcc=dca[ccc.id]
local _dc=dcc.enchantments[ccc.state]
if _dc then if _dc.modifierData then
for adc,bdc in pairs(_dc.modifierData)do
dbc[adc]=(dbc[adc]or 0)+bdc;_cc[adc]=(_cc[adc]or 0)+bdc end end;if _dc.statUpgrade then acc=
acc+_dc.statUpgrade end end end end
if acc>0 and bbc.statUpgrade then
for bcc,ccc in pairs(bbc.statUpgrade)do if ccc~=0 then local dcc=ccc*acc;dbc[bcc]=(
dbc[bcc]or 0)+dcc
_cc[bcc]=(_cc[bcc]or 0)+dcc end end end;if bbc.bonusStats then
for bcc,ccc in pairs(bbc.bonusStats)do if type(ccc)=="number"then
_cc[bcc]=(_cc[bcc]or 0)+ccc end end end;return _cc,dbc end
local function acb(bbc)local cbc=dca[bbc.id]local dbc=cbc.tier;local _cc=cbc.modifierData or{}
local acc=0;local bcc,ccc=_cb(cbc,bbc)
for ddc,__d in pairs(ccc)do
local a_d=(__d<0 and __d*0.5)or __d
if ddc=="baseDamage"or ddc=="defense"then acc=acc+a_d elseif ddc=="maxMana"or ddc==
"maxHealth"then acc=acc+a_d*0.05 elseif
ddc=="str"or ddc=="dex"or ddc=="int"or ddc=="vit"then
acc=acc+a_d*0.7 elseif ddc=="stamina"then acc=acc+a_d*2 elseif ddc=="jump"or ddc=="walkspeed"then acc=acc+
a_d elseif
ddc=="criticalStrikeChance"or ddc=="blockChance"then acc=acc+a_d*50 end end;local dcc=(cbc.maxUpgrades or 0)local _dc=dcc/7;local adc
if dcc>0 and
not cbc.notUpgradable then
if acc>=49 *_dc then adc=6 elseif acc>=32 *_dc then adc=5 elseif acc>=21 *_dc then adc=4 elseif acc>=
10 *_dc then adc=3 elseif acc<0 then adc=-1 elseif bbc and bbc.upgrades and bbc.upgrades>0 then
if
bbc.successfulUpgrades and bbc.successfulUpgrades>0 then adc=2 else adc=-1 end end end;local bdc=dbc
if adc then if dbc==nil or adc>dbc then bdc=adc end end;local cdc=bdc and _aa.tierColors[bdc]return cdc,bdc end;_aa.getTitleColorForInventorySlotData=acb
local function bcb(bbc)local cbc=dca[bbc.id]
local dbc=cbc.tier or 1;local _cc=bbc.maxUpgrades or cbc.maxUpgrades;local acc=0;local bcc=
bbc and bbc.upgrades or 0;local ccc=bbc.enchantments or{}
if bcc>0 then
local _dc=0
for adc,bdc in pairs(ccc)do
local cdc=dca[bdc.id].enchantments[bdc.state]local ddc=cdc.tier;if ddc then _dc=_dc+ddc end end;acc=1 +0.01 +_dc/_cc end
local dcc=( (acc>dbc or acc==-1)and math.floor(acc))or dbc;if acc>1 and dcc<2 then dcc=2 end;if dcc~=1 then
local _dc=_aa.tierColors[dcc]return _dc end end;local ccb
local function dcb(bbc)if
a_b.Parent.Visible and a_b.Visible and a_b.main.Visible and a_b.main.thumbnail.Visible then
return false end
a_b.header.itemName.Position=UDim2.new(0,0,0,3)a_b.header.itemName.cuteDecor.Visible=false
if bbc==
nil or bbc.text==nil then if
bbc.source==nil or bbc.source==ccb.source then script.Parent.Visible=false
script.Parent.contents.Visible=false end;return false end;script.Parent.Size=UDim2.new(0,320 +4,0,100)
script.Parent.contents.Visible=false;ccb=bbc
dab.input.setCurrentFocusFrame(script.Parent)dbb()_aa.source="text"a_b.main.Visible=false
a_b.stats.Visible=false
local cbc=bbc.text and bbb.translate(bbc.text,a_b.header.itemName)a_b.header.itemName.Text=cbc or"???"a_b.header.itemName.TextColor3=
bbc.textColor3 or Color3.new(1,1,1)a_b.header.itemName.Font=
bbc.font or Enum.Font.SourceSansBold
local dbc=bda:GetTextSize(a_b.header.itemName.Text,cab,a_b.header.itemName.Font,Vector2.new())local _cc=dbc;local acc=0;for _dc,adc in
pairs(a_b.stats.container:GetChildren())do
if not adc:IsA("UIListLayout")then adc:Destroy()end end
if bbc.additionalLines then
for _dc,adc in
pairs(bbc.additionalLines)do
c_b.createTextFragmentLabels(a_b.stats.container,{adc})
local bdc=bda:GetTextSize(adc.text or"???",adc.textSize or 20,adc.font or Enum.Font.SourceSansBold,Vector2.new())if bdc.X>_cc.X then
_cc=Vector2.new(math.min(320 +10,bdc.X),bdc.Y)end
local cdc=math.ceil(bdc.X/ (320 +10))acc=acc+cdc end end
a_b.stats.container.Size=UDim2.new(1,0,0,acc*20)a_b.stats.Size=UDim2.new(1,0,0,acc*20)
a_b.stats.Visible=acc>0;local bcc=0
for _dc,adc in pairs(a_b:GetChildren())do if
adc:IsA("GuiObject")and adc.Visible then
bcc=bcc+adc.AbsoluteSize.Y+a_b.UIListLayout.Padding.Offset end end;local ccc=20 +_cc.X;local dcc=UDim2.new(0,ccc+4,0,bcc+4)
script.Parent.Size=dcc
a_b.header.itemName.Size=UDim2.new(0,dbc.X,0,18)a_b.header.itemName.stars.Visible=false
script.Parent.UIScale.Scale=dab.input.menuScale;abb()script.Parent.Visible=true
script.Parent.contents.Visible=true end
baa:create("{8E50CEB3-90F4-484F-8841-721129149A17}","BindableFunction","OnInvoke",dcb)
local function _db(bbc,cbc,dbc,_cc)local acc=dbc or bbc;local bcc=_cc or cbc
a_b.header.itemName.Position=UDim2.new(0,18,0,3)a_b.header.itemName.cuteDecor.Visible=true
a_b.header.itemName.cuteDecor.Image="rbxassetid://2528902611"if bbc==nil then script.Parent.Visible=false
script.Parent.contents.Visible=false;return false end;script.Parent.Size=UDim2.new(0,
320 +4,0,40 +4)
script.Parent.contents.Visible=false
dab.input.setCurrentFocusFrame(script.Parent)a_b.main.thumbnailBG.Visible=false
a_b.header.itemName.AutoLocalize=false;a_b.main.Visible=true
a_b.main.thumbnail.Image=acc.image;local ccc=
acc.name and bbb.translate(acc.name,a_b.header.itemName)or"???"
local dcc="("..
bbb.translate("Unlearned",a_b.header.itemName)..")"a_b.header.itemName.Text=ccc..
" ".. ( (bcc>1 and"+".. (bcc-1))or
(bcc==0 and dcc)or"")
dbb()_aa.source="ability"local _dc=(cbc>0 and cbc)or 1;local adc;if bbc.statistics then
adc=aba.getAbilityStatisticsForRank(bbc,_dc)end;local bdc=-1
if bcc>0 then bdc=1;if bcc>1 then bdc=2 end end;local cdc;if dbc and _cc then
cdc=aba.getAbilityStatisticsForRank(dbc,_cc)end;if bcc~=0 and adc and adc.tier and
adc.tier>bdc then bdc=adc.tier end
if bcc~=0 and
cdc and cdc.tier and cdc.tier>bdc then bdc=cdc.tier end;local ddc=_aa.tierColors[bdc]
local __d=acc.description and
bbb.translate(acc.description,a_b.main.mainContents.itemDescription)
a_b.main.mainContents.itemDescription.Text=__d or"???"
a_b.main.mainContents.equippableClasses.Visible=false
a_b.main.mainContents.abilityInfo.Visible=false
for dad,_bd in pairs(a_b.stats.container:GetChildren())do if not
_bd:IsA("UIListLayout")then _bd:Destroy()end end;local a_d=0
if bbc.statistics then if cdc then
for dad,_bd in pairs(cdc)do if not adc[dad]then adc[dad]=0 end end end
for dad,_bd in pairs(adc)do
if
dad~="tier"and
string.sub(dad,1,1)~="_"and not( (dad=="manaCost"or dad=="cost")and
_bd==0)then local abd=dad;local bbd;local cbd=""local dbd=Color3.fromRGB(255,255,255)local _cd=5
local acd=":"
if dad=="damageMultiplier"then abd="Power"
bbd=function(_dd)return _dd*100 end;_cd=1 elseif dad=="healing"then _cd=2 elseif dad=="walkspeed"then abd="Movement Speed"acd=" +"elseif
dad=="staminaRecovery"then abd="Stamina Recovery"
bbd=function(_dd)return _dd*100 .."\%"end;acd=" +"elseif dad=="manaRestored"then abd="MP Restored"elseif dad=="cooldown"then
bbd=function(_dd)return _dd.."s"end;dbd=Color3.fromRGB(160,160,160)_cd=6 elseif dad=="range"then bbd=function(_dd)
return _dd.."m"end;_cd=3 elseif
dad=="cost"or dad=="manaCost"then abd="MP"dbd=Color3.fromRGB(0,152,255)_cd=7 elseif dad=="healthCost"then
abd="HP"dbd=Color3.fromRGB(226,34,40)_cd=7 end
abd=string.upper(string.sub(abd,1,1))..string.sub(abd,2)local bcd
if cdc and(cdc[dad]==nil or cdc[dad]~=_bd)then local _dd=
cdc[dad]or 0;local add=bbd and bbd(_dd)or _dd
bcd={text="→ "..add,textColor3=Color3.fromRGB(220,181,25),font=Enum.Font.SourceSansBold,textSize=23}end;local ccd=bbd and bbd(_bd)or _bd
local dcd=c_b.createTextFragmentLabels(a_b.stats.container,{{text=
abd..acd,textColor3=dbd,textSize=19},{text=tostring(ccd),font=Enum.Font.SourceSansBold,textColor3=dbd,textSize=23},bcd})a_d=a_d+1;dcd.LayoutOrder=_cd end end end
local b_d=bda:GetTextSize(a_b.header.itemName.Text,cab,a_b.header.itemName.Font,Vector2.new())
local c_d=bda:GetTextSize(a_b.main.mainContents.itemDescription.Text,a_b.main.mainContents.itemDescription.TextSize,a_b.main.mainContents.itemDescription.Font,Vector2.new())local d_d=1
local _ad=math.ceil(c_d.X/
a_b.main.mainContents.itemDescription.AbsoluteSize.X)local aad=b_d.Y*d_d;a_b.header.Size=UDim2.new(1,0,0,aad)a_b.header.itemName.Size=UDim2.new(0,b_d.X,0,
b_d.Y*d_d)
a_b.header.itemName.stars.Visible=false
a_b.stats.container.Size=UDim2.new(1,0,0,a_d*19)a_b.stats.Size=UDim2.new(1,0,0,a_d*19)
a_b.stats.Visible=a_d>0
a_b.main.mainContents.itemDescription.Size=UDim2.new(1,0,0,c_d.Y*_ad+10)local bad=16
for dad,_bd in pairs(a_b:GetChildren())do if
_bd:IsA("GuiObject")and _bd.Visible then
bad=bad+_bd.AbsoluteSize.Y+a_b.UIListLayout.Padding.Offset end end;local cad=UDim2.new(0,320 +4,0,bad+4)
script.Parent.Size=cad;a_b.header.itemName.TextColor3=ddc
a_b.header.itemName.cuteDecor.ImageColor3=ddc;a_b.main.thumbnail.BorderColor3=ddc
script.Parent.UIScale.Scale=dab.input.menuScale;abb()script.Parent.Visible=true
script.Parent.UIScale.Scale=dab.input.menuScale;script.Parent.contents.Visible=true end
baa:create("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}","BindableFunction","OnInvoke",_db)
local function adb(bbc,cbc,dbc,_cc)a_b.header.itemName.Position=UDim2.new(0,18,0,3)
a_b.header.itemName.cuteDecor.Visible=true
a_b.header.itemName.cuteDecor.Image="rbxassetid://2528902611"a_b.main.thumbnailBG.Visible=true
dab.input.setCurrentFocusFrame(script.Parent)
a_b.main.mainContents.abilityInfo.Visible=false;a_b.main.Visible=true;cbc=cbc or"pickup"_aa.source=cbc;if bbc==nil then
script.Parent.Visible=false;script.Parent.contents.Visible=false;_aa.source="none"return
false end;script.Parent.Size=UDim2.new(0,
320 +4,0,40 +4)
if
not script.Parent.Visible then script.Parent.contents.Visible=false end;a_b.header.itemName.AutoLocalize=false
if dbc and dbc.customName then
a_b.header.itemName.Font=Enum.Font.SourceSansItalic else a_b.header.itemName.Font=Enum.Font.SourceSansBold end;dbb()
local acc=bbc.name and bbb.translate(bbc.name,a_b.header.itemName)
local bcc=dbc and dbc.customName or acc or"???"local ccc=dbc.attribute
if ccc then local ccd=ada[ccc]
if ccd then if ccd.color then
a_b.main.thumbnailBG.ImageColor3=ccd.color end
if ccd.prefix and not dbc.customName then
local dcd=bbb.translate(ccd.prefix,a_b.header.itemName)bcc=dcd.." "..bcc end end end
bcc=bcc..
( (dbc and dbc.upgrades and dbc.upgrades>0 and" +"..
(dbc.successfulUpgrades or 0))or"")a_b.header.itemName.Text=bcc
a_b.main.mainContents.itemDescription.AutoLocalize=false
local dcc=bbc.description and
bbb.translate(bbc.description,a_b.main.mainContents.itemDescription)
a_b.main.mainContents.itemDescription.Text=dcc or"Unknown"
a_b.header.itemType.Text=
bbc.category and
string.upper(bbc.category:sub(1,1))..bbc.category:sub(2)or"Unknown"
local _dc=bda:GetTextSize(a_b.header.itemName.Text,cab,a_b.header.itemName.Font,Vector2.new())
local adc=bda:GetTextSize(a_b.main.mainContents.itemDescription.Text,a_b.main.mainContents.itemDescription.TextSize,a_b.main.mainContents.itemDescription.Font,Vector2.new())local bdc=0;if(dbc and dbc.soulbound)or bbc.soulbound then
a_b.soulbound.Visible=true;bdc=bdc+24 end
if bbc.perks then
for ccd,dcd in
pairs(bbc.perks)do
if dcd then local _dd=_da[ccd]
if _dd then local add=script.perk:Clone()
add.title.Text=_dd.title;add.description.Text=_dd.description;if _dd.color then
add.ImageColor3=_dd.color end;add.Visible=true;add.Parent=a_b;bdc=bdc+46 end end end end
if _cc and _cc.notOwned then a_b.notOwned.Visible=true;bdc=bdc+24 end;local cdc=1
local ddc=math.ceil(adc.X/
a_b.main.mainContents.itemDescription.AbsoluteSize.X)a_b.main.thumbnail.Image=bbc.image
a_b.main.mainContents.equippableClasses.Visible=
bbc.category and bbc.category=="equipment"
a_b.main.mainContents.equippableClasses.requirements.reqLevel.Visible=false
if bbc.minLevel then
a_b.main.mainContents.equippableClasses.requirements.reqLevel.Visible=true
a_b.main.mainContents.equippableClasses.requirements.reqLevel.Text=
"REQ Lvl. "..bbc.minLevel or 0
local ccd=baa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")or 1
a_b.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3=Color3.fromRGB(203,203,203)if bbc.minLevel>ccd then
a_b.main.mainContents.equippableClasses.requirements.reqLevel.TextColor3=Color3.fromRGB(203,69,71)end end;local __d=false;local a_d=bbc.minimumClass or"adventurer"
a_d=a_d:lower()
if a_d=="adventurer"then __d=true elseif
baa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","class"):lower()==a_d then __d=true else
local ccd=baa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilityBooks")__d=ccd[a_d]~=nil end
local b_d={["hunter"]="hunter",["assassin"]="hunter",["trickster"]="hunter",["ranger"]="hunter",["mage"]="mage",["sorcerer"]="mage",["warlock"]="mage",["cleric"]="mage",["warrior"]="warrior",["paladin"]="warrior",["knight"]="warrior",["berserker"]="warrior"}local c_d=b_d[a_d]c_d=c_d or a_d
for ccd,dcd in
pairs(a_b.main.mainContents.equippableClasses:GetChildren())do
if dcd:IsA("ImageLabel")then
if c_d and c_d==dcd.Name then dcd.ImageTransparency=0;dcd.Image=
"rbxgameasset://Images/emblem_"..a_d else dcd.ImageTransparency=0.7;dcd.Image=
"rbxgameasset://Images/emblem_"..dcd.Name end;if __d then dcd.ImageColor3=Color3.fromRGB(173,173,173)else
dcd.ImageColor3=Color3.fromRGB(203,69,71)end end end
for ccd,dcd in pairs(a_b.stats.container:GetChildren())do if not
dcd:IsA("UIListLayout")then dcd:Destroy()end end;local d_d=0;local _ad,aad=_cb(bbc,dbc)local bad
local cad=baa:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")local dad;for ccd,dcd in pairs(cad)do
if bbc.equipmentSlot and dcd.position and
bbc.equipmentSlot==dcd.position then dad=dcd;break end end;if
cbc~="equipment"then
if dad then local ccd=dca[dad.id]if ccd then bad=_cb(ccd,dad)end end end
for ccd,dcd in pairs(_ad)do
if dcd~=0 then
local _dd=#ccd<=3 and
ccd:upper()or ccd:sub(1,1):upper()..ccd:sub(2)local add;local bdd=Color3.new(160,160,160)local cdd=5;local ddd=24
if ccd=="baseDamage"then
_dd="Weapon Attack"cdd=1 elseif ccd=="defense"then cdd=1 elseif ccd=="damageTakenMulti"then _dd="Damage Taken"cdd=3
add=dcd*100 ..
"\%".. (
aad[ccd]and aad[ccd]>0 and" (+"..aad[ccd]*100 .."\%)"or"")elseif ccd=="damageGivenMulti"then _dd="Damage Given"cdd=3
add=dcd*100 .."\%"..
(
aad[ccd]and aad[ccd]>0 and" (+"..aad[ccd]*100 .."\%)"or"")elseif ccd=="magicalDamage"then _dd="Magic Attack"cdd=3 elseif ccd=="rangedDamage"then
_dd="Ranged Attack"cdd=3 elseif ccd=="physicalDamage"then _dd="Physical Attack"cdd=3 elseif ccd=="magicalDefense"then
_dd="Magic Defense"cdd=3 elseif ccd=="rangedDefense"then _dd="Projectile Defense"cdd=3 elseif ccd=="physicalDefense"then
_dd="Physical Defense"cdd=3 elseif ccd=="maxMana"then _dd="Max MP"cdd=4 elseif ccd=="maxHealth"then _dd="Max HP"cdd=4 elseif
ccd=="healthRegen"then _dd="HP Recovery"cdd=5;add=dcd..
"\%".. (aad[ccd]and aad[ccd]>0 and" (+"..
aad[ccd].."\%)"or"")elseif ccd==
"manaRegen"then _dd="MP Recovery"cdd=5;add=dcd..
"\%".. (aad[ccd]and aad[ccd]>0 and" (+"..aad[ccd]..
"\%)"or"")elseif ccd==
"criticalStrikeChance"then _dd="Critical Hits"
add=dcd*100 .."\%"..
(aad[ccd]and aad[ccd]>0 and
" (+"..aad[ccd]*100 .."\%)"or"")cdd=5 elseif ccd=="blockChance"then _dd="Block Chance"
add=dcd*100 .."\%"..
(
aad[ccd]and aad[ccd]>0 and" (+"..aad[ccd]*100 .."\%)"or"")cdd=5 elseif ccd=="greed"then _dd="Greed"cdd=6
add=dcd*100 .."\%"..
(aad[ccd]and aad[ccd]>0 and" (+"..
aad[ccd]*100 .."\%)"or"")elseif ccd=="wisdom"then _dd="XP"cdd=6
add=dcd*100 .."\%"..
(aad[ccd]and aad[ccd]>0 and" (+"..aad[ccd]*
100 .."\%)"or"")elseif ccd:find("_totalMultiplicative")then
_dd=ccd:gsub("_totalMultiplicative","")
_dd=_dd:sub(1,1):upper().._dd:sub(2)cdd=7;add=(dcd*100).."\%"elseif ccd=="attackSpeed"then _dd="Attack Speed"cdd=10
ddd=19;add=
({"Very slow","Slow","Normal","Fast","Very fast"})[dcd]or dcd end;local ___a={["Walkspeed"]="Movement Speed"}
_dd=___a[_dd]or _dd;if not add then
add=(dcd..
(aad[ccd]and
( (aad[ccd]>0 and" (+"..aad[ccd]..")")or(
aad[ccd]<0 and" ("..aad[ccd]..")"))or""))end;local a__a
if bad and
bad[ccd]and bad[ccd]~=0 then
local c__a=( (dcd-bad[ccd])/bad[ccd])if ccd=="damageTakenMulti"then c__a=-c__a end
if c__a==c__a then local d__a;local _a_a
if
dcd==bad[ccd]or math.abs(c__a)<=0.01 then elseif c__a>=0 then d__a="↑"
_a_a=Color3.fromRGB(150,255,150)else d__a="↓"_a_a=Color3.fromRGB(255,150,150)end;if d__a then
a__a={text=d__a,textSize=20,font=Enum.Font.SourceSansBold,textColor3=_a_a or Color3.new(0.6,0.6,0.6),autoLocalize=false}end end end;if dcd>0 then add=add end
_dd=bbb.translate(_dd,a_b.stats.container)..": "
local b__a=c_b.createTextFragmentLabels(a_b.stats.container,{{text=_dd,textColor3=bdd,textSize=19,autoLocalize=false},{text=add,font=Enum.Font.SourceSansBold,textSize=ddd,textColor3=bdd,autoLocalize=false},a__a})b__a.LayoutOrder=cdd;d_d=d_d+1
if aad[ccd]and aad[ccd]>0 then
if
ccd=="baseDamage"then local c__a=_ad["baseDamage"]or 0.1
local d__a=aad["baseDamage"]or 0;local _a_a=c__a/ (c__a-d__a)end end end end
if dbc and dbc.upgrades then
local ccd=(bbc.maxUpgrades or 0)+ (dbc.bonusUpgrades or 0)local dcd=ccd-dbc.upgrades;local _dd=dcd==1 and"upgrade attempt remaining"or
"upgrade attempts remaining"
local add=c_b.createTextFragmentLabels(a_b.stats.container,{{text=(
tostring(dcd).." ".._dd),font=Enum.Font.SourceSans,textColor3=Color3.new(1,1,1),textTransparency=0.5,autoLocalize=true}})add.LayoutOrder=7;d_d=d_d+1 end;local _bd;if dbc then _bd=acb(dbc)end
_bd=_bd or bbc.nameColor or Color3.new(1,1,1)a_b.header.itemName.TextColor3=_bd
a_b.header.itemName.cuteDecor.ImageColor3=_bd;local abd=bbc.itemType;a_b.header.itemName.cuteDecor.Image=
"rbxgameasset://Images/category_"..abd
local bbd=bbc.maxUpgrades or 0;a_b.main.thumbnailBG.frame.ImageColor3=_bd
a_b.main.thumbnailBG.shine.ImageColor3=_bd;a_b.main.thumbnail.BorderColor3=_bd
a_b.main.thumbnail.ImageColor3=Color3.new(1,1,1)
local cbd=(dbc and dbc.customTag)or(bbc and bbc.customTag)
if cbd then
local ccd=c_b.createTextFragmentLabels(a_b.stats.container,cbd)ccd.LayoutOrder=12;d_d=d_d+1 end;local dbd={}
if bbc.perkData then table.insert(dbd,bbc.perkData)end
if dbc.perkData then table.insert(dbd,dbc.perkData)end
for ccd,dcd in pairs(dbd)do
local _dd=c_b.createTextFragmentLabels(a_b.stats.container,{{text=bbc.perkData.title,font=Enum.Font.SourceSansBold,textColor3=_aa.tierColors[
dcd.tier or 1],textTransparency=0,autoLocalize=true}})_dd.LayoutOrder=9;d_d=d_d+1 end
if dbc and dbc.dye then
a_b.main.thumbnail.ImageColor3=Color3.fromRGB(dbc.dye.r,dbc.dye.g,dbc.dye.b)
local ccd=c_b.createTextFragmentLabels(a_b.stats.container,{{text="Dyed",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(dbc.dye.r,dbc.dye.g,dbc.dye.b),textTransparency=0}})ccd.LayoutOrder=10;d_d=d_d+1 end
if dbc and dbc.customStory then
local ccd=c_b.createTextFragmentLabels(a_b.stats.container,{{text="",font=Enum.Font.SourceSans,textTransparency=1,autoLocalize=false}})ccd.LayoutOrder=11
local dcd=c_b.createTextFragmentLabels(a_b.stats.container,{{text="\""..dbc.customStory.."\"",font=Enum.Font.Antique,textColor3=Color3.new(1,1,1),textTransparency=0.2,autoLocalize=false}})dcd.LayoutOrder=11;d_d=d_d+2 end;local _cd=_dc.Y*cdc;a_b.header.Size=UDim2.new(1,0,0,_cd)a_b.header.itemName.Size=UDim2.new(0,_dc.X,0,
_dc.Y*cdc)a_b.stats.container.Size=UDim2.new(1,0,0,
d_d*20)
a_b.stats.Size=UDim2.new(1,0,0,d_d*20)a_b.stats.Visible=d_d>0;a_b.main.mainContents.itemDescription.Size=UDim2.new(1,0,0,
adc.Y*ddc+10)local acd=10
for ccd,dcd in
pairs(a_b:GetChildren())do if dcd:IsA("GuiObject")and dcd.Visible then
acd=
acd+dcd.AbsoluteSize.Y+a_b.UIListLayout.Padding.Offset end end;local bcd=UDim2.new(0,320 +4,0,acd+4)
script.Parent.Size=bcd;script.Parent.contents.Visible=true
if
_aa.source~="pickup"and _aa.source~="none"then
script.Parent.UIScale.Scale=dab.input.menuScale;abb()script.Parent.Visible=true end end
baa:create("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}","BindableFunction","OnInvoke",adb)
local function bdb(bbc)local cbc=cca:FindFirstChild(bbc.Name)if cbc then local dbc=require(cbc)
dbc.physItemName=bbc.Name;return dbc end end
local function cdb()
if dda.Character and dda.Character.PrimaryPart then local bbc,cbc=nil,_ab
for dbc,_cc in
pairs(__b:GetChildren())do
local acc=_ba.magnitude(dda.Character.PrimaryPart.Position-_cc.Position)
if(not bbc and acc<=cbc)or(bbc and acc<cbc)then if
_ba.playerCanPickUpItem(dda,_cc)then bbc=_cc;cbc=acc end end end;return bbc,cbc end end
local function ddb(bbc)
if bbc.UserInputType==Enum.UserInputType.MouseMovement then
local cbc,dbc,_cc=cbb(bbc.Position.X,bbc.Position.Y)
if cbc then
local acc=(cbc.Parent==__b and cbc)or
(cbc.Parent.Parent==__b and cbc.Parent)or(
cbc.Parent.Parent.Parent==__b and cbc.Parent.Parent)local bcc=bdb(acc)local ccc=_ba.playerCanPickUpItem(dda,acc)
local dcc={}if not ccc then dcc.notOwned=true end
if bcc then
if not d_b or d_b.item~=acc then
if
acc:FindFirstChild("metadata")and acc.metadata.Value~=""then
local _dc,adc=adb(bcc,"pickup",game:GetService("HttpService"):JSONDecode(acc.metadata.Value),dcc)else local _dc,adc=adb(bcc,"pickup",nil,dcc)end end
if not script.Parent.Visible then _aa.source="pickup"
script.Parent.UIScale.Scale=dab.input.menuScale;abb()script.Parent.Visible=true end else if script.Parent.Visible and _aa.source=="pickup"then
script.Parent.Visible=false end end else d_b=nil;if script.Parent.Visible and _aa.source=="pickup"then
script.Parent.Visible=false end end end end;local __c;local function a_c(bbc,cbc)local dbc=0;local _cc=1;bbc=bbc/cbc
return-_cc*bbc* (bbc-2)+dbc end
local b_c=game:GetService("RunService")
local function c_c(bbc)local cbc=bbc.CFrame;local dbc=tick()local _cc=0.5
while tick()-dbc<=_cc do
b_c.Heartbeat:wait()
if bbc then
if game.Players.LocalPlayer.Character and
game.Players.LocalPlayer.Character.PrimaryPart then
bbc.CFrame=cbc:lerp(game.Players.LocalPlayer.Character.PrimaryPart.CFrame,a_c(
tick()-dbc,_cc))else break end end end end
local function d_c(bbc,cbc,dbc,_cc,acc)local bcc=dca[bbc.id]
if cbc then
if bcc.id==1 then c_b.showCurrency(dbc)elseif bcc.autoConsume and
acc then
local dcc=c_b.createInteractionPrompt(nil,{text=acc,textColor3=Color3.fromRGB(70,70,70)})
dcc:setBackgroundColor3(Color3.fromRGB(190,190,190))dcc:setExpireTime(5)if bcc.useSound then
_ba.playSound(bcc.useSound)end else c_b.showItemPickup(bcc,dbc,bbc)end;local ccc=game.Players.LocalPlayer.Character
if __c and ccc and
ccc.PrimaryPart and not _cc then local dcc=__c:Clone()
__c:Destroy()__c=nil;dcc.Parent=workspace.CurrentCamera;dcc.Anchored=true
dcc.CanCollide=false;local _dc
if game.ReplicatedStorage:FindFirstChild("sounds")then
if dcc.Name==
"monster idol"and
game.ReplicatedStorage.sounds:FindFirstChild("idolPickup")then
_dc=_ba.playSound("idolPickup",dcc)elseif
dcc:FindFirstChild("Legendary")and dcc.Legendary.Enabled and
game.ReplicatedStorage.sounds:FindFirstChild("legendaryItemPickup")then
_dc=_ba.playSound("legendaryItemPickup",dcc)elseif dcc:FindFirstChild("Rare")and dcc.Rare.Enabled and
game.ReplicatedStorage.sounds:FindFirstChild("rareItemPickup")then
_dc=_ba.playSound("rareItemPickup",dcc)elseif
game.ReplicatedStorage.sounds:FindFirstChild("pickup")then _dc=_ba.playSound("pickup",dcc)end end;if dcc:IsA("BasePart")then dcc.CanCollide=false end
for adc,bdc in
pairs(dcc:GetDescendants())do if bdc:IsA("BasePart")then bdc.CanCollide=false end end;c_c(dcc)if _dc then
pcall(function()_dc.Parent=workspace.CurrentCamera
game.Debris:AddItem(_dc,2)end)end;dcc:Destroy()end else
if acc=="full-inventory"then
baa:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text="Your inventory is full for this item's category."})warn("inventory full?")end end end
local function _ac(bbc,cbc)
if cbc and cbc>0 then table.insert(bbc,{id=1,value=cbc})end
for dbc,_cc in pairs(bbc)do local acc=dca[_cc.id or _cc.id]
if acc then
d_c(_cc,true,(_cc.value or _cc.stacks),true)
if(acc.rarity and acc.rarity=="Legendary")then
if
game.ReplicatedStorage.sounds:FindFirstChild("legendaryItemPickup")then _ba.playSound("legendaryItemPickup")end elseif(acc.rarity and acc.rarity=="Rare")or(acc.category and
acc.category=="equipment")then
if
game.ReplicatedStorage.sounds:FindFirstChild("rareItemPickup")then _ba.playSound("rareItemPickup")end end end end end
baa:create("{0E75A1BF-C1A5-4731-8782-314C09378114}","BindableFunction","OnInvoke",_ac)
baa:connect("{2ABFAB8F-ADB5-403F-B04E-FBFAD43EE8D4}","OnClientEvent",_ac)local aac={}
local function bac(bbc)
if bbc=="pickup"and bab.item then __c=bab.item
local cbc,dbc=baa:invokeServer("{F74B377B-619C-4700-BB20-F930BA740C50}",bab.item)if not cbc then
baa:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{id=bab.item,text="Pick-up failed: "..dbc})end;bab.item=nil end end;local cac=false;local dac;local function _bc(bbc)dac=bbc
if dac and
dac.UserInputState==Enum.UserInputState.Begin then cac=true;bac("pickup")else cac=false end end
_aa.pickupInputGained=_bc
baa:invoke("{7AE42210-0ED8-4379-800E-3C54632521A1}","pick up",_bc,"F")
local function abc()_ca.InputChanged:connect(ddb)
baa:connect("{00C8A0C1-B9BF-4E80-BA56-5A4370445636}","OnClientEvent",d_c)
while wait(1 /15)do if
dac and dac.UserInputState==Enum.UserInputState.Begin then cac=true else cac=false end
local bbc=dab.input.actions["pick up"]local cbc=bbc and bbc.bindedTo or"F"_aa.closestItem=cdb()
if not
d_b then
if _aa.closestItem then
if bab.item~=_aa.closestItem then
if
not bab.itemBaseData or
bab.itemBaseData.physItemName~=_aa.closestItem.Name then local dbc=bdb(_aa.closestItem)
if dbc then bab.itemBaseData=dbc end end;bab.item=_aa.closestItem
bab.prompt:updateTextFragments(false,{text="Pick up"},{text=bab.itemBaseData and
bab.itemBaseData.name or _aa.closestItem.Name,textColor3=Color3.fromRGB(143,120,255)})if cac and bab.item then bac("pickup")end end else if not bab.prompt.isHiding then bab.prompt:hide()bab.item=nil;bab.itemBaseData=
nil end end else
if bab.item~=d_b.item then bab.item=d_b.item;bab.itemBaseData=d_b.itemBaseData
bab.prompt:updateTextFragments(false,{text="Pick up"},{text=
bab.itemBaseData and bab.itemBaseData.name or _aa.closestItem.Name,textColor3=Color3.fromRGB(143,120,255)})if cac and bab.item then bac("pickup")end end end end end;spawn(abc)end;return _aa