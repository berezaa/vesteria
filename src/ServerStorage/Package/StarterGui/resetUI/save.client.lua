script.Parent.Enabled=false
script.Parent.saveMe.Visible=false
game.Players.LocalPlayer:WaitForChild("DataLoaded",60)wait(5)
if
(not script.Parent.Parent.gameUI.Enabled)and
(not script.Parent.Parent.customize.Enabled)then
script.Parent.Enabled=true;script.Parent.saveMe.Visible=true
local function a()local b=""
for c,d in
pairs(game.LogService:GetLogHistory())do b=b.."  [["..d.message.."]]  "end;script.Parent.incident.contents.Text=b
script.Parent.incident.Visible=true end
script.Parent.incident.continue.Activated:connect(function()
local b=require(game.ReplicatedStorage:WaitForChild("modules"))local c=b.load("network")
c:invokeServer("{2A007D14-8D6B-4DF7-96F6-A6F3A0B71EFC}")
script.Parent.incident.continue:Destroy()end)
script.Parent.saveMe.Activated:connect(function()
script.Parent.saveMe.Visible=false;a()end)end