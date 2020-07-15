local _a={}local aa;local ba=false;local ca=Random.new(os.time())
function _a.init(da)
local _b=da.network;local ab=da.fx;local bb=0
local cb=Instance.new("ColorCorrectionEffect")cb.Name="DamageColor"cb.Parent=game.Lighting
local db=Instance.new("BlurEffect")db.Name="DamageBlur"db.Parent=game.Lighting;db.Size=0;local _c=da.tween
local function ac(dd)
local __a=script.Parent.header.username.value;__a.Text=game.Players.LocalPlayer.Name
local a_a=
game.TextService:GetTextSize(__a.Text,__a.TextSize,__a.Font,Vector2.new()).X+15
dd=string.lower(
dd or _b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","class")or"Unknown")
if dd:lower()~="adventurer"then script.Parent.header.username.icon.Image=
"rbxgameasset://Images/emblem_"..dd:lower()
script.Parent.header.username.icon.Visible=true;__a.Size=UDim2.new(1,-25,1,0)a_a=a_a+25 else
script.Parent.header.username.icon.Visible=false;__a.Size=UDim2.new(1,0,1,0)end
script.Parent.header.username.Size=UDim2.new(0,a_a+10,0,26 +10)end;spawn(ac)
repeat wait()until game.Players.LocalPlayer.Character;local bc=game.Players.LocalPlayer.Character
while

not bc.PrimaryPart and bc.Parent and bc:IsDescendantOf(workspace)do local dd=bc:WaitForChild("hitbox",1)
if dd then bc.PrimaryPart=dd;break end end;aa=bc.PrimaryPart;aa:WaitForChild("health")
local cc=aa.health.Value
local function dc()
local dd=math.clamp(aa.health.Value-cc,-aa.maxHealth.Value*0.25,
aa.maxHealth.Value*0.25)/
(aa.maxHealth.Value*0.25)cc=aa.health.Value
local __a=math.clamp(aa.health.Value/aa.maxHealth.Value,0,1)
local a_a=math.clamp(aa.mana.Value/aa.maxMana.Value,0,1)
script.Parent.content.healthBar.value.Size=UDim2.new(__a,0,1,0)
script.Parent.content.healthBar.title.Text=math.floor(
aa.health.Value+0.5).."/"..
math.floor(aa.maxHealth.Value+0.5)
script.Parent.content.manaBar.value.Size=UDim2.new(a_a,0,1,0)
script.Parent.content.manaBar.title.Text=math.floor(
aa.mana.Value+0.5).."/"..
math.floor(aa.maxMana.Value+0.5)
if dd<0 then local b_a=(0.9)* (math.abs(dd))local c_a=0.15 +b_a/1.4
_c(cb,{"TintColor","Contrast"},{Color3.fromRGB(255,
255 -b_a*150,255 -b_a*150),b_a/3},
c_a/2)_c(db,{"Size"},b_a*5,c_a/2)
spawn(function()wait(c_a/2)_c(cb,{"TintColor","Contrast"},{Color3.fromRGB(255,255,255),0},
c_a/2)_c(db,{"Size"},0,
c_a/2)end)
spawn(function()
for i=1,3 do
script.Parent.content.healthBarUnder.Visible=true;wait(0.08)
script.Parent.content.healthBarUnder.Visible=false;wait(0.08)end end)else
if aa.health.Value-cc>5 and dd>0.01 then
local b_a=0.3 +math.abs(dd)local c_a=b_a/1.4
_c(cb,{"TintColor","Contrast"},{Color3.fromRGB(255 -b_a*150,255,255 -b_a*150),
-b_a/3},c_a/2)
spawn(function()wait(c_a/1.5)_c(cb,{"TintColor","Contrast"},{Color3.fromRGB(255,255,255),0},
c_a/2)end)end end end;aa.health.Changed:connect(dc)
aa.mana.Changed:connect(dc)aa.maxHealth.Changed:connect(dc)
aa.maxMana.Changed:connect(dc)dc()script.Parent.header.xp.Visible=true
local _d=da.levels;local ad=da.network
local function bd()
local dd=ad:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","exp")
local __a=ad:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")local a_a=script.Parent.header.level.value;a_a.Text=
"Lvl. "..__a
local b_a=
game.TextService:GetTextSize(a_a.Text,a_a.TextSize,a_a.Font,Vector2.new()).X+16
script.Parent.header.level.Size=UDim2.new(0,b_a+10,0,26 +10)local c_a=dd
local d_a=math.floor(_d.getEXPToNextLevel(__a))bb=dd;script.Parent.header.xp.title.Text="XP: "..c_a..
"/"..d_a;script.Parent.header.xp.value.Size=UDim2.new(
c_a/d_a,0,1,0)
script.Parent.header.xp.instant.Size=script.Parent.header.xp.value.Size end
local function cd(dd,__a)
if dd=="class"then ac(__a)elseif dd=="gold"then elseif dd=="level"then
local a_a=script.Parent.header.xp.value.ImageColor3;script.Parent.header.xp.ImageColor3=a_a
_c(script.Parent.header.xp,{"ImageColor3"},Color3.new(
a_a.r+0.2,a_a.g+0.2,a_a.b+0.2),0.4)
script.Parent.header.xp.pulse.ImageTransparency=0
script.Parent.header.xp.pulse.ImageColor3=a_a
script.Parent.header.xp.pulse.Size=UDim2.new(1,0,1,0)
script.Parent.header.xp.pulse.Visible=true
_c(script.Parent.header.xp.pulse,{"Size","ImageTransparency"},{UDim2.new(1,140,1,140),1},0.5)wait(0.4)
_c(script.Parent.header.xp,{"ImageColor3"},Color3.fromRGB(15,15,15),1)elseif dd=="exp"then
local a_a=ad:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","level")local b_a=script.Parent.header.level.value;b_a.Text=
"Lvl. "..a_a
local c_a=
game.TextService:GetTextSize(b_a.Text,b_a.TextSize,b_a.Font,Vector2.new()).X+16
script.Parent.header.level.Size=UDim2.new(0,c_a+10,0,26 +10)local d_a=__a
local _aa=math.floor(_d.getEXPToNextLevel(a_a))script.Parent.header.xp.title.Text="XP: "..
math.floor(d_a).."/".._aa
local aaa=d_a-bb
local baa=script.Parent.header.xp.value.tip.sample
for i=1,10 do local caa=baa:Clone()caa.Rotation=math.random(1,90)
caa.Parent=baa.Parent;caa.Visible=true
_c(caa,{"Rotation","Position","Size","BackgroundTransparency"},{
caa.Rotation+math.random(100,200),UDim2.new(0,math.random(3,25),0.5,math.random(-20,20)),UDim2.new(0,16,0,16),1},
math.random(60,130)/100)game.Debris:AddItem(caa,1.5)end
if d_a<bb then
da.tween(script.Parent.header.xp.value,{"Size"},{UDim2.new(1,0,1,0)},0.5)
script.Parent.header.xp.instant.Size=UDim2.new(1,0,1,0)
spawn(function()wait(0.25)
script.Parent.header.xp.value.Size=UDim2.new(1,0,0,0)local caa=UDim2.new(d_a/_aa,0,1,0)
da.tween(script.Parent.header.xp.value,{"Size"},{caa},0.5)
script.Parent.header.xp.instant.Size=caa end)else
da.tween(script.Parent.header.xp.value,{"Size"},{UDim2.new(d_a/_aa,0,1,0)},1)
script.Parent.header.xp.instant.Size=UDim2.new(d_a/_aa,0,1,0)end;script.Parent.header.xp.Visible=true;bb=__a end end
script.Parent.header.xp.MouseEnter:connect(function()
script.Parent.header.xp.title.Visible=true;ba=true end)
script.Parent.header.xp.MouseLeave:connect(function()
script.Parent.header.xp.title.Visible=false;ba=false end)
ad:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",cd)spawn(bd)end;return _a