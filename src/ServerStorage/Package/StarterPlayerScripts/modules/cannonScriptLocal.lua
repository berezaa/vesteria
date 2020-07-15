local ba={}ba.isActive=false;ba.interactPrompt="FIRE!"ba.instant=true
local ca=game.Players.LocalPlayer
local da=require(game.ReplicatedStorage:WaitForChild("modules"))local _b=da.load("network")local ab=da.load("utilities")
local bb=da.load("tween")
function ba.init()
_b:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true,
script.Parent.Parent.target.CFrame*CFrame.Angles(-math.pi/2,0,0))
_b:fireServer("{E7B04DB3-26B9-43B4-B169-4DD66837696A}",script.Parent.Parent)end
_b:connect("{A48814D7-0864-467B-B159-37C7A0D0F0EA}","OnClientEvent",function(cb)
if cb==script.Parent.Parent then
_b:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)local db=280;if script.Parent:FindFirstChild("strength")then
db=script.Parent.strength.Value end
_b:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",
script.Parent.Parent.target.CFrame.LookVector*db)end end)function ba.close()end;return ba