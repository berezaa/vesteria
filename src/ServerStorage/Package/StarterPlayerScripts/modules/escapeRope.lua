local aa={}aa.isActive=false;aa.interactPrompt="ESCAPE"aa.instant=true
local ba=game.Players.LocalPlayer
local ca=require(game.ReplicatedStorage:WaitForChild("modules"))local da=ca.load("network")local function _b()
return script.Parent.Parent.Target end
function aa.init()local ab=_b()
if ab and ba.Character and
ba.Character.PrimaryPart then if
game.ReplicatedStorage.sounds:FindFirstChild("ladder")then
game.ReplicatedStorage.sounds.ladder:Play()end
da:fireServer("{40B15535-4971-4C14-A24E-E7F003E3FC9B}",script.Parent)end end;function aa.close()end;return aa