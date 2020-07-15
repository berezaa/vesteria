
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=22,name="Blue Potion",rarity="Common",image="rbxassetid://2528903811",description="A magical potion",customTag={{text="Restores",font=Enum.Font.SourceSans,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0},{text="25 MP",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(0,152,255),textSize=19,textTransparency=0},{text="after",font=Enum.Font.SourceSans,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0},{text="1s",font=Enum.Font.SourceSansBold,textColor3=Color3.fromRGB(160,160,160),textSize=19,textTransparency=0}},itemType="potion",useSound="potion",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and

_a.Character.PrimaryPart.mana.Value<_a.Character.PrimaryPart.maxMana.Value then
local aa,ba=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,
nil,50,"item",22)return aa,aa and"You feel recharged."or ba end;return false,"Character is invalid."end,stackSize=32,buyValue=70,sellValue=30,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}