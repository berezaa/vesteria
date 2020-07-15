local _a={}local aa={}
function _a.getEntityGUIDByEntityManifest(da)if da:IsA("Model")then
if not da.PrimaryPart then return end;da=da.PrimaryPart end;local _b;if da.Parent and
da.Parent:IsA("Model")then
_b=game.Players:GetPlayerFromCharacter(da.Parent)end
if _b then
return _b.entityGUID.Value elseif da:FindFirstChild("entityGUID")then return da.entityGUID.Value end;return nil end;function _a.getEntityManifestByEntityGUID(da)return aa[da]end
local function ba(da)
if da:IsA("Model")then if not
da.PrimaryPart then return end;da=da.PrimaryPart end;local _b=_a.getEntityGUIDByEntityManifest(da)
if _b then aa[_b]=da end end
local function ca(da)
if da:IsA("Model")then if not da.PrimaryPart then return end;da=da.PrimaryPart end;for _b,ab in pairs(aa)do if ab==da then aa[_b]=nil end end end
coroutine.wrap(function()
workspace:WaitForChild("placeFolders"):WaitForChild("entityManifestCollection")for da,_b in
pairs(workspace.placeFolders.entityManifestCollection:GetChildren())do ba(_b)end
workspace.placeFolders.entityManifestCollection.ChildAdded:connect(ba)
workspace.placeFolders.entityManifestCollection.ChildRemoved:connect(ca)end)()return _a