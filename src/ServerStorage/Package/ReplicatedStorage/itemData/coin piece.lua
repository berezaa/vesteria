local d=game:GetService("ReplicatedStorage")
local _a=require(d.modules)local aa=_a.load("network")
return
{id=1,name="Mushcoin",rarity="Common",image="rbxassetid://2535600080",description="The main currency of Vesteria",useSound="coins",activationEffect=function(ba,ca)
local da=
ca:FindFirstChild("itemValue")and ca.itemValue.Value or 1
local _b=ca:FindFirstChild("itemSource")and ca.itemSource.Value
local ab=aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba)
if ab then
local bb=aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba).nonSerializeData.statistics_final;local cb=bb and bb.greed or 1;local db=math.floor(da*cb)
ab.nonSerializeData.incrementPlayerData("gold",db,_b)return true,"Successfully gained "..da.." coins!",db end;return false,"Can't consume this right now",0 end,canStack=true,canBeBound=false,canAwaken=false,autoConsume=true,isImportant=false,category="consumable"}