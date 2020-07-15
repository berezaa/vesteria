local d={"\n","\r","\t","\v","\f"}
local _a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local aa=_a.load("network")
return
{id=104,name="Ink & Quill",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://2856319694",description="Add a line of custom lore description to your equipment.",successRate=1,upgradeCost=0,playerInputFunction=function()
local ba={}
ba.desiredName=aa:invoke("{24640DF3-5DD8-42D6-86BE-8308D69CD158}",{prompt="Write your item's lore..."})return ba end,applyScroll=function(ba,ca,da,_b)
local ab=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local bb=ab[ca.id]if not _b then return false,"no player input"end
if
bb.category=="equipment"then
if da then local cb=_b.desiredName;if not cb then
return false,"desired item story not provided"end;if#cb>40 then
return false,"Item story cannot be longer than 40 characters"end;for bc,cc in pairs(d)do
if string.find(cb,cc)then return false,
"Item story cannot contain whitespace characters."end end;if#cb<3 then return false,
"Item story must be at least 3 characters long."end;local db
local _c,ac=pcall(function()
db=game.Chat:FilterStringForBroadcast(cb,ba)end)if not _c then return false,"filter error: "..ac end
if not db or
string.find(db,"#")then return false,"Item story rejected by Roblox filter."end;ca.customStory=db;return true,"Item story applied."end end;return false,"Only equipment can be given a story."end,buyValue=1000000,sellValue=1000,canStack=false,canBeBound=false,canAwaken=false,enchantsEquipment=true,isImportant=true,category="consumable"}