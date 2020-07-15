local ab=game:GetService("UserInputService")
local bb=script.Parent;local cb;local db;local _c;local ac;local function bc(ad)local bd=ad.Position-_c
bb.Position=UDim2.new(ac.X.Scale,ac.X.Offset+bd.X,ac.Y.Scale,
ac.Y.Offset+bd.Y)end
local function cc(ad)
if ad.UserInputType==
Enum.UserInputType.MouseButton1 or
ad.UserInputType==Enum.UserInputType.Touch then cb=true;_c=ad.Position
ac=bb.Position
ad.Changed:Connect(function()if ad.UserInputState==Enum.UserInputState.End then
cb=false end end)end end;local function dc(ad)
if ad.UserInputType==Enum.UserInputType.MouseMovement or ad.UserInputType==
Enum.UserInputType.Touch then db=ad end end;local function _d(ad)if
ad==db and cb then bc(ad)end end
bb.InputBegan:connect(cc)bb.InputChanged:connect(dc)
ab.InputChanged:connect(_d)