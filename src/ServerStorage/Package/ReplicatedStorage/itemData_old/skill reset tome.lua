
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _a=d.load("network")local aa=d.load("mapping")
return
{id=165,name="Skill Reset Tome",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3215802930",description="Reset all your skill points and allows you to reapply them.",useSound="fireIgnite",consumeTime=0,askForConfirmationBeforeConsume=true,activationEffect=function(ba)
local ca=_a:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba)
if ca then ca.abilities={}
for da,_b in pairs(ca.abilityBooks)do _b.pointsAssigned=0 end
while true do local da=false
for _b,ab in pairs(ca.hotbar)do if ab.dataType==aa.dataType.ability then da=true
table.remove(ca.hotbar,_b)break end end;if not da then break end end
ca.nonSerializeData.setPlayerData("abilities",ca.abilities)
ca.nonSerializeData.setPlayerData("abilityBooks",ca.abilityBooks)
ca.nonSerializeData.setPlayerData("hotbar",ca.hotbar)return true,"Successfully reset abilities!"end;return false,"Failed to load playerData."end,buyValue=5000,sellValue=300,canStack=false,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}