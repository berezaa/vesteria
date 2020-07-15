local ba=script.Parent.Parent;local ca=require(ba.util.queue)
local da=string;local _b={}
_b.fromString=function(cb)local db=0
return function()db=db+1;if(db<=da.len(cb))then return da.byte(cb,db)else
return nil end end end
_b.toString=function(cb)local db={}local _c=1;local ac=cb()
while ac~=nil do db[_c]=da.char(ac)_c=_c+1;ac=cb()end;return table.concat(db,"")end
_b.fromArray=function(cb)local db=ca()local _c=1;local ac=cb[_c]while ac~=nil do db.push(ac)_c=_c+1
ac=cb[_c]end;return db.pop end
_b.toArray=function(cb)local db={}local _c=1;local ac=cb()
while ac~=nil do db[_c]=ac;_c=_c+1;ac=cb()end;return db end;local ab={}for i=0,255 do ab[da.format("%02X",i)]=i
ab[da.format("%02x",i)]=i end
_b.fromHex=function(cb)local db=ca()
for i=1,da.len(cb)/2 do local _c=da.sub(cb,i*2 -
1,i*2)db.push(ab[_c])end;return db.pop end;local bb={}for i=0,255 do bb[i]=da.format("%02X",i)end
_b.toHex=function(cb)
local db={}local _c=1;local ac=cb()
while ac~=nil do db[_c]=bb[ac]_c=_c+1;ac=cb()end;return table.concat(db,"")end;return _b