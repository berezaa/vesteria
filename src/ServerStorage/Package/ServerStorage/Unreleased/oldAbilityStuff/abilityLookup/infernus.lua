
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("projectile")local cc=ac.load("placeSetup")
local dc=ac.load("client_utilities")local _d=ac.load("network")local ad=ac.load("damage")
local bd=ac.load("detection")local cd=ac.load("physics")
local dd=game:GetService("HttpService")
local __a=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local a_a=game:GetService("RunService")
local b_a=require(game:GetService("ReplicatedStorage"):WaitForChild("monsterLookup"))
local c_a={id=21,manaCost=1,name="Infernus",image="rbxassetid://2528903781",description="lol be a dragon",animationName={},windupTime=1.5,maxRank=1,statistics={[1]={flameConeAngle=15,flameConeDistance=10,flameConeSpeed=10,cooldown=5,duration=5,manaCost=1,damageMultiplier=1}},abilityDecidesEnd=true}
function c_a._serverProcessDamageRequest(d_a,_aa)return _aa,"magical","dot"end
function c_a:execute(d_a,_aa,aaa,baa)
if not d_a:FindFirstChild("entity")then return end
local caa=_d:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local daa=caa["1"]and caa["1"].manifest;if not daa or not
daa:FindFirstChild("magic")then return end
local _ba=daa:FindFirstChild("infernusCastPoint")
do if not _ba then
_ba=script.container.infernusCastPoint:Clone()_ba.Parent=daa end end
if
_aa["ability-state"]=="begin"or _aa["ability-state"]=="update"then
if not aaa then
_ba.ParticleEmitter.Enabled=_aa.areFlamesVisible or false
_ba.CFrame=CFrame.new(_ba.Position,_ba.Position+
(_aa.flamesDirection or Vector3.new(0,1,0)))end
if aaa and _aa["ability-state"]=="begin"then
spawn(function()local aba=false
local bba=(
_ba.CFrame*CFrame.new(0,0,-1)):toObjectSpace(_ba.CFrame).p;local function cba(_da)
if _da.UserInputType==Enum.UserInputType.MouseButton1 then aba=true end end
local function dba(_da)if _da.UserInputType==
Enum.UserInputType.MouseMovement then
bba=(_ba.CFrame*CFrame.new(0,0,-1)):toObjectSpace(_ba.CFrame).p end end;local function _ca(_da)
if _da.UserInputType==Enum.UserInputType.MouseButton1 then aba=false end end
local aca=game:GetService("UserInputService").InputBegan:connect(cba)
local bca=game:GetService("UserInputService").InputChanged:connect(dba)
local cca=game:GetService("UserInputService").InputEnded:connect(_ca)local dca=tick()
while
tick()-dca<=_aa["ability-statistics"].duration do _aa.areFlamesVisible=aba;_aa.flamesDirection=bba
_aa["ability-state"]="update"
_ba.ParticleEmitter.Enabled=_aa.areFlamesVisible or false
_ba.CFrame=CFrame.new(_ba.Position,_ba.Position+
(_aa.flamesDirection or Vector3.new(0,1,0)))
_d:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",c_a.id,"update",_aa,baa)a_a.Stepped:Wait()end;aca:disconnect()bca:disconnect()cca:disconnect()
_d:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",c_a.id,"end",_aa,baa)end)end elseif _aa["ability-state"]=="end"then _ba:Destroy()end end;return c_a