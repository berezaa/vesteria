local ab={}local bb=game:GetService("HttpService")
local cb=game:GetService("TeleportService")local db=game:GetService("MessagingService")
local _c=game:GetService("ReplicatedStorage")local ac=require(_c.modules)local bc=ac.load("network")
local cc=require(_c.abilityLookup)
local function dc()local ad=20
local bd,cd=pcall(function()
db:SubscribeAsync("summonSpell",function(dd)local __a=dd.Data.playerName
if

game.Players:FindFirstChild(__a)and dd.Data.placeId and dd.Data.instanceId then
if game.Players[__a]and game.Players[__a].Character and
game.Players[__a].Character.PrimaryPart then
game.Players[__a].Character.PrimaryPart.Anchored=true
pcall(function()
cc[19].summonGate(
game.Players[__a].Character.PrimaryPart.CFrame-
Vector3.new(0,
game.Players[__a].Character.PrimaryPart.Size.Y/2 +0.05,0),4,nil,nil)end)end
cb:TeleportToPlaceInstance(dd.Data.placeId,dd.Data.instanceId,game.Players[__a],nil,{destination=dd.Data.placeId,dataSlot=game.Players[__a].dataSlot.Value,slot=game.Players[__a].dataSlot.Value})end end)end)
bc:create("{FD22A59A-4EEC-482F-A241-8159B2B522BE}","BindableFunction","OnInvoke",function(dd,__a)if __a then
local d_a=pcall(function()
db:PublishAsync("summonSpell",{playerName=dd,placeId=game.PlaceId,instanceId=game.JobId})end)end
local a_a=Instance.new("BindableEvent")delay(ad,function()a_a:Fire()end)
local b_a=game.Players.PlayerAdded:connect(function(d_a)
if
d_a.Name==dd then
while wait()do
if d_a.Parent==game.Players then
if
d_a.Character and d_a.Character.PrimaryPart then
if d_a:FindFirstChild("isPlayerSpawning")then if
d_a.isPlayerSpawning.Value==false then break end end end else break end end;a_a:Fire(d_a)end end)local c_a=a_a.Event:Wait()b_a:disconnect()return c_a end)end;local function _d()dc()end;_d()return ab