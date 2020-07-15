local b={}b.loaded=false
function b.init(c)b.loaded=true;if true then return end
local d=game:GetService("ContentProvider")local _a=game:GetService("RunService")
local aa=game:GetService("TeleportService")local ba=aa:GetLocalPlayerTeleportData()or{}
local ca=ba.arrivingFrom;if
ca and ca~=2015602902 and ca~=2376885433 and ca~=2015602902 then b.loaded=true;return false end
local da=c.tween;local _b={}local ab=true
table.insert(_b,game.ReplicatedStorage:WaitForChild("characterAnimations"))
table.insert(_b,game.ReplicatedStorage:WaitForChild("abilityAnimations"))
table.insert(_b,game.ReplicatedStorage:WaitForChild("sounds"))
table.insert(_b,game:GetService("StarterGui"))
table.insert(_b,game.ReplicatedStorage:WaitForChild("itemData"))
table.insert(_b,game.ReplicatedStorage:WaitForChild("abilityLookup"))
table.insert(_b,game.ReplicatedStorage:WaitForChild("accessoryLookup"))local bb=script.Parent.contents
spawn(function()local cb=d.RequestQueueSize
while ab do
local db=d.RequestQueueSize;if db>cb then cb=db end;local _c=cb-db;bb.value.Text=tostring(_c)..
"/"..tostring(cb)
bb.spinner.Rotation=bb.spinner.Rotation+1;_a.Heartbeat:wait()end end)
spawn(function()d:PreloadAsync({script.Parent})
script.Parent.Visible=true;d:PreloadAsync(_b)b.loaded=true;ab=false
bb.spinner.Image="rbxassetid://2528903599"bb.spinner.Rotation=0;bb.value.Text="All done!"
da(bb.spinner,{"ImageColor3"},{Color3.fromRGB(132,255,98)},0.5)
da(bb.value,{"TextColor3"},{Color3.fromRGB(132,255,98)},0.5)
for i=1,4 do local cb=script.Parent.flare:Clone()
cb.Name="flareCopy"cb.Parent=script.Parent;cb.Visible=true
cb.Size=UDim2.new(1,4,1,4)cb.Position=UDim2.new(0,-2,0.5,0)
cb.AnchorPoint=Vector2.new(0,0.5)local db=(180 -40 *i)local _c=(14 -2 *i)
local ac=UDim2.new(0,-_c/2,0.5,0)local bc=UDim2.new(1,db,1,_c)da(cb,{"Position","Size","ImageTransparency"},{ac,bc,1},
0.5 *i)end;wait(2)
da(bb,{"Position"},{UDim2.new(-1,-20,0,0)},0.5)wait(0.5)script.Parent.Visible=false end)end;return b