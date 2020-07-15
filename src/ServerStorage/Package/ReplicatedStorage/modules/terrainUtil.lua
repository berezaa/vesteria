local aa={}local ba=Vector3.new(4,4,4)local ca=workspace.Terrain
function aa.getTerrainAt(ab)
local bb=ca:WorldToCell(ab)local cb=ca:CellCornerToWorld(bb)
local db=Region3.new(cb,cb+ba)local _c,ac=ca:ReadVoxels(db,4)
return _c[1][1][1],ac[1][1][1]end;local da=Enum.Material.Water;local _b=Enum.Material.Air
function aa.isPointUnderwater(ab)
local bb=ca:WorldToCell(ab)local cb=ca:CellCornerToWorld(bb.X,bb.Y,bb.Z)local db=Region3.new(cb,cb+
Vector3.new(4,8,4))
local _c,ac=ca:ReadVoxels(db,4)local bc,cc=_c[1][1][1],ac[1][1][1]
local dc,_d=_c[1][2][1],ac[1][2][1]
if bc==da then if dc~=_b then return true,bb.Y*ba.Y,false end;local ad=cc;local bd=
bb.Y+0.5 +math.max(0,ad-0.5)return ab.Y/4 <bd,bd*ba.Y,
true elseif dc==da then
if bc~=_b then return true, (bb.Y+1)*ba.Y,false end;local ad=_d;local bd=(bb.Y+1)-math.min(ad,0.5)return ab.Y/4 >bd,bd*
ba.Y,true end;return false,0,false end;return aa