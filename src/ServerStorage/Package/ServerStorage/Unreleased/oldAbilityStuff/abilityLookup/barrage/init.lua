
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("projectile")local _d=cc.load("placeSetup")
local ad=cc.load("client_utilities")local bd=cc.load("network")local cd=cc.load("detection")
local dd=cc.load("damage")local __a=cc.load("utilities")local a_a=cc.load("levels")
local function b_a(caa,daa)
local _ba=Instance.new("Motor6D")_ba.Part0=caa;_ba.Part1=daa;_ba.C0=CFrame.new()
_ba.C1=daa.CFrame:toObjectSpace(caa.CFrame)_ba.Name=daa.Name;_ba.Parent=caa end;local c_a=game:GetService("HttpService")
local d_a=game:GetService("RunService")
local _aa={cost=2,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(caa)return caa.class=="Hunter"end}
local aaa={id=15,metadata=_aa,book="hunter",name="Barrage",image="rbxassetid://3736597469",description="Fire three arrows at once. (Requires bow.)",damageType="physical",windupTime=0.1,maxRank=10,prerequisite={{id=7,rank=1}},layoutOrder=1,statistics={[1]={damageMultiplier=1.2,manaCost=12,cooldown=7,_angleOffset=2.5},[2]={damageMultiplier=1.4,manaCost=14},[3]={damageMultiplier=1.6,manaCost=16},[4]={damageMultiplier=1.8,manaCost=18},[5]={damageMultiplier=2.1,cooldown=6,manaCost=21,tier=3},[6]={damageMultiplier=2.4,manaCost=24},[7]={damageMultiplier=2.7,manaCost=27},[8]={damageMultiplier=3.1,cooldown=5,manaCost=31,tier=4}},securityData={playerHitMaxPerTag=1},equipmentTypeNeeded="bow",disableAutoaim=true,projectileSpeed=200,targetingData={targetingType="projectile",projectileSpeed="projectileSpeed",projectileGravity=1,onStarted=function(caa)
local daa=caa.entity.AnimationController:LoadAnimation(bc.bow_targeting_sequence)daa:Play()return{track=daa}end,onEnded=function(caa,daa,_ba)
_ba.track:Stop()end}}local baa=Random.new()
function aaa._serverProcessDamageRequest(caa,daa,_ba)
if
caa=="arrow-1"or caa=="arrow-2"or caa=="arrow-3"then return daa,"physical","projectile"end end
function aaa:validateDamageRequest(caa,daa)return(caa-daa).magnitude<=2 end
function aaa:execute(caa,daa,_ba,aba)
if not caa:FindFirstChild("entity")then return end
local bba=bd:invoke("{43AF616F-F116-4C11-A6BC-C47304DE8FE6}",caa)if not bba then return end
local cba=bd:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",caa.entity)local dba=cba["1"]and cba["1"].manifest
if not dba then return end
if daa["ability-state"]=="begin"then
local _ca=caa.entity.AnimationController:LoadAnimation(bc.player_tripleshot)
local aca=dba.AnimationController:LoadAnimation(bc.bow_tripleshot)local bca=script.arrow:Clone()bca.Reflectance=1
bca.Material=Enum.Material.Neon;bca.Anchored=true;bca.Parent=workspace.CurrentCamera
local cca=script.arrow:Clone()cca.Parent=workspace.CurrentCamera
local dca=script.arrow:Clone()dca.Reflectance=1;dca.Material=Enum.Material.Neon
bca.Anchored=true;dca.Parent=workspace.CurrentCamera;local _da={}_da.arrow1=bca
_da.arrow2=cca;_da.arrow3=dca
bd:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",bba,"abilityRenderData"..aaa.id,_da)local ada=script.sphere:Clone()
ada.Parent=workspace.CurrentCamera;local bda=script.sphere:Clone()
bda.Parent=workspace.CurrentCamera;local cda=dba.slackRopeRepresentation.arrowHolder
cda.C0=
CFrame.Angles(0,math.rad(180),0)*CFrame.Angles(math.rad(45),0,0)*
CFrame.Angles(math.rad(45),0,0)*CFrame.new(0,
-cca.Size.Y/2 -0.1,0)cda.Part1=cca;cda.Parent=dba.slackRopeRepresentation;local dda
do
local function b_b()if dda then
dda:disconnect()dda=nil end;bca:Destroy()cca:Destroy()
dca:Destroy()if _ba then
bd:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",true)end end;dda=aca.Stopped:connect(b_b)end;_ca:Play()aca:Play()if _ba then
bd:invoke("{7312D87A-2CEB-427E-9FC9-78CB6711E469}",false)end
__a.playSound("bowDraw",
dba:IsA("Model")and dba.PrimaryPart or dba)local __b=daa["ability-statistics"]._angleOffset
local a_b=tick()
do local b_b=Vector3.new(0.154,0.050,0.301)
local c_b=Vector3.new(0.154,2.803,0.301)local d_b=Vector3.new(0.050,0.050,0.050)
local _ab=Vector3.new(1.000,1.000,1.000)
while true do local aab=(tick()-a_b)/ (0.3 *aca.Length)
ada.Size=_ab:Lerp(b_b,aab)bda.Size=_ab:Lerp(b_b,aab)
ada.CFrame=dba.arrowPart.CFrame*CFrame.Angles(-
math.rad(__b),0,0)*CFrame.new(0,1.15,0)
bda.CFrame=
dba.arrowPart.CFrame*CFrame.Angles(math.rad(__b),0,0)*CFrame.new(0,-1.15,0)bca.Size=b_b:Lerp(c_b,aab)dca.Size=b_b:Lerp(c_b,aab)
bca.CFrame=
ada.CFrame*CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(80),0,0)*
CFrame.new(0,bca.Size.Y/2,0)
dca.CFrame=bda.CFrame*CFrame.Angles(0,math.rad(180),0)*
CFrame.Angles(math.rad(80),0,0)*
CFrame.new(0,dca.Size.Y/2,0)
if aab<=1 then d_a.RenderStepped:Wait()else break end end;ada:Destroy()bda:Destroy()cda.Part1=nil end
if _ba then
local b_b=bd:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",aaa.id,daa)b_b["ability-state"]="update"b_b["ability-guid"]=aba
local c_b,d_b=__a.safeJSONEncode(b_b)
game.Players.LocalPlayer.Character.PrimaryPart.activeAbilityExecutionData.Value=d_b
bd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",aaa.id,"update",b_b,aba)end elseif daa["ability-state"]=="update"then
local _ca=bd:invoke("{BEC900E6-8DE3-4227-8435-05D09CBBABA5}",bba,"abilityRenderData"..
aaa.id)if not _ca then return end
bd:invoke("{71510047-678D-48FB-8A57-28C119ED14DB}",bba,"abilityRenderData"..aaa.id,
nil)
local aca=_d.awaitPlaceFolder("entityManifestCollection")local bca=_d.awaitPlaceFolder("entityRenderCollection")
local cca=daa["ability-statistics"]._angleOffset;local dca=_ca.arrow1;local _da=_ca.arrow2;local ada=_ca.arrow3
local bda,cda=dc.getUnitVelocityToImpact_predictive(_da.Position,self.projectileSpeed,daa["mouse-target-position"],Vector3.new())if not bda then
bda=(daa["mouse-target-position"]-_da.Position).Unit end
spawn(function()for i=1,3 do wait()
__a.playSound("bowFire",
dba:IsA("Model")and dba.PrimaryPart or dba)end end)
dc.createProjectile(_da.Position,bda,self.projectileSpeed,_da,function(dda,__b,a_b,b_b)if _da:FindFirstChild("Trail")then
_da.Trail.Enabled=false end;local c_b=2
if dda then
if(dda:IsDescendantOf(aca)or
dda:IsDescendantOf(bca))then _da.Anchored=false;b_a(_da,dda)c_b=5 else
if
_da:FindFirstChild("impact")then local d_b=dda.Color;if dda==workspace.Terrain then
d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=_da.CFrame-
_da.CFrame.p+__b
local aab=_da.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;__a.playSound("bowArrowImpact",_da)
game:GetService("Debris"):AddItem(_da,c_b)
if _ba and dda then
local d_b,_ab=dd.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,"arrow-2",aba)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{caa,caa.clientHitboxToServerHitboxReference.Value},true)
dc.createProjectile(dca.Position,(CFrame.new(Vector3.new(),bda)*
CFrame.Angles(0,math.rad(cca),0)).lookVector,self.projectileSpeed,dca,function(dda,__b,a_b,b_b)if
dca:FindFirstChild("Trail")then dca.Trail.Enabled=false end;local c_b=2
if dda then
if(
dda:IsDescendantOf(bca)or dda:IsDescendantOf(aca))then dca.Anchored=false
b_a(dca,dda)c_b=5 else
if dca:FindFirstChild("impact")then local d_b=dda.Color;if dda==workspace.Terrain then
d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=dca.CFrame-
dca.CFrame.p+__b
local aab=dca.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;__a.playSound("bowArrowImpact",dca)
game:GetService("Debris"):AddItem(dca,c_b)
if _ba and dda then
local d_b,_ab=dd.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,"arrow-1",aba)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{caa,caa.clientHitboxToServerHitboxReference.Value},true)
dc.createProjectile(ada.Position,(CFrame.new(Vector3.new(),bda)*CFrame.Angles(0,-
math.rad(cca),0)).lookVector,self.projectileSpeed,ada,function(dda,__b,a_b,b_b)if
ada:FindFirstChild("Trail")then ada.Trail.Enabled=false end;local c_b=2
if dda then
if(
dda:IsDescendantOf(bca)or dda:IsDescendantOf(aca))then ada.Anchored=false
b_a(ada,dda)c_b=5 else
if ada:FindFirstChild("impact")then local d_b=dda.Color;if dda==workspace.Terrain then
d_b=dda:GetMaterialColor(b_b)end;local _ab=Instance.new("Part")
_ab.Size=Vector3.new(0.1,0.1,0.1)_ab.Transparency=1;_ab.Anchored=true;_ab.CanCollide=false;_ab.CFrame=ada.CFrame-
ada.CFrame.p+__b
local aab=ada.impact:Clone()aab.Parent=_ab;_ab.Parent=workspace.CurrentCamera
aab.Color=ColorSequence.new(d_b)aab:Emit(10)game.Debris:AddItem(_ab,3)end end end;__a.playSound("bowArrowImpact",ada)
game:GetService("Debris"):AddItem(ada,c_b)
if _ba and dda then
local d_b,_ab=dd.canPlayerDamageTarget(game.Players.LocalPlayer,dda)if d_b and _ab then
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab,__b,"ability",self.id,"arrow-3",aba)end end end,function(dda)return
CFrame.Angles(math.rad(90),0,0)end,{caa,caa.clientHitboxToServerHitboxReference.Value},true)if _ba then
bd:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
bd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",aaa.id,"end")end elseif
daa["ability-state"]=="end"then end end;return aaa