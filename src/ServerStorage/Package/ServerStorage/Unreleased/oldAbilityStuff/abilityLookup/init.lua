local c={}local d={}
for _a,aa in pairs(script:GetChildren())do local ba=require(aa)local ca;if
typeof(ba)=="function"then ca=ba;ba=ca()end
local da={__call=function(_b,ab,bb)
_b=ca and ca(ab,bb)or _b;_b.module=aa;return _b end}ba.module=aa;setmetatable(ba,da)c[ba.id]=ba;c[aa.Name]=ba;if not
d[ba.id]then d[ba.id]=true else
warn("@@@ ABILITY ID OVERLAP --",ba.id,ba.name,aa.Name)end end;for i=1,#script:GetChildren()do if not d[i]then
warn("@@@ ABILITY ID NOT TAKEN",i)end end;function c:GetAbilityIds()return
d end;return c