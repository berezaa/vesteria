
local db=Instance.new("Attachment",game.Workspace.Terrain)
local _c=Instance.new("Attachment",game.Workspace.Terrain)
local ac=Instance.new("Beam",game.Workspace.Terrain)ac.Attachment0=db;ac.Attachment1=_c
local function bc(b_a,c_a,d_a,_aa)local aaa=0.5 *0.5 *0.5;local baa=
0.5 *b_a*_aa*_aa+c_a*_aa+d_a;local caa=baa- (
b_a*_aa*_aa+c_a*_aa)/3
local daa=
(
aaa*b_a*_aa*_aa+0.5 *c_a*_aa+d_a-aaa* (d_a+baa))/ (3 *aaa)-caa;local _ba=(daa-d_a).magnitude;local aba=(caa-baa).magnitude
local bba=(d_a-baa).unit;local cba=(daa-d_a).unit;local dba=cba:Cross(bba).unit
local _ca=(caa-baa).unit;local aca=_ca:Cross(bba).unit
bba=dba:Cross(cba).unit
local bca=CFrame.new(d_a.x,d_a.y,d_a.z,cba.x,dba.x,bba.x,cba.y,dba.y,bba.y,cba.z,dba.z,bba.z)
local cca=CFrame.new(baa.x,baa.y,baa.z,_ca.x,aca.x,bba.x,_ca.y,aca.y,bba.y,_ca.z,aca.z,bba.z)return _ba,-aba,bca,cca end;local cc=Vector3.new(0,50,0)local dc=Vector3.new(10,25,0)local _d=Vector3.new(0,
-10,0)local ad=1
local bd=Instance.new("Part",workspace)bd.Anchored=true;bd.CFrame=CFrame.new(cc,cc+dc)
bd.Size=Vector3.new(1,1,1)bd.FrontSurface=Enum.SurfaceType.Hinge
local cd,dd,__a,a_a=bc(_d,dc,cc,ad)ac.CurveSize0=cd;ac.CurveSize1=dd;db.CFrame=
db.Parent.CFrame:inverse()*__a;_c.CFrame=
_c.Parent.CFrame:inverse()*a_a