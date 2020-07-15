local b={}
for c,d in pairs(script:GetChildren())do local _a=require(d)
if _a then if b[_a.id]then
warn(
"QuestId: ".._a.id.." already taken.")else b[_a.id]=_a end end end;return b