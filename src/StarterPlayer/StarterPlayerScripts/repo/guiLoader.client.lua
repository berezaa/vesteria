-- Annoying hack to get around Roblox's dumb gui replication changes
-- Author: berezaa

if not game:IsLoaded() then
	repeat wait() until game:IsLoaded()
end

local localPlayer = game.Players.LocalPlayer
local uiSystem = game.ReplicatedStorage:WaitForChild("StarterGuiFolder")

function rebuildUiLocally(character)
	for i, child in ipairs(uiSystem:GetChildren()) do
		child:Clone().Parent = localPlayer.PlayerGui		
	end
end

localPlayer.CharacterAdded:Connect(rebuildUiLocally)

if localPlayer.Character then
	rebuildUiLocally()
end