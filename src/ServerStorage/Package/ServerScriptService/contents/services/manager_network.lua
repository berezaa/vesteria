local aa={}local ba=Instance.new("RemoteEvent")ba.Name="signal"
local ca,da
ba.OnServerEvent:connect(function(ab,bb,...)
local cb=game.ServerStorage.serverNetwork:FindFirstChild(bb)
if cb then return cb:Fire(ab,...)else if da then
da:invoke("{7F950F67-EB33-446A-83AE-F154B23F1CFE}",ab,60 *60 *24,"Compromised client","network")end end end)ba.Parent=game.ReplicatedStorage
local _b=Instance.new("RemoteFunction")_b.Name="playerRequest"
_b.OnServerInvoke=function(ab,bb,...)
local cb=game.ServerStorage.serverNetwork:FindFirstChild(bb)
if cb then return cb:Invoke(ab,...)else if da then
da:invoke("{7F950F67-EB33-446A-83AE-F154B23F1CFE}",ab,60 *60 *24,"Compromised client","network")end end end;_b.Parent=game.ReplicatedStorage
ca=require(game.ReplicatedStorage.modules)da=ca.load("network")
da:create("{58FE3047-C850-4DDE-BFC8-822A8DF0215A}","RemoteFunction","OnServerInvoke",function(ab)if
ab:FindFirstChild("developer")then return da.log end end)return{}