local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{default="idling",states={},processDamageRequestToMonster=function(bc,cc)if cc.damageType==
"magical"then cc.damage=math.floor(cc.damage*0.5)
cc.supressed=true end;return cc end}