local _c={}local ac=game:GetService("ReplicatedStorage")
local bc=require(ac.modules)local cc=bc.load("network")local dc=bc.load("utilities")
local _d=bc.load("mapping")local ad=bc.load("enchantment")
local bd=require(ac:WaitForChild("itemData"))
local cd=require(ac:WaitForChild("itemAttributes"))local dd=script.Parent.content
local __a=script.Parent.character.ViewportFrame;local a_a=game.Players.LocalPlayer;function _c.show()script.Parent.Visible=not
script.Parent.Visible end;function _c.hide()
script.Parent.Visible=false end
script.Parent.close.Activated:connect(_c.hide)local b_a={}local c_a
function _c.init(d_a)
local function _aa()local _ca={}
local aca=cc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","inventory")for bca,cca in pairs(aca)do
if _ca[cca.id]then
_ca[cca.id]=_ca[cca.id]+ (cca.stacks or 1)else _ca[cca.id]=cca.stacks or 1 end end;return _ca end
local function aaa(_ca)c_a=_ca;local aca=b_a[_ca]
if aca then local bca=bd[aca.id]if bca then
cc:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",bca,"equipment",aca)end end end
local function baa(_ca)if c_a==_ca then
cc:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end;local function caa(_ca,aca)
for bca,cca in pairs(_ca)do if cca.position==aca then return cca end end end
local function daa(_ca)_ca=_ca or
cc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")
b_a={}
for a_b,b_b in pairs(_ca)do
local c_b=_d.getMappingByValue("equipmentPosition",b_b.position)
if c_b and b_b.id and dd:FindFirstChild(c_b)then
local d_b=bd[b_b.id]local _ab=dd[c_b].equipItemButton
if d_b then _ab.Image=d_b.image
_ab.ImageColor3=Color3.new(1,1,1)if b_b.dye then
_ab.ImageColor3=Color3.fromRGB(b_b.dye.r,b_b.dye.g,b_b.dye.b)end;b_a[_ab]=b_b
_ab.Parent.frame.Visible=true;if _ab.Parent:FindFirstChild("icon")then
_ab.Parent.icon.Visible=false end;_ab.Parent.ImageTransparency=0
_ab.Parent.title.TextTransparency=0;_ab.Parent.title.TextStrokeTransparency=0.2;local aab,bab;if b_b then
aab,bab=d_a.itemAcquistion.getTitleColorForInventorySlotData(b_b)end;local cab=_ab.Parent
cab.attribute.Visible=false;if b_b.attribute then local _bb=cd[b_b.attribute]
if _bb and _bb.color then
cab.attribute.ImageColor3=_bb.color;cab.attribute.Visible=true end end
cab.stars.Visible=false;local dab=b_b.successfulUpgrades
if dab then
for _bb,abb in
pairs(cab.stars:GetChildren())do
if abb:IsA("ImageLabel")then
abb.ImageColor3=aab or Color3.new(1,1,1)abb.Visible=false elseif abb:IsA("TextLabel")then
abb.TextColor3=aab or Color3.new(1,1,1)abb.Visible=false end end;cab.stars.Visible=true
if dab<=3 then for _bb,abb in
pairs(cab.stars:GetChildren())do local bbb=tonumber(abb.Name)
if bbb then abb.Visible=bbb<=dab end end
cab.stars.exact.Visible=false else cab.stars["1"].Visible=true
cab.stars.exact.Visible=true;cab.stars.exact.Text=dab end;cab.stars.Visible=true end
_ab.Parent.shine.Visible=aab~=nil and bab and bab>1
d_a.fx.setFlash(_ab.Parent.frame,_ab.Parent.shine.Visible)_ab.Parent.frame.ImageColor3=(bab and bab>1 and aab)or
Color3.fromRGB(106,105,107)
_ab.Parent.shine.ImageColor3=
aab or Color3.fromRGB(179,178,185)
if b_b.position==_d.equipmentPosition.weapon then
local _bb=caa(_ca,_d.equipmentPosition.arrow)local abb=caa(_ca,_d.equipmentPosition.weapon)
if abb and
bd[abb.id].equipmentType=="bow"then
if _bb then local bbb=_aa()dd.weapon.ammo.amount.Text=tostring(
bbb[_bb.id]or 0)
dd.weapon.ammo.icon.Image=bd[_bb.id].image;dd.weapon.ammo.Visible=true else
dd.weapon.ammo.Visible=false end else dd.weapon.ammo.Visible=false end end end end end
for a_b,b_b in pairs(dd:GetChildren())do
if b_b:FindFirstChild("frame")and not
b_a[b_b.equipItemButton]then
b_b.equipItemButton.Image=""local c_b=b_b;c_b.frame.Visible=false;c_b.shine.Visible=false;if
c_b:FindFirstChild("icon")then c_b.icon.Visible=true end
c_b.stars.Visible=false;c_b.attribute.Visible=false;c_b.ImageTransparency=0
c_b.title.TextTransparency=0.6;c_b.title.TextStrokeTransparency=0.6 end end
if __a:FindFirstChild("entity")then __a.entity:Destroy()end
if __a:FindFirstChild("entity2")then __a.entity2:Destroy()end;local aca=__a.CurrentCamera;if aca==nil then aca=Instance.new("Camera")
aca.Parent=__a;__a.CurrentCamera=aca end
local bca=game.Players.LocalPlayer;local cca=bca.Character;local dca=__a.characterMask;local _da={}
_da.equipment=cc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","equipment")
_da.accessories=cc:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","accessories")
local ada=cc:invoke("{01474D9A-12D0-4C30-90B0-649477E2B77A}",dca,_da or{},bca)ada.Parent=workspace.CurrentCamera
local bda=ada.entity:WaitForChild("AnimationController")
local cda=cc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",ada.entity)local dda;do
if cda["1"]then dda=cda["1"].baseData.equipmentType end end
local __b=cc:invoke("{F22A757B-3CF2-4CEE-ACF2-466C636EF6BB}",bda,"idling",dda,nil)
if __b then
spawn(function()
if ada then local a_b=ada.entity
local b_b=
CFrame.new(a_b.PrimaryPart.Position+
a_b.PrimaryPart.CFrame.lookVector*6.5,a_b.PrimaryPart.Position)*CFrame.new(-1,0,0)
aca.CFrame=CFrame.new(b_b.p+Vector3.new(0,1.5,0),a_b.PrimaryPart.Position+
Vector3.new(0,0.5,0))end
if typeof(__b)=="Instance"then __b:Play()elseif typeof(__b)=="table"then for a_b,b_b in pairs(__b)do
b_b:Play()end end
while true do wait(0.1)
if typeof(__b)=="Instance"then if __b.Length>0 then break end elseif
typeof(__b)=="table"then local a_b=true
for b_b,c_b in pairs(__b)do if __b.Length==0 then a_b=false end end;if a_b then break end end end
if ada then local a_b=ada.entity;a_b.Parent=__a;ada:Destroy()end end)else local a_b=bda:LoadAnimation(dca.idle)a_b.Looped=true
a_b.Priority=Enum.AnimationPriority.Idle;a_b:Play()end end;local function _ba(_ca)return b_a[_ca]end;local aba=d_a.levels;local bba=d_a.tween;local function cba(_ca,aca)if
_ca=="equipment"then daa(aca)end end;_c.update=function(...)
daa(...)end
local function dba()
cc:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",cba)
cc:create("{1277F0DD-09D0-4F1C-9F20-408F77D81A00}","BindableFunction","OnInvoke",_ba)
for _ca,aca in
pairs(script.Parent.content:GetChildren())do
if aca:FindFirstChild("equipItemButton")then
aca.equipItemButton.MouseEnter:connect(function()
aaa(aca.equipItemButton)end)
aca.equipItemButton.MouseLeave:connect(function()
baa(aca.equipItemButton)end)
aca.equipItemButton.SelectionGained:connect(function()
aaa(aca.equipItemButton)end)
aca.equipItemButton.SelectionLost:connect(function()
baa(aca.equipItemButton)end)
aca.equipItemButton.Activated:connect(function()if d_a.inventory.isEnchantingEquipment then
d_a.inventory.enchantItem(aca.equipItemButton)end end)end end end;dba()end
function _c.postInit(d_a)_c.update()local _aa=d_a.network
_aa:connect("{3027D9DD-C67B-4B3C-B2BB-947EAD001371}","Event",function(aaa,baa)
for caa,daa in
pairs(script.Parent.content:GetChildren())do
if daa:FindFirstChild("equipItemButton")then
if aaa and baa then
local _ba=b_a[daa.equipItemButton]
if _ba then daa.blocked.Visible=false;local aba=bd[_ba.id]local bba=bd[baa.id]local cba=
bba.upgradeCost or 1;local dba=aba.maxUpgrades
local _ca,aca=ad.enchantmentCanBeAppliedToItem(baa,_ba)local bca=not _ca;daa.blocked.Visible=bca end else daa.blocked.Visible=false end end end end)end;return _c