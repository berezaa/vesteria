local ba={}local ca=game:GetService("TextService")
local da=require(game.ReplicatedStorage.modules)local _b=da.load("network")
local function ab(cb,db)if db==""then return end
local _c,ac=pcall(function()
ca:FilterStringAsync(db,cb.userId)end)
if _c then
for bc,cc in pairs(game.Players:GetPlayers())do
if cc~=cb then
local dc,_d=pcall(function()
ac:GetChatForUserAsync(cc.userId)end)
if dc then
_b:fireClient("{C6324C7B-DB46-42BF-BAC2-FE4075874783}",cc,cb.Name,_d)else
_b:fireClient("{C6324C7B-DB46-42BF-BAC2-FE4075874783}",cc,nil,"A message from "..cb.Name.." failed to send.")end end end end end;local function bb()
_b:create("{C6324C7B-DB46-42BF-BAC2-FE4075874783}","RemoteEvent","OnServerEvent",ab)end;bb()return ba