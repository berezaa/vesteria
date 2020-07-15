local d={}local _a=game:GetService("RunService")
function d.show()script.Parent.Visible=
not script.Parent.Visible end;function d.hide()script.Parent.Visible=false end
script.Parent.close.Activated:connect(d.hide)
function d.refreshKeybinds()warn("settings.refreshKeybinds not ready")end;local aa
function d.init(ba)local ca=ba.network
script.Parent.close.Activated:connect(function()
ba.focus.toggle(script.Parent)end)
local function da(db)
for bc,cc in pairs(script.Parent.pages:GetChildren())do if
cc:IsA("GuiObject")then cc.Visible=false end end
for bc,cc in
pairs(script.Parent.header.buttons:GetChildren())do if cc:IsA("ImageButton")then
cc.ImageColor3=Color3.fromRGB(212,212,212)end end
local _c=script.Parent.pages:FindFirstChild(db)
local ac=script.Parent.header.buttons:FindFirstChild(db)_c.Visible=true;ac.ImageColor3=Color3.fromRGB(90,225,255)end;da("options")
for db,_c in
pairs(script.Parent.header.buttons:GetChildren())do if _c:IsA("GuiButton")then
_c.Activated:connect(function()da(_c.Name)end)end end;local _b=script.Parent.pages.options.volume
_b.bar.InputBegan:connect(function(db)
if
db.UserInputType==Enum.UserInputType.MouseButton1 or db.UserInputType==
Enum.UserInputType.Touch then
local _c=_b.bar.AbsolutePosition.X
local ac=_b.bar.AbsolutePosition.X+_b.bar.AbsoluteSize.X;local bc=_b.bar.slider.Position.X.Scale
while
db.UserInputState~=Enum.UserInputState.Cancel and db.UserInputState~=
Enum.UserInputState.End do local cc=
db.Position.X-_c;local dc=math.clamp(cc/ (ac-_c),0,1)if dc<=
0.05 then dc=0 end;if bc~=dc then
ca:fire("{483BF873-91D4-45C3-9E92-87532E15EB8A}",dc)bc=dc end
_b.bar.slider.Position=UDim2.new(bc,0,0.5,0)_a.Heartbeat:wait()end;if
aa and(aa.musicVolume==nil or aa.musicVolume~=bc)then
ca:invokeServer("{824567B5-00A7-4537-A369-8994740B7212}","musicVolume",bc)end end end)
script.Parent.pages.mainMenu.mainMenu.Activated:Connect(function()
ca:invokeServer("{2A007D14-8D6B-4DF7-96F6-A6F3A0B71EFC}")end)local ab=script.Parent.pages.keybinds
local bb=ab:WaitForChild("sampleAction")bb.Visible=false;bb.Parent=script;d.keybindSample=bb
local function cb(db)local _c=d.remapTarget
if _c then
_c.ImageColor3=bb.ImageColor3;if _c==db then d.remapTarget=nil;return true end end;d.remapTarget=db;db.ImageColor3=Color3.fromRGB(61,255,74)end
function d.open()ba.focus.toggle(script.Parent)end
function d.refreshKeybinds()
if bb:FindFirstChild("title")==nil then return false end;d.remapTarget=nil;for ac,bc in pairs(ab:GetChildren())do if bc:IsA("GuiObject")then
bc:Destroy()end end;local db=0
for ac,bc in
pairs(ba.input.actions)do local cc=bb:Clone()cc.Name=ac;cc.title.Text=ac;cc.Parent=ab
cc.LayoutOrder=bc.priority;cc.Visible=true
cc.MouseButton1Click:connect(function()cb(cc)end)db=db+1 end
local _c=10 +math.ceil(db/2)* (bb.AbsoluteSize.Y+5)ab.CanvasSize=UDim2.new(0,0,0,_c)end
aa=ca:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","userSettings")if aa.musicVolume then
_b.bar.slider.Position=UDim2.new(aa.musicVolume,0,0.5,0)end
ca:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",function(db,_c)
if db==
"userSettings"then aa=_c;if aa.musicVolume then
_b.bar.slider.Position=UDim2.new(aa.musicVolume,0,0.5,0)end end end)end;return d