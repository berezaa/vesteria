
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=263,name="Cactus Fruit",rarity="Common",image="rbxassetid://4626456045",description="Awful texture and bland taste, but quite hydrating.",useSound="eat_food",activationEffect=function(_a)if
_a.Character then
d:fireClient("{E68719DC-5D55-4EF3-B970-EAACE3A872AB}",_a,"max",true)return true end
return false,"Character is invalid."end,consumeTime=0.5,stackSize=44,buyValue=500,sellValue=100,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item