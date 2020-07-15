
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=164,name="Stat Reset Tome",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3215802990",description="Reset all your stat points and allows you to reapply them.",useSound="fireIgnite",consumeTime=0,askForConfirmationBeforeConsume=true,activationEffect=function(_a)
local aa=d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_a)
if aa then aa.statistics.dex=0;aa.statistics.int=0
aa.statistics.str=0;aa.statistics.vit=0
aa.nonSerializeData.setPlayerData("statistics",aa.statistics)return true,"Succesfully reset stats!"end;return false,"Failed to fetch data."end,buyValue=5000,sellValue=300,canStack=false,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}