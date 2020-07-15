local ac=game:GetService("ReplicatedStorage")
local bc=require(ac.modules)local cc=bc.load("pathfinding")local dc=bc.load("utilities")
local _d=bc.load("projectile")local ad=bc.load("detection")local bd=bc.load("network")
local cd=bc.load("placeSetup")local dd=cd.getPlaceFoldersFolder()local __a
do spawn(function()
__a=require(ac.itemData)end)end;local a_a=2;local b_a=6;local c_a=20;local d_a={dd}
local function _aa(aaa,baa)if not aaa.__LAST_NEARBY_ITEM_CHECK then
aaa.__LAST_NEARBY_ITEM_CHECK=0 end;if not aaa.owner then return nil end;if not
__a then return nil end
if baa or
tick()-aaa.__LAST_NEARBY_ITEM_CHECK>=2 then aaa.__LAST_NEARBY_ITEM_CHECK=tick()local caa,daa=nil,c_a
for _ba,aba in
pairs(dd.items:GetChildren())do
local bba=(aba.Position-aaa.manifest.Position).magnitude
if

bba<=daa and dc.playerCanPickUpItem(aaa.owner,aba,true)and
(not aba:FindFirstChild("playerDropSource")or
aba.playerDropSource.Value~=aaa.owner.userId)then
local cba=Ray.new(aaa.manifest.Position,aba.Position-aaa.manifest.Position)local dba=_d.raycastForProjectile(cba,d_a)
if not dba then
if __a[aba.Name]then if
bd:invoke("{64BA54DA-B49A-4738-9938-FAD92EB33267}",aaa.owner,{},{{id=__a[aba.Name].id}})then caa=aba;daa=bba end end end end end;aaa.__CLOSEST_ITEM=caa end;return aaa.__CLOSEST_ITEM end
return
{default="setup",states={["setup"]={animationEquivalent="idle",transitionLevel=0,step=function(aaa)
if aaa.owner then
if
aaa.owner.Character and aaa.owner.Character.PrimaryPart then
local baa=
aaa.owner.Character.PrimaryPart.CFrame*CFrame.new(0,0,3)*CFrame.new(2,0,0)aaa.manifest.CFrame=baa;return"idle"end end end},["idle"]={animationEquivalent="idle",transitionLevel=1,step=function(aaa,baa)
if
aaa.owner then
if aaa.owner.Character and aaa.owner.Character.PrimaryPart then
local caa=_aa(aaa)
if not caa then
local daa=(
(aaa.owner.Character.PrimaryPart.Position-aaa.manifest.Position)*Vector3.new(1,0,1)).magnitude;if daa>7 then return"follow"else
aaa.manifest.BodyVelocity.Velocity=Vector3.new()end else
aaa.timeSwitchToFetching=tick()return"fetching-item"end end end end},["follow"]={animationEquivalent="movement",transitionLevel=2,step=function(aaa,baa)
local caa=_aa(aaa)
if not caa then
local daa=(
(aaa.owner.Character.PrimaryPart.Position-aaa.manifest.Position)*Vector3.new(1,0,1))aaa.manifest.BodyVelocity.Velocity=daa.unit*20
aaa.manifest.BodyGyro.CFrame=CFrame.new(aaa.manifest.Position,
aaa.manifest.Position+daa)
if daa.magnitude<7 then return"idle"elseif daa.magnitude>=40 then return"setup"end else aaa.timeSwitchToFetching=tick()return"fetching-item"end end},["fetching-item"]={animationEquivalent="movement",transitionLevel=3,step=function(aaa,baa)
local caa=_aa(aaa)
if caa then local daa=caa.CFrame
local _ba=Vector3.new(aaa.manifest.Position.X,daa.Y,aaa.manifest.Position.Z)
aaa.manifest.BodyGyro.CFrame=CFrame.new(_ba,daa.p)
if
aaa.timeSwitchToFetching and tick()-aaa.timeSwitchToFetching<=6 then
if(_ba-daa.p).magnitude<3 then
aaa.manifest.BodyVelocity.Velocity=Vector3.new()
local aba,bba=bd:invoke("{9C17E666-62A0-4E6C-BCF3-B10CB1CCC44B}",aaa.owner,caa,true)if aba then _aa(aaa,true)end else aaa.manifest.BodyVelocity.Velocity=(daa.p-
_ba).unit*20 end else return"setup"end else return"follow"end end}}}