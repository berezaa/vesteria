
return
{id=31,name="Spider Fang",rarity="Common",image="rbxassetid://2528902666",description="A venomous fang pulled from a giant Spider.",canStack=true,canBeBound=false,canAwaken=false,perkData={title="Essence Drain",tier=2,description="Steal mana from your targets.",modifierData={},apply=function(a)
end,onBeforeDamageDealt=function(a,b,c,d,_a,aa)end,onAfterDamageDealt=function(a,b,c,d,_a,aa)
if _a.sourceType=="equipment"then
if
d and a:FindFirstChild("mana")and a:FindFirstChild("maxMana")then
if
d:FindFirstChild("mana")and d:FindFirstChild("maxMana")then a.mana.Value=math.clamp(
a.mana.Value+5,0,a.maxMana.Value)d.mana.Value=math.clamp(
d.mana.Value-5,0,d.maxMana.Value)
return true else
a.mana.Value=math.clamp(a.mana+2,0,a.maxMana.Value)end end end end,onBeforeDamageReceived=function(a,b,c,d,_a,aa)
end,onAfterDamageReceived=function(a,b,c,d,_a,aa)end},sellValue=75,buyValue=250,isImportant=false,category="miscellaneous"}