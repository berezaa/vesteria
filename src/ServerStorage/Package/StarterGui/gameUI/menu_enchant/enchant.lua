local _b={}local ab=game:GetService("ReplicatedStorage")
local bb=require(ab.modules)local cb=bb.load("network")local db=bb.load("utilities")
local _c=bb.load("mapping")local ac=bb.load("enchantment")
local bc=require(ab.abilityLookup)function _b.dragItem(dc)end;local cc
function _b.init(dc)local _d=dc.tween;local ad=dc.localization
function _b.close()
script.Parent.Visible=false;dc.playerMenu.closeSelected()if
script.Parent.Parent.Parent.Visible then
dc.focus.toggle(script.Parent.Parent.Parent)end end
local function bd(bba,cba,dba)bba=bba or 1;cba=cba or 1
for i=1,bba do
local _ca=dba or math.random(1,3)==2 and
math.random(2,6)/2 or 1;local aca=script.Parent.sprite:Clone()
local bca=UDim2.new(math.random(),0,1,0)aca.Position=bca;local cca=math.random(40,150)/100
aca.Parent=script.Parent.curve.sprites;aca.ImageTransparency=1;aca.Size=UDim2.new(0,10,0,10)
aca.Visible=true
local dca=UDim2.new(bca.X.Scale,math.random(-50,50)*cca*cba,bca.Y.Scale,-
math.random(20,200)*cca*cba)cca=cca*_ca;game.Debris:AddItem(aca,cca+0.1)
_d(aca,{"Position"},dca,cca)
_d(aca,{"Size"},UDim2.new(0,20 *_ca,0,20 *_ca),cca/2)
spawn(function()wait(cca/2)
_d(aca,{"Size"},UDim2.new(0,10,0,10),cca/2)end)local _da=math.random(30,40)/100
_d(aca,{"ImageTransparency"},{1 -
(1 -_da)/_ca^2},cca/4)
spawn(function()wait(cca*3 /4)
_d(aca,{"ImageTransparency"},{1},cca/4)end)end end
spawn(function()while wait(1)do for i=1,15 do
delay(math.random(),function()bd()end)end end end)local cd=script.Parent;local dd=false;local __a;local a_a;local b_a
function _b.reset()
for bba,cba in
pairs(cd.enchantments.contents:GetChildren())do if cba:IsA("GuiObject")then cba:Destroy()end end
_d(cd.button,{"ImageColor3"},{Color3.fromRGB(113,113,113)},0.5)cd.cost.Visible=false
cd.input.equipItemButton.Image="rbxassetid://2528902611"cd.input.equipItemButton.ImageTransparency=0.6
cd.input.equipItemButton.ImageColor3=Color3.new(1,1,1)cd.input.shine.Visible=false
cd.input.frame.Visible=false;cd.output.equipItemButton.ImageTransparency=1
cd.output.frame.Visible=false;cd.output.shine.Visible=false
cd.output.ImageTransparency=0.4;__a=nil;a_a=nil;b_a=nil end;local c_a;local d_a
function _b.open(bba)cc=bba;_b.reset()
dc.playerMenu.selectMenu(script.Parent,dc[script.Name])cb:fire("{E1E81CAA-958F-4A3C-998E-9C3E44528FF8}")end;local _aa={}local aaa
local function baa(bba,cba)c_a=bba;_aa={}aaa=nil
d_a=cb:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local dba=bc[cba.id](d_a)
for bca,cca in
pairs(cd.enchantments.contents:GetChildren())do if cca:IsA("GuiObject")then cca:Destroy()end end;bba.Image=dba.image;bba.ImageColor3=Color3.new(1,1,1)
bba.Parent.frame.Visible=true;bba.Parent.shine.Visible=true
bba.Parent.ImageTransparency=0;bba.ImageTransparency=0;local _ca=dba.metadata
if _ca then
if
_ca.upgradeCost and _ca.maxRank then
if cba.rank<_ca.maxRank then
local bca=cd.enchantments.sampleItem:Clone()bca.item.itemThumbnail.Image=dba.image;local cca=dba.name and
ad.translate(dba.name)or"???"bca.itemName.Text=
cca.." +"..cba.rank;bca.locked.Visible=false
bca.LayoutOrder=1;bca.Parent=cd.enchantments.contents;bca.abilityPoints.amount.Text=
_ca.upgradeCost.." AP"bca.Visible=true
_aa[bca]={id=cba.id,request="upgrade"}
local function dca()if not bca.locked.Visible then
cb:invoke("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}",dba,cba.rank,dba,cba.rank+1)end end;bca.MouseEnter:connect(dca)
bca.SelectionGained:connect(dca)bca.item.itemThumbnail.Active=false;local function _da()
cb:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end
bca.MouseLeave:connect(_da)bca.SelectionLost:connect(_da)end end
if _ca.variants then
if
cba.variant==nil or _ca.variants[cba.variant].default then
for bca,cca in pairs(_ca.variants)do
if cca.cost and not cca.default then local dca={variant=bca}local _da=bc[cba.id](
nil,dca)
if _da then
local ada=cd.enchantments.sampleItem:Clone()ada.item.itemThumbnail.Image=_da.image;local bda=_da.name and
ad.translate(_da.name)or"???"
ada.itemName.Text=
bda.. (cba.rank>1 and(" +".. (cba.rank-1))or"")ada.abilityPoints.amount.Text=cca.cost.." AP"
if
cca.requirement and cca.requirement(d_a)then ada.locked.Visible=false
ada.LayoutOrder=3 else ada.locked.Visible=true;ada.LayoutOrder=5 end;ada.Parent=cd.enchantments.contents;ada.Visible=true
_aa[ada]={id=cba.id,request="variant",variant=bca}ada.item.itemThumbnail.Active=false
local function cda()if
not ada.locked.Visible then
cb:invoke("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}",dba,cba.rank,_da,cba.rank)end end;ada.MouseEnter:connect(cda)
ada.SelectionGained:connect(cda)local function dda()
cb:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end
ada.MouseLeave:connect(dda)ada.SelectionLost:connect(dda)end end end end end end
for bca,cca in
pairs(cd.enchantments.contents:GetChildren())do if cca:IsA("GuiObject")then
cca.Activated:connect(function()aaa=cca
_d(cd.button,{"ImageColor3"},{Color3.fromRGB(87,211,217)},0.5)end)end end;local aca;aca=aca or Color3.new(1,1,1)
bba.Parent.frame.ImageColor3=
aca or Color3.fromRGB(106,105,107)
bba.Parent.shine.ImageColor3=aca or Color3.fromRGB(179,178,185)
bba.Parent.shine.ImageTransparency=aca and 0.47 or 0.63 end
cd.button.Activated:Connect(function()if not __a then return false end
if not aaa then return false end;local bba=_aa[aaa]
if not dd then dd=true
local cba,dba=cb:invokeServer("{1027F153-81C2-4933-9BAE-25D65DC9F81D}",cc,bba)
if cba then aaa=nil;cd.curve.shine.ImageTransparency=0
cd.curve.shine.ImageColor3=Color3.fromRGB(0,230,255)bd(70,1.5)
_d(cd.curve.shine,{"ImageTransparency","ImageColor3"},{0.5,Color3.fromRGB(14,123,125)},1)db.playSound("itemEnchanted")
_d(cd.button,{"ImageColor3"},{Color3.fromRGB(113,113,113)},0.5)else warn("No enchanting allowed"..dba)end;dd=false end end)
function _b.dragItem(bba,cba)_b.reset()
cd.input.equipItemButton.ImageTransparency=0
cd.input.equipItemButton.ImageColor3=Color3.new(1,1,1)b_a=cba;__a=bba;baa(cd.input.equipItemButton,__a)if a_a then end end
local function caa()
if __a then
d_a=cb:invoke("{4947D6C0-3492-484E-8D54-243215910D55}")local bba=bc[__a.id](d_a)
cb:invoke("{03F015DE-FE75-4209-A7CE-C4F8CCE70EC5}",bba,__a.rank)end end;local function daa()
cb:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end
local function _ba(bba)if __a then
for cba,dba in pairs(bba)do if dba.id==__a.id then __a=dba
baa(cd.input.equipItemButton,dba)break end end end end
local function aba(bba,cba)if bba=="abilities"then _ba(cba)end end
cb:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",aba)
cd.input.equipItemButton.MouseEnter:connect(caa)
cd.input.equipItemButton.SelectionGained:connect(caa)
cd.input.equipItemButton.MouseLeave:connect(daa)
cd.output.equipItemButton.MouseLeave:connect(daa)end;return _b