local _a={}function _a.open()end
function _a.close()script.Parent.Visible=false end
local aa={"health potion","health potion 2","wooden club","wooden sword","pitchfork","oak axe"}local ba=game:GetService("ReplicatedStorage")
local ca=require(ba.itemData)
function _a.init(da)local _b=da.network;local ab=da.fx;local bb=da.tween;local cb=da.utilities
local db=da.economy;function _a.close(baa)script.Parent.Visible=false
if not baa then
warn("stop interact")da.interaction.stopInteract()end end;script.Parent.close.Activated:connect(function()
_a.close()end)
local _c;function _a.open()da.focus.toggle(script.Parent)
if
script.Parent.Visible then _b:fire("{89A86833-DEB3-4C09-AB20-848484FA9BCB}")end end;local ac={}
local bc
local function cc()
script.Parent.buy.content.amount.value.Text=tostring(script.Parent.amount.Value)
script.Parent.sell.selling.amount.value.Text=tostring(script.Parent.amount.Value)
if not ac.itemBaseData then script.Parent.sell.Visible=false
script.Parent.sell.item.itemThumbnail.Image=""script.Parent.buy.Visible=false;return end;local baa=ac.itemBaseData.module.Name
for caa,daa in
pairs(script.Parent.curve.contents:GetChildren())do
if daa:IsA("ImageButton")then
if daa.Name~=baa then
daa.ImageColor3=Color3.fromRGB(30,30,30)
daa.frame.Inner.ImageColor3=Color3.fromRGB(30,30,30)else daa.ImageColor3=Color3.fromRGB(9,39,58)
daa.frame.Inner.ImageColor3=Color3.fromRGB(9,39,58)end end end
if ac.itemBaseData then
script.Parent.sell.selling.Visible=true;script.Parent.sell.Visible=true
if ac.itemBaseData.name then
if
script.Parent.buy.Visible and ac.itemBaseData.buyValue then
script.Parent.buy.content.itemName.Text=ac.itemBaseData.name
script.Parent.buy.item.itemThumbnail.Image=
ac.itemBaseData.image or"rbxassetid://2679574493"
if ac.costInfo then
da.money.setLabelAmount(script.Parent.buy.content.cost,ac.cost*
script.Parent.amount.Value,ac.costInfo)else
local caa=_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData").statistics_final
local daa=1 -math.clamp(caa.merchantCostReduction,0,1)
da.money.setLabelAmount(script.Parent.buy.content.cost,math.clamp(ac.cost*
script.Parent.amount.Value*daa,1,math.huge),ac.costInfo)end elseif script.Parent.sell.Visible then
script.Parent.sell.selling.itemName.Text=ac.itemBaseData.name
script.Parent.sell.item.itemThumbnail.Image=
ac.itemBaseData.image or"rbxassetid://2679574493"local caa=ac.inventorySlotData or{}local daa;if caa then
daa=da.itemAcquistion.getTitleColorForInventorySlotData(caa)end;script.Parent.sell.selling.itemName.TextColor3=
daa or Color3.new(1,1,1)
local _ba=script.Parent.sell.item.curve;_ba.stars.Visible=false;local aba=caa.successfulUpgrades
if aba then
for cba,dba in
pairs(_ba.stars:GetChildren())do
if dba:IsA("ImageLabel")then
dba.ImageColor3=daa or Color3.new(1,1,1)dba.Visible=false elseif dba:IsA("TextLabel")then
dba.TextColor3=daa or Color3.new(1,1,1)dba.Visible=false end end;_ba.stars.Visible=true
if aba<=3 then for cba,dba in
pairs(_ba.stars:GetChildren())do local _ca=tonumber(dba.Name)
if _ca then dba.Visible=_ca<=aba end end
_ba.stars.exact.Visible=false else _ba.stars["1"].Visible=true
_ba.stars.exact.Visible=true;_ba.stars.exact.Text=aba end;_ba.stars.Visible=true end
local bba=db.getSellValue(ac.itemBaseData,ac.inventorySlotData)
da.money.setLabelAmount(script.Parent.sell.selling.cost,(bba)*
script.Parent.amount.Value)end end else script.Parent.buy.Visible=false
script.Parent.sell.Visible=false end end
local function dc()ac={}script.Parent.ethyr.Visible=false;cc()if
da.input.mode.Value=="xbox"then
game.GuiService.SelectedObject=script.Parent.sell.item.itemThumbnail end end;dc()
local function _d()
if script.Parent.buy.Visible and bc then
if ac.itemBaseData then
if
ac.itemBaseData.buyValue then local baa=ac.itemBaseData.id
local caa=script.Parent.amount.Value;local daa=ac.costInfo
local _ba,aba=_b:invokeServer("{346E0AEC-179E-46F7-A37F-910E02933FDD}",{id=baa,costInfo=daa},caa,bc)
if _ba then
ab.statusRibbon(script.Parent,"Bought "..ac.itemBaseData.name,"success",3)else
ab.statusRibbon(script.Parent,"Failed to purchase.","fail",3)warn(aba)
if daa.costType=="ethyr"then da.products.open()end end;dc()end end end end
script.Parent.buy.content.no.MouseButton1Click:connect(dc)
script.Parent.sell.selling.no.MouseButton1Click:connect(dc)
script.Parent.amount.Changed:connect(cc)
local function ad(baa,caa,daa)script.Parent.sell.Visible=false
script.Parent.buy.Visible=true;if da.input.mode.Value=="xbox"then
game.GuiService.SelectedObject=script.Parent.buy.content.no end
if ac.itemBaseData and
ac.itemBaseData.name==baa and
script.Parent.amount.Value==1 then cc()end;script.Parent.amount.Value=1 end
local function bd(baa)script.Parent.sell.Visible=true
script.Parent.sell.selling.Visible=true;script.Parent.buy.Visible=true
if ac.itemBaseData and ac.itemBaseData.name==
baa and
script.Parent.amount.Value==1 then cc()end;script.Parent.amount.Value=1 end
local function cd(baa,caa,daa,_ba)local aba=baa.id;local bba=baa.position;local cba=baa.stacks or 1
script.Parent.amount.Value=cba
ac={id=aba,inventorySlotDataPosition=bba,inventorySlotData=baa,itemBaseData=ca[aba],cost=daa,costInfo=_ba}script.Parent.buy.Visible=not caa;script.Parent.sell.Visible=
not not caa;cc()end
_b:create("{AE54CE76-A031-482B-8639-B3200C582B10}","BindableFunction","OnInvoke",cd)
local function dd()
if script.Parent.sell.Visible and
script.Parent.sell.selling.Visible then
if not ac.itemBaseData then dc()return end;local baa=ac.itemBaseData.name
if ac.itemBaseData then
if ac.itemBaseData.cantSell then return false end;local caa=ac.itemBaseData.name;local daa=ac.id
local _ba=script.Parent.amount.Value
local aba=_b:invoke("{84775882-4247-4E60-9AC0-54F2E601087E}")
local bba=_b:invokeServer("{E78B3F0F-50E6-4DAD-83C1-CC9AC8419699}",{id=daa,position=ac.inventorySlotDataPosition},_ba)if bba then
ab.statusRibbon(script.Parent,"Sold "..caa,"gold",3)else
ab.statusRibbon(script.Parent,"'fraid you can't do that :/","fail",3)end
dc()end end end
script.Parent.buy.content.yes.MouseButton1Click:connect(_d)
script.Parent.sell.selling.yes.MouseButton1Click:connect(dd)local function __a()
if script.Parent.amount.Value<999 then script.Parent.amount.Value=
script.Parent.amount.Value+1 end end;local function a_a()
if
script.Parent.amount.Value>1 then script.Parent.amount.Value=
script.Parent.amount.Value-1 end end;local function b_a()
local baa=tonumber(script.Parent.buy.content.amount.value.Text)
if baa then script.Parent.amount.Value=baa;cc()end end;local function c_a()
local baa=tonumber(script.Parent.sell.selling.amount.value.Text)
if baa then script.Parent.amount.Value=baa;cc()end end
script.Parent.buy.content.amount.increase.MouseButton1Click:connect(__a)
script.Parent.buy.content.amount.decrease.MouseButton1Click:connect(a_a)
script.Parent.sell.selling.amount.increase.MouseButton1Click:connect(__a)
script.Parent.sell.selling.amount.decrease.MouseButton1Click:connect(a_a)
script.Parent.buy.content.amount.value.FocusLost:connect(b_a)
script.Parent.sell.selling.amount.value.FocusLost:connect(c_a)local d_a
local _aa=script.Parent.curve.contents:WaitForChild("sampleItem")_aa.Visible=false;_aa.Parent=script
local function aaa()
script.Parent.ethyr.Visible=false
for caa,daa in
pairs(script.Parent.curve.contents:GetChildren())do if
daa:IsA("GuiObject")and daa:FindFirstChild("itemName")then daa:Destroy()end end;local baa=0
for caa,daa in pairs(_c)do local _ba;local aba;local bba
if typeof(daa)=="string"then _ba=daa;aba={}elseif typeof(daa)==
"table"then _ba=daa.itemName;aba=daa.costInfo;if aba and aba.costType and
aba.costType=="ethyr"then end;bba=daa.cost else
error("Invalid shopItemInfo type. Failed to refresh shop inventory.")end;local cba=ca[_ba]
if cba and cba.name then
local dba=aba and aba.costType or"money"bba=bba or cba.buyValue
if bba and dba then local _ca=_aa:Clone()_ca.Name=_ba
_ca.itemName.Text=cba.name;local aca=cba.itemType
_ca.itemName.cuteDecor.Image="rbxgameasset://Images/category_"..aca
_ca.item.itemThumbnail.Image=cba.image or"rbxassetid://2679574493"da.money.setLabelAmount(_ca.cost,bba,aba)
_ca.Parent=script.Parent.curve.contents;_ca.LayoutOrder=caa;_ca.Visible=true
_ca.MouseButton1Click:connect(function()
cd(cba,nil,bba,aba)ad(_ba,bba,aba)end)
_ca.item.itemThumbnail.MouseButton1Click:connect(function()
cd(cba,nil,bba,aba)ad(_ba,bba,aba)end)local bca={id=cba.id}
if daa.attributes then for ada,bda in pairs(daa.attributes)do if not bca[ada]then
bca[ada]=bda end end end;local function cca()
_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",cba,"shop",bca)d_a=_ca end
local function dca()if d_a==_ca then
_b:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end
_ca.item.itemThumbnail.MouseEnter:connect(cca)
_ca.item.itemThumbnail.MouseLeave:connect(dca)_ca.SelectionGained:connect(cca)
_ca.SelectionLost:connect(dca)local _da;if cba then
_da=da.itemAcquistion.getTitleColorForInventorySlotData(bca)end;_ca.shine.Visible=_da~=nil;_ca.shine.ImageColor3=
_da or Color3.fromRGB(179,178,185)_ca.frame.ImageColor3=
_da or Color3.fromRGB(106,105,107)_ca.shine.ImageColor3=
_da or Color3.fromRGB(179,178,185)_ca.itemName.TextColor3=
_da or Color3.new(1,1,1)
da.fx.setFlash(_ca.frame,_ca.shine.Visible)baa=baa+1 end end end
script.Parent.curve.contents.CanvasSize=UDim2.new(0,0,0,20 +
math.ceil(baa)* (70 +5))end
function _a.open(baa)dc()
script.Parent.curve.contents.CanvasPosition=Vector2.new()
if script.Parent.Visible then
script.Parent.Visible=not script.Parent.Visible else _b:fire("{89A86833-DEB3-4C09-AB20-848484FA9BCB}")
if baa then
if
baa:FindFirstChild("inventory")then bc=baa.inventory;_c=require(baa.inventory)
if
bc:FindFirstChild("shopName")then
script.Parent.header.itemType.Text=bc:FindFirstChild("shopName").Value else
script.Parent.header.itemType.Text="Merchant"end else bc=nil;_c={}end;if baa:IsA("BasePart")then end end;aaa()script.Parent.Visible=true end end
_b:create("{D839BF28-4985-4BB5-86EF-DCD6824CF09F}","BindableFunction","OnInvoke",_a.open)end;return _a