
return
{id=38,name="Rockfish",rarity="Common",image="rbxassetid://2539246261",description="A fish that's nutritious but not very delicious. Restores a ton of MP.",useSound="eat_food",activationEffect=function(a)
if a.Character and
a.Character.PrimaryPart and
a.Character.PrimaryPart.health.Value>0 then
if
(
a.Character.PrimaryPart.mana.Value<a.Character.PrimaryPart.maxMana.Value)then
a.Character.PrimaryPart.mana.Value=math.clamp(
a.Character.PrimaryPart.mana.Value+250,0,a.Character.PrimaryPart.maxMana.Value)end;return true,"You feel refreshed."end;return false,"Character is invalid."end,buyValue=600,sellValue=150,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}