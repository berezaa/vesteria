local d=game:GetService("ReplicatedStorage")
local _a=require(d.modules.levels)local aa={}
do
for ba,ca in pairs(script:GetChildren())do local da=require(ca)
local _b=_a.getBaseStatInfoForMonster(da.level)
da.str=da.str or _b.str* (da.strMultiplier or 1)
da.int=da.int or _b.int* (da.intMultiplier or 1)
da.dex=da.dex or _b.dex* (da.dexMultiplier or 1)
da.vit=da.vit or _b.vit* (da.vitMultiplier or 1)da.module=ca;da.entity=ca:WaitForChild("entity")
local ab=require(d.defaultMonsterState)local bb;local cb=ca:FindFirstChild("states")
if cb then bb=require(cb)end;if bb then setmetatable(bb,{__index=ab})
setmetatable(bb.states,{__index=ab.states})else bb=ab end;da.statesData=bb
aa[ca.Name]=da end end;return aa