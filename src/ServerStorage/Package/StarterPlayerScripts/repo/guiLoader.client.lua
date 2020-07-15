
if not game:IsLoaded()then repeat wait()until game:IsLoaded()end;local c=game.Players.LocalPlayer
local d=game.ReplicatedStorage:WaitForChild("StarterGuiFolder")
function rebuildUiLocally(_a)for aa,ba in ipairs(d:GetChildren())do
ba:Clone().Parent=c.PlayerGui end end;c.CharacterAdded:Connect(rebuildUiLocally)if
c.Character then rebuildUiLocally()end