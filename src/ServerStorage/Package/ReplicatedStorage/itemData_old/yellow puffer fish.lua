
local c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local d=c.load("network")
return
{id=39,name="Yellow Pufferfish",rarity="Common",image="rbxassetid://2539240983",description="You probably don't want to eat this fish.",useSound="eat_food",activationEffect=function(_a)
if
_a.Character and _a.Character.PrimaryPart and
_a.Character.PrimaryPart.health.Value>0 then _a.Character.PrimaryPart.health.Value=
_a.Character.PrimaryPart.health.Value-500
if
_a.Character.PrimaryPart.health.Value<=0 then
local aa="☠ ".._a.Name.." ate a Yellow Pufferfish ☠"
d:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=aa,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,130,100)})end;return true,"You feel refreshed."end;return false,"Character is invalid."end,buyValue=1000,sellValue=500,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}