local _a={}
local aa=workspace:WaitForChild("placeFolders",60)local ba={}local ca=game:GetService("RunService")function _a.awaitPlaceFolder(da)
if
not ba[da]then local _b=aa:WaitForChild(da)if _b then ba[da]=_b end end;return ba[da]end
function _a.getPlaceFolder(da,_b)
if
not ba[da]then
if ca:IsClient()then _a.awaitPlaceFolder(da)else
local ab=aa:FindFirstChild(da)
if not ab and not _b then ab=Instance.new("Folder",aa)ab.Name=da end;ba[da]=ab end end;return ba[da]end;function _a.getPlaceFoldersFolder()return aa end;return _a