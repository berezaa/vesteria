local cb={}local db=game:GetService("ReplicatedStorage")
local _c=require(db.modules)local ac=_c.load("network")local bc=_c.load("utilities")
local cc=require(db.itemData)local dc=game.Players.LocalPlayer
local _d=script.Parent.Frame.content;local ad=nil;local bd={}local cd
local dd=require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))
function cb.init(__a)local a_a=__a.uiCreator
local function b_a(daa)cd=daa;local _ba=bd[daa]
if _ba then local aba=cc[_ba.id]if aba then
ac:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}",aba,"storage",_ba)end end end
local function c_a(daa)if cd==daa then
ac:invoke("{F2C470EF-8710-44BB-9203-C4357B8E4FA2}")end end;local d_a=script:WaitForChild("storageItemTemplate")
local function _aa(daa)if
bd[daa]then
local _ba,aba=ac:invokeServer("{D8C69E55-8192-43C2-9C8F-38D98BEF2E96}",bd[daa])end end;local function aaa(daa)return bd[daa]end
local function baa(daa)if daa then ad=daa end
local _ba=game.GuiService.SelectedObject;local aba,bba;if _ba and _ba:IsDescendantOf(script.Parent)then
aba=_ba.Name;bba=_ba.Parent end
if ad then bd={}
for dba,_ca in
pairs(_d:GetChildren())do if _ca:FindFirstChild("item")then _ca:Destroy()end end;local cba=0
for dba,_ca in pairs(ad)do local aca=cc[_ca.id]
if aca then local bca=d_a:Clone()
if aca.canBeBound then
local _da=Instance.new("BoolValue")_da.Name="bindable"_da.Parent=bca end;bca.ImageTransparency=0;bca.item.Image=aca.image
bca.item.ImageColor3=Color3.new(1,1,1)if _ca.dye then
bca.item.ImageColor3=Color3.fromRGB(_ca.dye.r,_ca.dye.g,_ca.dye.b)end
bca.item:WaitForChild("duplicateCount").Text=(
_ca.stacks and aca.canStack and _ca.stacks>1)and
tostring(_ca.stacks)or""bca.Parent=_d;bca.LayoutOrder=dba;bca.Name=tostring(dba)
local cca=bc.copyTable(_ca)cca.position=dba;bd[bca.item]=cca;local dca;if _ca then
dca=__a.itemAcquistion.getTitleColorForInventorySlotData(_ca)end;dca=dca or aca.nameColor;bca.frame.ImageColor3=
dca or Color3.fromRGB(106,105,107)bca.shine.ImageColor3=
dca or Color3.fromRGB(179,178,185)bca.shine.ImageTransparency=
dca and 0.47 or 0.66;bca.item.MouseEnter:connect(function()
b_a(bca.item)end)bca.item.SelectionGained:connect(function()
b_a(bca.item)end)bca.item.MouseLeave:connect(function()
c_a(bca.item)end)bca.item.SelectionLost:connect(function()
c_a(bca.item)end)
a_a.drag.setIsDragDropFrame(bca.item)a_a.setIsDoubleClickFrame(bca.item,0.2,_aa)
cba=cba+1 end end
for i=1,20 do
if not _d:FindFirstChild(tostring(i))then
local dba=script.storageItemTemplate:Clone()dba.item.duplicateCount.Text=""dba.item.Image=""
dba.item.Visible=true;dba.frame.Visible=false;dba.shine.Visible=false
dba.ImageTransparency=0.5;dba.shadow.ImageTransparency=0.5;dba.Name=tostring(i)
dba.LayoutOrder=i;dba.Parent=_d
a_a.drag.setIsDragDropFrame(dba.item)end end
_d.CanvasSize=UDim2.new(0,0,0,math.ceil(math.max(cba,20)/5)*66)
if bba and aba then local dba=bba:FindFirstChild(aba)if dba then
game.GuiService.SelectedObject=dba end end end end
function cb.open()
if script.Parent.Visible then
__a.playerMenu.closeSelected()if script.Parent.Parent.Parent.Visible then
__a.focus.toggle(script.Parent.Parent.Parent)end else
local daa=ac:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","globalData")if daa and daa.itemStorage then baa(daa.itemStorage)
__a.playerMenu.selectMenu(script.Parent,__a[script.Name])end end end
function cb.close()__a.playerMenu.closeSelected()if
script.Parent.Parent.Parent.Visible then
__a.focus.toggle(script.Parent.Parent.Parent)end end;local function caa(daa,_ba)
if
daa=="globalData"and script.Parent.Visible and _ba.itemStorage then baa(_ba.itemStorage)end end
ac:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",caa)
ac:create("{C2C0B93C-33EA-4C01-8C24-1C4E0429CCA2}","BindableFunction","OnInvoke",aaa)
ac:create("{1A8BA235-5735-4864-AA56-48E78F68949C}","BindableFunction","OnInvoke",function()cb.open()end)
ac:create("{C8A7EC2E-AA23-4D5E-AE6D-1DD172B63E7C}","BindableFunction","OnInvoke",function()cb.close()end)end;return cb