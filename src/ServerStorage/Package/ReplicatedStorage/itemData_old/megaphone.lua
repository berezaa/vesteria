local d={"\n","\r","\t","\v","\f"}
local _a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local aa=_a.load("network")
item={id=135,name="Megaphone",nameColor=Color3.fromRGB(237,98,255),rarity="Legendary",image="rbxassetid://3109212291",description="Send a message to all online Vesteria players.",tier=2,useSound="potion",consumeTime=0,playerInputFunction=function()
local ba={}
ba.desiredName=aa:invoke("{24640DF3-5DD8-42D6-86BE-8308D69CD158}",{prompt="Enter shout message..."})return ba end,activationEffect=function(ba,ca)
if
game.ReplicatedStorage:FindFirstChild("doNotSaveData")then return false,"No shouting in testing realms"end;if not ca then return false,"No player input recieved"end
local da=ca.desiredName;if not da then return false,"Desired shout not provided"end
if
#da>100 then return false,"Shout cannot be longer than 100 characters."end
for _c,ac in pairs(d)do if string.find(da,ac)then
return false,"Shout cannot contain whitespace characters."end end
if#da<3 then return false,"Shout must be at least 3 characters long."end;local _b
local ab,bb=pcall(function()
_b=game.Chat:FilterStringForBroadcast(da,ba)end)if not ab then return false,"filter error: "..bb end;if not _b or
string.find(_b,"#")then
return false,"Shout rejected by Roblox filter: \"".._b.."\""end
local cb,db=pcall(function()
game:GetService("MessagingService"):PublishAsync("megaphone",
"["..ba.Name.."'s shout] ".._b)warn("MESSAGE SENT!!!")end)
if not cb then return false,"MessagingService error: "..db end;return true,"Shout sent!"end,buyValue=2500,sellValue=400,canStack=true,canBeBound=true,canAwaken=false,isImportant=false,category="consumable"}return item