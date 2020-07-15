local _a={}_a.interactPrompt="SIT"_a.leavePrompt="GET UP"_a.leaveMask=true
_a.isActive=false;local aa=game.Players.LocalPlayer
local ba=require(game.ReplicatedStorage:WaitForChild("modules"))local ca=ba.load("network")
function _a.init()
if not aa or not aa.Character or not
aa.Character.PrimaryPart then return end;aa.Character.PrimaryPart.CFrame=script.Parent.CFrame+
Vector3.new(0,0.5,0)
aa.Character.PrimaryPart.Anchored=true
ca:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSitting",true,script.Parent)end
function _a.close()if not aa then return end
aa.Character.PrimaryPart.Anchored=false
ca:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSitting",false,script.Parent)end;return _a