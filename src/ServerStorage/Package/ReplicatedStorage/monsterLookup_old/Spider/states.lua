local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
return cc,"physical","direct"end,getClosestEntities=function(bc)local cc=bb.getEntities()
for i=#cc,1,-1 do local dc=cc[i]if(
dc.Name==
"Spider"or dc.Name=="Spiderling"or dc.Name=="Spider Queen"or dc.Name=="Hitbox")or
dc==bc.manifest then
table.remove(cc,i)end end;return cc end,default="idling",states={},processDamageRequestToMonster=function(bc,cc)
if
bc.state=="attacking"and cc.damageType~="magical"then cc.damage=math.floor(
cc.damage*0.35)cc.supressed=true end;return cc end}