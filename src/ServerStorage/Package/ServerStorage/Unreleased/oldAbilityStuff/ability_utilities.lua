local c={}
function c.getUnusedAbilityBookPoints(_a,aa,ba)
local ca=require(script.Parent.Parent.abilityBookLookup)local da=ca[_a]
local _b=(da.maxLevel-da.minLevel)*da.pointsGainPerLevel
local ab=
math.clamp((aa-da.minLevel)*da.pointsGainPerLevel,0,_b)+da.startingPoints;return ab-ba end;function c.getAbilityCastingOrigin(_a)end
function c.getAbilityStatisticsForRank(_a,aa)
if _a then if
not _a.statistics[aa-1]then return _a.statistics[aa],{}end;if not
_a.statistics[aa]then return nil end;local ba={}for i=1,aa do for _b,ab in
pairs(_a.statistics[i])do ba[_b]=ab end end
local ca={}
for i=1,aa-1 do for _b,ab in pairs(_a.statistics[i])do ca[_b]=ab end end;local da={}for _b,ab in pairs(_a.statistics[aa])do
if ca[_b]then da[_b]=ab-ca[_b]end end;return ba,da end end
function c.getMouseHoveredTarget(_a)
local aa=game.Players:GetPlayerByUserId(_a["cast-player-userId"])if not aa then return nil,false end
local ba=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ca=ba.load("damage")local da=ba.load("placeSetup")
local _b=da.awaitPlaceFolder("entityRenderCollection")local ab=_a["mouse-screen-position"]
local bb=workspace.CurrentCamera:ViewportPointToRay(ab.X,ab.Y)bb=Ray.new(bb.Origin,bb.Direction*1024)
local cb=workspace:FindPartOnRayWithWhitelist(bb,{_b})local db,_c=ca.canPlayerDamageTarget(aa,cb)return _c,db end
function c.raycastMap(_a)
if not c.RAYCAST_IGNORE_LIST then
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ba=aa.load("placeSetup")
local ca=ba.awaitPlaceFolder("entities")local da=ba.getPlaceFolder("spawnRegionCollections")
local _b=ba.getPlaceFolder("entityManifestCollection")local ab=ba.getPlaceFolder("entityRenderCollection")
local bb=ba.getPlaceFolder("items")local cb=ba.getPlaceFolder("foilage")
c.RAYCAST_IGNORE_LIST={da,_b,ab,bb,ca,cb}end
return workspace:FindPartOnRayWithIgnoreList(_a,c.RAYCAST_IGNORE_LIST)end
function c.getMeleeHorizontalHitbox(_a,aa,ba)local ca=ba["mouse-world-position"]
ca=Vector3.new(ca.X,_a.Y,ca.Z)
local da=CFrame.new(_a,ca)*CFrame.new(0,0,-aa.Z/2)return da end
function c.getCastingPlayer(_a)return
game:GetService("Players"):GetPlayerByUserId(_a["cast-player-userId"])end
function c.calculateStats(_a)local aa={}
if _a.dynamic then
for ba,ca in pairs(_a.dynamic)do local da=ca[1]local _b=ca[2]local ab={}ab.offset=(_b-
_a.maxRank*da)/ (1 -_a.maxRank)ab.slope=
da-ab.offset;if#ca>=3 then
for index=3,#ca do ab[index]=ca[index]end end;_a.dynamic[ba]=ab end end
for rank=1,_a.maxRank do local ba={}if rank==1 and _a.static then
for ca,da in pairs(_a.static)do ba[ca]=da end end;if _a.dynamic then
for ca,da in pairs(_a.dynamic)do ba[ca]=
rank*da.slope+da.offset;if da[3]=="int"then
ba[ca]=math.floor(ba[ca])end end end
if
_a.staggered then
for ca,da in pairs(_a.staggered)do local _b=#da.levels;local ab=0;for bb,cb in pairs(da.levels)do if rank>=cb then
ab=ab+1 end end;ba[ca]=da.first+ (
(da.final-da.first)/_b)*ab;if
da.integer then ba[ca]=math.floor(ba[ca])end end end
if _a.additive then for ca,da in pairs(_a.additive)do local _b=0;for index=1,rank do _b=_b+da[index]end
ba[ca]=_b end end
if _a.pattern then
for ca,da in pairs(_a.pattern)do local _b=da.base;local ab=1
for _=1,rank-1 do
_b=_b+da.pattern[ab]ab=ab+1;if ab>#da.pattern then ab=1 end end;ba[ca]=_b end end
for ca,da in pairs(ba)do ba[ca]=math.floor(da*100)/100 end;aa[rank]=ba end;return aa end
local function d(_a)return
(
CFrame.new(Vector3.new(),Vector3.new(_a.X,0,_a.Z))*CFrame.Angles(math.pi/4,0,0)).LookVector end
function c.knockbackMonster(_a,aa,ba,ca)local da=_a.BodyVelocity;local _b=-da.MaxForce
da.MaxForce=da.MaxForce+_b;local ab=_a.Position-aa;local bb=d(ab)
_a.Velocity=bb*ba/_a:GetMass()
delay(ca or 1,function()da.MaxForce=da.MaxForce-_b end)end
function c.knockbackLocalPlayer(_a,aa)aa=aa/14
local ba=require(script.Parent).load("network")local ca=game.Players.LocalPlayer;if not ca then return end;local da=ca.Character;if
not da then return end;local _b=da.PrimaryPart;if not _b then return end
local ab=_b.Position-_a;local bb=d(ab)
ba:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",bb*aa/_b:GetMass())end;return c