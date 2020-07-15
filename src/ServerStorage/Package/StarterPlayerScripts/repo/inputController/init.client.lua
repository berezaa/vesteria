local d=game.Players.LocalPlayer
local _a=game:GetService("UserInputService")local aa=require(script.characterController)
d.CharacterAdded:Connect(function()
wait(3)aa.new(d)end)