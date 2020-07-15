local c={}
function c.boxcast_singleTarget(_a,aa,ba)
local ca=_a:pointToObjectSpace(ba)/aa;return

ca.X<=0.5 and ca.X>=-0.5 and ca.Y<=0.5 and ca.Y>=-0.5 and ca.Z<=0.5 and ca.Z>=-0.5 end
function c.boxcast_closest(_a,aa,ba,ca)local da=nil;local _b=math.huge
for ab,bb in pairs(_a)do
local cb=c.projection_Box(bb.CFrame,bb.Size,aa.Position)
if c.boxcast_singleTarget(aa,ba,cb)then local db=cb-ca;local _c=db.X*db.X+db.Y*db.Y+
db.Z*db.Z;if _c<_b then da=bb;_b=_c end end end;return da end
function c.boxcast_all(_a,aa,ba)local ca={}for da,_b in pairs(_a)do
local ab=c.projection_Box(_b.CFrame,_b.Size,aa.Position)
if c.boxcast_singleTarget(aa,ba,ab)then table.insert(ca,_b)end end
return ca end
local function d(_a,aa)local ba=Instance.new("Part")ba.Shape=Enum.PartType.Ball
ba.Anchored=true;ba.CanCollide=false;ba.Size=Vector3.new(2,2,2)*aa
ba.Material=Enum.Material.Neon;ba.BrickColor=BrickColor.new("Hot pink")
ba.CFrame=CFrame.new(_a)ba.Parent=workspace
game:GetService("Debris"):AddItem(ba,1.5)end
function c.spherecast_singleTarget(_a,aa,ba)return(_a-ba).magnitude<=aa end
function c.projection_Box(_a,aa,ba)local ca=_a:pointToObjectSpace(ba)return
(_a*
CFrame.new(math.clamp(ca.X,-aa.X/
2,aa.X/2),math.clamp(ca.Y,-aa.Y/2,aa.Y/2),math.clamp(ca.Z,
-aa.Z/2,aa.Z/2))).p end
function c.projection_Sphere(_a,aa,ba)return _a+ (ba-_a).unit*aa end;return c