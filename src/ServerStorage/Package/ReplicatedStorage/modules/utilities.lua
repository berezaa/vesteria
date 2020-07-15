local ab={}local bb=game:GetService("RunService")
local cb=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local db=cb.load("network")local _c=cb.load("configuration")function ab.simulateProjectileMotion()
end
ab.romanNumerals={"I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","XIII","XIV","XV","XVI","XVII","XVIII","XIX","XX"}
function ab.copyTable(ad)local bd={}
for cd,dd in pairs(ad)do if type(dd)=="table"then bd[cd]=ab.copyTable(dd)else
bd[cd]=dd end end;return bd end;function addComas(ad)
return#ad%3 ==0 and
ad:reverse():gsub("(%d%d%d)","%1,"):reverse():sub(2)or
ad:reverse():gsub("(%d%d%d)","%1,"):reverse()end
function ab.formatNumber(ad)
ad=math.floor(ad)return addComas(tostring(ad))end
function ab.isEntityManifestValid(ad,bd)
return



ad:FindFirstChild("entityType")and ad:FindFirstChild("entityId")and ad:FindFirstChild("state")and(bd or
ad.state.Value~="dead")and ad:FindFirstChild("health")and ad:FindFirstChild("maxHealth")end
function ab.getEntities(ad,bd)local cd={}
for dd,__a in
pairs(workspace.placeFolders.entityManifestCollection:GetChildren())do local a_a
do if __a:IsA("Model")and __a.PrimaryPart then a_a=__a.PrimaryPart elseif
__a:IsA("BasePart")then a_a=__a end end;if a_a then
if ab.isEntityManifestValid(a_a,bd)then if
not ad or a_a.entityType.Value==ad then table.insert(cd,a_a)end end end end;return cd end
function ab.timeToString(ad)local bd=math.floor(ad/86400)ad=ad-bd*86400;local cd=math.floor(
ad/3600)ad=ad-cd*3600
local dd=math.floor(ad/60)ad=ad-dd*60;local __a=""if bd>0 then __a=__a..bd.."d "end;if cd>0 then __a=__a..
cd.."h "end
if dd>0 then __a=__a..dd.."m "end;if ad>0 then __a=__a..ad.."s"end;return __a end
function ab.soundFromMirror(ad)local bd=Instance.new("Sound")for cd,dd in
pairs(game.HttpService:JSONDecode(ad.Value))do bd[cd]=dd end;for cd,dd in
pairs(ad:GetChildren())do dd:Clone().Parent=bd end;return bd end
function ab.playSound(ad,bd,cd,dd)local __a;if typeof(ad)=="string"then
__a=ab.soundFromMirror(game.ReplicatedStorage.sounds:FindFirstChild(ad))else __a=ad end
if __a then
if bd then
if typeof(bd)==
"Instance"and bd:IsA("BasePart")then __a.Volume=dd and dd.volume or
__a.Volume
__a.EmitterSize=dd and dd.emitterSize or __a.EmitterSize
__a.MaxDistance=dd and dd.maxDistance or __a.MaxDistance;__a.Parent=bd;__a:Play()if not __a.Looped then game.Debris:AddItem(__a,cd or
__a.TimeLength+1)elseif cd then
game.Debris:AddItem(__a,cd)end;return __a else local a_a
if
typeof(bd)=="CFrame"then a_a=bd elseif typeof(bd)=="Vector3"then a_a=CFrame.new(bd)end
if a_a then local b_a=Instance.new("Part")b_a.Name="soundPart"
b_a.Size=Vector3.new(1,1,1)b_a.Anchored=true;b_a.CanCollide=false;b_a.Transparency=1;b_a.CFrame=a_a
b_a.Parent=workspace.CurrentCamera;__a=__a:Clone()
__a.Volume=dd and dd.volume or __a.Volume
__a.EmitterSize=dd and dd.emitterSize or __a.EmitterSize
__a.MaxDistance=dd and dd.maxDistance or __a.MaxDistance;__a.Parent=b_a;__a:Play()if not __a.Looped then game.Debris:AddItem(b_a,cd or
__a.TimeLength+1)elseif cd then
game.Debris:AddItem(b_a,cd)end;return b_a else end end else if __a.Looped then __a:Play()else __a=__a:Clone()
__a.Parent=workspace.CurrentCamera;__a:Play()
game.Debris:AddItem(__a,1 +__a.TimeLength)end
return __a end else end end
function ab.weld(ad,bd)local cd=Instance.new("Motor6D")cd.Part0=ad;cd.Part1=bd
cd.C0=CFrame.new()cd.C1=bd.CFrame:toObjectSpace(ad.CFrame)
cd.Name=bd.Name;cd.Parent=ad end;local ac=game:GetService("HttpService")
function ab.safeJSONEncode(ad)
local bd=ab.copyTable(ad)for cd,dd in pairs(bd)do
if typeof(dd)=="Vector3"then bd[cd]={x=dd.X,y=dd.Y,z=dd.Z}elseif
typeof(dd)=="Vector2"then bd[cd]={x=dd.X,y=dd.Y}end end
return pcall(function()return
ac:JSONEncode(bd)end)end
function ab.safeJSONDecode(ad)
local bd,cd=pcall(function()return ac:JSONDecode(ad)end)
if bd then local dd=ab.copyTable(cd)
for __a,a_a in pairs(dd)do
if
typeof(a_a)=="table"and a_a.x and a_a.y and a_a.z then
dd[__a]=Vector3.new(a_a.x,a_a.y,a_a.z)elseif
typeof(a_a)=="table"and a_a.x and a_a.y and not a_a.z then dd[__a]=Vector2.new(a_a.x,a_a.y)end end;return true,dd end;return false,nil end;local bc
function ab.playerCanPickUpItem(ad,bd,cd)if not bc then
bc=require(game.ReplicatedStorage.itemData)end
if bd:FindFirstChild("pickupBlacklist")and
bd.pickupBlacklist:FindFirstChild(tostring(ad.userId))then return false end
if cd and bd:FindFirstChild("petsIgnore")then return false end
if bd:FindFirstChild("created")then
local dd=os.time()-bd.created.Value
if
dd>=_c.getConfigurationValue("timeForAnyonePickupItem")then return true elseif bc[bd.Name]then
if bc[bd.Name].everyoneAvailabilityTime and dd>=
bc[bd.Name].everyoneAvailabilityTime then return true end end end
if bd:FindFirstChild("owners")then
for dd,__a in pairs(bd.owners:GetChildren())do if
__a.Value==ad or tonumber(__a.Name)==ad.userId then
return true end end;return false end;return true end;function ab.magnitude(ad)local bd=ad.x;local cd=ad.y;local dd=ad.z
local __a=(bd*bd+cd*cd+dd*dd)return __a^.5 end
function ab.wipeReferences(ad)
for bd,cd in
pairs(ad)do if typeof(cd)=="Instance"then ad[bd]=nil elseif type(cd)=="table"then
ab.wipeReferences(cd)end;if typeof(bd)=="Instance"then ad[bd]=
nil end end end
function ab.isSafeToProcess(ad,bd,...)for cd,dd in pairs({...})do
if bd then ad:WaitForChild(dd)else if
not ad:FindFirstChild(dd)then return false end end end;return true end;function ab.isInTable(ad,bd)for cd,dd in pairs(ad)do if dd==bd then return true end end
return false end
local cc=Random.new()
function ab.selectFromWeightTable(ad)local bd=0
for cd,dd in pairs(ad)do bd=bd+dd.selectionWeight end
while true do local cd=cc:NextInteger(1,#ad)local dd=ad[cd]
if dd then
if
bd-dd.selectionWeight>0 then bd=bd-dd.selectionWeight else return dd,cd end else return ad[1]or{},ad[1]and 1 or nil end end end
local function dc(ad,bd,cd,dd)if not ad then return end;local __a,a_a=string.find(ad.Name,bd)
if __a==1 and a_a==#
(ad.Name)then if not cd or ad.className==cd or(
pcall(ad.IsA,ad,cd)and ad:IsA(cd))then
table.insert(dd,ad)end end;if pcall(ad.GetChildren,ad)then local b_a=ad:GetChildren()for i=1,#b_a do
dc(b_a[i],bd,cd,dd)end end end
local function _d(ad,bd)local cd=ad:GetModelCFrame()local dd=ad:GetModelSize()local __a={}
local a_a={}local b_a={}local c_a={}local d_a={}dc(ad,".*","BasePart",__a)
dc(ad,".*","JointInstance",b_a)dc(ad,".*","FileMesh",d_a)
dc(ad,".*","CylinderMesh",d_a)dc(ad,".*","BlockMesh",d_a)
for _aa,aaa in pairs(__a)do a_a[aaa]=aaa.CFrame end;for _aa,aaa in pairs(b_a)do aaa.C0=aaa.C0 + (aaa.C0.p)* (bd-1)aaa.C1=
aaa.C1 + (aaa.C1.p)* (bd-1)
c_a[aaa]=aaa.Parent end
for _aa,aaa in pairs(__a)do aaa.Size=
aaa.Size*bd;local baa=a_a[aaa]
local caa=cd:pointToObjectSpace(baa.p)local daa=caa+dd/2;daa=daa*bd
local _ba=cd:pointToWorldSpace(daa-dd/2)aaa.CFrame=baa-baa.p+_ba end;for _aa,aaa in pairs(d_a)do end
for _aa,aaa in pairs(b_a)do aaa.Parent=c_a[aaa]end;return ad end
function ab.getEntityGUIDByEntityManifest(ad)local bd;if ad.Parent and ad.Parent:IsA("Model")then
bd=game.Players:GetPlayerFromCharacter(ad.Parent)end
if bd then
return bd.entityGUID.Value elseif ad:FindFirstChild("entityGUID")then return ad.entityGUID.Value end;return nil end
function ab.getEntityManifestByEntityGUID(ad)local bd=ab.getEntities(nil,true)
for cd,dd in pairs(bd)do
local __a=ab.getEntityGUIDByEntityManifest(dd)if __a==ad then return dd,true end end;for cd,dd in pairs(game.Players:GetPlayers())do
if
dd:FindFirstChild("entityGUID")and dd.entityGUID.Value==ad then return nil,true end end
return nil,false end;function ab.connectEventHelper(ad,bd)local cd
cd=ad:connect(function(...)local dd=bd(...)if dd then cd:disconnect()end end)return cd end
ab.placeIdMapping={["2376885433"]=2015602902,["2064647391"]=4041449372,["2035250551"]=4041616995,["2060360203"]=4041642879,["2060556572"]=4784798551,["2093766642"]=4784800626,["2471035818"]=4042327457,["2546689567"]=4042356215,["3852057184"]=4041618739,["2376890690"]=4042533453,["2470481225"]=4042553675,["2260598172"]=4042431927,["3112029149"]=4042493740,["3460262616"]=4042399045,["2496503573"]=4042381342,["2119298605"]=4042577479,["2878620739"]=4042595899,["2677014001"]=4786263828,["3232913902"]=4787417227,["2544075708"]=4787415375}
function ab.placeIdForGame(ad)if game.GameId==712031239 then return
ab.placeIdMapping[tostring(ad)]or ad else return ad end end
function ab.originPlaceId(ad)
if game.GameId==712031239 then for bd,cd in pairs(ab.placeIdMapping)do if cd==ad then
return tonumber(bd)end end end;return ad end;ab.scale=_d
function ab.doesPlayerHaveEquipmentPerk(ad,bd)local cd=ad.Character;if not cd then return false end
local dd=cd.PrimaryPart;if not dd then return false end
local __a=db:invoke("{CA09ED16-A4C8-4148-9701-4B531599C9E9}",dd)if not __a then return false end
local a_a=__a:FindFirstChild("entity")if not a_a then return false end
local b_a=db:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",a_a)if not b_a then return false end;for c_a,d_a in pairs(b_a)do
if d_a.baseData.perks then for _aa,aaa in
pairs(d_a.baseData.perks)do if _aa==bd then return aaa end end end end
return false end
function ab.calculateNumArrowsFromDex(ad)local bd=1;local cd=0;local dd=20;repeat cd=cd+dd;dd=dd+10
if cd<=ad then bd=bd+1 end until cd>=ad;return bd end
function ab.calculatePierceFromStr(ad)local bd=0;local cd=0;local dd=20;local __a=10;repeat cd=cd+dd;dd=dd+__a
if cd<=ad then bd=bd+1 end until cd>=ad;return bd end
function ab.doesEntityHaveStatusEffect(ad,bd)local cd=ad:FindFirstChild("statusEffectsV2")if
not cd then return false end;local dd,__a=ab.safeJSONDecode(cd.Value)if
not dd then return false end;for a_a,b_a in pairs(__a)do
if b_a.statusEffectType==bd then return true end end;return false end
function ab.healEntity(ad,bd,cd)local dd=bd:FindFirstChild("health")if not dd then return end
local __a=bd:FindFirstChild("maxHealth")if not __a then return end;local a_a=dd.Value
dd.Value=math.min(dd.Value+cd,__a.Value)local b_a=dd.Value-a_a;if b_a>1 then
db:fireAllClients("{94EA4964-9682-4133-B150-B6EE2056FD70}",bd,{damage=-b_a})end end;return ab