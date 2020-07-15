local d=game:GetService("ReplicatedStorage")
local _a=require(d.modules)local aa=_a.load("network")
return
{id=181,name="Monster Idol",rarity="Common",image="rbxassetid://2535600080",description="Learn more about a monster by collecting its Monster Idols.",useSound="coins",activationEffect=function(ba,ca)
if
ca:FindFirstChild("monsterName")then
local da=aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba)
if da then local _b=da.globalData.monsterData or{}_b[ca.monsterName.Value]=(
_b[ca.monsterName.Value]or 0)+1
da.globalData.monsterData=_b
da.nonSerializeData.setPlayerData("globalData",da.globalData)
if _b[ca.monsterName.Value]==1 then
return true,"Obtained "..ca.monsterName.Value..
" idol! (Monster page unlocked)"else return true,
"Obtained "..ca.monsterName.Value.." idol! ("..
_b[ca.monsterName.Value].." total)"end end end;return false,"Can't consume this right now",0 end,canStack=true,canBeBound=false,canAwaken=false,autoConsume=true,isImportant=false,category="consumable"}