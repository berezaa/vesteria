local c_a={}local d_a=game:GetService("CollectionService")
local _aa=game:GetService("ReplicatedStorage")local aaa=require(_aa.modules)local baa=aaa.load("network")
local caa=aaa.load("placeSetup")local daa=aaa.load("physics")local _ba=aaa.load("utilities")
local aba=require(_aa.professionLookup)local bba=game:GetService("ServerStorage")
local cba=game:GetService("HttpService")local dba=_aa.itemData;local _ca=require(dba)
local aca=caa.getPlaceFolder("items")local bca=2.2
local cca=caa.getPlaceFolder("fishingRegionCollections")
local dca={["Fresh Fish"]={id="fish",level=1,expMulti=1,favoredRodLevel=1},["Zebra Fish"]={id="pretty pink fish",level=1,expMulti=1,favoredRodLevel=1},["Rock Fish"]={id="tall blue fish",level=2,expMulti=1,favoredRodLevel=1}}
local function _da(_ab,aab)
if dca[_ab]then return
{id=dca[_ab].id,level=dca[_ab].level,rolls=aab,favoredRodLevel=dca[_ab].favoredRodLevel,expMulti=dca[_ab].expMulti}end;return false,"entry does not exist in fishpedia"end
local ada={["2061558182"]={_da("Fresh Fish",50),_da("Zebra Fish",50)},["2119298605"]={{id="fish",level=1,rolls=20}}}local bda;do bda=script.spot:Clone()bda.CanCollide=true
bda.Anchored=true;d_a:AddTag(bda,"fishingSpot")
daa:setWholeCollisionGroup(bda,"fishingSpots")end
local cda={}
local function dda(_ab,aab)wait(math.random(4,10))
if
cda[_ab]and cda[_ab].guid==aab then local bab=false
for cab,dab in pairs(cca:GetChildren())do
for _bb,abb in
pairs(dab.FishFolder:GetChildren())do
if abb.Parent and abb:isA("Part")then if

(abb.Position-cda[_ab].castPosition).magnitude<=script.spot.Size.Y/2 +.1 then bab=true end end end end;if bab then cda[_ab].lastTimeBobbed=tick()
baa:fireClient("{13EFDC34-33BB-47A4-B0E8-95EBEA676878}",_ab)else end;dda(_ab,aab)end end
local function __b(_ab,aab)
if not cda[_ab]then local bab=_ab.Character
if bab then if
(bab.PrimaryPart.Position-aab).magnitude>100 then return end else return end
local cab=baa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ab)
if cab then local dab=cba:GenerateGUID(false)local _bb={}_bb.lastTimeBobbed=0
_bb.guid=dab;_bb.castPosition=aab;cda[_ab]=_bb
spawn(function()wait(1)if cda[_ab]and
cda[_ab].guid==dab then dda(_ab,dab)end end)return true end end end
local function a_b(_ab,aab)
if cda[_ab]then
if tick()-cda[_ab].lastTimeBobbed<=bca then
cda[_ab]=nil;local bab=ada[tostring(game.PlaceId)]
if bab==nil then return end
local cab=baa:invoke("{83E76C51-0968-447F-84F6-89C2F8206D22}",_ab,"fishing")or 1
local dab=baa:invoke("{E465467C-BAB6-411A-B0AB-4EF4B37914E9}",_ab,1)if dab==nil then return end;local _bb=dab.id;local abb=0;if _bb==37 then abb=1 else return end
local bbb={}
for _db,adb in pairs(bab)do
if adb.level<=cab then
if adb.favoredRodLevel<abb then for ii=1,adb.rolls do
table.insert(bbb,adb.id)end else
for ii=1,adb.rolls+
math.clamp((cab-adb.level)*2,0,adb.rolls)do table.insert(bbb,adb.id)end end end end;if#bbb==0 then return end;local cbb=bbb[math.random(#bbb)]
local dbb=_ca[cbb].id
local _cb=baa:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",{id=dbb},aab+Vector3.new(0,0.5,0),{_ab})
local acb=(aab-_ab.Character.PrimaryPart.Position).unit
local bcb=CFrame.new(Vector3.new(),acb)*
CFrame.Angles(-math.pi/4,math.pi/8 * (
math.random()-0.5)*2,0)
local ccb=-
Vector3.new(bcb.lookVector.X,bcb.lookVector.Y*1.4,bcb.lookVector.Z)*50;_cb.Velocity=ccb;Instance.new("Attachment",_cb)
_cb:SetNetworkOwner(_ab)_cb.HumanoidRootPart:SetNetworkOwner(_ab)
local dcb=baa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ab)if dcb then end;return true,_cb,ccb else cda[_ab]=nil end end end;local function b_b(_ab)cda[_ab]=nil end;local c_b=1.5
local function d_b()
game.Players.PlayerRemoving:connect(b_b)
baa:create("{D6E3F48A-F21A-4522-AA30-81C9563343DE}","RemoteFunction","OnServerInvoke",__b)
baa:create("{51AD8BDD-2BEA-49C4-B9AB-7D3997D72838}","RemoteFunction","OnServerInvoke",a_b)
baa:create("{13EFDC34-33BB-47A4-B0E8-95EBEA676878}","RemoteEvent")
spawn(function()
while wait(0 or c_b)do if cca==nil then return end
for _ab,aab in pairs(cca:GetChildren())do
local bab,cab=string.match(aab.Name,"(.+)-(%d+)")cab=tonumber(cab)
if cab then
local dab=cab-#aab.FishFolder:GetChildren()
if dab>0 then local _bb=bda:Clone()local abb={}
for _cb,acb in pairs(aab:GetChildren())do if
acb:isA("Part")then table.insert(abb,acb)end end;local bbb=abb[math.random(#abb)]
local cbb=math.random(bbb.Position.X-
bbb.Size.X/2,bbb.Position.X+bbb.Size.X/2)
local dbb=math.random(bbb.Position.Z-bbb.Size.Z/2,bbb.Position.Z+
bbb.Size.Z/2)
_bb.Position=Vector3.new(cbb,bbb.Position.Y+bbb.Size.Y/2 -.25,dbb)
_bb.effect.Position=_bb.Position-Vector3.new(0,.75,0)_bb.Parent=aab.FishFolder
game.Debris:AddItem(_bb,math.random(20,60))end end end end end)end;d_b()return c_a