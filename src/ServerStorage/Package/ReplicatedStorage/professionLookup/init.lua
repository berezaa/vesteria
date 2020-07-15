local b={}
do for c,d in pairs(script:GetChildren())do local _a=require(d)_a.module=d
b[_a.id]=_a;b[d.Name]=_a end end;return b