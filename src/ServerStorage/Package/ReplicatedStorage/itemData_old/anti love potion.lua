
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=189,name="Anti-Love Potion",rarity="Common",image="rbxassetid://3649386892",description="Concocted by a strange lady.",useSound="potion",activationEffect=function(_a)return
false,"This is meant for Gnomeo!"end,stackSize=24,buyValue=0,sellValue=1,soulbound=true,questbound=true,canStack=true,canBeBound=false,canAwaken=false,isImportant=false,category="consumable"}