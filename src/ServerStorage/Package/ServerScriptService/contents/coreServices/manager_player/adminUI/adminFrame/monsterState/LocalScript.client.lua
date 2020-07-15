local db=game.Players.LocalPlayer
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("placeSetup")
local cc=workspace.CurrentCamera
local dc=bc.awaitPlaceFolder("monsterManifestCollection")local _d=bc.awaitPlaceFolder("monsterRenderCollection")
local ad=bc.awaitPlaceFolder("spawnRegionCollections")local bd=script.Parent;local cd
local function dd(b_a)bd.changeState.Visible=true;bd.info.viewing.value.Text=
b_a["name"]or"nil"bd.info.lastUpdated.value.Text=
b_a["last-updated"]or"nil"bd.info.targetPlayer.value.Text=
b_a["target-player"]or"nil"bd.info.state.value.Text=
b_a["current-state"]or"nil"bd.info.previousState.value.Text=
b_a["previous-state"]or"nil"end;local __a={}
do local b_a=game:GetService("UserInputService")
function __a:getMouseTarget(d_a)
local _aa=b_a:GetMouseLocation()
if _aa then local aaa=cc:ScreenPointToRay(_aa.X,_aa.Y)local baa=Ray.new(aaa.Origin,
aaa.Direction*30)local caa,daa=workspace:FindPartOnRayWithWhitelist(baa,
d_a or{dc})
return caa,daa end end
local function c_a(d_a)
if d_a.UserInputType==Enum.UserInputType.MouseButton1 and
b_a:IsKeyDown(Enum.KeyCode.LeftShift)then
local _aa=__a:getMouseTarget()
if _aa and _aa:IsDescendantOf(_d)then if
_aa.Parent:FindFirstChild("clientHitboxToServerHitboxReference")then
_aa=_aa.Parent.clientHitboxToServerHitboxReference.Value end end
if _aa and(_aa:IsDescendantOf(dc))then
local aaa=db:FindFirstChild("developer")
if aaa then
local baa,caa=ac:invokeServer("{0814EB37-C329-4C35-A1DD-0C1515FABD4B}",_aa)if baa then cd=_aa;dd(caa)end end end end end;b_a.InputBegan:connect(c_a)end;local function a_a()
ac:connect("{32FD9E0E-7C7D-4B5C-AEE9-78A7E26CE528}","OnClientEvent",dd)end;a_a()