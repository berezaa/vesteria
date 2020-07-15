
local ad=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local bd=game:GetService("Debris")
local cd=game:GetService("RunService")
local dd=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local __a=dd.load("network")local a_a=dd.load("damage")
local b_a=dd.load("placeSetup")local c_a=dd.load("tween")
local d_a=dd.load("ability_utilities")local _aa=dd.load("detection")local aaa=dd.load("projectile")
local baa=b_a.awaitPlaceFolder("entities")local caa=b_a.getPlaceFolder("spawnRegionCollections")
local daa=b_a.getPlaceFolder("entityManifestCollection")local _ba=b_a.getPlaceFolder("entityRenderCollection")
local aba=b_a.getPlaceFolder("items")local bba=b_a.getPlaceFolder("foilage")
local cba={caa,daa,_ba,aba,baa,bba}
local dba={id=1,name="Magic Missile",image="rbxassetid://3736638029",description="Call upon your innate magic ability to send out a homing energy missile.",mastery="More bolts.",prerequisite={{id=3,rank=1}},maxRank=5,statistics={[1]={cooldown=1,manaCost=10,bolts=1,damageMultiplier=1,tier=1},[2]={damageMultiplier=1.1,manaCost=12},[3]={bolts=2,damageMultiplier=0.75,cooldown=1.5,manaCost=15},[4]={damageMultiplier=0.8,manaCost=17},[5]={bolts=3,damageMultiplier=0.7,cooldown=2,manaCost=20}},windupTime=0.35,securityData={playerHitMaxPerTag=10,isDamageContained=true,projectileOrigin="character"},targetingData={targetingType="directSphere",radius=3,range=128,onStarted=function(aca,bca)
local cca=aca.entity.AnimationController:LoadAnimation(ad.rock_throw_upper_loop)cca:Play()return{track=cca}end,onEnded=function(aca,bca,cca)
cca.track:Stop()end}}
function createEffectPart()local aca=Instance.new("Part")aca.Anchored=true
aca.CanCollide=false;aca.TopSurface=Enum.SurfaceType.Smooth
aca.BottomSurface=Enum.SurfaceType.Smooth;return aca end
function bolt(aca,bca,cca,dca,_da)local ada=50;local bda=3 ^2;local cda=24 ^2;local dda=0.2;local __b=script.missile;if _da=="star"then
__b=script.star;ada=ada*1.5 end;local a_b=__b:Clone()a_b.CFrame=aca*
a_b.alignAttachment.CFrame:Inverse()local b_b=a_b.mover
local c_b=a_b.orientationAttachment;local d_b=a_b.trail;c_b.CFrame=aca;c_b.Parent=workspace.Terrain
a_b.Parent=baa
local _ab={speed=12,missile=a_b,target=nil,startTime=tick(),driftCFrame=CFrame.Angles(math.pi*2 *math.random(),0,math.pi*2 *
math.random())}local aab
local function bab(abb)aab:Disconnect()c_b:Destroy()a_b.Anchored=true
a_b.Transparency=1;d_b.Enabled=false;bd:AddItem(a_b,d_b.Lifetime)
if abb and dca then
local bbb="strike"if _da=="star"then bbb="twilight"end
__a:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",_ab.target,_ab.target.Position,"ability",dba.id,bbb,cca)end end
local function cab()local abb=_ab.missile;local bbb=abb.Position
local cbb=abb.CFrame.LookVector/2;local dbb=Ray.new(bbb,cbb)
local _cb=workspace:FindPartOnRayWithIgnoreList(dbb,cba,false,true)return _cb~=nil and _cb.CanCollide end
local function dab()local abb=a_a.getDamagableTargets(bca)
local bbb=_ab.missile.Position;local cbb=nil;local dbb=cda
for _cb,acb in pairs(abb)do
local bcb=_aa.projection_Box(acb.CFrame,acb.Size,bbb)local ccb=bcb-bbb
local dcb=ccb.X*ccb.X+ccb.Y*ccb.Y+ccb.Z*ccb.Z;if(dcb<=dbb)then cbb=acb;dbb=dcb end end;_ab.target=cbb end
local function _bb(abb)b_b.Velocity=
(a_b.CFrame*a_b.alignAttachment.CFrame).LookVector*_ab.speed
if
_ab.target then
local bbb=CFrame.new(a_b.Position,_ab.target.Position)c_b.CFrame=bbb
local cbb=_ab.target.Position-a_b.Position
local dbb=cbb.X*cbb.X+cbb.Y*cbb.Y+cbb.Z*cbb.Z;local _cb=_ab.target.Size/2;local acb=_cb.X*_cb.X+_cb.Y*_cb.Y+
_cb.Z*_cb.Z;if
dbb<=math.max(bda,acb)then bab(true)end else local bbb=tick()
local cbb=bbb-_ab.startTime;if cbb>=dda then _ab.speed=ada;dab()else
b_b.Velocity=_ab.driftCFrame.LookVector*_ab.speed end end;if cab()then bab(false)end end;_bb()aab=cd.Heartbeat:Connect(_bb)
delay(1.4,function()bab(false)end)return _ab end
function dba._serverProcessDamageRequest(aca,bca)if aca=="strike"then return bca,"magical","aoe"elseif aca=="twilight"then return bca*1.25,
"magical","aoe"end end
local function _ca(aca,bca,cca,dca,_da,ada)
for boltNumber=1,aca do bolt(bca,cca,dca,_da,ada)if ada=="normal"then wait(0.1)elseif ada=="star"then
wait(0.05)end end end;function dba:execute_server(aca,bca,cca,dca)
__a:fireAllClientsExcludingPlayer("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",aca,bca,self.id,dca)end
function dba:execute_client(aca,bca)_ca(bca.bolts,bca.cframe,bca.owner,
nil,false,bca.boltType)end;function dba._abilityExecutionDataCallback(aca,bca)
bca["twilight"]=aca and
aca.nonSerializeData.statistics_final.activePerks["twilight"]end
function dba:execute(aca,bca,cca,dca)
local _da=aca.PrimaryPart;if not _da then return end;local ada=aca:FindFirstChild("entity")if not ada then
return end;local bda=ada:FindFirstChild("RightHand")
if not bda then return end
local cda=aca.entity.AnimationController:LoadAnimation(ad["rock_throw_upper"])cda:Play()wait(self.windupTime)for a_b,b_b in
pairs{script.throw,script.magic}do local c_b=b_b:Clone()c_b.Parent=_da;c_b:Play()
bd:AddItem(c_b,c_b.TimeLength)end
local dda=bca["ability-statistics"]["bolts"]local __b="normal"if bca["twilight"]then dda=dda+4;__b="star"end
if cca then
local a_b=bda.Position
local b_b=CFrame.new(_da.Position,bca["mouse-world-position"])b_b=b_b+ (a_b-b_b.Position)
_ca(dda,b_b,game.Players.LocalPlayer,dca,true,__b)
__a:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",bca,self.id,{bolts=dda,cframe=b_b,owner=game.Players.LocalPlayer,boltType=__b})end end;return dba