
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=186,name="Ethyr Crystal",nameColor=Color3.fromRGB(115,255,251),rarity="Legendary",image="rbxassetid://3405408525",description="The rarest material in Vesteria. Adds a small amount of Ethyr to your account when used.",soulbound=true,useSound="ethyr1",consumeTime=0,activationEffect=function(_a)
local aa=d:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_a)
if aa and aa.globalData then
local ba=Random.new():NextInteger(15,25)local ca=aa.globalData;ca.ethyr=(ca.ethyr or 0)+ba
aa.nonSerializeData.setPlayerData("globalData",ca)return true,"Obtained "..ba.." Ethyr."end;return false,"Failed to fetch data."end,buyValue=5000,sellValue=300,canStack=true,canBeBound=true,canAwaken=false,isImportant=true,category="consumable"}