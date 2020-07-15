
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("detection")
local ad=_c.load("damage")local bd=_c.load("utilities")
local function cd(b_a,c_a)
local d_a=Instance.new("Motor6D")d_a.Part0=b_a;d_a.Part1=c_a;d_a.C0=CFrame.new()
d_a.C1=c_a.CFrame:toObjectSpace(b_a.CFrame)d_a.Name=c_a.Name;d_a.Parent=b_a end;local dd=game:GetService("HttpService")
local __a=game:GetService("RunService")
local a_a={id=15,book="hunter",name="Barrage",image="rbxassetid://2871266140",description="Like shooting an arrow, but with three times the arrow.",damageType="physical",windupTime=0.1,maxRank=10,statistics={[1]={damageMultiplier=1.25,manaCost=15,cooldown=12},[2]={damageMultiplier=1.30},[3]={damageMultiplier=1.35},[4]={damageMultiplier=1.40},[5]={damageMultiplier=1.45}},equipmentTypeNeeded="bow"}
function a_a._serverProcessDamageRequest(b_a,c_a)return c_a,"ranged","projectile"end
function a_a:validateDamageRequest(b_a,c_a)return(b_a-c_a).magnitude<=2 end
function a_a:execute(b_a,c_a,d_a,_aa)
if not b_a:FindFirstChild("entity")then return end
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)local baa=aaa["1"]and aaa["1"].manifest
if not baa then return end
local caa=bc.awaitPlaceFolder("playerManifestCollection")local daa=bc.awaitPlaceFolder("playerRenderCollection")
local _ba=bc.awaitPlaceFolder("monsterRenderCollection")
local aba=bc.awaitPlaceFolder("monsterManifestCollection")
local bba=b_a.entity.AnimationController:LoadAnimation(db.player_tripleshot)
local cba=baa.AnimationController:LoadAnimation(db.bow_tripleshot)local dba=script.arrow:Clone()dba.Reflectance=1
dba.Material=Enum.Material.Neon;dba.Anchored=true;dba.Parent=workspace.CurrentCamera
local _ca=script.arrow:Clone()_ca.Parent=workspace.CurrentCamera
local aca=script.arrow:Clone()aca.Reflectance=1;aca.Material=Enum.Material.Neon
dba.Anchored=true;aca.Parent=workspace.CurrentCamera
local bca=script.sphere:Clone()bca.Parent=workspace.CurrentCamera
local cca=script.sphere:Clone()cca.Parent=workspace.CurrentCamera
local dca=baa.slackRopeRepresentation.arrowHolder
dca.C0=
CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(45),0,0)*CFrame.Angles(math.rad(45),0,0)*CFrame.new(0,-_ca.Size.Y/2 -0.1,0)dca.Part1=_ca;dca.Parent=baa.slackRopeRepresentation;local _da
do local function dda()
dba:Destroy()_ca:Destroy()aca:Destroy()
dc:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",true)end
_da=cba.Stopped:connect(dda)end;bba:Play()cba:Play()
dc:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",false)local ada=tick()
do local dda=Vector3.new(0.154,0.050,0.301)
local __b=Vector3.new(0.154,2.803,0.301)local a_b=Vector3.new(0.050,0.050,0.050)
local b_b=Vector3.new(1.000,1.000,1.000)
while true do local c_b=(tick()-ada)/ (0.4 *cba.Length)
bca.Size=b_b:Lerp(dda,c_b)cca.Size=b_b:Lerp(dda,c_b)bca.CFrame=baa.arrowPart.CFrame*
CFrame.new(0,1,0)cca.CFrame=baa.arrowPart.CFrame*CFrame.new(0,
-1,0)
dba.Size=dda:Lerp(__b,c_b)aca.Size=dda:Lerp(__b,c_b)
dba.CFrame=

bca.CFrame*
CFrame.Angles(0,math.rad(180),0)*CFrame.Angles(math.rad(45),0,0)*CFrame.Angles(math.rad(45),0,0)*CFrame.new(0,dba.Size.Y/2,0)
aca.CFrame=cca.CFrame*CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(45),0,0)*
CFrame.Angles(math.rad(45),0,0)*
CFrame.new(0,aca.Size.Y/2,0)
if c_b<=1 then __a.RenderStepped:Wait()else break end end;bca:Destroy()cca:Destroy()dca.Part1=nil end
local bda,cda=ac.getUnitVelocityToImpact_predictiveByAbilityExecutionData(_ca.Position,200,c_a)
ac.createProjectile(_ca.Position,bda,200,_ca,function(dda,__b,a_b,b_b)if _ca:FindFirstChild("Trail")then
_ca.Trail.Enabled=false end;local c_b=2
if dda then
if
(
dda:IsDescendantOf(daa)or
dda:IsDescendantOf(_ba)or dda:IsDescendantOf(caa)or dda:IsDescendantOf(aba))then _ca.Anchored=false;cd(_ca,dda)c_b=5 else
if _ca:FindFirstChild("impact")then
local d_b=dda.Color
if dda==workspace.Terrain then d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=_ca.CFrame-
_ca.CFrame.p+__b
local aab=_ca.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;bd.playSound("bowArrowImpact",_ca)
game:GetService("Debris"):AddItem(_ca,c_b)
if d_a and dda then
local d_b,_ab=ad.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,nil,_aa)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{b_a},true)
ac.createProjectile(dba.Position,bda,200,dba,function(dda,__b,a_b,b_b)if dba:FindFirstChild("Trail")then
dba.Trail.Enabled=false end;local c_b=2
if dda then
if
(
dda:IsDescendantOf(daa)or
dda:IsDescendantOf(_ba)or dda:IsDescendantOf(caa)or dda:IsDescendantOf(aba))then dba.Anchored=false;cd(dba,dda)c_b=5 else
if dba:FindFirstChild("impact")then
local d_b=dda.Color
if dda==workspace.Terrain then d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=dba.CFrame-
dba.CFrame.p+__b
local aab=dba.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;bd.playSound("bowArrowImpact",dba)
game:GetService("Debris"):AddItem(dba,c_b)
if d_a and dda then
local d_b,_ab=ad.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,nil,_aa)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{b_a},true)
ac.createProjectile(aca.Position,bda,200,aca,function(dda,__b,a_b,b_b)if aca:FindFirstChild("Trail")then
aca.Trail.Enabled=false end;local c_b=2
if dda then
if
(
dda:IsDescendantOf(daa)or
dda:IsDescendantOf(_ba)or dda:IsDescendantOf(caa)or dda:IsDescendantOf(aba))then aca.Anchored=false;cd(aca,dda)c_b=5 else
if aca:FindFirstChild("impact")then
local d_b=dda.Color
if dda==workspace.Terrain then d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=aca.CFrame-
aca.CFrame.p+__b
local aab=aca.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;bd.playSound("bowArrowImpact",aca)
game:GetService("Debris"):AddItem(aca,c_b)
if d_a and dda then
local d_b,_ab=ad.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,nil,_aa)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{b_a},true)end;return a_a