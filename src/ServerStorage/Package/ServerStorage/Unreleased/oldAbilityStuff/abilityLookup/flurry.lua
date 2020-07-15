
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("projectile")local cc=ac.load("placeSetup")
local dc=ac.load("client_utilities")local _d=ac.load("network")local ad=ac.load("damage")
local bd=ac.load("detection")local cd=ac.load("tween")
local dd=cc.getPlaceFolder("entities")local __a=game:GetService("HttpService")
local a_a={id=27,name="Flurry",image="rbxassetid://4079577011",description="Deal quick and powerful strikes to your enemy.",damageType="physical",windupTime=0.1,maxRank=10,cooldown=3,cost=10,statistics={[1]={damageMultiplier=2.00,range=5,coneAngle=30,cooldown=3,manaCost=1},[2]={damageMultiplier=2.10},[3]={damageMultiplier=2.20,manaCost=30,range=7},[4]={damageMultiplier=2.30},[5]={damageMultiplier=2.40,manaCost=25,range=10}},damage=30,maxRange=30,equipmentTypeNeeded="dagger"}function a_a._serverProcessDamageRequest(d_a,_aa)
if d_a=="strike"then return _aa,"physical","direct"end end
function a_a.__serverValidateMovement(d_a,_aa,aaa)
local baa=_d:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",a_a,_d:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",d_a,a_a.id))return(aaa-_aa).magnitude<=baa.range*2 end;local function b_a()end;local c_a=1
function a_a:execute(d_a,_aa,aaa,baa)
if not d_a:FindFirstChild("entity")then return end
local caa=_d:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local daa=caa["1"]and caa["1"].manifest
if not daa then return end
local _ba=d_a.entity.AnimationController:LoadAnimation(script.flurryAnimation)local aba;local bba;local cba={}local dba
local function _ca(bca)
if not d_a:FindFirstChild("entity")or not
d_a.entity.PrimaryPart then return end
if c_a==1 then
if bca~="slash0"and aaa then local cca=ad.getDamagableTargets()
for dca,_da in
pairs(ad.getDamagableTargets(game.Players.LocalPlayer))do local ada=daa.CFrame
local bda=bd.projection_Box(_da.CFrame,_da.Size,ada.p)
if
bd.boxcast_singleTarget(ada,daa.Size*Vector3.new(5,3,5),bda)then
_d:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_da,bda,"ability",self.id,"strike",baa)end end end elseif c_a==2 then
local cca=daa.CFrame:toObjectSpace(d_a.entity.PrimaryPart.CFrame)
if bca=="slash0"then local dca=ad.getDamagableTargets()
for _da,ada in pairs(dca)do if
(ada.Position-
d_a.entity.PrimaryPart.Position).magnitude<=30 then dba=ada;break end end;if dba then table.insert(cba,cca)end elseif dba then local dca=cba[#cba]
table.insert(cba,cca)local _da=(cca.p-dca.p)*Vector3.new(1,1,0)
local ada=
math.max(dba.Size.X,dba.Size.Y,dba.Size.Z)/2 +3
local bda=d_a.entity.PrimaryPart.CFrame* (-_da*ada)-
d_a.entity.PrimaryPart.CFrame.p+dba.Position
local cda=d_a.entity.PrimaryPart.CFrame* (_da*ada)-
d_a.entity.PrimaryPart.CFrame.p+dba.Position;local dda=script.flurryCrescent:Clone()
dda.Parent=workspace.CurrentCamera
dda.CFrame=CFrame.new(bda,cda)*CFrame.Angles(0,0,math.pi/2)dda.Transparency=1
cd(dda,{"CFrame"},{CFrame.new(cda,cda+_da)},0.5,Enum.EasingStyle.Quad)
cd(dda,{"Transparency"},{0},0.5,Enum.EasingStyle.Quad)
game:GetService("Debris"):AddItem(dda,0.5)if aaa then
_d:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dba,dba.Position,"ability",self.id,"strike",baa)end end end end
local function aca()aba:disconnect()bba:disconnect()end;aba=_ba.KeyframeReached:connect(_ca)
bba=_ba.Stopped:connect(aca)_ba:Play()end;return a_a