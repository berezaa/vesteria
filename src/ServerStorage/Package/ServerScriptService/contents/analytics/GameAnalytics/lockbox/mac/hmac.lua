local ca=script.Parent.Parent;local da=require(ca.util.bit)
local _b=string;local ab=require(ca.util.stream)
local bb=require(ca.util.array)local cb=da.bxor
local db=function()local _c={}local ac=64;local bc=nil;local cc={}local dc={}local _d
_c.setBlockSize=function(ad)ac=ad;return _c end;_c.setDigest=function(ad)bc=ad;_d=bc()return _c end
_c.setKey=function(ad)
local bd
if(bb.size(ad)>ac)then
bd=ab.fromArray(bc().update(ab.fromArray(ad)).finish().asBytes())else bd=ab.fromArray(ad)end;cc={}dc={}for i=1,ac do local cd=bd()if cd==nil then cd=0x00 end;cc[i]=cb(0x5C,cd)
dc[i]=cb(0x36,cd)end;return _c end;_c.init=function()_d.init().update(ab.fromArray(dc))
return _c end;_c.update=function(ad)
_d.update(ad)return _c end
_c.finish=function()
local ad=_d.finish().asBytes()
_d.init().update(ab.fromArray(cc)).update(ab.fromArray(ad)).finish()return _c end;_c.asBytes=function()return _d.asBytes()end;_c.asHex=function()return
_d.asHex()end;return _c end;return db