local b={}
do
spawn(function()
local c=require(game.ReplicatedStorage.abilityLookup)for d,_a in pairs(c)do
if typeof(d)=="number"then table.insert(b,{id=d})end end end)end
return
{name="Admin",pointsGainPerLevel=5,startingPoints=0,lockPointsOnClassChange=false,minLevel=1,maxLevel=9999999999,layoutOrder=5,bookColor=Color3.fromRGB(130,78,154),abilities=b}