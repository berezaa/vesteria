local dca={}dca.drag={}local _da=game:GetService("TextService")
local ada=game:GetService("TweenService")local bda=game:GetService("UserInputService")
local cda=game:GetService("ReplicatedStorage")local dda=require(cda.modules)local __b=dda.load("network")
local a_b=dda.load("utilities")local b_b=dda.load("mapping")local c_b=dda.load("tween")
local d_b=dda.load("localization")local _ab=require(cda:WaitForChild("itemData"))
local aab=require(cda:WaitForChild("itemAttributes"))local bab=require(cda.abilityLookup)
local cab=TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)local dab={}local _bb={}local abb=nil;local bbb=script.Parent;local cbb=bbb.menu_inventory
local dbb=bbb.menu_trade;local _cb=bbb.menu_enchant;local acb=bbb.menu_shop;local bcb=bbb.menu_storage
local ccb=bbb.menu_equipment;local dcb=bbb.interactionPrompts;local _db=bbb.notifcationsFrame
local adb=bbb.dragDropMask
__b:create("{8D4F20B3-8051-4019-986F-EE6A5C4DFF0C}","BindableEvent","Event",function(bbc)bbb.Enabled=bbc end)local bdb
function dca.init(bbc)bdb=bbc
local function cbc()
if bdb.input.mode.Value=="mobile"then script.Parent.interactionPrompts.Position=UDim2.new(1,
-110,1,-200)script.Parent.interactionPrompts.UIScale.Scale=
bdb.input.menuScale or 1 else script.Parent.interactionPrompts.Position=UDim2.new(1,
-110,1,-130)
script.Parent.interactionPrompts.UIScale.Scale=1 end end;cbc()
bdb.input.mode.Changed:connect(cbc)end;local cdb=false;local ddb
function dca.showCurrency(bbc)if not bdb then return false end
a_b.playSound("coins")local cbc=script.moneyObtained:Clone()
local dbc=cbc:FindFirstChild("count")
if dbc then
cbc.backdrop.UIScale.Scale=1.15 +math.clamp(dbc.Value/150,0,0.75)c_b(cbc.backdrop.UIScale,{"Scale"},1,0.5)else
cbc.Size=UDim2.new(0,0,0,42)dbc=Instance.new("IntValue")dbc.Name="count"dbc.Value=0
dbc.Parent=cbc end;local _cc="rbxassetid://2535600080"local acc=1
if bbc>=1e6 then _cc="rbxassetid://2536432897"if
bbc>=5e8 then acc=4 elseif bbc>=1e8 then acc=3 elseif bbc>=1e7 then acc=2 end elseif bbc>=1e3 then
_cc="rbxassetid://2535600034"if bbc>=5e5 then acc=4 elseif bbc>=1e5 then acc=3 elseif bbc>=1e4 then acc=2 end else
_cc="rbxassetid://2535600080"if bbc>=5e2 then acc=4 elseif bbc>=1e2 then acc=3 elseif bbc>=1e1 then acc=2 end end
for i=1,acc do local bdc=script.coin:Clone()
local cdc=UDim2.new(0.5,math.random(-100,100),0.5,math.random(
-50,50))bdc.Parent=cbc;bdc.Visible=true;bdc.Image=_cc;bdc.ImageTransparency=1
bdc.Size=UDim2.new(0,20,0,20)
c_b(bdc,{"Position","ImageTransparency","Size"},{cdc,0,UDim2.new(0,32,0,32)},1,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
delay(1,function()
if bdc and bdc.Parent then
c_b(bdc,{"ImageTransparency"},{1},0.5)game.Debris:AddItem(bdc,0.5)end end)end;dbc.Value=dbc.Value+1;local bcc=tick()ddb=bcc;cbc.amount.Value=
cbc.amount.Value+bbc;local ccc=cbc.amount.Value
bdb.money.setLabelAmount(cbc.backdrop.money,ccc)local dcc=
cbc.backdrop.money.amount.AbsoluteSize.X+32 +16
cbc.backdrop.money.Size=UDim2.new(0,dcc,cbc.backdrop.money.Size.Y.Scale,cbc.backdrop.money.Size.Y.Offset)cbc.Visible=true;cbc.Parent=dcb;local _dc=5
local adc=UDim2.new(0,dcc+35,0,42)c_b(cbc,{"Size"},adc,0.5)
spawn(function()wait(_dc)
c_b(cbc,{"Size"},UDim2.new(0,0,0,42),0.5)wait(0.5)if ddb==bcc then cbc:Destroy()end end)end
function dca.showLootUnlock(bbc,cbc,dbc,_cc)_cc=_cc or dbc
local acc=script.monsterBook:Clone()
acc.backdrop.contents.thumbnail.Image=cbc.image
acc.backdrop.contents.holder:ClearAllChildren()
bbc:Clone().Parent=acc.backdrop.contents.holder;acc.backdrop.ImageColor3=dbc;acc.flare.ImageColor3=_cc
local bcc=acc.Size;acc.Visible=true;acc.Parent=dcb
local ccc=acc:WaitForChild("flare"):clone()ccc.Parent=acc;ccc.Size=UDim2.new(1,6,1,0)
ccc.Position=UDim2.new(1,0,0.5,0)ccc.Visible=true
for i=1,4 do
local dcc=acc:WaitForChild("flare"):clone()dcc.Parent=acc;dcc.Visible=true;dcc.Size=UDim2.new(1,4,1,4)
dcc.Position=UDim2.new(0.5,0,0.5,0)dcc.AnchorPoint=Vector2.new(0.5,0.5)local _dc=(260 -40 *i)local adc=(14 -
2 *i)local bdc=UDim2.new(1,_dc,1,adc)c_b(dcc,{"Size","ImageTransparency"},{bdc,1},
0.7 *i)end;c_b(acc,{"Size"},bcc,0.5)
spawn(function()wait(10)
c_b(acc,{"Size"},UDim2.new(0,0,0,60),0.5)wait(0.5)acc:Destroy()end)end
function dca.showItemPickup(bbc,cbc,dbc)cbc=dbc.stacks or cbc or 1
local _cc=bbc.name..
( (
dbc and dbc.upgrades and dbc.upgrades>0 and
" +".. (dbc.successfulUpgrades or 0))or"")or"Unknown"dbc=dbc or{}dbc.id=dbc.id or bbc.id;local acc
if dbc.attribute then
local b_d=aab[dbc.attribute]if b_d then acc=b_d.color
if b_d.prefix then _cc=b_d.prefix.." ".._cc end end end;local bcc;local ccc;if ccc then bcc=true else ccc=script.itemObtained:Clone()
ccc.Size=UDim2.new(0,0,0,60)end;ccc.Name=_cc
ccc.backdrop.contents.item.attribute.Visible=false;if acc then
ccc.backdrop.contents.item.attribute.ImageColor3=acc
ccc.backdrop.contents.item.attribute.Visible=true end
ccc.backdrop.contents.title.Text=_cc
ccc.backdrop.contents.item.thumbnail.Image=bbc.image;ccc.amount.Value=ccc.amount.Value+cbc
local dcc=ccc.amount.Value
ccc.backdrop.contents.item.thumbnail.duplicateCount.Text=dcc;ccc.backdrop.contents.item.thumbnail.duplicateCount.Visible=
dcc>1;if bcc then ccc.backdrop.UIScale.Scale=1.15 +math.clamp(
dcc/150,0,0.75)
c_b(ccc.backdrop.UIScale,{"Scale"},1,0.5)end;local _dc,adc;if _ab then
_dc,adc=bdb.itemAcquistion.getTitleColorForInventorySlotData(dbc)end;ccc.backdrop.contents.item.shine.Visible=
_dc~=nil and adc and adc>1
ccc.backdrop.contents.item.shine.ImageColor3=
_dc or Color3.fromRGB(179,178,185)
ccc.backdrop.contents.item.frame.ImageColor3=(
adc and adc>1 and _dc)or Color3.fromRGB(106,105,107)ccc.backdrop.contents.item.shine.ImageColor3=_dc or
Color3.fromRGB(179,178,185)ccc.backdrop.contents.title.TextColor3=
_dc or Color3.new(1,1,1)
ccc.backdrop.contents.item.thumbnail.ImageColor3=Color3.new(1,1,1)local bdc=dbc and dbc.dye;if bdc then
ccc.backdrop.contents.item.thumbnail.ImageColor3=Color3.fromRGB(bdc.r,bdc.g,bdc.b)end;ccc.Visible=true
ccc.Parent=dcb
bdb.fx.setFlash(ccc.backdrop.contents.item.frame,ccc.backdrop.contents.item.shine.Visible)
local cdc=game.TextService:GetTextSize(ccc.backdrop.contents.title.Text,18,Enum.Font.SourceSansBold,Vector2.new(90,36))local ddc=UDim2.new(0,125 +cdc.X,0,60)ccc.backdrop.contents.title.Size=UDim2.new(0,
cdc.X+40,1,0)local __d;local a_d=2
if(bbc.rarity and bbc.rarity==
"Legendary")then a_d=a_d+2.5
__d=ccc:WaitForChild("flare"):clone()__d.Parent=ccc;__d.Size=UDim2.new(1,8,1,0)
__d.AnchorPoint=Vector2.new(0.5,0.5)__d.Position=UDim2.new(0.5,0,0.5,0)
__d.ImageColor3=Color3.fromRGB(174,34,234)__d.Visible=true
for i=1,6 do
local b_d=ccc:WaitForChild("flare"):clone()b_d.Parent=ccc;b_d.Visible=true
b_d.ImageColor3=Color3.fromRGB(174,34,234)b_d.Size=UDim2.new(1,4,1,4)
b_d.Position=UDim2.new(0.5,0,0.5,0)b_d.AnchorPoint=Vector2.new(0.5,0.5)local c_d=(1000 -53 *i)local d_d=(28 -
3 *i)local _ad=UDim2.new(1,d_d/2,0.5,0)
local aad=UDim2.new(1,c_d,1,d_d)
c_b(b_d,{"Size","ImageTransparency"},{aad,1},0.7 *i)end elseif(bbc.rarity and bbc.rarity=="Rare")or(bbc.category and
bbc.category=="equipment")then
a_d=a_d+1.5
__d=ccc:WaitForChild("flare"):clone()__d.Parent=ccc;__d.Size=UDim2.new(1,8,1,0)
__d.AnchorPoint=Vector2.new(0.5,0.5)__d.Position=UDim2.new(0.5,0,0.5,0)__d.Visible=true
for i=1,4 do
local b_d=ccc:WaitForChild("flare"):clone()b_d.Parent=ccc;b_d.Visible=true;b_d.Size=UDim2.new(1,4,1,4)
b_d.Position=UDim2.new(0.5,0,0.5,0)b_d.AnchorPoint=Vector2.new(0.5,0.5)local c_d=(500 -40 *i)local d_d=(14 -
2 *i)local _ad=UDim2.new(1,c_d,1,d_d)c_b(b_d,{"Size","ImageTransparency"},{_ad,1},
0.7 *i)end end;if not bcc then c_b(ccc,{"Size"},ddc,0.5)end
spawn(function()
wait(a_d)
if __d then c_b(__d,{"ImageTransparency"},1,0.5)end
if ccc.Parent and dcc==ccc.amount.Value then
c_b(ccc,{"Size"},UDim2.new(0,0,0,60),0.5)if ccc.Parent and dcc==ccc.amount.Value then wait(0.5)
ccc:Destroy()end end end)end
local __c=script:WaitForChild("interactionPromptTextLabel")
function dca.createTextFragmentLabels(bbc,cbc)local dbc=0;local _cc=0;local acc;local bcc=Instance.new("Frame")
local ccc=0;local dcc;local _dc=1
for adc,bdc in ipairs(cbc)do
local cdc=bdc.textColor3 or Color3.fromRGB(15,15,15)local ddc=bdc.font or Enum.Font.SourceSans;local __d=false;if
bdc.autoLocalize==nil or bdc.autoLocalize then
bdc.text=d_b.translate(bdc.text,bbc)end
local a_d=bdc.textTransparency or 0;local b_d=bdc.textSize or 18
local c_d=_da:GetTextSize(bdc.text,b_d,ddc,Vector2.new())local d_d
if dcc then c_d=Vector2.new(c_d.X,dcc.Y)else dcc=c_d end;d_d=b_d
if dbc+c_d.X+3 >bbc.AbsoluteSize.X then local _ad={}for cad in
string.gmatch(bdc.text,"%S+")do table.insert(_ad,cad)end;local aad={}
local bad=0
for cad,dad in pairs(_ad)do
local _bd=_da:GetTextSize(dad,b_d,ddc,Vector2.new())
if dbc+bad+_bd.X+3 >bbc.AbsoluteSize.X then _dc=_dc+1
if#aad>
0 then local abd=""
for cbd,dbd in pairs(aad)do abd=abd..dbd;if cbd~=#aad then abd=abd.." "end end;local bbd=__c:Clone()bbd.AutoLocalize=__d;bbd.TextSize=b_d
bbd.TextColor3=cdc;bbd.Position=UDim2.new(0,dbc,0,_cc)
bbd.Size=UDim2.new(0,bad,0,d_d)bbd.Text=abd;bbd.Font=ddc;bbd.Parent=bcc;bbd.TextTransparency=a_d end;_cc=_cc+d_d;dbc=0;aad={}bad=_bd.X;table.insert(aad,dad)else bad=
bad+_bd.X+3;table.insert(aad,dad)end end
if#aad>0 then local cad=""for _bd,abd in pairs(aad)do cad=cad..abd
if _bd~=#aad then cad=cad.." "end end;local dad=__c:Clone()
dad.TextSize=b_d;dad.TextColor3=cdc;dad.Position=UDim2.new(0,dbc,0,_cc)
dad.Size=UDim2.new(0,bad,0,d_d)dad.Text=cad;dad.Font=ddc;dad.Parent=bcc;dad.TextTransparency=a_d
dbc=dbc+bad+3 end;if ccc<=0 then ccc=d_d end else if ccc<=0 then ccc=d_d end;local _ad=__c:Clone()
_ad.TextSize=b_d;_ad.TextColor3=cdc
_ad.Position=UDim2.new(0,dbc,ccc~=d_d and 0.5 or 0,_cc)
_ad.AnchorPoint=Vector2.new(0,ccc~=d_d and 0.5 or 0)_ad.Size=UDim2.new(0,c_d.X,0,d_d)_ad.Text=bdc.text
_ad.Font=ddc;_ad.Parent=bcc;_ad.TextTransparency=a_d;if#cbc>1 then dbc=dbc+c_d.X+3 else dbc=dbc+
c_d.X end end end;bcc.Size=UDim2.new(1,0,0,ccc*_dc)
bcc.BackgroundTransparency=1;bcc.Parent=bbc;return bcc,_cc,dbc end
__b:create("{F679D532-32A5-46B4-9FFB-E7BA60BD7EDB}","BindableFunction","OnInvoke",dca.createTextFragmentLabels)
local function a_c(bbc,cbc,dbc,_cc,acc)local bcc=0;local ccc=0;local dcc=bbc.manifest;for _dc,adc in
pairs(dcc.curve.contents:GetChildren())do
if not adc:isA("UIPadding")then adc:Destroy()end end
if
dcc["pick up"].Visible then bcc=10;dcc.curve.Size=UDim2.new(1,-25,0,28)
dcc.curve.Position=UDim2.new(0.5,25,0.5,0)dcc.LayoutOrder=10 else dcc.curve.Size=UDim2.new(1,0,0,28)
dcc.curve.Position=UDim2.new(0.5,0,0.5,0)end
for _dc,adc in pairs(cbc)do
local bdc=_da:GetTextSize(adc.text,__c.TextSize,__c.Font,Vector2.new())
local cdc=adc.textColor3 or Color3.fromRGB(170,170,170)local ddc=adc.text or""
if not adc.eventType or
(adc.eventType=="key"and adc.id)then local __d=__c:Clone()__d.TextColor3=cdc
__d.Position=UDim2.new(0,bcc,0,ccc)__d.Size=UDim2.new(0,bdc.X,0,bdc.Y)__d.Text=ddc
__d.Parent=dcc.curve.contents
if adc.eventType=="key"and adc.id and adc.keyCode and not
dbc[adc.id]then
dbc[adc.id]=bda.InputBegan:connect(function(a_d)
if

a_d.UserInputType==Enum.UserInputType.Keyboard and a_d.KeyCode==adc.keyCode then if _cc then _cc:Fire(adc.id)end end end)end
if#cbc>1 then bcc=bcc+bdc.X+3 else bcc=bcc+bdc.X end end end
if not acc or bbc.isHiding then bbc.isHiding=false;local _dc=18 +10;if
dcc["pick up"].Visible then bcc=bcc+40;dcc.LayoutOrder=10;_dc=40 end
if acc then dcc.Size=UDim2.new(0,
bcc+15,0,_dc)else local adc=18 +10
if dcc["pick up"].Visible then
dcc.Parent=dcb;dcc.LayoutOrder=10;adc=40 else dcc.Parent=dcb end
local bdc=ada:Create(dcc,cab,{Size=UDim2.new(0,bcc+15,0,adc)})bdc:Play()end end end;local b_c=script:WaitForChild("interactionPrompt")
function dca.createInteractionPrompt(bbc,...)bbc=
bbc or{}local cbc=bbc.itemName or bbc.promptId
local dbc=bbc.value;local _cc={...}local acc=tick()local bcc,ccc,dcc,_dc
if cbc and dab[cbc]then
bcc=dab[cbc].interactionPromptCopy;ccc=dab[cbc].eventsData;dcc=dab[cbc].eventSignal
dab[cbc].textDisplayedTime=acc
if bbc.itemName and dbc then local bdc=dab[cbc].value or 0;dbc=dbc+bdc
dab[cbc].value=dbc
bcc.curve.UIScale.Scale=1.15 +math.clamp(dbc/150,0,0.75)c_b(bcc.curve.UIScale,{"Scale"},1,0.5)end else bcc=b_c:Clone()ccc={}
dcc=Instance.new("BindableEvent")_dc=false
if cbc and not dab[cbc]then dab[cbc]={}
dab[cbc].interactionPromptCopy=bcc;dab[cbc].eventsData=ccc;dab[cbc].eventSignal=dcc
dab[cbc].value=dbc;dab[cbc].textDisplayedTime=acc end end;if dbc and dbc~=1 then
table.insert(_cc,{text="x"..tostring(dbc),textColor3=Color3.fromRGB(120,120,120)})end;local adc={}
do
adc.manifest=bcc;adc.eventSignal=dcc;adc.isHiding=false
local function bdc()
if cbc==nil or
dab[cbc].textDisplayedTime==acc then if ccc then
for ddc,__d in pairs(ccc)do __d:disconnect()end;ccc=nil end
if dcc then dcc:Destroy()dcc=nil end;if bcc then bcc:Destroy()bcc=nil end
if cbc then dab[cbc]=nil end end end;local cdc=18 +10;bcc["pick up"].Visible=false
bcc.mobilePrompt.Visible=false;if bbc.promptId then cdc=40;bcc.LayoutOrder=10;bcc["pick up"].Visible=true
bcc.mobilePrompt.Visible=true end
function adc:close(ddc)
if cbc==nil or
dab[cbc].textDisplayedTime==acc then
if not ddc and bcc then
local __d=ada:Create(bcc,cab,{Size=UDim2.new(0,0,0,cdc)})__d.Completed:connect(function()bdc()end)
__d:Play()elseif ddc then bdc()end end end;function adc:hide(ddc)adc.isHiding=true
local __d=ada:Create(bcc,cab,{Size=UDim2.new(0,0,0,cdc)})__d:Play()end
function adc:setExpireTime(ddc,__d,a_d)
delay(ddc,function()
if
cbc==nil or dab[cbc].textDisplayedTime==acc then if not __d then
adc:close(a_d)else adc:hide(a_d)end end end)end
function adc:setBackgroundColor3(ddc)if bcc then bcc.curve.ImageColor3=ddc end end
function adc:updateTextFragments(ddc,...)if bcc then a_c(adc,{...},ccc,dcc,ddc)end end end;a_c(adc,_cc,ccc,dcc,_dc)return adc end
function dca.showEtcItemPickup(bbc,cbc,dbc)
local _cc=dca.createInteractionPrompt({itemName=bbc.name,value=dbc.stacks or 1},{text="Obtained",textColor3=Color3.fromRGB(120,120,120)},{text=bbc.name,textColor3=Color3.fromRGB(143,120,255)})
_cc:setBackgroundColor3(Color3.fromRGB(190,190,190))_cc:setExpireTime(4)end
local function c_c(bbc,cbc)
local dbc=(cbc.AbsolutePosition-bbc)/cbc.AbsoluteSize
return
dbc.X>=-0.55 and dbc.X<=0.55 and dbc.Y>=-0.55 and dbc.Y<=0.55 end
local function d_c(bbc,cbc,dbc,_cc)if cdb then return false end;if not bbc then return false end
if(cbc==bbc and not
(_cc and _cc.originSlotData))then return false end;cdb=true
if bbc:IsDescendantOf(dbb.yourTrade)then if
cbc:IsDescendantOf(dbb.yourTrade)then bdb.trading.swap(bbc,cbc)else
bdb.trading.clearLocalTradeSlot(bbc)end elseif
bbc:IsDescendantOf(bcb)then
if cbc and cbc:IsDescendantOf(cbb)then
local acc=__b:invoke("{C2C0B93C-33EA-4C01-8C24-1C4E0429CCA2}",bbc)if acc then
local bcc,ccc=__b:invokeServer("{D8C69E55-8192-43C2-9C8F-38D98BEF2E96}",acc)end end elseif bbc:IsDescendantOf(cbb)then
if cbc then
if cbc:IsDescendantOf(_cb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
if acc and bcc=="ability"then bdb.enchant.dragItem(acc)end elseif cbc:IsDescendantOf(bcb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)if acc and bcc=="item"then
local ccc,dcc=__b:invokeServer("{9B6A6C02-E725-410F-8A3D-E553FD395A27}",acc)end elseif
cbc:IsDescendantOf(cbb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
local ccc,dcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",cbc)
if acc and bcc=="item"then local _dc=_ab[acc.id]
local adc=ccc and _ab[ccc.id]or nil
if _dc then
if adc then
if
_dc.category~="equipment"and adc.category~="equipment"and _dc.id==adc.id then
local bdc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local cdc=__b:invokeServer("{6917E7D5-3893-4ADF-8FEF-BA77CCBDD1C3}",bdc,acc.position,ccc.position,acc.stacks)else local bdc=bbc.Image;local cdc=bbc.duplicateCount.Text
bbc.Image=cbc.Image;bbc.duplicateCount.Text=cbc.duplicateCount.Text
cbc.Image=bdc;cbc.duplicateCount.Text=cdc
local ddc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local __d=__b:invokeServer("{FD1E6717-D161-49D9-94DB-999748FE7D5F}",ddc,acc.position,ccc.position)end else
if dbc and _dc.canStack then
local bdc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local cdc=__b:invokeServer("{6917E7D5-3893-4ADF-8FEF-BA77CCBDD1C3}",bdc,acc.position,tonumber(cbc.Parent.Name),1)else local bdc=bbc.Image;local cdc=bbc.duplicateCount.Text;bbc.Image=""
bbc.duplicateCount.Text=""cbc.Image=bdc;cbc.duplicateCount.Text=cdc
local ddc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local __d=__b:invokeServer("{FD1E6717-D161-49D9-94DB-999748FE7D5F}",ddc,acc.position,tonumber(cbc.Parent.Name))end end else end end elseif cbc:IsDescendantOf(bbb.bottomRight.hotbarFrame)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
if acc then
if bcc=="item"then local ccc=_ab[acc.id]
if
ccc and ccc.category=="consumable"and ccc.canBeBound then
local dcc=string.gsub(cbc.Name,"[^.0-9]+","")if tonumber(dcc)==10 then dcc=0 end
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",b_b.dataType.item,acc.id,tonumber(dcc))end elseif bcc=="ability"and not acc.passive then
if acc.id then
local ccc=string.gsub(cbc.Name,"[^.0-9]+","")if tonumber(ccc)==10 then ccc=0 end
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",b_b.dataType.ability,acc.id,tonumber(ccc))end end end elseif cbc:IsDescendantOf(ccb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
local ccc=__b:invoke("{1277F0DD-09D0-4F1C-9F20-408F77D81A00}",cbc)
if acc and bcc=="item"then
if ccc then local dcc=_ab[acc.id]
if dcc and dcc.isEquippable then
local _dc=bbc.Image
local adc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local bdc=__b:invokeServer("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}",adc,acc.position,b_b.equipmentPosition[cbc.Parent.Name])if bdc then bbc.Image=cbc.Image;cbc.Image=_dc end elseif dcc.applyScroll then
local _dc=_ab[acc.id]local adc=true
if _dc.dye then local bdc=_ab[ccc.id]if
not bdb.dyePreview.prompt(_dc,bdc)then adc=false end end
if adc then
local bdc=cbc.AbsolutePosition+cbc.AbsoluteSize/2;local cdc={}if _dc and _dc.playerInputFunction then
cdc=_dc.playerInputFunction()end
local ddc,__d,a_d,b_d=__b:invokeServer("{5FDEEFB3-EF88-4117-9480-ABF7D716D38E}",acc,ccc,"equipment",cdc)if b_d then
spawn(function()wait(0.5)
__b:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",b_d)end)end
if ddc and __d and a_d then
spawn(function()
wait(0.5)
local c_d={color=bdb.itemAcquistion.getTitleColorForInventorySlotData(a_d)or
Color3.new(1,1,1)}bdb.fx.ring(c_d,bdc)end)end end end else local dcc=_ab[acc.id]
if dcc.isEquippable then
local _dc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local adc=__b:invokeServer("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}",_dc,tonumber(bbc.Parent.Name),b_b.equipmentPosition[cbc.Parent.Name])end end end elseif cbc:IsDescendantOf(acb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
if acc and bcc=="item"then local ccc=_ab[acc.id]if ccc then
__b:invoke("{AE54CE76-A031-482B-8639-B3200C582B10}",acc,true)end end elseif cbc:IsDescendantOf(dbb.yourTrade)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)if acc and bcc=="item"then
bdb.trading.setLocalTradeSlot(cbc.Name,acc)end end else
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",bbc)
if acc and bcc=="item"then
local ccc=_ab[acc.id]or{name="...wait what????????"}
local dcc="Are you sure you want to drop your "..ccc.name.."?"
if ccc.soulbound then dcc="DESTROY your "..ccc.name.."?"end;local _dc=bdb.prompting_Fullscreen.prompt(dcc)
if _dc then
if

ccc.soulbound and not
bdb.prompting_Fullscreen.prompt("⚠ ARE YOU SURE you want to DESTROY your "..
ccc.name.."? This action cannot be undone! ⚠")then return false end
local adc,bdc=__b:invokeServer("{7920C078-60F4-43D3-981E-8A4E3113CEC5}",acc)end end end elseif bbc:IsDescendantOf(bbb.bottomRight.hotbarFrame)then
if cbc then
if
cbc:IsDescendantOf(bbb.bottomRight.hotbarFrame)then
local acc=(_cc and _cc.originSlotData)or
__b:invoke("{0DDCC4A0-F15A-41C7-BE2A-50C0EE574D2C}",bbc)
local bcc=__b:invoke("{0DDCC4A0-F15A-41C7-BE2A-50C0EE574D2C}",cbc)local ccc=string.gsub(cbc.Name,"[^.0-9]+","")if
tonumber(ccc)==10 then ccc=0 end
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",acc.dataType,acc.id,tonumber(ccc))local dcc=string.gsub(bbc.Name,"[^.0-9]+","")if
tonumber(dcc)==10 then dcc=0 end
if cbc~=bbc then
if bcc then
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",bcc.dataType,bcc.id,tonumber(dcc))else
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",nil,nil,tonumber(dcc))end end end else
local acc=__b:invoke("{0DDCC4A0-F15A-41C7-BE2A-50C0EE574D2C}",bbc)if acc then
__b:invokeServer("{9D970E47-AEE0-4992-8AE2-702EFA017AA5}",nil,nil,acc.position)end end elseif bbc:IsDescendantOf(ccb)then
if cbc then
if cbc:IsDescendantOf(_cb)then
local acc=__b:invoke("{1277F0DD-09D0-4F1C-9F20-408F77D81A00}",bbc)
if acc then bdb.enchant.dragItem(acc,"equipment")end elseif cbc:IsDescendantOf(cbb)then
local acc,bcc=__b:invoke("{EF630E9A-7A99-4862-9F00-055B1003CD14}",cbc)
local ccc=__b:invoke("{1277F0DD-09D0-4F1C-9F20-408F77D81A00}",bbc)
if acc and bcc=="item"then
if ccc then local dcc=_ab[acc.id]
if dcc and dcc.isEquippable and

bbc.Parent.Name==b_b.getMappingByValue("equipmentPosition",dcc.equipmentSlot)then local _dc=cbc.Image
cbc.Image=bbc.Image;bbc.Image=_dc
local adc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local bdc=__b:invokeServer("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}",adc,acc.position,b_b.equipmentPosition[bbc.Parent.Name])end end else local dcc=_ab[ccc.id]
local _dc=__b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local adc=__b:invokeServer("{243553BE-8CD6-4475-B98B-542B8DE7CA1D}",_dc,tonumber(cbc.Parent.Name),b_b.equipmentPosition[bbc.Parent.Name])end end else end elseif bbc:IsDescendantOf(_cb)then if
cbc==nil or not bbc:IsDescendantOf(_cb)then bdb.enchant.reset()end end;cdb=false end;dca.processSwap=d_c
local function _ac(bbc)local cbc
local function dbc(_cc)
if _cc:IsA("GuiObject")and _cc.Visible then if

_cc:FindFirstChild("draggableFrame")and _cc~=bbc and c_c(adb.AbsolutePosition,_cc)then cbc=_cc end;for acc,bcc in
pairs(_cc:GetChildren())do dbc(bcc)end end end
for _cc,acc in pairs(script.Parent:GetChildren())do dbc(acc)end;return cbc end;local function aac(bbc)for cbc,dbc in pairs(_bb)do if dbc==bbc then return true end end
return false end
local bac=game:GetService("RunService")
local function cac(bbc)
if abb then
if adb.ImageTransparency~=0 then abb.ImageTransparency=0.6
if
abb:IsDescendantOf(cbb)then abb.duplicateCount.Visible=false end;adb.Image=abb.Image;adb.ImageTransparency=0 end
adb.Position=UDim2.new(0,bbc.Position.X-25,0,bbc.Position.Y-25)end end
function dca.drag.setIsDragDropFrame(bbc)if not bbc:IsA("ImageLabel")and not
bbc:IsA("ImageButton")then
error("Only ImageButtons and ImageLabels can be DragDropFrames")return end;if
aac(bbc)then return end
local function cbc(dbc)if not bbc.Active then return false end
if
(dbc.UserInputType==
Enum.UserInputType.MouseButton1 or
dbc.UserInputType==Enum.UserInputType.Touch)and dbc.UserInputState==
Enum.UserInputState.Begin then
if bbc.ImageTransparency<1 then local _cc={}abb=bbc;local acc=tick()local bcc=dbc.Position
repeat
bac.RenderStepped:wait()
if dbc.UserInputType==Enum.UserInputType.Touch then cac(dbc)end
if dbc.UserInputState==Enum.UserInputState.End then
if abb==bbc then
local ccc=dbc.Position;if
tick()-acc>0.1 and a_b.magnitude(bcc-ccc)>26 then local dcc=_ac()
spawn(function()if d_c(bbc,dcc,nil,_cc)then else end end)end end end until dbc.UserInputState==Enum.UserInputState.End or dbc.UserInputState==
Enum.UserInputState.Cancel
if abb==bbc then abb=nil;if bbc:IsDescendantOf(cbb)then
bbc.duplicateCount.Visible=true end;adb.ImageTransparency=1;adb.Position=UDim2.new(-1,-100,
-1,-100)bbc.ImageTransparency=0 end end end end;bbc.InputBegan:connect(cbc)
table.insert(_bb,bbc)end
function dca.setIsDoubleClickFrame(bbc,cbc,dbc)local _cc
bbc.MouseButton1Click:connect(function()
__b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")dbc(bbc)end)
if bbc and bbc.Parent then local acc=Instance.new("UIScale")acc.Parent=bbc
local bcc=bbc.Parent.ZIndex;local ccc
if
bbc.Parent:IsA("ImageLabel")or bbc.Parent:IsA("ImageButton")then ccc=bbc.Parent.ImageColor3 end;local dcc;if bbc.Parent:FindFirstChild("shine")then
dcc=bbc.Parent.shine.ImageTransparency end
bbc.MouseEnter:connect(function()bbc.Parent.ZIndex=
bcc+1;c_b(acc,{"Scale"},{1.1},0.4)if ccc then
c_b(bbc.Parent,{"ImageColor3"},{Color3.new(
ccc.r*0.65,ccc.g*0.65,ccc.b*0.65)},0.6)end
if dcc then c_b(bbc.Parent.shine,{"ImageTransparency"},{
dcc/1.5},0.6)end end)
bbc.MouseLeave:connect(function()bbc.Parent.ZIndex=bcc
c_b(acc,{"Scale"},{1.0},0.4)
if ccc then c_b(bbc.Parent,{"ImageColor3"},{ccc},0.6)end;if dcc then
c_b(bbc.Parent.shine,{"ImageTransparency"},{dcc},0.6)end end)end end;local dac=false
function dca.setIsEnchantingFrame(bbc,cbc)local dbc;local _cc=false
local function acc()
if not dbc then dbc=tick()return end;local bcc=tick()-dbc;if bcc<0.1 then _cc=true end;dbc=nil end;bbc.MouseButton1Click:connect(acc)end
local function _bc(bbc)if
abb and bbc.UserInputType==Enum.UserInputType.MouseMovement then cac(bbc)end end;local function abc(bbc)
if
abb and bbc.UserInputType==Enum.UserInputType.MouseButton2 then local cbc=_ac(abb)if cbc then d_c(abb,cbc,true)end end end
bda.InputChanged:connect(_bc)bda.InputBegan:connect(abc)
for bbc,cbc in
pairs(bbb:GetDescendants())do if cbc.Name=="draggableFrame"then
dca.drag.setIsDragDropFrame(cbc.Parent)end end;return dca