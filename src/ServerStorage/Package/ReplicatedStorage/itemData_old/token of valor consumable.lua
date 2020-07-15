local d=game:GetService("ReplicatedStorage")
local _a=require(d.modules)local aa=_a.load("network")
return
{id=140,name="Dropped Mark of Valor",rarity="Common",image="rbxassetid://3051739743",description="A mark of great value in the Colosseum.",soulbound=true,canStack=true,canBeBound=false,canAwaken=false,useSound="coins",activationEffect=function(ba,ca)
local da=
ca:FindFirstChild("itemValue")and ca.itemValue.Value or 1;local _b=ba.Character
if _b and _b.PrimaryPart and
_b.PrimaryPart:FindFirstChild("heldPvpTokens")then _b.PrimaryPart.heldPvpTokens.Value=
_b.PrimaryPart.heldPvpTokens.Value+1;return true,
"Mark of Valor picked up! ("..
tostring(_b.PrimaryPart.heldPvpTokens.Value).." in hand)",da end;return false,"Failed",0 end,buyValue=10,sellValue=1,autoConsume=true,petsIgnore=true,everyoneAvailabilityTime=3,isImportant=false,category="consumable"}