local ba={}local ca=game:GetService("RunService")local da
local _b=script.Parent;local ab={}local bb;function ba.forceClose()if da then bb=false end end;function ba.isPrompting()
return da end;function ba.prompt(cb)end;ba.PROMPT_EXPIRE_TIME=30
function ba.init(cb)
local db=cb.tween;_b.Visible=false;local _c={}local ac
local function bc(_d)ac=_d
_b.curve.ImageColor3=Color3.fromRGB(30,30,30)_b.Visible=true;_b.curve.yes.Visible=true
_b.curve.no.Visible=true;_b.curve.Visible=true;_b.curve.title.Text=_d.text end;local function cc(_d)table.insert(_c,_d)
if#_c==1 or _c[1]==_d then bc(_d)end end
local function dc(_d)
if ac then ac.userResponse=_d;for bd,cd in pairs(_c)do if cd==ac then
table.remove(_c,bd)break end end;ac=nil
spawn(function()
wait()if not ac then _b.Visible=false end end)_b.curve.Visible=false;local ad=_c[1]if ad then bc(ad)end end end
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
function ba.prompt_old(_d)if da then return false end;local function ad()
local a_a=game:GetService("GuiService").SelectedObject
if a_a then return a_a:IsDescendantOf(_b)else return false end end
da=true;local bd;_b.curve.title.Text=_d
local cd=_b.curve.no.MouseButton1Click:Connect(function()
if
da then _b.curve.ImageColor3=Color3.fromRGB(30,7,8)
_b.curve.yes.Visible=false;_b.curve.no.Visible=false;bb=false end end)
local dd=_b.curve.yes.MouseButton1Click:Connect(function()if da then
_b.curve.ImageColor3=Color3.fromRGB(8,30,10)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
bb=true end end)_b.curve.ImageColor3=Color3.fromRGB(30,30,30)
_b.Visible=true;_b.curve.yes.Visible=true;_b.curve.no.Visible=true;repeat
ca.Heartbeat:Wait()until bb~=nil;local __a=bb;bb=nil;cd:Disconnect()
dd:Disconnect()da=false;_b.Visible=false;return __a end
cb.network:create("{98536A5A-1107-447A-8263-7528187ECA5B}","BindableFunction","OnInvoke",ba.prompt)end;return ba