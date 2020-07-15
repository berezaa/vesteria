local a_a={}local b_a={}local c_a;local d_a=game:GetService("RunService")
local _aa=game.Players.LocalPlayer
local aaa=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local baa=aaa.load("network")
local caa=aaa.load("configuration")local daa=aaa.load("placeSetup")local _ba=aaa.load("damage")
local aba=aaa.load("detection")local bba=daa.getPlaceFolder("entities")
local cba=daa.getPlaceFolder("entityManifestCollection")local dba;local _ca=3;local aca=tick()local bca=Vector3.new(0,-60,0)
a_a.GRAVITY=bca
function a_a.calculateBeamProjectile(a_b,b_b,c_b,d_b)d_b=d_b or 1;local _ab=0.5 *0.5 *0.5;local aab=
0.5 *bca*d_b*c_b*c_b+b_b*c_b+a_b
local bab=aab- (
bca*d_b*c_b*c_b+b_b*c_b)/3
local cab=
(
_ab*bca*d_b*c_b*c_b+0.5 *b_b*c_b+a_b-_ab* (a_b+aab))/ (3 *_ab)-bab;local dab=(cab-a_b).magnitude;local _bb=(bab-aab).magnitude
local abb=(a_b-aab).unit;local bbb=(cab-a_b).unit;local cbb=bbb:Cross(abb).unit
local dbb=(bab-aab).unit;local _cb=dbb:Cross(abb).unit
abb=cbb:Cross(bbb).unit
local acb=CFrame.new(a_b.x,a_b.y,a_b.z,bbb.x,cbb.x,abb.x,bbb.y,cbb.y,abb.y,bbb.z,cbb.z,abb.z)
local bcb=CFrame.new(aab.x,aab.y,aab.z,dbb.x,_cb.x,abb.x,dbb.y,_cb.y,abb.y,dbb.z,_cb.z,abb.z)return dab,-_bb,acb,bcb end
function a_a.showProjectilePath(a_b,b_b,c_b,d_b)d_b=d_b or 1
local _ab=Instance.new("Attachment",workspace.Terrain)
local aab=Instance.new("Attachment",workspace.Terrain)local bab=Instance.new("Beam",workspace.Terrain)
bab.Attachment0=_ab;bab.Attachment1=aab
local cab,dab,_bb,abb=a_a.calculateBeamProjectile(a_b,b_b,c_b,d_b)bab.CurveSize0=cab;bab.CurveSize1=dab;bab.Segments=50;_ab.CFrame=
_ab.Parent.CFrame:inverse()*_bb;aab.CFrame=
aab.Parent.CFrame:inverse()*abb;return bab,_ab,aab end
function a_a.updateProjectilePath(a_b,b_b,c_b,d_b,_ab,aab,bab)bab=bab or 1
local cab,dab,_bb,abb=a_a.calculateBeamProjectile(d_b,_ab,aab,bab)a_b.CurveSize0=cab;a_b.CurveSize1=dab;a_b.Segments=50;b_b.CFrame=
b_b.Parent.CFrame:inverse()*_bb;c_b.CFrame=
c_b.Parent.CFrame:inverse()*abb end
local function cca(a_b,b_b)
local c_b,d_b,_ab,aab=workspace:FindPartOnRayWithIgnoreList(a_b,b_b)while c_b and not c_b.CanCollide do b_b[#b_b+1]=c_b
c_b,d_b,_ab,aab=workspace:FindPartOnRayWithIgnoreList(a_b,b_b)end
return c_b,d_b,_ab,aab end;a_a.raycastForProjectile=cca;a_a.raycast=cca;local dca
local function _da()local a_b={}
for b_b,c_b in
pairs(cba:GetChildren())do
if c_b:IsA("BasePart")then table.insert(a_b,c_b)elseif c_b:IsA("Model")and
c_b.PrimaryPart then table.insert(a_b,c_b.PrimaryPart)end end;return a_b end
local function ada(a_b)local b_b=aca+a_b;local c_b=_da()
for d_b,_ab in pairs(b_a)do local aab=b_b-_ab.startTime
local bab=_ab.origin+
_ab.velocity*aab+
0.5 * (bca*_ab.projectileGravityMultipler)*aab*aab;local cab=bab-_ab.lastPosition
local dab,_bb,abb,bbb=cca(Ray.new(_ab.lastPosition,cab+cab.unit*0.15),
_ab.ignoreList or
{bba,daa.getPlaceFolder("items"),daa.getPlaceFolder("foilage"),game.Players.LocalPlayer.Character})local cbb
if _ab.stepFunction then cbb=_ab.stepFunction(aab)end
if _ab.trackerPart then
if _ab.pointToNextPosition then
if cbb then
_ab.trackerPart.CFrame=CFrame.new(_bb,_bb+cab)*cbb else _ab.trackerPart.CFrame=CFrame.new(_bb,_bb+cab)end else if cbb then _ab.trackerPart.CFrame=CFrame.new(_bb)*cbb else
_ab.trackerPart.CFrame=CFrame.new(_bb)end end
if caa.getConfigurationValue("doUseTrackerPartAsHitbox",_aa)then
if not dab then
for dbb,_cb in pairs(c_b)do
if
not
_ab.reverseIgnoreList or not _ab.reverseIgnoreList[_cb]then
local acb=aba.projection_Box(_cb.CFrame,_cb.Size,_ab.trackerPart.CFrame.p)if
aba.boxcast_singleTarget(_ab.trackerPart.CFrame,_ab.trackerPart.Size,acb)then dab=_cb end end end end end end
if dab or aab> (_ab.projectileLifetime or 3)then
table.remove(b_a,d_b)
local dbb=math.clamp(aab,0,_ab.projectileLifetime or 3)
if
aab<= (_ab.projectileLifetime or 3)and(not _ab.collisionFunction or not
_ab.collisionFunction(dab,_bb,abb,bbb,dbb))then elseif
aab<= (_ab.projectileLifetime or 3)and _ab.collisionFunction then _ab.lastPosition=bab;table.insert(b_a,_ab)
table.insert(_ab.ignoreList,dab)else _ab.collisionFunction(dab,_bb,abb,bbb,dbb)end else _ab.lastPosition=bab end end;if#b_a==0 and c_a then c_a:disconnect()c_a=nil end
aca=tick()end
function a_a.createProjectile(a_b,b_b,c_b,d_b,_ab,aab,bab,cab,dab,_bb)
local abb={origin=a_b,direction=b_b,speed=c_b,velocity=b_b*c_b,collisionFunction=_ab,trackerPart=d_b,stepFunction=aab,lastPosition=a_b,startTime=tick(),ignoreList=bab,pointToNextPosition=cab or false,projectileGravityMultipler=dab or 1,projectileLifetime=_bb or 3}
if abb.ignoreList then abb.reverseIgnoreList={}for bbb,cbb in pairs(abb.ignoreList)do
abb.reverseIgnoreList[cbb]=true end end;table.insert(b_a,abb)if not c_a then aca=tick()
c_a=d_a.Heartbeat:connect(ada)end end
function a_a.createProjectileByProjectileData(a_b)
assert(a_b.origin,"projectileData lacking origin")
assert(a_b.origin,"projectileData lacking direction")assert(a_b.origin,"projectileData lacking speed")
a_b.lastPosition=a_b.origin;a_b.startTime=tick()a_b.ignoreList=a_b.ignoreList;a_b.pointToNextPosition=
a_b.pointToNextPosition or false;a_b.projectileGravityMultipler=
a_b.projectileGravityMultipler or 1;a_b.projectileLifetime=
a_b.projectileLifetime or 3
a_b.collisionFunction=a_b.collisionFunction or nil;a_b.trackerPart=a_b.trackerPart or nil
a_b.stepFunction=a_b.stepFunction or nil end
function a_a.makeIgnoreList(a_b)
local b_b={daa.getPlaceFolder("entities"),daa.getPlaceFolder("spawnRegionCollections"),daa.getPlaceFolder("items"),daa.getPlaceFolder("foilage")}
for c_b,d_b in pairs(a_b or{})do table.insert(b_b,d_b)end;return b_b end;local bda=math.sqrt
function a_a.getUnitVelocityToImpact_predictive(a_b,b_b,c_b,d_b,_ab,aab)aab=aab or 3;_ab=_ab or 1;local bab=a_b.X
local cab=a_b.Z;local dab=c_b.X;local _bb=c_b.Z;local abb=d_b.X;local bbb=d_b.Z
local cbb=(abb*abb+bbb*bbb-b_b*b_b)
local dbb=(2 *dab*abb-2 *bab*abb+2 *_bb*bbb-2 *cab*bbb)
local _cb=(dab*dab-2 *dab*bab+bab*bab+_bb*_bb-2 *_bb*
cab+cab*cab)if dbb*dbb-4 *cbb*_cb<0 then return nil,nil end
local acb=(-dbb+math.sqrt(
dbb*dbb-4 *cbb*_cb))/ (2 *cbb)local bcb=(-dbb-math.sqrt(dbb*dbb-4 *cbb*_cb))/
(2 *cbb)if acb<0 and bcb<0 then
return nil,nil end;local ccb
if acb>0 and bcb<0 then ccb=acb elseif bcb>0 and acb<0 then ccb=bcb elseif
acb>0 and bcb>0 then ccb=acb<bcb and acb or bcb end;if ccb>aab then return nil,nil end;local dcb=c_b+ccb*d_b
local _db=(dcb-a_b-0.5 *
(a_a.GRAVITY*_ab)*ccb^2)/ (b_b*ccb)return _db,dcb end
function a_a.getTargetPositionByAbilityExecutionData(a_b)
return
a_b["target-casting-position"]or a_b["target-position"]or a_b["mouse-world-position"]end
function a_a.getUnitVelocityToImpact_predictiveByAbilityExecutionData(a_b,b_b,c_b,d_b)
return
a_a.getUnitVelocityToImpact_predictive(a_b,b_b,a_a.getTargetPositionByAbilityExecutionData(c_b),
(
c_b["target-casting-position"]and Vector3.new())or c_b["target-velocity"]or Vector3.new(),d_b)end;local cda;local function dda(a_b)local b_b={a_b,bba}end
local function __b()
if d_a:IsClient()then while not
game.Players.LocalPlayer do wait()end
_aa=game.Players.LocalPlayer;if _aa.Character then dda(_aa.Character)end
_aa.CharacterAdded:connect(dda)end
game.ReplicatedStorage.cust_test_stuff.grav.Changed:connect(function(a_b)
bca=Vector3.new(0,a_b,0)a_a.GRAVITY=bca end)end;spawn(__b)return a_a