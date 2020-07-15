
local d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local _a=d.load("network")local aa=Random.new()
return
{id=166,name="Referral Envelope",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3216941268",description="A reward for inviting a new adventurer through the referral program.",soulbound=true,useSound="potion",activationEffect=function(ba)
if
ba.Character and ba.Character.PrimaryPart and
ba.Character.PrimaryPart.health.Value>0 then
local ca=_a:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",ba)if not ca then return false,"failed to get PlayerData"end
local da={{id=131,stacks=3,chance=10},{id=118,stacks=1,chance=10},{id=112,stacks=1,chance=10},{id=75,stacks=30,chance=20},{id=154,stacks=1,chance=1},{id=135,stacks=1,chance=10},{id=103,stacks=1,chance=10},{id=104,stacks=1,chance=10},{id=105,stacks=1,chance=10},{id=106,stacks=1,chance=10},{id=111,stacks=1,chance=10},{id=107,stacks=1,chance=10},{id=108,stacks=1,chance=10},{id=110,stacks=1,chance=10},{id=109,stacks=1,chance=10}}local _b={equipment=20,consumable=20}
local ab=require(game.ReplicatedStorage.itemData)
for _c,ac in pairs(ca.inventory)do
if
ab[ac.id]and _b[ab[ac.id].category]then
_b[ab[ac.id].category]=_b[ab[ac.id].category]-1;if _b[ab[ac.id].category]<=0 then
return false,"not enough inventory space"end end end;local bb={}for _c,ac in pairs(da)do
for ii=1,ac.chance or 0 do table.insert(bb,ac)end end
local cb=bb[aa:NextInteger(1,#bb)]
local db=_a:invoke("{669C024B-B819-48D3-AC3D-84873A639D84}",ba,{},0,{{id=cb.id,stacks=cb.stacks}},0,"gift:alpha",{})
if db then return true else return false,"Not enough room in inventory."end end;return false,"Character is invalid."end,buyValue=40,sellValue=20,soulbound=true,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}