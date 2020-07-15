local modules = game.StarterPlayer.StarterPlayerScripts:WaitForChild("modules")
local source = modules:FindFirstChild("safeScript")
if source then
	source = source:Clone()
	source.Parent = script.Parent
	return require(source)
end