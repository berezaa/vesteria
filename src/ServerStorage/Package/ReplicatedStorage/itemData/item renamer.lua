
return
{id=103,name="Name Tag",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://2858147882",description="Give a piece of equipment a special name.",successRate=1,upgradeCost=0,playerInputFunction=function()
local a={}
a.desiredName=network:invoke("{24640DF3-5DD8-42D6-86BE-8308D69CD158}",{prompt="Name your item..."})return a end,applyScroll=function(a,b,c,d)
local _a=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local aa=_a[b.id]if not d then return false,"no player input"end
if aa.category==
"equipment"then
if c then local ba=d.desiredName;if not ba then
return false,"desired item name not provided"end;if#ba>30 then
return false,"Item name cannot be longer than 30 characters."end;for ab,bb in pairs(disallowedWhiteSpace)do
if
string.find(ba,bb)then return false,"Item name cannot contain whitespace characters."end end
if#ba<3 then return
false,"Item name must be at least 3 characters long."end;local ca
local da,_b=pcall(function()ca=game.Chat:FilterStringForBroadcast(ba,a)end)if not da then return false,"filter error: ".._b end
if not ca or
string.find(ca,"#")then return false,"Item name rejected by Roblox filter."end;b.customName=ca;return true,"Item renamed"end end;return false,"Only equipment can be re-named."end,buyValue=2000000,sellValue=1000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}