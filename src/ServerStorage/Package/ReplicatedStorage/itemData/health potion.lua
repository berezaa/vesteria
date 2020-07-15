
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=6,name="Red Potion",rarity="Common",image="rbxassetid://2528902180",description="A vibrant potion",customTag={{text="Restores",font=Enum.Font.SourceSans,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0},{text="25 HP",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(226,34,40),textSize=19,textTransparency=0},{text="after",font=Enum.Font.SourceSans,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0},{text="1s",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0}},itemType="potion",useSound="potion",activationEffect=function(_a)
if

_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,25,nil,"item",6)return aa,aa and"You feel refreshed."or"ERRORRRR"end;return false,"Character is invalid."end,stackSize=32,buyValue=50,sellValue=20,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}