
local b=function()local c={}local d=0;local _a=0;local aa={}
aa.push=function(ba)c[_a]=ba;_a=_a+1;return end
aa.pop=function()
if d<_a then local ba=c[d]c[d]=nil;d=d+1;return ba else return nil end end;aa.size=function()return _a-d end
aa.getHead=function()return _a end;aa.getTail=function()return d end
aa.reset=function()c={}_a=0;d=0 end;return aa end;return b