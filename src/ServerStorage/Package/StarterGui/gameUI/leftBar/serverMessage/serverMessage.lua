local b={}
function b.init(c)local d=c.network;local _a=c.configuration;local aa=c.tween;local ba
function b.displayMessage(ca)
script.Parent.contents.ImageColor3=Color3.fromRGB(18,18,18)script.Parent.Visible=true;ba=ca
script.Parent.contents.body.text.Text=ba
local da=script.Parent.contents.body.text.TextBounds;script.Parent.Size=UDim2.new(0,280,0,62 +da.Y)
for i=1,4 do
local _b=script.Parent.flare:Clone()_b.Name="flareCopy"_b.Parent=script.Parent;_b.Visible=true
_b.Size=UDim2.new(1,4,1,4)_b.Position=UDim2.new(0,-2,0.5,0)
_b.AnchorPoint=Vector2.new(0,0.5)local ab=(180 -40 *i)local bb=(14 -2 *i)
local cb=UDim2.new(0,-bb/2,0.5,0)local db=UDim2.new(1,ab,1,bb)aa(_b,{"Position","Size","ImageTransparency"},{cb,db,1},
0.5 *i)end end;function b.hide()
if script.Parent.Visible then ba=""script.Parent.Visible=false end end
script.Parent.contents.Activated:connect(b.hide)
script.Parent.contents.MouseEnter:connect(function()
script.Parent.contents.ImageColor3=Color3.fromRGB(12,0,63)end)
script.Parent.contents.MouseLeave:connect(function()
script.Parent.contents.ImageColor3=Color3.fromRGB(18,18,18)end)
spawn(function()
d:connect("{6EB94876-090C-423B-A85F-85A8F7E441EF}","Event",function(da)local _b=da.gameDisplayMessage;if _b and#_b>0 then
b.displayMessage(_b)else b.hide()end end)local ca=_a.getConfigurationValue("gameDisplayMessage")
if ca and#
ca>0 then b.displayMessage(ca)else b.hide()end end)end;return b