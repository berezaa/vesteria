local b={}function b.isPathValid(c)return true end
function b.isBetweenPathfindingNodes(c,d,_a)
local aa=(c-_a):Dot((d-_a))local ba=(c-_a).magnitude;return aa>0 and ba^2 >aa end
function b.isPastNextPathfindingNodeNode(c,d,_a)local aa=c-Vector3.new(0,c.Y,0)local ba=d-
Vector3.new(0,d.Y,0)
local ca=_a-Vector3.new(0,_a.Y,0)return(aa-ca):Dot((ba-ca))<=2 end
function b.dropPosition(c,d)
local _a=Ray.new(c+Vector3.new(0,1,0),Vector3.new(0,-999,0))local aa,ba=workspace:FindPartOnRayWithIgnoreList(_a,d)
return ba end
function b.didReachPosition(c,d,_a)return(c-d):Dot(_a-d)>=0 end
function b.adjustPathForProjectors(c,d)local _a=c:GetWaypoints()local aa={}local ba=false
for ca,da in pairs(_a)do if da.Action==
Enum.PathWaypointAction.Jump then ba=true end end;return _a end;return b