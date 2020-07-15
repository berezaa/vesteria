local b={}
function b.init(c)local d=c.tween
script.Parent.openEquipment.Activated:connect(function()
c.equipment.show()end)
script.Parent.openInventory.Activated:connect(function()
c.inventory.show()end)
script.Parent.openAbilities.Activated:connect(function()
c.abilities.show()end)
script.Parent.openSettings.Activated:connect(function()
c.settings.show()end)
for _a,aa in pairs(script.Parent:GetChildren())do
if aa:IsA("GuiButton")then
local function ba()
for ab,bb in
pairs(script.Parent:GetChildren())do if bb:IsA("GuiButton")then bb.ZIndex=1 end end;aa.ZIndex=2;local da=aa.Position
local _b=UDim2.new(da.X.Scale,da.X.Offset,da.Y.Scale,-36)d(aa,{"Position"},_b,0.5)end
local function ca()local da=aa.Position
local _b=UDim2.new(da.X.Scale,da.X.Offset,da.Y.Scale,0)d(aa,{"Position"},_b,0.5)end;aa.MouseEnter:connect(ba)
aa.SelectionGained:connect(ba)aa.MouseLeave:connect(ca)
aa.SelectionLost:connect(ca)end end end;return b