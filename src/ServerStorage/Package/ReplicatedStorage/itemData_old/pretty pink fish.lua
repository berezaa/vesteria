
return
{id=42,name="Zebra Fish",rarity="Common",image="rbxassetid://2539474081",description="A tasty freshly-caught fish that restores 150 HP & MP.",useSound="eat_food",activationEffect=function(a)
if a.Character and
a.Character.PrimaryPart and
a.Character.PrimaryPart.health.Value>0 then
if
(

a.Character.PrimaryPart.mana.Value<a.Character.PrimaryPart.maxMana.Value or a.Character.PrimaryPart.health.Value<
a.Character.PrimaryPart.maxHealth.Value)then
a.Character.PrimaryPart.health.Value=math.clamp(
a.Character.PrimaryPart.health.Value+150,0,a.Character.PrimaryPart.maxHealth.Value)
a.Character.PrimaryPart.mana.Value=math.clamp(
a.Character.PrimaryPart.mana.Value+150,0,a.Character.PrimaryPart.maxMana.Value)end;return true,"You feel refreshed."end;return false,"Character is invalid."end,buyValue=500,sellValue=150,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}