local _c={}local ac;local bc=game.Players.LocalPlayer
local cc=script.Parent.healthBar.value;local dc=script.Parent.healthBar.damageValue
local _d=game:GetService("TweenService")local ad;local bd;local cd;local dd;local __a;local a_a=false;local b_a=1
local c_a=Random.new(os.time())
function _c.init(d_a)local _aa=d_a.network;local aaa=d_a.fx;local baa=0
for aca,bca in
pairs(game.Lighting:GetChildren())do if bca.Name=="DamageColor"or bca.Name=="DamageBlur"then
bca:Destroy()end end;local caa=Instance.new("ColorCorrectionEffect")
caa.Name="DamageColor"caa.Parent=game.Lighting;local daa=Instance.new("BlurEffect")
daa.Name="DamageBlur"daa.Parent=game.Lighting;daa.Size=0;local _ba=d_a.tween
local aba=script.Parent.Parent.Parent.vin_low_health
function _c.manaWarning()
spawn(function()
for i=1,3 do
script.Parent.manaBar.ImageColor3=Color3.fromRGB(134,17,17)wait()
script.Parent.manaBar.ImageColor3=Color3.fromRGB(16,16,16)wait()end end)end;repeat wait()until game.Players.LocalPlayer.Character
local bba=game.Players.LocalPlayer.Character
while
not bba.PrimaryPart and bba.Parent and bba:IsDescendantOf(workspace)do local aca=bba:WaitForChild("hitbox",1)
if aca then bba.PrimaryPart=aca;break end end;ac=bba.PrimaryPart;ac:WaitForChild("health")
local cba=ac.health.Value
local function dba(aca)local bca=ac.health.Value-cba
local cca=ac.health.Value-cba;cba=ac.health.Value;local dca=ac.health.Value
local _da=ac.maxHealth.Value;local ada=cba-dca
local bda=math.clamp(ac.health.Value/ac.maxHealth.Value,0,1)
local cda=math.clamp(ac.mana.Value/ac.maxMana.Value,0,1)local dda=bca/_da;local __b=dca/_da;aba.Visible=__b<0.4 and __b>0;if
aba.Visible then aba.UIScale.Scale=1 +__b*10 end
if aca then
script.Parent.healthBar.value.Size=UDim2.new(math.max(bda,0),0,1,0)
script.Parent.manaBar.value.Size=UDim2.new(math.max(cda,0),0,1,0)else
_ba(script.Parent.healthBar.value,{"Size"},UDim2.new(math.max(bda,0),0,1,0),0.3)
_ba(script.Parent.manaBar.value,{"Size"},UDim2.new(math.max(cda,0),0,1,0),0.3)end
script.Parent.healthBar.title.Text=
math.floor(ac.health.Value+0.5).."/"..math.floor(ac.maxHealth.Value+0.5)
script.Parent.manaBar.title.Text=
math.floor(ac.mana.Value+0.5).."/"..math.floor(ac.maxMana.Value+0.5)
if bca<0 then
local a_b=dda^2 +math.clamp(1 -__b,0,1)^3;local b_b=0.15 +a_b^3
_ba(caa,{"TintColor","Contrast","Saturation"},{Color3.fromRGB(255,255 -a_b*
150,255 -a_b*150),a_b*2,a_b},
b_b/3)_ba(daa,{"Size"},a_b*5,b_b/3)
spawn(function()wait(b_b/2)
_ba(caa,{"TintColor","Contrast","Saturation"},{Color3.fromRGB(255,255,255),0,0},
b_b/2)_ba(daa,{"Size"},0,b_b/2)end)
spawn(function()local aab=ac.health.Value/ac.maxHealth.Value;local bab=math.abs(
cca/ac.maxHealth.Value)
local cab=script.Parent.healthBar.instant:Clone()cab.Name="instantClone"cab.Size=UDim2.new(bab,5,1,0)cab.Position=UDim2.new(aab,
-5,0.5,0)
cab.Parent=script.Parent.healthBar;cab.Visible=true
_ba(cab,{"Size","ImageTransparency"},{UDim2.new(bab,5,1 +bab*30,0),1},
0.25 +bab*2)game.Debris:AddItem(cab,0.25 +bab*2)end)local c_b=ac.health.Value;local d_b=ac.maxHealth.Value;local _ab=-cca
if _ab>0 then if cd and
cd.PlaybackState==Enum.PlaybackState.Playing then
cd:Cancel()end
cc.Size=UDim2.new(c_b/d_b,0,1,0)
dc.Position=UDim2.new(math.clamp(c_b/d_b-0.1,0,1),0,0,0)
dc.Size=UDim2.new(math.clamp(_ab/d_b+0.1,0,1),0,1,0)
dc.bar.ImageColor3=Color3.fromRGB(255,255,150 +50 * (_ab/d_b))
local aab=TweenInfo.new(0.5 * (_ab/d_b)^ (1 /3)*b_a,Enum.EasingStyle.Quart,Enum.EasingDirection.Out,0,false,0)
cd=_d:Create(dc.bar,aab,{ImageColor3=Color3.fromRGB(255,44,44)})local bab
bab=cd.Completed:connect(function(cab)bab:disconnect()
if
cab==Enum.PlaybackState.Completed then
local dab=TweenInfo.new(0.5 * (1 -_ab/d_b)^ (1 /3)*b_a,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0)
cd=_d:Create(dc,dab,{Size=UDim2.new(0,0,1,0)})cd:Play()end end)cd:Play()end else local a_b=math.abs(cca/ac.maxHealth.Value)if
a_b>0.01 then end
if ac.health.Value-cba>5 and bca>0.01 then local b_b=0.3 +
math.abs(bca)local c_b=b_b/1.4
_ba(caa,{"TintColor","Contrast"},{Color3.fromRGB(
255 -b_b*150,255,255 -b_b*150),-b_b/3},
c_b/2)
spawn(function()wait(c_b/1.5)
_ba(caa,{"TintColor","Contrast"},{Color3.fromRGB(255,255,255),0},
c_b/2)end)end end end;ac.health.Changed:connect(dba)
ac.mana.Changed:connect(dba)ac.maxHealth.Changed:connect(dba)
ac.maxMana.Changed:connect(dba)dba(true)local function _ca()end
d_a.input.mode.changed:connect(_ca)_ca()end;return _c