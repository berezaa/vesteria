local c={}function c.displayAbilityCooldown()end;function c.statusRibbon()end
function c.setFlash()end
c.colorTypes={success=Color3.fromRGB(97,180,79),fail=Color3.fromRGB(180,58,60),default=Color3.fromRGB(180,180,0),gold=Color3.fromRGB(255,188,52)}local d=c.colorTypes
function c.init(_a)local aa=_a.tween;local ba=_a.network
function c.setFlash(da,_b)if
da:FindFirstChild("flash")then da.flash:Destroy()end
if _b then
local ab=script.flash:Clone()ab.Parent=da;ab.Visible=true;local bb=0.6
local cb=math.max(da.AbsoluteSize.X,da.AbsoluteSize.Y)ab.ImageLabel.Size=UDim2.new(1,16,1,16)
spawn(function()
while
da.Parent and ab.Parent do ab.ImageLabel.Position=UDim2.new(0,0,0,0)
ab.ImageLabel.ImageTransparency=1
aa(ab.ImageLabel,{"Position"},{UDim2.new(1,0,1,0)},bb,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut)
aa(ab.ImageLabel,{"ImageTransparency"},{0},bb/2,nil,Enum.EasingDirection.Out)wait(bb/2)if da.Parent and ab.Parent then
aa(ab.ImageLabel,{"ImageTransparency"},{1},bb/2,nil,Enum.EasingDirection.In)end;wait(4 -bb)end end)end end
function c.displayAbilityCooldown(da,_b)
if da then if da:FindFirstChild("cooldown")then
da.cooldown:Destroy()end
local ab=script.cooldown:Clone()ab.Parent=da;ab.bar.value.Size=UDim2.new(1,0,1,0)
aa(ab.bar.value,{"Size"},UDim2.new(1,0,0,0),_b,Enum.EasingStyle.Linear)game.Debris:AddItem(ab,_b)end end
function c.ring(da,_b)local ab=da or{}local bb=ab.color or Color3.new(1,1,1)local cb=
ab.duration or 0.5;local db=ab.scale or 5
local _c=script.ring:Clone()_c.Parent=script.Parent;_c.ImageTransparency=0
_c.AnchorPoint=Vector2.new(0.5,0.5)
_c.Position=UDim2.new(0,_b.X,0,_b.Y-game.GuiService:GetGuiInset().Y)_c.Visible=true;_c.ImageColor3=bb;local ac=_c.AbsoluteSize*db
aa(_c,{"Size","ImageTransparency"},{UDim2.new(0,ac.X,0,ac.Y),1},cb)game.Debris:AddItem(_c,cb)end
ba:create("{57B7F861-701C-4A01-A7A9-5696208852A4}","BindableFunction","OnInvoke",c.displayAbilityCooldown)local ca;function c.consumableCooldown(da)local _b=tick()+da;ca=_b end
function c.statusRibbon(da,_b,ab,bb,cb)ab=
ab or"default"local db=d[ab]bb=bb or 3
local _c=Instance.new("Frame")_c.BorderSizePixel=0;_c.BackgroundTransparency=1;_c.ZIndex=7
local ac=da.AbsoluteSize.Y;ac=ac>30 and 30 or ac;_c.Size=UDim2.new(1,0,0,ac)
_c.Name="fxStatusRibbon"_c.ClipsDescendants=true;cb=cb or UDim2.new(0,0,0,28)
_c.Position=cb;if cb.Y.Scale>=0.49 and cb.Y.Scale<=0.51 then
_c.AnchorPoint=Vector2.new(0,0.5)end
local bc=Instance.new("TextLabel")bc.BackgroundTransparency=1;bc.Size=UDim2.new(1,0,0.8,0)
bc.AnchorPoint=Vector2.new(0,0.5)bc.Position=UDim2.new(1,0,0.5,0)
bc.TextColor3=Color3.new(1,1,1)bc.TextScaled=true;bc.Font=Enum.Font.SourceSans;bc.Parent=_c
bc.Text=_b;_c.BackgroundColor3=db;_c.Parent=da
game.Debris:AddItem(_c,bb+1)
spawn(function()
aa(_c,{"BackgroundTransparency"},0.1,bb*1 /8)
aa(bc,{"Position"},UDim2.new(0,0,0.5,0),bb*2 /8)wait(bb*6 /8)
aa(bc,{"Position"},UDim2.new(-1,0,0.5,0),bb*2 /8)wait(bb*1 /8)
aa(_c,{"BackgroundTransparency"},1,bb*1 /8)wait(bb*1 /8)if _c then _c.Visible=false end end)return _c end end;return c