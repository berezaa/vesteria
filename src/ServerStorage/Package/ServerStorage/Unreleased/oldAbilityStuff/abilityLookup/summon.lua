
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("projectile")local _d=cc.load("placeSetup")
local ad=cc.load("client_utilities")local bd=cc.load("network")local cd=cc.load("damage")
local dd=cc.load("detection")local __a=cc.load("physics")
local a_a=game:GetService("HttpService")
local b_a=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local c_a=game:GetService("RunService")
local d_a=require(game:GetService("ReplicatedStorage"):WaitForChild("monsterLookup"))
local _aa={cost=0,upgradeCost=0,maxRank=1,layoutOrder=1,requirement=function(caa)if
caa.nonSerializeData.playerPointer:FindFirstChild("developer")then return true else return false end end}
local aaa={id=19,metadata=_aa,manaCost=0,name="Summon",image="rbxassetid://2528903781",description="Call forth a player or monster by name.",animationName={},windupTime=1.5,maxRank=1,statistics={[1]={cooldown=5,manaCost=0,damageMultiplier=0}}}local baa=0.5
function aaa.summonGate(caa,daa,_ba,aba)if daa<2 then daa=2 end;local bba=baa/2
local cba=2 *math.sin(bba/daa)local dba=2 *math.pi/cba;local _ca={}
local aca=Instance.new("Part")aca.Size=Vector3.new(0.5,0.05,baa)
aca.BrickColor=BrickColor.new("Institutional white")aca.Material=Enum.Material.Neon;aca.Anchored=true
aca.CanCollide=false;local bca=0;local cca=c_a:IsServer()
while dba>0 do bca=bca+1;local ada=1;do if dba>1 then dba=dba-1 else ada=dba
dba=0 end end;local bda=aca:Clone()
bda.Parent=
cca and workspace.placeFolders.entities or workspace.CurrentCamera
bda.CFrame=caa*CFrame.Angles(0,cba*bca,0)*CFrame.new(0,0,daa)table.insert(_ca,bda)if bca%2 ==0 then wait()end end;wait(1)local dca=aca:Clone()dca.Shape=Enum.PartType.Cylinder;dca.Size=Vector3.new(0.05,
daa*2 +baa,daa*2 +baa)dca.CFrame=caa*CFrame.Angles(0,0,
math.pi/2)
dca.Parent=cca and
workspace.placeFolders.entities or workspace.CurrentCamera;dca.Transparency=0.015;local _da=aca:Clone()
_da.Shape=Enum.PartType.Cylinder;_da.Material=Enum.Material.Glass;_da.Size=Vector3.new(0.07,daa*2 +0.1 +baa,
daa*2 +0.1 +baa)_da.CFrame=
caa*CFrame.Angles(0,0,math.pi/2)
_da.Parent=
cca and workspace.placeFolders.entities or workspace.CurrentCamera;_da.Transparency=0.999
if aaa.execute_server then if c_a:IsClient()then
_ba["summon-end-position"]=caa.p
bd:invokeServer("{0650EB64-0176-4935-9226-F83AA6EF8464}",_ba,aaa.id,aba)end end
spawn(function()
for i=1,0,-1 / (aaa.windupTime*0.75 *30)do
_da.Size=Vector3.new(0.06,i* (daa*2 +
0.1),i* (daa*2 +0.1))
_da.CFrame=caa*CFrame.Angles(0,0,math.pi/2)wait()end;for ada,bda in pairs(_ca)do bda:Destroy()end;_ca=nil;wait(0.75)
for i=0,1,1 /
(1 *30)do
_da.Size=Vector3.new(0.06,i* (daa*2 +0.1),i* (daa*2 +0.1))
_da.CFrame=caa*CFrame.Angles(0,0,math.pi/2)wait()end;dca:Destroy()_da:Destroy()end)end
function aaa._serverProcessDamageRequest(caa,daa)return daa,"magical","direct"end
function aaa:execute_server(caa,daa,_ba)local aba=caa.Chatted:Wait()
if caa and caa.Character and
caa.Character.PrimaryPart then
local bba,cba=string.match(aba,"(%w+) (.+)")
if bba and cba then local dba,_ca=string.match(cba,"([%w%_]+)%s*(%d*)")
_ca=(
_ca==nil or _ca=="")and 1 or tonumber(_ca)bba=string.lower(bba)
if dba and _ca then
if bba=="monster"then
print("debug monster")
if d_a[dba]and _ba then
for i=1,_ca do
for bca,cca in pairs(daa)do print(bca," || ",cca)end
local aca=bd:invoke("{0A040B75-B4E3-4DED-A038-B72DCD22ED1D}",dba,daa["summon-end-position"],nil,{master=caa})end end elseif bba=="player"then print("debug player")
local aca=game.Players:FindFirstChild(dba)
do if not aca then
aca=bd:invoke("{FD22A59A-4EEC-482F-A241-8159B2B522BE}",dba,_ba)end end
if _ba then
if aca and aca.Character and aca.Character.PrimaryPart then
pcall(function()
aaa.summonGate(
aca.Character.PrimaryPart.CFrame-Vector3.new(0,
aca.Character.PrimaryPart.Size.Y/2 +0.05,0),4,
nil,nil)end)end
spawn(function()wait(aaa.windupTime)
if
aca and aca.Character and aca.Character.PrimaryPart then
bd:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",aca,CFrame.new(daa["summon-end-position"],Vector3.new(caa.Character.PrimaryPart.Position.X,daa["summon-end-position"].Y,caa.Character.PrimaryPart.Position.Z)))end end)end end end end end end
function aaa:execute(caa,daa,_ba,aba)
if not caa:FindFirstChild("entity")then return end
local bba=caa.entity.PrimaryPart.Position+
caa.entity.PrimaryPart.CFrame.lookVector*7;local cba=Ray.new(bba,Vector3.new(0,-10,0))
local dba,_ca,aca=workspace:FindPartOnRayWithIgnoreList(cba,{caa})
if dba then _ca=_ca+Vector3.new(0,0.05,0)
local bca=
CFrame.new(_ca,_ca+aca)*CFrame.Angles(math.pi/2,0,0)
if _ba then aaa.summonGate(bca,4,daa,aba)else spawn(function()
aaa.summonGate(bca,4,daa,aba)end)end end end;return aaa