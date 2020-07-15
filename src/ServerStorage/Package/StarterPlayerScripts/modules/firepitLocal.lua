local _a={}_a.isActive=false;_a.interactPrompt="Ignite"_a.instant=true
local aa=game.Players.LocalPlayer
local ba=require(game.ReplicatedStorage:WaitForChild("modules"))local ca=ba.load("network")function _a.init()
ca:fireServer("{00B764A1-3E25-4D07-9230-A642588CC6D1}",script.Parent)end;function _a.close()end;return _a