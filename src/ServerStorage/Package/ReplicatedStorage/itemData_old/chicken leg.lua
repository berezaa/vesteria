
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
item={id=277,name="Chicken Leg",rarity="Common",image="rbxassetid://5048073993",description="A rare treat.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character and
_a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 and

_a.Character.PrimaryPart.health.Value<_a.Character.PrimaryPart.maxHealth.Value then
local aa=d:invoke("{AB4CDDDB-D1C5-46A3-8B72-F09379DDD79F}",_a.Character.PrimaryPart,30,nil,"item",277)return aa,aa and"You feel refreshed."or"ERRORRRR"end;return false,"Character is invalid."end,consumeTime=3,stackSize=16,buyValue=1000,sellValue=250,canStack=true,canBeBound=false,canAwaken=false,isImportant=false,category="consumable"}return item