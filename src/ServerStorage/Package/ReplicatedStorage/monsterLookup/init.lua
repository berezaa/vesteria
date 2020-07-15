local c=game:GetService("ReplicatedStorage")local d={}
do
for _a,aa in
pairs(script:GetChildren())do local ba=require(aa)ba.module=aa
ba.entity=aa:WaitForChild("entity")local ca=require(c.defaultMonsterState)local da
local _b=aa:FindFirstChild("states")if _b then da=require(_b)end
if da then
setmetatable(da,{__index=ca})setmetatable(da.states,{__index=ca.states})else da=ca end;ba.statesData=da;d[aa.Name]=ba end end;return d