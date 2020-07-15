
local ac=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("projectile")local dc=bc.load("placeSetup")
local _d=bc.load("client_utilities")local ad=bc.load("network")local bd=bc.load("detection")
local cd=bc.load("damage")local dd=bc.load("utilities")local __a=bc.load("levels")
local function a_a(aaa,baa)
local caa=Instance.new("Motor6D")caa.Part0=aaa;caa.Part1=baa;caa.C0=CFrame.new()
caa.C1=baa.CFrame:toObjectSpace(aaa.CFrame)caa.Name=baa.Name;caa.Parent=aaa end;local b_a=game:GetService("HttpService")
local c_a=game:GetService("RunService")
local d_a={id=15,book="hunter",name="Barrage",image="rbxassetid://3736597469",description="Fire three arrows at once. (Requires bow.)",damageType="physical",windupTime=0.1,maxRank=10,prerequisite={{id=7,rank=1}},layoutOrder=1,statistics={[1]={damageMultiplier=1.25,manaCost=15,cooldown=5,angleOffset=2.5},[2]={damageMultiplier=1.30},[3]={damageMultiplier=1.35},[4]={damageMultiplier=1.40},[5]={damageMultiplier=1.45},[6]={damageMultiplier=1.50},[7]={damageMultiplier=1.55},[8]={damageMultiplier=1.60},[9]={damageMultiplier=1.65},[10]={damageMultiplier=1.75}},securityData={playerHitMaxPerTag=1},equipmentTypeNeeded="bow",disableAutoaim=true,projectileSpeed=200,targetingData={targetingType="projectile",projectileSpeed="projectileSpeed",projectileGravity=1,onStarted=function(aaa)
local baa=aaa.entity.AnimationController:LoadAnimation(ac.bow_targeting_sequence)baa:Play()return{track=baa}end,onEnded=function(aaa,baa,caa)
caa.track:Stop()end}}local _aa=Random.new()
function d_a._serverProcessDamageRequest(aaa,baa,caa)
if
aaa=="arrow-1"or aaa=="arrow-2"or aaa=="arrow-3"then return baa,"physical","projectile"end end
function d_a:validateDamageRequest(aaa,baa)return(aaa-baa).magnitude<=2 end
function d_a:execute(aaa,baa,caa,daa)
if not aaa:FindFirstChild("entity")then return end
local _ba=ad:invoke("{43AF616F-F116-4C11-A6BC-C47304DE8FE6}",aaa)if not _ba then return end
local aba=ad:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local bba=aba["1"]and aba["1"].manifest
if not bba then return end
if baa["ability-state"]=="begin"then
local cba=aaa.entity.AnimationController:LoadAnimation(ac.player_tripleshot)
local dba=bba.AnimationController:LoadAnimation(ac.bow_tripleshot)local _ca=script.arrow:Clone()_ca.Reflectance=1
_ca.Material=Enum.Material.Neon;_ca.Anchored=true;_ca.Parent=workspace.CurrentCamera
local aca=script.arrow:Clone()aca.Parent=workspace.CurrentCamera
local bca=script.arrow:Clone()bca.Reflectance=1;bca.Material=Enum.Material.Neon
_ca.Anchored=true;bca.Parent=workspace.CurrentCamera;local cca={}cca.arrow1=_ca
cca.arrow2=aca;cca.arrow3=bca
ad:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",_ba,"abilityRenderData"..d_a.id,cca)local dca=script.sphere:Clone()
dca.Parent=workspace.CurrentCamera;local _da=script.sphere:Clone()
_da.Parent=workspace.CurrentCamera;local ada=bba.slackRopeRepresentation.arrowHolder
ada.C0=
CFrame.Angles(0,math.rad(180),0)*CFrame.Angles(math.rad(45),0,0)*
CFrame.Angles(math.rad(45),0,0)*CFrame.new(0,
-aca.Size.Y/2 -0.1,0)ada.Part1=aca;ada.Parent=bba.slackRopeRepresentation;local bda
do
local function __b()if bda then
bda:disconnect()bda=nil end;_ca:Destroy()aca:Destroy()
bca:Destroy()if caa then
ad:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",true)end end;bda=dba.Stopped:connect(__b)end;cba:Play()dba:Play()if caa then
ad:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",false)end
dd.playSound("bowDraw",
bba:IsA("Model")and bba.PrimaryPart or bba)local cda=baa["ability-statistics"].angleOffset
local dda=tick()
do local __b=Vector3.new(0.154,0.050,0.301)
local a_b=Vector3.new(0.154,2.803,0.301)local b_b=Vector3.new(0.050,0.050,0.050)
local c_b=Vector3.new(1.000,1.000,1.000)
while true do local d_b=(tick()-dda)/ (0.3 *dba.Length)
dca.Size=c_b:Lerp(__b,d_b)_da.Size=c_b:Lerp(__b,d_b)
dca.CFrame=bba.arrowPart.CFrame*CFrame.Angles(-
math.rad(cda),0,0)*CFrame.new(0,1.15,0)
_da.CFrame=
bba.arrowPart.CFrame*CFrame.Angles(math.rad(cda),0,0)*CFrame.new(0,-1.15,0)_ca.Size=__b:Lerp(a_b,d_b)bca.Size=__b:Lerp(a_b,d_b)
_ca.CFrame=
dca.CFrame*CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(80),0,0)*
CFrame.new(0,_ca.Size.Y/2,0)
bca.CFrame=_da.CFrame*CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(80),0,0)*
CFrame.new(0,bca.Size.Y/2,0)
if d_b<=1 then c_a.RenderStepped:Wait()else break end end;dca:Destroy()_da:Destroy()ada.Part1=nil end
if caa then
local __b=ad:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",d_a.id)__b["ability-state"]="update"__b["ability-guid"]=daa
local a_b,b_b=dd.safeJSONEncode(__b)
game.Players.LocalPlayer.Character.PrimaryPart.activeAbilityExecutionData.Value=b_b
ad:fireServer("{51A91F3B-9019-471D-A6C9-79833B23B075}",d_a.id,"update",__b,daa)end elseif baa["ability-state"]=="update"then
local cba=ad:invoke("{BEC900E6-8DE3-4227-8435-05D09CBBABA5}",_ba,"abilityRenderData"..
d_a.id)if not cba then return end
ad:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",_ba,"abilityRenderData"..d_a.id,
nil)
local dba=dc.awaitPlaceFolder("entityManifestCollection")local _ca=dc.awaitPlaceFolder("entityRenderCollection")
local aca=baa["ability-statistics"].angleOffset;local bca=cba.arrow1;local cca=cba.arrow2;local dca=cba.arrow3
local _da,ada=cc.getUnitVelocityToImpact_predictive(cca.Position,self.projectileSpeed,baa["mouse-target-position"],Vector3.new())
spawn(function()for i=1,3 do wait()
dd.playSound("bowFire",bba:IsA("Model")and bba.PrimaryPart or bba)end end)
cc.createProjectile(cca.Position,_da,self.projectileSpeed,cca,function(bda,cda,dda,__b)if cca:FindFirstChild("Trail")then
cca.Trail.Enabled=false end;local a_b=2
if bda then
if(bda:IsDescendantOf(dba)or
bda:IsDescendantOf(_ca))then cca.Anchored=false;a_a(cca,bda)a_b=5 else
if
cca:FindFirstChild("impact")then local b_b=bda.Color;if bda==workspace.Terrain then
b_b=bda:GetMaterialColor(__b)end;local c_b=Instance.new("Part")
c_b.Size=Vector3.new(0.1,0.1,0.1)c_b.Transparency=1;c_b.Anchored=true;c_b.CanCollide=false;c_b.CFrame=cca.CFrame-
cca.CFrame.p+cda
local d_b=cca.impact:Clone()d_b.Parent=c_b;c_b.Parent=workspace.CurrentCamera
d_b.Color=ColorSequence.new(b_b)d_b:Emit(10)game.Debris:AddItem(c_b,3)end end end;dd.playSound("bowArrowImpact",cca)
game:GetService("Debris"):AddItem(cca,a_b)
if caa and bda then
local b_b,c_b=cd.canPlayerDamageTarget(game.Players.LocalPlayer,bda)if b_b and c_b then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",c_b,cda,"ability",self.id,"arrow-2",daa)end end end,function(bda)return
CFrame.Angles(math.rad(90),0,0)end,{aaa,aaa.clientHitboxToServerHitboxReference.Value},true)
cc.createProjectile(bca.Position,(CFrame.new(Vector3.new(),_da)*
CFrame.Angles(0,math.rad(aca),0)).lookVector,self.projectileSpeed,bca,function(bda,cda,dda,__b)if
bca:FindFirstChild("Trail")then bca.Trail.Enabled=false end;local a_b=2
if bda then
if(
bda:IsDescendantOf(_ca)or bda:IsDescendantOf(dba))then bca.Anchored=false
a_a(bca,bda)a_b=5 else
if bca:FindFirstChild("impact")then local b_b=bda.Color;if bda==workspace.Terrain then
b_b=bda:GetMaterialColor(__b)end;local c_b=Instance.new("Part")
c_b.Size=Vector3.new(0.1,0.1,0.1)c_b.Transparency=1;c_b.Anchored=true;c_b.CanCollide=false;c_b.CFrame=bca.CFrame-
bca.CFrame.p+cda
local d_b=bca.impact:Clone()d_b.Parent=c_b;c_b.Parent=workspace.CurrentCamera
d_b.Color=ColorSequence.new(b_b)d_b:Emit(10)game.Debris:AddItem(c_b,3)end end end;dd.playSound("bowArrowImpact",bca)
game:GetService("Debris"):AddItem(bca,a_b)
if caa and bda then
local b_b,c_b=cd.canPlayerDamageTarget(game.Players.LocalPlayer,bda)if b_b and c_b then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",c_b,cda,"ability",self.id,"arrow-1",daa)end end end,function(bda)return
CFrame.Angles(math.rad(90),0,0)end,{aaa,aaa.clientHitboxToServerHitboxReference.Value},true)
cc.createProjectile(dca.Position,(CFrame.new(Vector3.new(),_da)*CFrame.Angles(0,-
math.rad(aca),0)).lookVector,self.projectileSpeed,dca,function(bda,cda,dda,__b)if
dca:FindFirstChild("Trail")then dca.Trail.Enabled=false end;local a_b=2
if bda then
if(
bda:IsDescendantOf(_ca)or bda:IsDescendantOf(dba))then dca.Anchored=false
a_a(dca,bda)a_b=5 else
if dca:FindFirstChild("impact")then local b_b=bda.Color;if bda==workspace.Terrain then
b_b=bda:GetMaterialColor(__b)end;local c_b=Instance.new("Part")
c_b.Size=Vector3.new(0.1,0.1,0.1)c_b.Transparency=1;c_b.Anchored=true;c_b.CanCollide=false;c_b.CFrame=dca.CFrame-
dca.CFrame.p+cda
local d_b=dca.impact:Clone()d_b.Parent=c_b;c_b.Parent=workspace.CurrentCamera
d_b.Color=ColorSequence.new(b_b)d_b:Emit(10)game.Debris:AddItem(c_b,3)end end end;dd.playSound("bowArrowImpact",dca)
game:GetService("Debris"):AddItem(dca,a_b)
if caa and bda then
local b_b,c_b=cd.canPlayerDamageTarget(game.Players.LocalPlayer,bda)if b_b and c_b then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",c_b,cda,"ability",self.id,"arrow-3",daa)end end end,function(bda)return
CFrame.Angles(math.rad(90),0,0)end,{aaa,aaa.clientHitboxToServerHitboxReference.Value},true)if caa then
ad:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
ad:fireServer("{51A91F3B-9019-471D-A6C9-79833B23B075}",d_a.id,"end")end elseif
baa["ability-state"]=="end"then end end;return d_a