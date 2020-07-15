local ca={}
local da=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _b=da.load("network")local ab=da.load("placeSetup")
local bb=game:GetService("UserInputService")local cb={ab.getPlaceFoldersFolder()}
function ca.raycastFromCurrentScreenPoint(_c,ac)ac=
ac or 2048;local bc=bb:GetMouseLocation()local cc=workspace.CurrentCamera:ScreenPointToRay(bc.X,
bc.Y-36)local dc=Ray.new(cc.Origin,
cc.Direction.unit*ac)local _d,ad,bd,cd=workspace:FindPartOnRayWithIgnoreList(dc,
_c or cb)
while _d and(
not _d.CanCollide or _d.Transparency>=0.95)do table.insert(
_c or cb,_d)
_d,ad,bd,cd=workspace:FindPartOnRayWithIgnoreList(dc,_c or cb)end;return _d,ad,bd,cd,dc end;local function db()end;return ca