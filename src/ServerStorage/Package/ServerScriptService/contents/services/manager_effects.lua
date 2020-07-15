local _a=game:GetService("CollectionService")
local aa=require(game.ReplicatedStorage.modules)local ba=aa.load("network")
ba:create("{CE48DECD-5222-4973-B0AB-89B662749171}","RemoteEvent")local function ca(da)
assert(da:IsA("Sound"),"Non-sound tagged as a mapSound: "..da:GetFullName())da:Play()end
_a:GetInstanceAddedSignal("mapSound"):connect(ca)
for da,_b in pairs(_a:GetTagged("mapSound"))do ca(_b)end;return{}