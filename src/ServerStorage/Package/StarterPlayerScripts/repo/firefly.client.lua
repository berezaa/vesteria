local cc=game:GetService("RunService")local dc={}
local _d=game.Players.LocalPlayer;local ad=5;local bd=30;local cd;local dd=Vector3.new(200,10,200)
local __a=require(game.ReplicatedStorage:WaitForChild("modules"))local a_a=__a.load("placeSetup")
local b_a=__a.load("utilities")local c_a=__a.load("tween")local d_a=Instance.new("Folder")
d_a.Name="fireflies"d_a.Parent=workspace.CurrentCamera
local function _aa()
return
CFrame.new(workspace.CurrentCamera.CFrame.p)*
CFrame.new(math.random(-dd.X/2,dd.X/2),math.random(-dd.Y/2,dd.Y/2),math.random(
-dd.Z/2,dd.Z/2))end
local function aaa(_ba,aba)local bba=tick()
for cba,dba in pairs(dc)do
local _ca=(bba-dba.startTime)/dba.duration
dba.firefly.CFrame=dba.startCFrame:lerp(dba.targetCFrame,_ca)+Vector3.new(0,math.sin(
bba-dba.offsetY),0)
if _ca>=1 then local aca=_aa()local bca=
b_a.magnitude(aca.p-dba.firefly.Position)/ad;dba.duration=bca
dba.startCFrame=dba.firefly.CFrame;dba.targetCFrame=aca;dba.startTime=tick()end end end;local function baa(_ba)end;local caa
local function daa()if _d.Character then baa(_d.Character)end
_d.CharacterAdded:connect(baa)
while wait(1)do local _ba=workspace.CurrentCamera.CFrame
if not _ba then return end
for aba,bba in pairs(dc)do
if
b_a.magnitude(bba.firefly.Position-_ba.Position)>=b_a.magnitude(dd)*1.1 then
game.Debris:AddItem(bba.firefly,0.5)c_a(bba.firefly,{"Transparency"},1,0.5)
table.remove(dc,aba)end end
if
game.Lighting.ClockTime>=18 or game.Lighting.ClockTime<=6.15 then if not caa then caa=cc.Stepped:connect(aaa)end
if _ba and#
d_a:GetChildren()<bd then
local aba=game.ReplicatedStorage.firefly:Clone()
if game.ReplicatedStorage:FindFirstChild("fireflyColor")then
local dba=game.ReplicatedStorage.fireflyColor.Value;aba.Color=dba;if aba:FindFirstChild("ParticleEmitter")then
aba.ParticleEmitter.Color=ColorSequence.new(dba)end;if
aba:FindFirstChild("PointLight")then aba.PointLight.Color=dba end end;aba.Parent=d_a;aba.CFrame=_aa()aba.Transparency=1
c_a(aba,{"Transparency"},0,0.5)local bba=_aa()
local cba=b_a.magnitude(bba.p-aba.Position)/ad
table.insert(dc,{firefly=aba,duration=cba,startCFrame=aba.CFrame,targetCFrame=bba,startTime=tick(),offsetX=math.random(9001),offsetY=math.random(9001)})end else
if#d_a:GetChildren()>0 then
local aba=d_a:GetChildren()[1]for bba,cba in pairs(dc)do
if cba.firefly==aba then table.remove(dc,bba)end end;aba:Destroy()else if caa then
caa:disconnect()caa=nil end end end end end;daa()