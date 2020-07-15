
local ad=require(game:GetService("ReplicatedStorage"):WaitForChild("modules")).load("network")
local bd=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local cd=script.Parent;local dd=cd:WaitForChild("menu")
local __a=dd:WaitForChild("equipment")local a_a=dd:WaitForChild("inventory")
local b_a=dd:WaitForChild("previous")local c_a=dd:WaitForChild("next")
local d_a=dd:WaitForChild("select")local _aa=dd:WaitForChild("confirm")
local aaa=dd:WaitForChild("info")local baa=dd:WaitForChild("loading")
local caa=cd:WaitForChild("prompt")local daa=caa:WaitForChild("confirm")
local _ba=caa:WaitForChild("cancel")local aba=false
local function bba()for aca,bca in pairs(__a:GetChildren())do if bca:IsA("ImageLabel")then
bca:Destroy()end end
for aca,bca in
pairs(a_a:GetChildren())do if bca:IsA("ImageLabel")then bca:Destroy()end end end
local function cba(aca)
local bca=os.time()-aca.lastSaveTimestamp or 0;local cca=math.floor(bca/60 /60 /24)bca=bca-
cca*24 *60 *60;local dca=math.floor(bca/60 /60)bca=bca-dca*60 *
60;local _da=math.floor(bca/60)return
string.format("%dd %dh %dm",cca,dca,_da)end
local function dba(aca)bba()
local function bca(cca,dca)local _da=Instance.new("ImageLabel")_da.Image=bd[cca.id]and
bd[cca.id].image or""
if cca.stacks and
cca.stacks>1 then local ada=Instance.new("TextLabel")
ada.BackgroundTransparency=1;ada.Size=UDim2.new(1,0,1,0)
ada.TextColor3=Color3.new(1,1,1)ada.TextStrokeColor3=Color3.new(0,0,0)
ada.TextStrokeTransparency=0;ada.Text=cca.stacks;ada.Parent=_da end;_da.Parent=dca end;for cca,dca in pairs(aca.equipment)do bca(dca,__a)end;for cca,dca in
pairs(aca.inventory)do bca(dca,a_a)end
aaa.Text=string.format("Version: %d    Level: %d    Exp: %d    Class: %s    Gold: %d    Approx. %s ago",aca.globalData.version,aca.level,aca.exp,aca.class,aca.gold,cba(aca))end
local function _ca(aca)_aa.Visible=false;baa.Visible=not aca;for bca,cca in pairs{c_a,b_a,d_a}do
cca.Visible=aca end end
ad:connect("{70D48E6D-FA55-4F16-AA91-62D20043AA2C}","OnClientEvent",function(aca,bca,cca)if aba then return end;aba=true;caa.Visible=true
daa.Activated:Connect(function()
caa:Destroy()dd.Visible=true;dba(aca)local dca=aca.globalData.version;local _da=dca
c_a.Activated:Connect(function()if
dca>=_da then return end;dca=dca+1;_ca(false)
local ada,bda,cda=ad:invokeServer("{54E0CB0C-03DC-4132-BEF0-39CBD750342D}",bca,dca)if not ada then dca=dca-1 else dba(bda)end;_ca(true)end)
b_a.Activated:Connect(function()if dca<=1 then return end;dca=dca-1;_ca(false)
local ada,bda,cda=ad:invokeServer("{54E0CB0C-03DC-4132-BEF0-39CBD750342D}",bca,dca)if not ada then dca=dca+1 else dba(bda)end;_ca(true)end)
d_a.Activated:Connect(function()_ca(false)baa.Visible=false;_aa.Visible=true;delay(2.5,function()
_ca(true)end)end)
_aa.Activated:Connect(function()
ad:fireServer("{70D48E6D-FA55-4F16-AA91-62D20043AA2C}",bca,dca,cca)dd:Destroy()end)end)
_ba.Activated:Connect(function()caa:Destroy()
ad:fireServer("{1EF9400C-348E-43E7-B7E2-50A3A2BFF1ED}",cca)end)end)