
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=158,name="Alpha Gift",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3210082825",description="Thank you for your leap of faith in purchasing Alpha. Without your support, Vesteria wouldn't have been possible.",useSound="potion",consumeTime=0,activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then
local aa={{id=131,stacks=18},{id=135,stacks=1},{id=103,stacks=1},{id=104,stacks=1},{id=105,stacks=1},{id=112,stacks=1},{id=155,stacks=1},{id=164,stacks=1},{id=165,stacks=1}}
local ba=d:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",_a,{},0,aa,50000,"gift:alpha",{})
if ba then return true else return false,"Not enough room in inventory."end end;return false,"Character is invalid."end,buyValue=40,sellValue=20,soulbound=true,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}