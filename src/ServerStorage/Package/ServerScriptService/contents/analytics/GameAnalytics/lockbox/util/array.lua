local da=script.Parent.Parent;local _b=string
local ab=require(da.util.queue)local bb=require(da.util.bit)local cb=bb.bxor;local db={}
db.size=function(bc)return#bc end
db.fromString=function(bc)local cc={}local dc=1;local _d=_b.byte(bc,dc)while _d~=nil do cc[dc]=_d;dc=dc+1
_d=_b.byte(bc,dc)end;return cc end
db.toString=function(bc)local cc={}local dc=1;local _d=bc[dc]while _d~=nil do cc[dc]=_b.char(_d)dc=dc+1
_d=bc[dc]end;return table.concat(cc,"")end
db.fromStream=function(bc)local cc={}local dc=1;local _d=bc()
while _d~=nil do cc[dc]=_d;dc=dc+1;_d=bc()end;return cc end
db.readFromQueue=function(bc,cc)local dc={}for i=1,cc do dc[i]=bc.pop()end;return dc end
db.writeToQueue=function(bc,cc)local dc=db.size(cc)for i=1,dc do bc.push(cc[i])end end
db.toStream=function(bc)local cc=ab()local dc=1;local _d=bc[dc]
while _d~=nil do cc.push(_d)dc=dc+1;_d=bc[dc]end;return cc.pop end;local _c={}for i=0,255 do _c[_b.format("%02X",i)]=i
_c[_b.format("%02x",i)]=i end
db.fromHex=function(bc)local cc={}
for i=1,_b.len(bc)/2 do local dc=_b.sub(bc,i*2 -1,
i*2)cc[i]=_c[dc]end;return cc end;local ac={}for i=0,255 do ac[i]=_b.format("%02X",i)end
db.toHex=function(bc)
local cc={}local dc=1;local _d=bc[dc]
while _d~=nil do cc[dc]=ac[_d]dc=dc+1;_d=bc[dc]end;return table.concat(cc,"")end
db.concat=function(bc,cc)local dc={}local _d=1;local ad=1;local bd=bc[ad]while bd~=nil do dc[_d]=bd;ad=ad+1;_d=_d+1
bd=bc[ad]end;local cd=1;local dd=cc[cd]while dd~=nil do dc[_d]=dd;cd=cd+1
_d=_d+1;dd=cc[cd]end;return dc end
db.truncate=function(bc,cc)local dc={}for i=1,cc do dc[i]=bc[i]end;return dc end
db.XOR=function(bc,cc)local dc={}for _d,ad in pairs(bc)do dc[_d]=cb(ad,cc[_d])end
return dc end
db.substitute=function(bc,cc)local dc={}for _d,ad in pairs(bc)do dc[_d]=cc[ad]end;return dc end
db.permute=function(bc,cc)local dc={}for _d,ad in pairs(cc)do dc[_d]=bc[ad]end;return dc end
db.copy=function(bc)local cc={}for dc,_d in pairs(bc)do cc[dc]=_d end;return cc end
db.slice=function(bc,cc,dc)local _d={}for i=cc,dc do _d[i-cc+1]=bc[i]end;return _d end;return db