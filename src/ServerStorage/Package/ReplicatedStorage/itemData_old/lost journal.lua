
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _a=d.load("network")
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("loreBooks"))
return
{id=187,name="Lost Journal",rarity="Common",image="rbxassetid://4626642307",description="A worn journal containing some notes. There are pages clearly missing.",consumeTime=0,activationEffect=function(ba)
local ca=aa.getBook("Mississippi's Journal")
local da=_a:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba).userSettings;local _b={ca[1],ca[2]}if da["DesertPage1"]~=nil then
table.insert(_b,ca[3])else
table.insert(_b,{text="[A page is clearly missing here.]"})end;if
da["DesertPage2"]~=nil then table.insert(_b,ca[4])else
table.insert(_b,{text="[A page is clearly missing here.]"})end
_a:fireClient("{D5401345-3E55-471E-972D-4660C27D729B}",ba,_b)return true end,canStack=false,canBeBound=false,canAwaken=false,soulbound=true,buyValue=100,sellValue=55,isImportant=false,category="miscellaneous"}