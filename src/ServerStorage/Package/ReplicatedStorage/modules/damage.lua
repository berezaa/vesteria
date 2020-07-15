local da={}
local _b=require(script.Parent:WaitForChild("network"))
local ab=require(script.Parent:WaitForChild("utilities"))
local bb=require(script.Parent:WaitForChild("placeSetup"))local cb=bb.getPlaceFolder("entityManifestCollection")
local db=game:GetService("RunService")local _c=Random.new(os.time())
local function ac(bc)local cc
do
if db:IsServer()and bc then
local dc=_b:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bc)if dc then cc=dc.nonSerializeData end elseif db:IsClient()then
cc=_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData")end end;return cc end
function da.getNonHostileTargets(bc)local cc={}
for _d,ad in pairs(cb:GetChildren())do
if


ad:IsA("BasePart")and
ad:FindFirstChild("pet")and ad:FindFirstChild("state")and ad.state.Value~="dead"and ad:FindFirstChild("isTargetImmune")==nil then table.insert(cc,ad)end end;local dc=ac(bc)
if
dc.isGlobalPVPEnabled or#dc.whitelistPVPEnabled>0 then
local _d=dc.isGlobalPVPEnabled and game.Players:GetPlayers()or
dc.whitelistPVPEnabled
for ad,bd in pairs(_d)do if
bd~=bc and bd:FindFirstChild("isInPVP")and bd.Character and bd.Character.PrimaryPart then
table.insert(cc,bd.Character.PrimaryPart)end end end;if bc.Character then
table.insert(cc,bc.Character.PrimaryPart)end;return cc end
function da.getFriendlies(bc)local cc={}local dc
if db:IsClient()then
dc=_b:invokeServer("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}")elseif db:IsServer()then
dc=_b:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",bc)end
if dc then
for _d,ad in pairs(dc.members)do if
ad.player and ad.player~=bc and ad.player.Character then
table.insert(cc,ad.player.Character.PrimaryPart)end end end;if bc.Character then
table.insert(cc,bc.Character.PrimaryPart)end;return cc end
function da.getDamagableTargets(bc)local cc={}
for _d,ad in pairs(cb:GetChildren())do
if ad:IsA("BasePart")then
if




not
ad:FindFirstChild("pet")and ad:FindFirstChild("entityType")and ad.entityType.Value=="monster"and ad:FindFirstChild("state")and ad.state.Value~="dead"and not ad:FindFirstChild("isTargetImmune")then table.insert(cc,ad)end end end;local dc
do
if db:IsServer()and bc then
local _d=_b:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bc)if _d then dc=_d.nonSerializeData end elseif db:IsClient()then
dc=_b:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","nonSerializeData")end end;if not dc then return cc end
if
dc.isGlobalPVPEnabled or#dc.whitelistPVPEnabled>0 then
local _d=dc.isGlobalPVPEnabled and game.Players:GetPlayers()or
dc.whitelistPVPEnabled
for ad,bd in pairs(_d)do
if

bd~=bc and bd:FindFirstChild("isInPVP")and bd.isInPVP.Value and bd.Character and bd.Character.PrimaryPart then table.insert(cc,bd.Character.PrimaryPart)end end end;return cc end
function da.canPlayerDamageTarget(bc,cc)if not cc then return false,nil end
local dc=da.getDamagableTargets(bc)local _d=cc
do
if db:IsClient()then
if
cc:IsDescendantOf(workspace.placeFolders.entityRenderCollection)then local ad=cc;local bd
while

not ad:FindFirstChild("clientHitboxToServerHitboxReference")and ad~=workspace.placeFolders.entityRenderCollection do ad=ad.Parent end;if ad:FindFirstChild("clientHitboxToServerHitboxReference")then
_d=ad.clientHitboxToServerHitboxReference.Value end end end end;for ad,bd in pairs(dc)do if _d==bd then return true,_d end end
return false,_d end
function da.getNeutrals(bc)local cc={}
for dc,_d in pairs(game.Players:GetPlayers())do
if _d.Character and
_d.Character.PrimaryPart then local ad=_d.Character.PrimaryPart;if not
da.canPlayerDamageTarget(bc,ad)then
table.insert(cc,_d.Character.PrimaryPart)end end end;return cc end;return da