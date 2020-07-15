local c={}local d=game.Players.LocalPlayer
function c.init(_a)local aa=_a.tween
script.Parent.Visible=false
local function ba(da)script.Parent.success.Visible=false
script.Parent.fail.Visible=false;script.Parent.queue.Visible=false
script.Parent.Visible=true;local _b=script.Parent.fail
if da==1 then _b=script.Parent.queue end;_b.Visible=true
for i=1,4 do
local ab=script.Parent.flare:Clone()ab.Name="flareCopy"ab.ImageColor3=_b.spinner.ImageColor3
ab.Parent=script.Parent;ab.Visible=true;ab.Size=UDim2.new(1,4,1,4)
ab.Position=UDim2.new(0,-2,0.5,0)ab.AnchorPoint=Vector2.new(0,0.5)local bb=(180 -40 *i)
local cb=(14 -2 *i)local db=UDim2.new(0,-cb/2,0.5,0)
local _c=UDim2.new(1,bb,1,cb)
aa(ab,{"Position","Size","ImageTransparency"},{db,_c,1},0.5 *i)end end
local function ca()
if script.Parent.Visible then script.Parent.fail.Visible=false
script.Parent.success.Position=UDim2.new(0,0,0,0)script.Parent.success.Visible=true
spawn(function()wait(10)
if
script.Parent.success.Visible then
aa(script.Parent.success,{"Position"},{UDim2.new(-1,-20,0,0)},0.5)wait(0.5)script.Parent.Visible=false end end)end end;if d:FindFirstChild("DataSaveFailed")then
ba(d.DataSaveFailed.Value)end
d.ChildAdded:Connect(function(da)if
da.Name=="DataSaveFailed"then ba(da.Value)end end)
d.ChildRemoved:Connect(function(da)if

script.Parent.Visible and script.Parent.fail.Visible and d:FindFirstChild("DataSaveFailed")==nil then ca()end end)end;return c