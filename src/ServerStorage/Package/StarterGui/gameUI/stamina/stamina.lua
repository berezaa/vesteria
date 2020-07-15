local c={}local d=game.Players.LocalPlayer
function c.init(_a)
script.Parent.BackgroundTransparency=1;script.Parent.value.BackgroundTransparency=1
script.Parent.Active=false;script.Parent.Visible=true
local function aa()
if


d.Character and d.Character.PrimaryPart and d.Character.PrimaryPart:FindFirstChild("stamina")and d.Character.PrimaryPart:FindFirstChild("maxStamina")then
if d.Character.PrimaryPart.stamina.Value<
d.Character.PrimaryPart.maxStamina.Value then
script.Parent.Size=UDim2.new(0,10,0,
d.Character.PrimaryPart.maxStamina.Value*10)
_a.tween(script.Parent.value,{"Size"},UDim2.new(1,0,
d.Character.PrimaryPart.stamina.Value/d.Character.PrimaryPart.maxStamina.Value,0),0.1,Enum.EasingStyle.Linear)
if not script.Parent.Active then script.Parent.Active=true
_a.tween(script.Parent.value,{"BackgroundTransparency"},0,0.5)
_a.tween(script.Parent,{"BackgroundTransparency"},0,0.5)end
if d.Character.PrimaryPart.stamina.Value<=0 then
script.Parent.value.Visible=false
spawn(function()for i=1,5 do script.Parent.BorderSizePixel=2;wait(0.1)
script.Parent.BorderSizePixel=0;wait(0.1)end
if
d.Character.PrimaryPart.stamina.Value<=0 and
_a.network:invoke("{DEE6248B-5F6A-406E-AC36-86EA853CC31E}","heat exhausted")then
script.Parent.BorderSizePixel=2 end end)else script.Parent.value.Visible=true
script.Parent.BorderSizePixel=0;local ba=Color3.fromRGB(46,153,46)
if _a.network:invoke("{DEE6248B-5F6A-406E-AC36-86EA853CC31E}","empower",
nil,"haste")then
ba=Color3.fromRGB(45,191,162)elseif
_a.network:invoke("{DEE6248B-5F6A-406E-AC36-86EA853CC31E}","heat exhausted")then ba=Color3.fromRGB(255,255,127)end;script.Parent.value.BackgroundColor3=ba end else
if script.Parent.Active then
_a.tween(script.Parent.value,{"Size"},UDim2.new(1,0,1,0),0.1,Enum.EasingStyle.Linear)script.Parent.Active=false
_a.tween(script.Parent.value,{"BackgroundTransparency"},1,0.5)
_a.tween(script.Parent,{"BackgroundTransparency"},1,0.5)end end end end
spawn(function()local ba=tick()
repeat wait()until

(d.Character and d.Character.PrimaryPart and
d.Character.PrimaryPart:FindFirstChild("stamina")and
d.Character.PrimaryPart:FindFirstChild("maxStamina"))or tick()-ba>10;aa()
d.Character.PrimaryPart.stamina.Changed:connect(aa)end)end;return c