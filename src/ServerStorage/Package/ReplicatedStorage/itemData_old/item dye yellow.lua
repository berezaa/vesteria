local d={"\n","\r","\t","\v","\f"}
local _a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local aa=_a.load("network")
return
{id=106,name="Yellow Dye",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://2863286683",description="Tint your equipment with a light yellow hue.",dye=true,successRate=1,upgradeCost=0,applyScroll=function(ba,ca,da)
local _b=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local ab=_b[ca.id]
if ab.category=="equipment"then if da then ca.dye={r=255,g=255,b=110}return
true end end;return false,"Only equipment can be dyed"end,buyValue=4000000,sellValue=1000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}