
item={id=135,name="Megaphone",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3109212291",description="Send a message to all online Vesteria players.",tier=2,useSound="potion",consumeTime=0,playerInputFunction=function()
local a={}
a.desiredName=network:invoke("{24640DF3-5DD8-42D6-86BE-8308D69CD158}",{prompt="Enter shout message..."})return a end,activationEffect=function(a,b)
if
game.ReplicatedStorage:FindFirstChild("doNotSaveData")then return false,"No shouting in testing realms"end;if not b then return false,"No player input recieved"end
local c=b.desiredName;if not c then return false,"Desired shout not provided"end
if#c>100 then return
false,"Shout cannot be longer than 100 characters."end
for da,_b in pairs(disallowedWhiteSpace)do if string.find(c,_b)then
return false,"Shout cannot contain whitespace characters."end end
if#c<3 then return false,"Shout must be at least 3 characters long."end;local d
local _a,aa=pcall(function()d=game.Chat:FilterStringForBroadcast(c,a)end)if not _a then return false,"filter error: "..aa end;if not d or
string.find(d,"#")then
return false,"Shout rejected by Roblox filter: \""..d.."\""end
local ba,ca=pcall(function()
game:GetService("MessagingService"):PublishAsync("megaphone",
"["..a.Name.."'s shout] "..d)warn("MESSAGE SENT!!!")end)
if not ba then return false,"MessagingService error: "..ca end;return true,"Shout sent!"end,buyValue=2500,sellValue=400,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item