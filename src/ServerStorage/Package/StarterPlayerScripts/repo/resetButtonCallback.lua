local d={}
local _a=require(game.ReplicatedStorage:WaitForChild("modules"))network=_a.load("network")
local aa=Instance.new("BindableEvent")
aa.Event:connect(function()local ba=true
if not
game.ReplicatedStorage:FindFirstChild("safeZone")then
ba=network:invoke("{98536A5A-1107-447A-8263-7528187ECA5B}","Are you sure you wish to kill your character?")end;if ba then
network:invokeServer("{1D8F2EEC-0866-44D6-83BE-18595E9DA420}")end end)
game.StarterGui:SetCore("ResetButtonCallback",aa)return d