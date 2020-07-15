local ac=game:GetService("RunService")
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("projectile")local _d=cc.load("placeSetup")
local ad=cc.load("client_utilities")local bd=cc.load("network")local cd=cc.load("tween")
local dd=cc.load("configuration")local __a=_d.awaitPlaceFolder("entities")
local a_a=game:GetService("HttpService")
local b_a={id=32,name="Zap!",image="rbxassetid://3736598178",description="Zap your foes! Levels 5 & 10 add an electric beam.",mastery="Longer reach.",damageType="magical",animationName={},windupTime=0.35,maxRank=10,projectileSpeed=80,maxUpdateTimes=5,statistics={[1]={distance=30,manaCost=20,cooldown=3,damageMultiplier=1.1,bolts=3,tier=1},[2]={damageMultiplier=1.15},[3]={damageMultiplier=1.2},[4]={damageMultiplier=1.25},[5]={damageMultiplier=1.3,manaCost=25,bolts=4,tier=2},[6]={damageMultiplier=1.35},[7]={damageMultiplier=1.4},[8]={damageMultiplier=1.45},[9]={damageMultiplier=1.5},[10]={damageMultiplier=1.6,manaCost=30,bolts=5,tier=3}},securityData={playerHitMaxPerTag=5,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true}function b_a._serverProcessDamageRequest(aaa,baa,caa,daa)
if aaa=="bolt"then return baa,"magical","direct"end end
local function c_a(aaa,baa,caa)caa=caa or 1
local daa=(baa-aaa).magnitude;local _ba=Instance.new("Part")_ba.Anchored=true
_ba.CanCollide=false;_ba.TopSurface=Enum.SurfaceType.Smooth
_ba.BottomSurface=Enum.SurfaceType.Smooth;_ba.Material=Enum.Material.Neon
_ba.BrickColor=BrickColor.new("Electric blue")_ba.Size=Vector3.new(0.1 *caa,0.1 *caa,daa)
_ba.CFrame=
CFrame.new(aaa,baa)*CFrame.new(0,0,-daa/2)_ba.Parent=__a;cd(_ba,{"Transparency"},1,0.5)
game:GetService("Debris"):AddItem(_ba,0.5)end;local d_a=3
local function _aa(aaa,baa,caa,daa,_ba,aba,bba,cba,dba)local _ca=(baa-aaa).magnitude
local aca=math.sqrt(_ca/2)* (daa or 1)local bca=4;local cca=bba["ability-statistics"]["tier"]
local dca={{aaa,baa}}
for i=1,bca do local b_b={}
for c_b,d_b in pairs(dca)do local _ab=d_b[1]local aab=d_b[2]
local bab=360 *math.random()local cab=aca*math.random()local dab=CFrame.new(_ab,aab)local _bb=(aab-
_ab).magnitude
local abb=dab*CFrame.new(0,0,-_bb*math.random(40,60)/
100)*
CFrame.Angles(0,0,math.rad(bab))*CFrame.new(0,
cab*math.random(80,120)/100,0)table.insert(b_b,{_ab,abb.p})
table.insert(b_b,{abb.p,aab})if
caa and( (math.random(1,3)==2)or i==1 or i==2)then
table.insert(b_b,{abb.p,abb.p+dab.lookVector* (_bb/2)})end end;aca=aca/2;dca=b_b end;local _da=#dca;local ada=_ca/b_a.projectileSpeed
local bda=Ray.new(aaa,(baa-aaa).unit)for b_b,c_b in pairs(dca)do
c_b.lengthProjectionToThisSegment=(bda:ClosestPoint(c_b[1])-aaa).magnitude end;local cda=tick()
local dda=cc.load("damage")local __b={}local a_b={}
while true do local b_b=tick()-cda
local c_b=b_a.projectileSpeed*b_b
for d_b,_ab in pairs(dca)do
if _ab.lengthProjectionToThisSegment<=c_b then
local aab=table.remove(dca,d_b)c_a(aab[1],aab[2],cca)local bab=Ray.new(aaa,baa-aaa)
local cab={aba,workspace.CurrentCamera}
if workspace:FindFirstChild("placeFolders")and
workspace.placeFolders:FindFirstChild("foilage")then
table.insert(cab,workspace.placeFolders.foilage)end;local dab,_bb=dc.raycastForProjectile(bab,cab)
if
dab and not a_b[dab]then a_b[dab]=true
if _ba then
local cbb,dbb=dda.canPlayerDamageTarget(game.Players.LocalPlayer,dab)
if cbb and dbb and not __b[dbb]then __b[dbb]=true
bd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dbb,bba["mouse-world-position"],"ability",cba,"bolt",dba)end end;local abb=script.sparks:Clone()abb.Anchored=true
abb.CanCollide=false;abb.Transparency=1;abb.CFrame=CFrame.new(_bb)
abb.Parent=workspace.CurrentCamera;abb.Fire:Emit(25)
local bbb=script.zappity:Clone()bbb.Parent=abb
if not _ba then bbb.Volume=bbb.Volume*0.65 end;bbb:Play()game.Debris:AddItem(abb,5)end end end;if#dca>0 then ac.Heartbeat:Wait()else break end end end
function b_a:execute(aaa,baa,caa,daa)
if not aaa:FindFirstChild("entity")then return end;local _ba=baa["mouse-world-position"]if not _ba then return end
local aba=bd:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",aaa.entity)local bba=aba["1"]and aba["1"].manifest;if not bba or not
bba:FindFirstChild("magic")then return end
local cba=baa["ability-statistics"]["bolts"]
if
baa["ability-state"]=="begin"or baa["ability-state"]=="update"then
if baa["ability-state"]=="begin"then
local dca=aaa.entity.AnimationController:LoadAnimation(bc.mage_zap)dca:Play()wait(self.windupTime/3)else
wait(self.windupTime/4)end;bba.magic.castEffect.Enabled=true
local dba=script.sparks:Clone()dba.Anchored=true;dba.CanCollide=false;dba.Transparency=1
dba.CFrame=CFrame.new(bba.magic.WorldPosition)dba.Parent=workspace.CurrentCamera;dba.Fire:Emit(15)
local _ca=script.zippity:Clone()_ca.Parent=dba;_ca:Play()
bba.magic.castEffect.Enabled=false;local aca=bba.magic.WorldPosition;local bca=_ba
local cca=aca+ (_ba-aca).unit*
baa["ability-statistics"].distance
spawn(function()
if caa and aaa.entity.PrimaryPart then if
not aaa:FindFirstChild("entity")then return end
_aa(bba.magic.WorldPosition,cca,true,1.1,caa,aaa,baa,self.id,daa)elseif not caa and aaa.entity.PrimaryPart then _aa(aca,cca,true,1.1)end end)
if
caa and(baa["times-updated"]or 0)< (cba-1)then
local dca=bd:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",b_a.id,baa)dca["ability-state"]="update"dca["ability-guid"]=daa
bd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"update",dca,daa)elseif caa then
bd:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"end")end end end;return b_a