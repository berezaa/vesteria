local bb={}local cb=game:GetService("ReplicatedStorage")
local db=require(cb.modules)local _c=db.load("network")local ac=db.load("utilities")
local bc=db.load("mapping")local cc=db.load("configuration")local dc=require(cb.itemData)
local _d=game.Players.LocalPlayer;local ad=script.Parent;local bd={}
function bb.postInit(cd)local dd=cd.network
local function __a(b_a)lastSelected=b_a
local c_a=bd[b_a]
if c_a then local d_a=dc[c_a.id]if d_a then
dd:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",d_a,"inventory",c_a)end end end
local function a_a(b_a)if lastSelected==b_a then
dd:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end
for b_a,c_a in pairs(script.Parent:GetDescendants())do
if
c_a:IsA("GuiObject")and c_a:FindFirstChild("draggableFrame")then c_a.MouseEnter:connect(function()
__a(c_a)end)c_a.MouseLeave:connect(function()
a_a(c_a)end)c_a.SelectionGained:connect(function()
__a(c_a)end)c_a.SelectionLost:connect(function()
a_a(c_a)end)end end end
function bb.init(cd)local dd=ad.yourTrade;local __a=ad.theirTrade;local a_a=nil;local b_a;local c_a=nil
local function d_a()
if
dd.amount.Visible then
if dd.amount.TextBox.Text~=""then
local cba=_c:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","gold")
dd.amount.TextBox.Text=tostring(math.clamp(
tonumber(dd.amount.TextBox.Text)or 0,0,tonumber(cba)))dd.add.ImageColor3=Color3.new(0,1,0)
dd.add.inner.Text=">"else dd.add.ImageColor3=Color3.new(1,0,0)
dd.add.inner.Text="-"end end end;local function _aa(cba)end;local function aaa(cba)if c_a then end end;local function baa()end
local function caa(cba)
return


cba.playerTradeSessionData_player1.player==_d and cba.playerTradeSessionData_player1 or cba.playerTradeSessionData_player2,
cba.playerTradeSessionData_player1.player==_d and
cba.playerTradeSessionData_player2 or cba.playerTradeSessionData_player1 end
function bb.startTrade(cba)local dba,_ca=caa(cba)__a.title.Text=_ca.player.Name
dd.title.Text="Your offer"ad.Visible=true;a_a=cba;c_a={}cd.equipment.hide()
script.Parent.Visible=true;if not script.Parent.Parent.Parent.Visible then
cd.playerMenu.open()end end
function bb.endTrade(cba)ad.Visible=false;cd.equipment.show()if cba and a_a then
_c:invokeServer("{E19F4AF9-ED86-4E1B-B157-66AFF77A1928}",a_a.guid)end;c_a=nil;a_a=nil end;bb.tradeCollection={}function bb.clearLocalTradeSlot(cba)bd[cba]=nil;bb.tradeCollection[cba.Name]=
nil end
function bb.setLocalTradeSlot(cba,dba)
local _ca=dc[dba.id]
for aca,bca in pairs(bb.tradeCollection)do
if bca and bca.position==dba.position then
local cca=dc[bca.id]
if _ca and cca then if _ca.category==cca.category then
bb.tradeCollection[tostring(aca)]=nil end end end end;dba.stacks=dba.stacks or 1
bb.tradeCollection[tostring(cba)]=dba
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"inventoryTransferDataCollection",bb.tradeCollection)end
function bb.processDoubleClickFromInventory(cba)
if cba then local dba=dc[cba.id]
if dba then local _ca={}
for aca,bca in pairs(bb.tradeCollection)do
if bca then
_ca[aca]=true
if bca.id==cba.id and bca.position==cba.position then bb.tradeCollection[aca]=
nil;return
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"inventoryTransferDataCollection",bb.tradeCollection)end end end
for aca,bca in pairs(ad.yourTrade.contents:GetChildren())do
if
bca:IsA("GuiButton")and not _ca[bca.Name]then
bb.tradeCollection[bca.Name]=cba;return
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"inventoryTransferDataCollection",bb.tradeCollection)end end end end end
function bb.swap(cba,dba)local _ca=bd[cba]local aca=bd[dba]
bb.tradeCollection[cba.Name]=aca;bb.tradeCollection[dba.Name]=_ca
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"inventoryTransferDataCollection",bb.tradeCollection)end
local function daa(cba)if a_a~=cba then bb.startTrade(cba)end;if cba.state=="canceled"or
cba.state=="completed"then bb.tradeCollection={}
bb.endTrade()end
ad.countdown.Visible=false
if cba.state=="countdown"then ad.countdown.Text="6"
ad.countdown.Visible=true
spawn(function()local _da=6;while
a_a.state=="countdown"and ad.countdown.Text==tostring(_da)and _da>0 do _da=_da-1
ad.countdown.Text=tostring(_da)wait(1)end;if _da<=
0 then ad.countdown.Visible=false end end)end
local dba=
(cba.playerTradeSessionData_player1.player==_d and
cba.playerTradeSessionData_player1)or
(
cba.playerTradeSessionData_player2.player==_d and cba.playerTradeSessionData_player2)or{}
local _ca=
(cba.playerTradeSessionData_player1.player==_d and
cba.playerTradeSessionData_player2)or
(
cba.playerTradeSessionData_player2.player==_d and cba.playerTradeSessionData_player1)or{}
cd.money.setLabelAmount(ad.yourTrade.gold,dba.gold or 0)
cd.money.setLabelAmount(ad.theirTrade.gold,_ca.gold or 0)ad.yourTrade.approved.Visible=false
ad.yourTrade.denied.Visible=false;ad.theirTrade.approved.Visible=false
ad.theirTrade.denied.Visible=false;ad.yourTrade.ImageColor3=Color3.fromRGB(189,189,189)
ad.theirTrade.ImageColor3=Color3.fromRGB(139,139,139)
if _ca.state=="approved"then ad.theirTrade.approved.Visible=true
ad.theirTrade.ImageColor3=Color3.fromRGB(136,192,132)elseif _ca.state=="denied"then ad.theirTrade.denied.Visible=true
ad.theirTrade.ImageColor3=Color3.fromRGB(188,109,111)end
if dba.state=="approved"then ad.yourTrade.approved.Visible=true
ad.yourTrade.ImageColor3=Color3.fromRGB(97,141,98)elseif dba.state=="denied"then ad.yourTrade.denied.Visible=true
ad.yourTrade.ImageColor3=Color3.fromRGB(138,87,88)end;local aca=dba.inventoryTransferDataCollection or{}local bca=
_ca.inventoryTransferDataCollection or{}bb.tradeCollection=aca
local cca=ad.yourTrade.contents:GetChildren()
for _da,ada in pairs(cca)do
if ada:IsA("ImageButton")then ada.Image=""bd[ada]=nil
ada.duplicateCount.Visible=false;local bda=aca[ada.Name]or{}
if bda then local cda=dc[bda.id]
if cda then
ada.Image=cda.image;ada.ImageColor3=Color3.new(1,1,1)if bda.dye then
ada.ImageColor3=Color3.fromRGB(bda.dye.r,bda.dye.g,bda.dye.b)end;bd[ada]=bda end
if bda.stacks and bda.stacks>1 then
ada.duplicateCount.Text=tostring(bda.stacks)ada.duplicateCount.Visible=true end end end end
local dca=ad.theirTrade.contents:GetChildren()
for _da,ada in pairs(dca)do
if ada:IsA("ImageButton")then ada.Image=""bd[ada]=nil
ada.duplicateCount.Visible=false;local bda=bca[ada.Name]or{}
if bda then local cda=dc[bda.id]
if cda then
ada.Image=cda.image;ada.ImageColor3=Color3.new(1,1,1)if bda.dye then
ada.ImageColor3=Color3.fromRGB(bda.dye.r,bda.dye.g,bda.dye.b)end;bd[ada]=bda end
if bda.stacks and bda.stacks>1 then
ada.duplicateCount.Text=tostring(bda.stacks)ada.duplicateCount.Visible=true end end end end end
local function _ba(cba)
cd.money.setLabelAmount(ad.yourTrade.gold,tonumber(cba))
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"gold",tonumber(cba))end
local function aba()
if dd.amount.Visible then
if dd.amount.TextBox.Text~=""then
local cba=_c:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","gold")
local dba=tostring(math.clamp(tonumber(dd.amount.TextBox.Text)or 0,0,tonumber(cba)))if dba then _ba(dba)end end;dd.amount.Visible=false
dd.add.ImageColor3=Color3.new(1,1,0)dd.add.inner.Text="+"else dd.amount.TextBox.Text=""
dd.amount.Visible=true;dd.add.ImageColor3=Color3.new(1,0,0)
dd.add.inner.Text="-"end end
local function bba(cba,dba)
local _ca=_c:invoke("{DD5DD505-12AB-4E39-B224-2F36AD7629FC}",cba.Name.." wants to trade! Would you like to trade with them?")if _ca then
_c:invokeServer("{2681E5E8-E682-40E8-9D85-069793E724AF}",dba)end end
ad.buttons.leave.Activated:connect(function()bb.endTrade(true)end)
ad.buttons.accept.Activated:connect(function()
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"state","approved")end)
ad.buttons.deny.Activated:connect(function()
_c:invokeServer("{704827CF-86F6-4225-B83C-8986C104F12D}",a_a.guid,"state","denied")end)dd.add.MouseButton1Click:connect(aba)
dd.amount.TextBox:GetPropertyChangedSignal("Text"):connect(d_a)
_c:connect("{B9B41A65-A85E-4D55-92C9-43350C1DC213}","OnClientEvent",bba)
_c:connect("{37905E93-119E-4D0E-ACAC-65E10D9A62C0}","OnClientEvent",daa)end;return bb