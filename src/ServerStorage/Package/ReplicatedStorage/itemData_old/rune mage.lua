
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=58,name="Mage Rune",rarity="Common",image="rbxassetid://2577402018",description="A magical gemstone that can be used to return to the Mage City.",useSound="fireIgnite",consumeTime=0,askForConfirmationBeforeConsume=true,activationEffect=function(_a)
if


_a:FindFirstChild("teleportRune")==nil and _a:FindFirstChild("teleporting")==nil and _a:FindFirstChild("DataSaveFail")==nil then local aa=Instance.new("BoolValue")aa.Name="teleportRune"
aa.Parent=_a
if game.GameId==712031239 then
delay(0.2,function()
d:invoke("{283E214A-12D2-429B-9945-85DFCC54DCEA}",_a,4042493740)end)else
delay(0.2,function()
d:invoke("{283E214A-12D2-429B-9945-85DFCC54DCEA}",_a,3112029149)end)end;return true,"teleport queued"end;return false,"Character is invalid."end,buyValue=4000,sellValue=300,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}