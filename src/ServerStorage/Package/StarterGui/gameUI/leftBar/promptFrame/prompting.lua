local ba={}local ca=game:GetService("RunService")local da
local _b=script.Parent;local ab={}local bb;function ba.forceClose()if da then bb=false end end;function ba.isPrompting()
return da end;function ba.prompt(cb)end;ba.PROMPT_EXPIRE_TIME=30
function ba.init(cb)
local db=cb.tween;_b.Visible=false;local _c={}local ac
local function bc(_d)ac=_d
_b.curve.ImageColor3=Color3.fromRGB(30,30,30)_b.Visible=true;_b.curve.yes.Visible=true
_b.curve.no.Visible=true;_b.curve.Visible=true;_b.curve.title.Text=_d.text;_b.curve.Position=UDim2.new(
-1,0,0,0)
db(_b.curve,{"Position"},UDim2.new(0,0,0,0),0.6)end
local function cc(_d)table.insert(_c,_d)
if#_c==1 or _c[1]==_d then bc(_d)end
for i=1,3 do local ad=script.Parent.flare:Clone()
ad.Name="flareCopy"ad.Parent=script.Parent;ad.Visible=true
ad.Size=UDim2.new(1,4,1,4)ad.Position=UDim2.new(0,-2,0.5,0)
ad.AnchorPoint=Vector2.new(0,0.5)local bd=(180 -40 *i)local cd=(14 -2 *i)
local dd=UDim2.new(0,-cd/2,0.5,0)local __a=UDim2.new(1,bd,1,cd)db(ad,{"Position","Size","ImageTransparency"},{dd,__a,1},
0.5 *i)end end
local function dc(_d)
if ac then ac.userResponse=_d;for cd,dd in pairs(_c)do
if dd==ac then table.remove(_c,cd)break end end;ac=nil;local ad=_b.curve:Clone()
ad.Name="transition"ad.ZIndex=ad.ZIndex+1;ad.Parent=_b
db(ad,{"Position"},UDim2.new(-1,-10,0,0),0.6)game.Debris:AddItem(ad,0.6)
spawn(function()wait(0.6)if not ac then
_b.Visible=false end end)_b.curve.Visible=false;local bd=_c[1]if bd then bc(bd)end end end
function ba.prompt(_d)local ad=tick()local bd={text=_d,timestamp=ad}cc(bd)
repeat wait()until
bd.userResponse~=nil or tick()-ad>=ba.PROMPT_EXPIRE_TIME;if tick()-ad>=ba.PROMPT_EXPIRE_TIME then
if bd==ac then dc(false)else for cd,dd in pairs(_c)do if dd==ac then
table.remove(_c,cd)break end end end end;return
bd.userResponse or false end
_b.curve.no.MouseButton1Click:Connect(function()
_b.curve.ImageColor3=Color3.fromRGB(30,7,8)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
dc(false)end)
_b.curve.yes.MouseButton1Click:Connect(function()
_b.curve.ImageColor3=Color3.fromRGB(8,30,10)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
dc(true)end)
function ba.prompt_old(_d)if da then return false end
_b.Position=UDim2.new(0.5,0,0.5,0)local function ad()
local a_a=game:GetService("GuiService").SelectedObject
if a_a then return a_a:IsDescendantOf(_b)else return false end end
da=true;local bd;_b.curve.title.Text=_d
local cd=_b.curve.no.MouseButton1Click:Connect(function()
if
da then _b.curve.ImageColor3=Color3.fromRGB(30,7,8)
_b.curve.yes.Visible=false;_b.curve.no.Visible=false;bb=false end end)
local dd=_b.curve.yes.MouseButton1Click:Connect(function()if da then
_b.curve.ImageColor3=Color3.fromRGB(8,30,10)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
bb=true end end)
db(_b.curve,{"Position"},UDim2.new(0,0,0,0),0)_b.curve.ImageColor3=Color3.fromRGB(30,30,30)
_b.Visible=true;_b.curve.yes.Visible=true;_b.curve.no.Visible=true
for i=1,3 do
local a_a=script.Parent.flare:Clone()a_a.Name="flareCopy"a_a.Parent=script.Parent;a_a.Visible=true
a_a.Size=UDim2.new(1,4,1,4)a_a.Position=UDim2.new(0,-2,0.5,0)
a_a.AnchorPoint=Vector2.new(0,0.5)local b_a=(180 -40 *i)local c_a=(14 -2 *i)
local d_a=UDim2.new(0,-c_a/2,0.5,0)local _aa=UDim2.new(1,b_a,1,c_a)db(a_a,{"Position","Size","ImageTransparency"},{d_a,_aa,1},
0.5 *i)end;repeat ca.Heartbeat:Wait()until bb~=nil;local __a=bb;bb=nil
cd:Disconnect()dd:Disconnect()da=false
db(_b.curve,{"Position"},UDim2.new(-1,-10,0,0),0.6)
spawn(function()wait(0.6)if not da then _b.Visible=false end end)return __a end
cb.network:create("{DD5DD505-12AB-4E39-B224-2F36AD7629FC}","BindableFunction","OnInvoke",ba.prompt)end;return ba