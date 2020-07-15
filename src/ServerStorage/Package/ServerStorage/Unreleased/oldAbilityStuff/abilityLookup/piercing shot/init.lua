
local ac=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("projectile")local dc=bc.load("placeSetup")
local _d=bc.load("client_utilities")local ad=bc.load("network")local bd=bc.load("detection")
local cd=bc.load("damage")local dd=bc.load("utilities")local __a=bc.load("levels")
local function a_a(aaa,baa)
local caa=Instance.new("Motor6D")caa.Part0=aaa;caa.Part1=baa;caa.C0=CFrame.new()
caa.C1=baa.CFrame:toObjectSpace(aaa.CFrame)caa.Name=baa.Name;caa.Parent=aaa end;local b_a=game:GetService("HttpService")
local c_a=game:GetService("RunService")
local d_a={id=22,name="Piercing Shot",image="rbxassetid://2871266140",description="Fire an arrow that will pierce through enemies.",damageType="physical",windupTime=0.1,maxRank=10,statistics={[1]={damageMultiplier=1.50,manaCost=15,cooldown=5,angleOffset=2.5},[2]={damageMultiplier=1.60},[3]={damageMultiplier=1.70},[4]={damageMultiplier=1.80},[5]={damageMultiplier=1.90}},equipmentTypeNeeded="bow",disableAutoaim=false}local _aa=Random.new()
function d_a._serverProcessDamageRequest(aaa,baa,caa)
if aaa=="arrow-hit"then
if
__a.getPlayerCritChance(caa)>=_aa:NextNumber()then return baa*2,"physical","projectile"end;return baa,"physical","projectile"end end
function d_a:validateDamageRequest(aaa,baa)return(aaa-baa).magnitude<=2 end
function d_a:execute(aaa,baa,caa,daa)
if not aaa:FindFirstChild("entity")then return end
local _ba=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local aba=_ba["1"]and _ba["1"].manifest
if not aba then return end
local bba=dc.awaitPlaceFolder("entityManifestCollection")local cba=dc.awaitPlaceFolder("entityRenderCollection")
local dba=aaa.entity.AnimationController:LoadAnimation(ac.player_tripleshot)
local _ca=aba.AnimationController:LoadAnimation(ac.bow_tripleshot)local aca=script.arrow:Clone()aca.Reflectance=1
aca.Material=Enum.Material.Neon;aca.Anchored=true;aca.Parent=workspace.CurrentCamera
local bca=script.sphere:Clone()bca.Parent=workspace.CurrentCamera
local cca=script.sphere:Clone()cca.Parent=workspace.CurrentCamera
local dca=aba.slackRopeRepresentation.arrowHolder
dca.C0=
CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(45),0,0)*CFrame.Angles(math.rad(45),0,0)*CFrame.new(0,-aca.Size.Y/2 -0.1,0)dca.Part1=aca;dca.Parent=aba.slackRopeRepresentation;local _da
do
local function __b()
aca:Destroy()if caa then
ad:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",true)end end;_da=_ca.Stopped:connect(__b)end;dba:Play()_ca:Play()if caa then
ad:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",false)end
dd.playSound("bowDraw",
aba:IsA("Model")and aba.PrimaryPart or aba)local ada=baa["ability-statistics"].angleOffset
local bda=tick()
do local __b=Vector3.new(0.154,0.050,0.301)
local a_b=Vector3.new(0.154,2.803,0.301)local b_b=Vector3.new(0.050,0.050,0.050)
local c_b=Vector3.new(1.000,1.000,1.000)
while true do local d_b=(tick()-bda)/ (0.4 *_ca.Length)
bca.Size=c_b:Lerp(__b,d_b)cca.Size=c_b:Lerp(__b,d_b)
bca.CFrame=aba.arrowPart.CFrame*CFrame.Angles(-
math.rad(ada),0,0)*CFrame.new(0,1.15,0)
cca.CFrame=
aba.arrowPart.CFrame*CFrame.Angles(math.rad(ada),0,0)*CFrame.new(0,-1.15,0)aca.Size=__b:Lerp(a_b,d_b)
aca.CFrame=
bca.CFrame*
CFrame.Angles(0,math.rad(180),0)*CFrame.Angles(math.rad(80),0,0)*CFrame.new(0,aca.Size.Y/2,0)
if d_b<=1 then c_a.RenderStepped:Wait()else break end end;bca:Destroy()cca:Destroy()dca.Part1=nil end
local cda,dda=cc.getUnitVelocityToImpact_predictiveByAbilityExecutionData(aca.Position,200,baa)
spawn(function()for i=1,3 do wait()
dd.playSound("bowFire",aba:IsA("Model")and aba.PrimaryPart or aba)end end)
cc.createProjectile(aca.Position,cda,200,aca,function(__b,a_b,b_b,c_b)if aca:FindFirstChild("Trail")then
aca.Trail.Enabled=false end;local d_b=2
if __b then
if(__b:IsDescendantOf(bba)or
__b:IsDescendantOf(cba))then aca.Anchored=false;a_a(aca,__b)d_b=5 else
if
aca:FindFirstChild("impact")then local _ab=__b.Color;if __b==workspace.Terrain then
_ab=__b:GetMaterialColor(c_b)end;local aab=Instance.new("Part")
aab.Size=Vector3.new(0.1,0.1,0.1)aab.Transparency=1;aab.Anchored=true;aab.CanCollide=false;aab.CFrame=aca.CFrame-
aca.CFrame.p+a_b
local bab=aca.impact:Clone()bab.Parent=aab;aab.Parent=workspace.CurrentCamera
bab.Color=ColorSequence.new(_ab)bab:Emit(10)game.Debris:AddItem(aab,3)end end end;dd.playSound("bowArrowImpact",aca)
game:GetService("Debris"):AddItem(aca,d_b)
if caa and __b then
local _ab,aab=cd.canPlayerDamageTarget(game.Players.LocalPlayer,__b)if _ab and aab then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",aab,a_b,"ability",self.id,"arrow-hit",daa)return true end end end,function(__b)return
CFrame.Angles(math.rad(90),0,0)end,{aaa,aaa.clientHitboxToServerHitboxReference.Value},true)end;return d_a