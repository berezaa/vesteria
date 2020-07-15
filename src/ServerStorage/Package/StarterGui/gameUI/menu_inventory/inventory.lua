local cd={}local dd=game:GetService("ReplicatedStorage")
local __a=require(dd:WaitForChild("itemData"))
local a_a=require(dd:WaitForChild("itemAttributes"))
local b_a=require(game.ReplicatedStorage:WaitForChild("abilityLookup"))local c_a=game.Players.LocalPlayer;local d_a=script.Parent.header
local _aa=d_a.sorts;local aaa=script.Parent.content;local baa=script.Parent.Parent
local caa=baa.scrollingMask;local daa=game:GetService("TweenService")local _ba="equipment"
local aba=nil;local bba={}local cba={}local dba={}local _ca=false;cd.isEnchantingEquipment=false
script.Parent.scrollPrompt.Visible=false;local aca=nil;local bca;local cca;function cd.show()
script.Parent.Visible=not script.Parent.Visible end;function cd.hide()
script.Parent.Visible=false end
script.Parent.close.Activated:connect(cd.hide)
local dca=require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))
function cd.init(_da)local ada=baa.menu_trade;local bda=baa.menu_enchant;local cda=baa.menu_shop
local dda=baa.menu_storage;local __b=baa.menu_equipment;local a_b=_da.network;local b_b=_da.utilities
local c_b=_da.uiCreator;local d_b=_da.tween;local _ab=_da.enchantment;local aab=_da.localization
local bab=_da.mapping
a_b:create("{3027D9DD-C67B-4B3C-B2BB-947EAD001371}","BindableEvent")function cd.setIsEnchantingEquipment(abc,bbc)cd.isEnchantingEquipment=abc
a_b:fire("{3027D9DD-C67B-4B3C-B2BB-947EAD001371}",abc,bbc)end
local function cab(abc)local bbc=
(abc^ (1 /3))/3.5
for i=1,abc do
spawn(function()
wait(bbc*math.random())
local cbc=script.Parent.currency.ethyr.icon:Clone()cbc.Name="iconClone"
cbc.Parent=script.Parent.currency.ethyr;cbc.ImageTransparency=0;local dbc=math.random(-10,10)
local _cc=math.random(-10,10)cbc.Position=UDim2.new(0.5,dbc,0.5,_cc)cbc.Visible=true;local acc=
math.random(60,110)/100
d_b(cbc,{"ImageTransparency","Position"},{1,UDim2.new(0.5,dbc+math.random(
-100,100)*bbc,0.5,_cc+
math.random(-100,100)*bbc)},acc)game.Debris:AddItem(cbc,acc+0.1)end)end end
game.MarketplaceService.PromptProductPurchaseFinished:Connect(function(abc,bbc,cbc)
if abc==
game.Players.LocalPlayer.userId and cbc then local dbc;local _cc
if bbc==509934399 then
_cc="ethyr1"dbc=7 elseif bbc==509935760 then _cc="ethyr2"dbc=14 elseif bbc==509935018 then _cc="ethyr3"dbc=26 elseif
bbc==539152241 then _cc="ethyr4"dbc=46 end;if _cc then b_b.playSound(_cc)end end end)
local dab={costType="ethyr",icon="rbxassetid://31886504632",textColor=Color3.fromRGB(115,255,251)}
local _bb=a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","globalData")
script.Parent.currency.ethyr.Visible=false
if _bb then
_da.money.setLabelAmount(script.Parent.currency.ethyr.amount,
_bb.ethyr or 0,dab)
script.Parent.currency.ethyr.Size=UDim2.new(0,
script.Parent.currency.ethyr.amount.amount.AbsoluteSize.X+95 +10,0,36 +10)
script.Parent.currency.ethyr.Visible=(_bb.ethyr and _bb.ethyr>0)end
script.Parent.currency.ethyr.buy.Activated:connect(function()
_da.products.open()end)local abb=_bb.ethyr or 0
a_b:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",function(abc,bbc)
if abc=="globalData"then
local cbc=a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","globalData")local dbc=cbc.ethyr or 0
if dbc>abb and dbc>0 then local _cc=dbc-abb
local acc=math.clamp(_cc/10,3,50)cab(acc)
_da.money.setLabelAmount(script.Parent.currency.ethyr.amount,
bbc.ethyr or 0,dab)
script.Parent.currency.ethyr.Size=UDim2.new(0,
script.Parent.currency.ethyr.amount.amount.AbsoluteSize.X+95,0,36 +10)
script.Parent.currency.ethyr.Visible=(dbc>0)end;abb=dbc end end)
local function bbb(abc)bca=abc;local bbc=cba[abc]if bbc then local dbc=b_a[bbc.id](cca)
a_b:invoke("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}",dbc,bbc.rank)end;local cbc=bba[abc]
if cbc then
local dbc=__a[cbc.id]if dbc then
a_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",dbc,"inventory",cbc)end end end
local function cbb(abc)if bca==abc then
a_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end
_da.money.subscribeToPlayerMoney(script.Parent.currency.money)local dbb=script:WaitForChild("inventoryItemTemplate")
local function _cb(abc)
if
cba[abc]then local bbc=cba[abc]
if bbc then if bda.Visible then _da.enchant.dragItem(bbc)else
a_b:invoke("{7A60EE45-884C-4454-8518-F0B368D30D75}",bbc.id)end end elseif bba[abc]then local bbc=bba[abc]
if ada.Visible then
_da.trading.processDoubleClickFromInventory(bbc)elseif dda.Visible then
a_b:invokeServer("{9B6A6C02-E725-410F-8A3D-E553FD395A27}",bbc)elseif cda.Visible then
a_b:invoke("{AE54CE76-A031-482B-8639-B3200C582B10}",bbc,true)else local cbc=__a[bbc.id]
print("doubleclick",cbc and cbc.name,cbc and cbc.category,cbc and
cbc.equipmentPosition)
if cbc then
if cbc.category=="equipment"then
if
cbc.equipmentPosition==bab.equipmentPosition.arrow then print("arrow hehe")
local dbc=a_b:invokeServer("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}","equipment",bbc.position,bab.equipmentPosition.arrow)else
local dbc=_da.mapping.getMappingByValue("equipmentPosition",cbc.equipmentSlot)
if dbc then local _cc=__b.content:FindFirstChild(dbc)if _cc and
_cc:FindFirstChild("equipItemButton")then
_da.uiCreator.processSwap(abc,_cc.equipItemButton)end end end elseif
cbc.category=="consumable"or cbc.activationEffect~=nil then
local dbc,_cc=a_b:invoke("{A1D46A31-29BA-4A4A-BCE2-E06641926EF8}",bbc)end end end end end
local function acb(abc)
if cd.isEnchantingEquipment and aca then local bbc;local cbc
if
abc:IsDescendantOf(script.Parent)and bba[abc]then local acc=bba[abc]if acc then bbc=acc end elseif
abc:IsDescendantOf(__b)then
local acc=a_b:invoke("{1277F0DD-09D0-4F1C-9F20-408F77D81A00}",abc)if acc then bbc=acc;cbc="equipment"end end;if abc.Parent.blocked.Visible then return false end;local dbc=true
local _cc=aca
if _cc then local acc=__a[_cc.id]if bbc then local bcc=__a[bbc.id]
if acc.dye and not
_da.dyePreview.prompt(acc,bcc)then dbc=false end end end
if bbc and dbc then local acc=_cc;local bcc={}local ccc=__a[acc.id]
if
ccc and ccc.playerInputFunction then bcc=ccc.playerInputFunction()end
local dcc,_dc,adc,bdc=a_b:invokeServer("{5FDEEFB3-EF88-4117-9480-ABF7D716D38E}",acc,bbc,cbc,bcc)if bdc then
spawn(function()wait(0.5)
a_b:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",bdc)end)end;_ca=false
cd.setIsEnchantingEquipment(false)script.Parent.scrollPrompt.Visible=false;aca=nil
caa.ImageTransparency=1
a_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")
if dcc and _dc and adc then
spawn(function()wait(0.5)
local cdc={color=
_da.itemAcquistion.getTitleColorForInventorySlotData(adc)or Color3.new(1,1,1)}
_da.fx.ring(cdc,abc.AbsolutePosition+abc.AbsoluteSize/2)end)end
a_b:invoke("{D2CCD241-4C4A-4861-8463-1C7ACE2BD18F}")end end end;cd.enchantItem=acb;local bcb
local function ccb(abc)local bbc=0
for cbc,dbc in pairs(abc.abilities)do
if dbc.rank~=0 then
local _cc=b_a[dbc.id](abc)
if _cc and _cc.metadata then bbc=bbc+_cc.metadata.cost end;local acc=dbc.rank-1
if
acc>0 and _cc.metadata and _cc.metadata.upgradeCost then bbc=bbc+_cc.metadata.upgradeCost*acc end;if dbc.variant then local bcc=_cc.metadata.variants[dbc.variant]bbc=bbc+
bcc.cost end end end;return bbc end;local dcb=script.Parent.learnAbilities;local _db=0
local function adb()bcb=bcb or
a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")
for bcc,ccc in
pairs(dcb.contents:GetChildren())do if ccc:IsA("GuiObject")then ccc:Destroy()end end;local abc={}for bcc,ccc in pairs(bcb)do abc[ccc.id]=ccc end;local bbc={}
for bcc,ccc in
pairs(b_a:GetAbilityIds())do
if ccc then local dcc=b_a[bcc](cca)
if
dcc.metadata and dcc.metadata.requirement and dcc.metadata.requirement(cca)then if
abc[dcc.id]==nil or abc[dcc.id].rank==0 then
table.insert(bbc,dcc)end end end end;_db=#bbc
for bcc,ccc in pairs(bbc)do local dcc=dcb.template:Clone()local _dc=
ccc.metadata.cost or 0;dcc.item.Image=ccc.image;dcc.abilityPoints.amount.Text=
_dc.." AP"dcc.LayoutOrder=_dc;dcc.Parent=dcb.contents
dcc.Visible=true;local function adc()
a_b:invoke("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}",ccc,0)bca=dcc end
local function bdc()if bca==dcc then
a_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end;dcc.item.MouseEnter:connect(adc)
dcc.item.SelectionGained:connect(adc)dcc.item.MouseLeave:connect(bdc)
dcc.item.SelectionLost:connect(bdc)
dcc.item.Activated:connect(function()
local cdc=aab.translate("Are you sure you want to spend %s to learn %s?",dcb)
local ddc=ccc.name and aab.translate(ccc.name)or"???"
local __d=a_b:invoke("{98536A5A-1107-447A-8263-7528187ECA5B}",string.format(cdc,_dc.." AP",ddc))
if __d then
local a_d,b_d=a_b:invokeServer("{4C2EA395-81A8-4F25-BDE8-DD916F41B890}",ccc.id)
if a_d then
if not ccc.passive then
local c_d=a_b:invoke("{D25B262F-2680-4CB6-A98E-1A5A5E31DA12}")
for d_d,_ad in pairs(c_d)do local aad=_ad.button;local bad=_ad.data
if(bad==nil or bad.id==nil or
bad.id<=0)then
local cad=string.gsub(aad.Name,"[^.0-9]+","")cad=tonumber(cad)
if cad~=1 and cad~=2 then if cad==10 then cad=0 end
local dad=a_b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",bab.dataType.ability,ccc.id,tonumber(cad))
if dad then
for i=1,4 do local _bd=aad.flare:Clone()_bd.Name="flareCopy"_bd.Parent=aad
_bd.Visible=true;_bd.Size=UDim2.new(1,4,1,4)
_bd.Position=UDim2.new(0.5,0,1,2)_bd.AnchorPoint=Vector2.new(0.5,1)local abd=(180 -40 *i)
local bbd=(14 -2 *i)local cbd=UDim2.new(0.5,0,1,2)local dbd=UDim2.new(1,bbd,1,abd)d_b(_bd,{"Position","Size","ImageTransparency"},{cbd,dbd,1},
0.5 *i)end;break end end end end end
if
game.ReplicatedStorage.sounds:FindFirstChild("idolPickup")then b_b.playSound("idolPickup")end end end end)end;local cbc=math.ceil(#bbc/4)local dbc=dcb.contents.UIGridLayout
local _cc=
dbc.CellPadding.Y.Offset+dbc.CellSize.Y.Offset
local acc=dbc.CellPadding.X.Offset+dbc.CellSize.X.Offset
dcb.Size=UDim2.new(0,( (cbc>1 and acc*4 +14)or acc*#bbc),0,math.min(cbc*_cc,170))dcb.contents.CanvasSize=UDim2.new(0,0,0,cbc*_cc)
dcb.contents.CanvasPosition=Vector2.new()end
local function bdb(abc)if abc then aba=abc end;if _ba~="ability"then dcb.Visible=false end
local bbc=game.GuiService.SelectedObject;local cbc,dbc;if bbc and bbc:IsDescendantOf(script.Parent)then
cbc=bbc.Name;dbc=bbc.Parent end
if aba then bba={}cba={}
for adc,bdc in
pairs(aaa:GetChildren())do if bdc:FindFirstChild("item")then bdc:Destroy()end end;local _cc=0
cca=a_b:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")
bcb=bcb or a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities")
local acc=a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")or 1;local bcc=acc-1;local ccc=bcc-ccb(cca)script.Parent.abilityPoints.Visible=
ccc>0;script.Parent.abilityPoints.amount.Text=
tostring(ccc).." AP"local dcc={}local _dc=0
if _ba=="ability"then for adc,bdc in
pairs(bcb)do
if bdc.rank>0 then _dc=_dc+1;dcc[tostring(_dc)]=bdc end end else
for adc,bdc in pairs(aba)do local cdc=__a[bdc.id]if
cdc then
if cdc.category==_ba then dcc[tostring(bdc.position)]=bdc end end end end
for i=1,20 do
local adc=script.inventoryItemTemplate:Clone()adc.stars.Visible=false;adc.blocked.Visible=false
adc.shine.Visible=false;adc.locked.Visible=false;adc.attribute.Visible=false
adc.item.duplicateCount.Text=""local bdc=dcc[tostring(i)]
if bdc then
if _ba=="ability"then local cdc=bdc
local ddc=b_a[cdc.id](cca)if not ddc.passive then local c_d=Instance.new("BoolValue")
c_d.Name="bindable"c_d.Parent=adc.item end
adc.ImageTransparency=0;adc.item.Image=ddc.image
adc.item.ImageColor3=Color3.new(1,1,1)if ddc.passive then cdc.passive=true end;cba[adc.item]=cdc;local __d,a_d;if
cdc then if cdc.rank>1 then a_d=2 end end
if ddc.statistics then
local c_d=_da.ability_utilities.getAbilityStatisticsForRank(ddc,cdc.rank)if c_d and c_d.tier and(a_d==nil or c_d.tier>a_d)then
a_d=c_d.tier end end;if a_d and a_d>1 then __d=_ab.tierColors[a_d]end;local b_d=
cdc.rank>1 and cdc.rank-1
if b_d then
for c_d,d_d in
pairs(adc.stars:GetChildren())do
if d_d:IsA("ImageLabel")then
d_d.ImageColor3=__d or Color3.new(1,1,1)d_d.Visible=false elseif d_d:IsA("TextLabel")then
d_d.TextColor3=__d or Color3.new(1,1,1)d_d.Visible=false end end;adc.stars.Visible=true
if b_d<=3 then for c_d,d_d in
pairs(adc.stars:GetChildren())do local _ad=tonumber(d_d.Name)
if _ad then d_d.Visible=_ad<=b_d end end
adc.stars.exact.Visible=false else adc.stars["1"].Visible=true
adc.stars.exact.Visible=true;adc.stars.exact.Text=b_d end;adc.stars.Visible=true end;adc.shine.Visible=__d~=nil and a_d>1;adc.shine.ImageColor3=__d or
Color3.fromRGB(179,178,185)
_da.fx.setFlash(adc.frame,adc.shine.Visible)
adc.frame.ImageColor3=(a_d and a_d>1 and __d)or Color3.fromRGB(106,105,107)c_b.drag.setIsDragDropFrame(adc.item)
c_b.setIsDoubleClickFrame(adc.item,0.2,_cb)else local cdc=bdc;local ddc=__a[cdc.id]
if ddc.canBeBound then
local c_d=Instance.new("BoolValue")c_d.Name="bindable"c_d.Parent=adc.item end;adc.ImageTransparency=0;adc.item.Image=ddc.image
adc.item.ImageColor3=Color3.new(1,1,1)if cdc.dye then
adc.item.ImageColor3=Color3.fromRGB(cdc.dye.r,cdc.dye.g,cdc.dye.b)end
if ddc.minLevel then local c_d=
a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")or 1;adc.locked.Visible=
c_d<ddc.minLevel end
adc.item.duplicateCount.Text=
(cdc.stacks and ddc.canStack and cdc.stacks>1)and tostring(cdc.stacks)or""bba[adc.item]=cdc;local __d,a_d;if cdc then
__d,a_d=_da.itemAcquistion.getTitleColorForInventorySlotData(cdc)end
if cdc.attribute then
local c_d=a_a[cdc.attribute]if c_d and c_d.color then adc.attribute.ImageColor3=c_d.color
adc.attribute.Visible=true end end;local b_d=cdc.successfulUpgrades
if b_d then
for c_d,d_d in
pairs(adc.stars:GetChildren())do
if d_d:IsA("ImageLabel")then
d_d.ImageColor3=__d or Color3.new(1,1,1)d_d.Visible=false elseif d_d:IsA("TextLabel")then
d_d.TextColor3=__d or Color3.new(1,1,1)d_d.Visible=false end end;adc.stars.Visible=true
if b_d<=3 then for c_d,d_d in
pairs(adc.stars:GetChildren())do local _ad=tonumber(d_d.Name)
if _ad then d_d.Visible=_ad<=b_d end end
adc.stars.exact.Visible=false else adc.stars["1"].Visible=true
adc.stars.exact.Visible=true;adc.stars.exact.Text=b_d end;adc.stars.Visible=true end
if cd.isEnchantingEquipment and aca then local c_d=__a[aca.id]
local d_d=c_d.upgradeCost or 1;local _ad=ddc.maxUpgrades
local aad,bad=_ab.enchantmentCanBeAppliedToItem(aca,cdc)local cad=not aad;adc.blocked.Visible=cad end;adc.shine.Visible=__d~=nil and a_d>1;adc.shine.ImageColor3=__d or
Color3.fromRGB(179,178,185)
_da.fx.setFlash(adc.frame,adc.shine.Visible)
adc.frame.ImageColor3=(a_d and a_d>1 and __d)or Color3.fromRGB(106,105,107)
if not cd.isEnchantingEquipment then
c_b.drag.setIsDragDropFrame(adc.item)c_b.setIsDoubleClickFrame(adc.item,0.2,_cb)else
adc.item.MouseButton1Click:connect(function()
acb(adc.item)end)end end else adc.item.Image=""adc.item.Visible=true
adc.frame.Visible=false;adc.shine.Visible=false;adc.ImageTransparency=0.5
if _ba=="ability"and
i==_dc+1 then local cdc=script.upgrade:Clone()cdc.Parent=adc
cdc.Visible=true
local function ddc()
if dcb.Visible then cdc.ImageColor3=Color3.fromRGB(243,37,52)
cdc.text.Text="x"cdc.Active=true
local __d=adc.AbsolutePosition-script.Parent.AbsolutePosition
dcb.Position=UDim2.new(0,__d.X+adc.AbsoluteSize.X,0,__d.Y)else
if ccc>0 then cdc.ImageColor3=Color3.fromRGB(255,182,12)
cdc.text.Text="+"cdc.Active=true else cdc.ImageColor3=Color3.fromRGB(185,185,185)
cdc.text.Text="+"cdc.Active=false end end;adb()cdc.Visible=_db>0 end;dcb.Visible=false;ddc()
cdc.Activated:connect(function()if dcb.Visible then dcb.Visible=false else adb()
dcb.Visible=true end;ddc()end)end end
adc.item.MouseEnter:connect(function()bbb(adc.item)end)
adc.item.SelectionGained:connect(function()bbb(adc.item)end)
adc.item.MouseLeave:connect(function()cbb(adc.item)end)
adc.item.SelectionLost:connect(function()cbb(adc.item)end)adc.Name=tostring(i)adc.LayoutOrder=i;adc.Parent=aaa end
if dbc and cbc then local adc=dbc:FindFirstChild(cbc)if adc then
game.GuiService.SelectedObject=adc end end end end;local cdb=true;local function ddb(abc)cdb=abc end;local __c=4;local a_c=0;local b_c=false
local function c_c(abc)
if _ca then return false end;if not cdb then return false end;if
c_a.Character.PrimaryPart.health.Value<=0 then return false end;if
a_b:invoke("{EAD6BA98-4037-456F-AB79-F30E6DD0D488}").isSprinting then return end;if
a_b:invoke("{BF956380-404B-41BA-8742-E8FD573AD12E}")then return end;_ca=true;local bbc=__a[abc.id]
if bbc then
if
bbc.askForConfirmationBeforeConsume then
local dbc=a_b:invoke("{98536A5A-1107-447A-8263-7528187ECA5B}","Are you sure you want to use '"..bbc.name.."'?")if not dbc then _ca=false;return false,"denied confirmation"end end
local cbc=math.clamp(1 -
a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final.consumeTimeReduction,0,1)
if bbc.enchantsEquipment then cd.setIsEnchantingEquipment(true,abc)aca=abc
caa.ImageTransparency=0;script.Parent.scrollPrompt.Visible=true
script.Parent.scrollPrompt.contents.itemIcon.Image=bbc.image;caa.Image=bbc.image
a_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")dba[_ba].mouseLeaveTween:Play()
_ba="equipment"
dba.equipment.mouseClickTween:Play()bdb()_ca=false;return nil elseif not b_c then a_c=tick()local dbc,_cc
local acc=bbc.playerInputFunction and
bbc.playerInputFunction()or{}local bcc;local ccc;local dcc=(bbc.consumeTime or 1)*cbc
a_b:invoke("{128DE203-3671-40A9-9C56-D5E9534ABB5E}",dcc)
local function _dc()if bcc then bcc:disconnect()bcc=nil end;b_c=false;if tick()-ccc<dcc*
0.90 then return end
dbc,_cc=a_b:invokeServer("{25AC3715-858A-45E0-AA01-86637A049ED3}",bbc.category,abc.position,
nil,acc)delay(0.5,function()end)end
local adc=a_b:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if adc then
local bdc=dca:getAnimationsForAnimationController(adc.entity.AnimationController)ccc=tick()b_c=true
dca:replicatePlayerAnimationSequence("movementAnimations","consume_consumable",nil,{id=bbc.id,ANIMATION_DESIRED_LENGTH=dcc})while
not bdc.movementAnimations.consume_loop.IsPlaying do wait(0.05)end
bcc=bdc.movementAnimations.consume_loop.Stopped:connect(_dc)
delay(dcc+1.5,function()if bcc then b_c=false;bcc:disconnect()bcc=nil end end)end;while bcc do wait(0.1)end;_ca=false;return dbc,_cc end end;_ca=false;return false end
a_b:create("{A1D46A31-29BA-4A4A-BCE2-E06641926EF8}","BindableFunction","OnInvoke",c_c)
a_b:create("{CB505807-178C-4E8F-AE40-B0B823BF476E}","BindableFunction","OnInvoke",function()return b_c end)
local function d_c(abc,bbc)if abc=="inventory"then bdb(bbc)elseif abc=="abilities"then
print("abilities updated!")bcb=bbc;bdb()end end
local function _ac(abc)
local bbc=a_b:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")
if bbc then
local cbc=dca:getAnimationsForAnimationController(bbc.entity.AnimationController)if cbc and cbc.movementAnimations and
cbc.movementAnimations.consume_loop.IsPlaying then
cbc.movementAnimations.consume_loop:Stop()end end end
game:GetService("UserInputService").InputBegan:connect(function(abc,bbc)
if
script.Parent.Visible then
if abc.KeyCode==Enum.KeyCode.ButtonL1 then
if _ba=="consumable"then _ba="equipment"elseif _ba==
"miscellaneous"then _ba="consumable"elseif _ba=="equipment"then _ba="miscellaneous"end;game.GuiService.SelectedObject=_aa:FindFirstChild(_ba)
bdb()elseif abc.KeyCode==Enum.KeyCode.ButtonR1 then
if _ba=="consumable"then
_ba="miscellaneous"elseif _ba=="miscellaneous"then _ba="equipment"elseif _ba=="equipment"then _ba="consumable"end;game.GuiService.SelectedObject=_aa:FindFirstChild(_ba)
bdb()
for cbc,dbc in pairs(_aa:GetChildren())do if dbc.Name==_ba then
dbc.ImageColor3=Color3.fromRGB(84,190,255)elseif dbc:IsA("GuiObject")then
dbc.ImageColor3=Color3.fromRGB(202,202,202)end end end end end)
a_b:create("{89A86833-DEB3-4C09-AB20-848484FA9BCB}","BindableEvent","Event",function()
if _ba=="ability"then _ba="miscellaneous"
bdb()
for abc,bbc in pairs(_aa:GetChildren())do if bbc.Name==_ba then
bbc.ImageColor3=Color3.fromRGB(84,190,255)elseif bbc:IsA("GuiObject")then
bbc.ImageColor3=Color3.fromRGB(202,202,202)end end end end)
a_b:create("{E1E81CAA-958F-4A3C-998E-9C3E44528FF8}","BindableEvent","Event",function()
if _ba~="ability"then _ba="ability"bdb()
for abc,bbc in
pairs(_aa:GetChildren())do
if bbc.Name==_ba then bbc.ImageColor3=Color3.fromRGB(84,190,255)elseif
bbc:IsA("GuiObject")then bbc.ImageColor3=Color3.fromRGB(202,202,202)end end end end)
local function aac(abc)local bbc=false
local cbc=TweenInfo.new(0.2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)dba[abc.Name]={}
dba[abc.Name].mouseEnterTween=daa:Create(abc,cbc,{ImageColor3=Color3.fromRGB(120,222,222)})
dba[abc.Name].mouseLeaveTween=daa:Create(abc,cbc,{ImageColor3=Color3.fromRGB(202,202,202)})
dba[abc.Name].mouseClickTween=daa:Create(abc,cbc,{ImageColor3=Color3.fromRGB(84,190,255)})
abc.Activated:connect(function()_ba=abc.Name;bdb()end)
local function dbc(acc)
if acc.UserInputType==Enum.UserInputType.MouseMovement then bbc=true;if _ba~=
abc.Name then
dba[abc.Name].mouseEnterTween:Play()end elseif
acc.UserInputType==Enum.UserInputType.MouseButton1 then if _ba~=abc.Name then
dba[abc.Name].mouseClickTween:Play()
if dba[_ba]then dba[_ba].mouseLeaveTween:Play()end end end end
local function _cc(acc)
if acc.UserInputType==Enum.UserInputType.MouseMovement then bbc=false;if _ba~=
abc.Name then
dba[abc.Name].mouseLeaveTween:Play()end end end;abc.InputBegan:connect(dbc)
abc.InputEnded:connect(_cc)end;local function bac(abc)if abc then if bba[abc]then return bba[abc],"item"end;if cba[abc]then
return cba[abc],"ability"end end
return nil end;local function cac()
return _ba end
local function dac(abc)if not aba then return end;for bbc,cbc in pairs(aba)do
if cbc.id==abc then return cbc end end;return nil end
local function _bc()
cca=a_b:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")
bdb(a_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory"))for cbc,dbc in pairs(_aa:GetChildren())do
if dbc:IsA("ImageButton")then aac(dbc)end end
a_b:connect("{CB527931-903D-443E-9010-9C92D87E9BE2}","Event",_ac)
a_b:create("{239414C2-E250-4BB6-8E25-D15DAD420362}","BindableFunction","OnInvoke",ddb)
a_b:create("{EF630E9A-7A99-4862-9F00-055B1003CD14}","BindableFunction","OnInvoke",bac)
a_b:create("{84775882-4247-4E60-9AC0-54F2E601087E}","BindableFunction","OnInvoke",cac)
a_b:create("{6126742D-1497-4C61-B4A2-7787E1E36454}","BindableFunction","OnInvoke",dac)
a_b:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",d_c)
a_b:create("{D2CCD241-4C4A-4861-8463-1C7ACE2BD18F}","BindableFunction","OnInvoke",function()bdb()end)
local function abc(cbc)
if cd.isEnchantingEquipment then
if caa.ImageTransparency~=0 then caa.ImageTransparency=0 end
_da.tween(caa,{"Position"},UDim2.new(0,cbc.Position.X-40,0,cbc.Position.Y+20),0.2)end end;local bbc=game:GetService("UserInputService")
bbc.InputChanged:connect(abc)
bbc.InputBegan:connect(function(cbc)
if
cbc.UserInputType==Enum.UserInputType.MouseButton1 and cd.isEnchantingEquipment then wait(0.15)
_ca=false;cd.setIsEnchantingEquipment(false)
script.Parent.scrollPrompt.Visible=false;aca=nil;caa.ImageTransparency=1
a_b:invoke("{D2CCD241-4C4A-4861-8463-1C7ACE2BD18F}")end end)end;delay(1,_bc)end;return cd