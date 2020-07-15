local player = game.Players.LocalPlayer


local inputService = game:GetService("UserInputService")
local characterController = require(script.characterController)
player.CharacterAdded:Connect(function()
	wait(3) -- temporary debug wait
	characterController.new(player)
end)
	
