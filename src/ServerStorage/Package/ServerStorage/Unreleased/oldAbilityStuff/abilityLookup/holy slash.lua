
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("projectile")local bc=_c.load("placeSetup")
local cc=_c.load("client_utilities")local dc=_c.load("network")local _d=_c.load("damage")
local ad=_c.load("detection")local bd=_c.load("tween")
local cd=bc.getPlaceFolder("entities")local dd=game:GetService("HttpService")
local __a={id=28,name="Holy Slash",image="rbxassetid://4079576639",description=".",damageType="physical",windupTime=0.1,maxRank=10,cooldown=3,cost=10,statistics={[1]={damageMultiplier=2.00,range=5,coneAngle=30,cooldown=3,manaCost=1},[2]={damageMultiplier=2.10},[3]={damageMultiplier=2.20,manaCost=30,range=7},[4]={damageMultiplier=2.30},[5]={damageMultiplier=2.40,manaCost=25,range=10}},damage=30,maxRange=30,equipmentTypeNeeded="sword"}
function __a._serverProcessDamageRequest(b_a,c_a)if b_a=="strike"then return c_a,"physical","direct"elseif b_a=="crescent"then return c_a,"magical",
"projectile"end end
function __a.__serverValidateMovement(b_a,c_a,d_a)
local _aa=dc:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",__a,dc:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",b_a,__a.id))return(d_a-c_a).magnitude<=_aa.range*2 end;local function a_a()end
function __a:execute(b_a,c_a,d_a,_aa)
if not b_a:FindFirstChild("entity")then return end
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",b_a.entity)local baa=aaa["1"]and aaa["1"].manifest
if not baa then return end
local caa=b_a.entity.AnimationController:LoadAnimation(script.holySlashAnimation)local daa;local _ba;local aba
local function bba(dba)
if not b_a:FindFirstChild("entity")or not
b_a.entity.PrimaryPart then return end;local _ca=b_a.entity.PrimaryPart
if dba=="releaseCrescent"then
local aca=_ca.CFrame.lookVector;local bca=_ca.CFrame+aca*3
local cca=CFrame.new(bca.p+aca*2,bca.p+aca*3)
local dca=CFrame.new(bca.p+aca*50,bca.p+aca*51)local _da=script.holySlashCrescent:Clone()
_da.Parent=workspace.CurrentCamera;_da.CFrame=cca;_da.Transparency=0.5
ac.createProjectile(cca.p,aca,60,_da,function(ada,bda,cda,dda,__b)
if ada then
local a_b,b_b=_d.canPlayerDamageTarget(game.Players.LocalPlayer,ada)if a_b and b_b then
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",b_b,bda,"ability",self.id,"crescent",_aa)end end
game:GetService("Debris"):AddItem(_da,0.1)end,function(ada)return
CFrame.new()end,{_da,b_a,b_a.clientHitboxToServerHitboxReference.Value},true,0.001)end end
local function cba()daa:disconnect()_ba:disconnect()end;daa=caa.KeyframeReached:connect(bba)
_ba=caa.Stopped:connect(cba)caa:Play()end;return __a