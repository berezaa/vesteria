local cc={}local dc={}local _d;local ad=game:GetService("RunService")
local bd=game.Players.LocalPlayer;local cd=game:GetService("ReplicatedStorage")
local dd=require(cd.modules)local __a=dd.load("network")local a_a=dd.load("utilities")
local b_a=dd.load("placeSetup")local c_a=require(cd.itemData)
local d_a=b_a.awaitPlaceFolder("items")local function _aa(_ba)_d=_ba.PrimaryPart end
local function aaa(_ba)
if _ba:WaitForChild("MASK_MOTOR",20)then
local aba=math.random(360)
local bba=CFrame.Angles(math.pi*math.sin(16 *aba),aba,math.pi*
math.cos(16 *aba))table.insert(dc,{manifest=_ba,offset=bba})end
if _ba:WaitForChild("owners",20)then wait()
if a_a.playerCanPickUpItem(bd,_ba)then
if
_ba:FindFirstChild("Legendary")then a_a.playSound("legendaryItemDrop",_ba)
_ba:WaitForChild("Trail",1)
_ba.Trail.Color=ColorSequence.new(Color3.fromRGB(138,11,170))elseif _ba:FindFirstChild("Rare",1)then
a_a.playSound("rareItemDrop",_ba)_ba:WaitForChild("Trail",1)
_ba.Trail.Color=ColorSequence.new(Color3.fromRGB(255,213,0))elseif _ba.Name=="monster idol"then a_a.playSound("idolDrop",_ba)else
a_a.playSound("itemDrop",_ba)end else
for aba,bba in pairs(_ba:GetDescendants())do
if
bba:IsA("BasePart")and bba.Transparency<1 then
bba.Transparency=1 - ( (1 -bba.Transparency)*0.3)if bba.Material==Enum.Material.Glass then
bba.Material=Enum.Material.SmoothPlastic end elseif
bba:IsA("ParticleEmitter")or
bba:IsA("Beam")or bba:IsA("Trail")or
bba:IsA("PointLight")or bba:IsA("Light")then bba.Enabled=false end end
if _ba:IsA("BasePart")then
_ba.Transparency=1 - ( (1 -_ba.Transparency)*0.3)if _ba.Material==Enum.Material.Glass then
_ba.Material=Enum.Material.SmoothPlastic end end end end end;local baa=2 *math.pi
local function caa()local _ba=math.rad(tick()%360)
local aba=Vector3.new(0,0.75 +
0.35 *math.sin(32 *_ba),0)
local bba=CFrame.Angles(0,math.pi*math.cos(16 *_ba),math.pi/6)
for cba,dba in pairs(dc)do if dba.manifest and dba.manifest.Parent then dba.manifest.MASK_MOTOR.C1=(
bba*dba.offset)+aba else
table.remove(dc,cba)end end end
local function daa()if bd.Character then _aa(bd.Character)end
bd.CharacterAdded:connect(_aa)for _ba,aba in pairs(d_a:GetChildren())do
spawn(function()aaa(aba)end)end
d_a.ChildAdded:connect(aaa)ad.Heartbeat:connect(caa)end;daa()return cc