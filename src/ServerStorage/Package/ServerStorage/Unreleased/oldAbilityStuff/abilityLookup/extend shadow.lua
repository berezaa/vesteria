
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("damage")
local ad=_c.load("detection")local bd=_c.load("physics")
local cd=game:GetService("HttpService")local dd=game:GetService("RunService")
local __a=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))
local a_a={id=23,manaCost=15,name="Extend Shadow",image="http://www.roblox.com/asset/?id=1879548550",description="Send forth your shadow to impale your enemy",animationName={},windupTime=0.2,maxRank=10,statistics={[1]={distance=20,cooldown=5,manaCost=10,damageMultiplier=3}},dontDisableSprinting=true}
function a_a._serverProcessDamageRequest(b_a,c_a)return c_a,"physical","direct"end;function a_a.__serverValidateMovement(b_a,c_a,d_a)return true end
function a_a:execute(b_a,c_a,d_a,_aa)if not
b_a:FindFirstChild("entity")then return end
if b_a.entity.PrimaryPart then
local aaa=b_a.entity.PrimaryPart;local baa
do
local caa=Ray.new(c_a["absolute-mouse-world-position"]+Vector3.new(0,3,0),Vector3.new(0,
-999,0))
local daa,_ba=workspace:FindPartOnRayWithIgnoreList(caa,{workspace.CurrentCamera,workspace.placeFolders})if daa then baa=_ba+Vector3.new(0,2,0)end end
if baa then local caa=1.5;local daa=baa-aaa.Position;local _ba=100
local aba=script.shadowProjection:Clone()do aba.Parent=workspace.CurrentCamera end;local bba=tick()
do
while true do local bca=
tick()-bba
local cca=aaa.Position-daa.unit*caa+daa.unit*_ba*bca
local dca=Ray.new(cca+Vector3.new(0,1,0),Vector3.new(0,-999,0))
local _da,ada=workspace:FindPartOnRayWithIgnoreList(dca,{workspace.CurrentCamera,workspace.placeFolders})if _da then
aba.CFrame=
CFrame.new(ada,ada+daa)*CFrame.Angles(0,0,math.pi/2)+Vector3.new(0,0.025,0)end
if bca>=
(daa.magnitude+caa)/_ba then break else dd.RenderStepped:Wait()end end end;local cba=aba.Trail.Lifetime
delay(cba,function()aba:Destroy()end)local dba=script.shadow:Clone()do
dba.Parent=workspace.CurrentCamera end;local _ca=tick()
do
while true do
local bca=math.clamp((tick()-_ca)/0.5,0,1)dba.Size=Vector3.new(0.05,30 *bca,30 *bca)
dba.CFrame=
CFrame.new(aba.Position)*CFrame.Angles(0,0,math.pi/2)
if bca>=1 then break else dd.RenderStepped:Wait()end end end;local aca=tick()
do local bca=script.shadowSpikes:Clone()do
bca.Parent=workspace.CurrentCamera;bca.Size=dba.Size end
while true do local cca=
math.clamp((tick()-aca)/0.5,0,1)^ (1 /3)
bca.Size=Vector3.new(dba.Size.Y-
5,7 *cca,dba.Size.Z-5)bca.CFrame=CFrame.new(dba.Position)+
Vector3.new(0,bca.Size.Y/2,0)if cca>=1 then break else
dd.RenderStepped:Wait()end end
if d_a then
for cca,dca in
pairs(_d.getDamagableTargets(game.Players.LocalPlayer))do local _da=bca.CFrame
local ada=ad.projection_Box(dca.CFrame,dca.Size,_da.p)
if
ad.boxcast_singleTarget(_da,bca.Size*Vector3.new(3,2,3),ada)then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dca,ada,"ability",self.id,nil,_aa)end end end
delay(cba,function()bca:Destroy()local cca=tick()
do
while true do
local dca=math.clamp((tick()-cca)/0.5,0,1)
dba.Size=Vector3.new(0.05,30 * (1 -dca),30 * (1 -dca))
dba.CFrame=CFrame.new(aba.Position)*CFrame.Angles(0,0,math.pi/2)
if dca>=1 then break else dd.RenderStepped:Wait()end end end;dba:Destroy()end)end end end end;return a_a