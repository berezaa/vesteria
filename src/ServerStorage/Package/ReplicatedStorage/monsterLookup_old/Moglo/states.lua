local da=game:GetService("ReplicatedStorage")
local _b=require(da.modules)local ab=_b.load("pathfinding")local bb=_b.load("utilities")
local cb=_b.load("detection")local db=_b.load("network")local _c=1;local ac=Random.new()
return
{processDamageRequest=function(bc,cc)
return cc,"physical","direct"end,getClosestEntities=function(bc)local cc=bb.getEntities()
for i=#cc,1,-1 do local dc=cc[i]if
dc.Name==
"Mo Ko Tu Aa"or dc.Name==bc.monsterName or dc==bc.manifest or dc.Name=="Mogloko"then
table.remove(cc,i)end end;return cc end,default="setup",states={["setup"]={animationEquivalent="idling",transitionLevel=0,step=function(bc)
if
bc.moveGoal then bc.__directRoamGoal=bc.moveGoal
bc.__directRoamOrigin=bc.manifest.Position;bc.__blockConfidence=0;bc.__LAST_ROAM_TIME=tick()return"direct-roam"end;local cc=math.random(3)if cc==1 then return"sitting"end;return"idling"end},["sitting"]={transitionLevel=1,step=function(bc,cc)
if
bc.randomSitOrientated==nil then bc.randomSitOrientated=true
bc.manifest.BodyGyro.CFrame=CFrame.new(bc.manifest.Position,
bc.manifest.Position+
Vector3.new(math.random(-20,20),0,math.random(-20,20)))end
if bc.closestEntity then
local dc=bb.magnitude(bc.closestEntity.Position-bc.manifest.Position)
if dc<=bc.aggressionRange and
bc:isTargetEntityInLineOfSight(bc.aggressionRange,true)then bc.__providedDirectRoamTheta=nil
bc:setTargetEntity(bc.closestEntity)return"idling"end end end}}}