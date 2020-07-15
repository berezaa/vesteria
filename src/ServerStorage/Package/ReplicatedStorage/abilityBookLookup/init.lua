local b={}
do
for c,d in pairs(script:GetChildren())do local _a=require(d)_a.module=d
b[string.lower(_a.name)]=_a
b[string.upper(_a.name):sub(1,1).._a.name:sub(2)]=_a end end;return b