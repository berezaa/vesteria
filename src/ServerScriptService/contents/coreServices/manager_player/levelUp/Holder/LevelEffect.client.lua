script.Parent.Visible = true
script.Parent:WaitForChild("Image")
script.Parent.Image.Position = UDim2.new(0,0,0.333,0)
script.Parent.Image.ImageTransparency = 1

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local tween		= modules.load("tween")
		
tween(script.Parent.Image,{"Position"},UDim2.new(0,0,0,0),3,Enum.EasingStyle.Linear)
tween(script.Parent.Image,{"ImageTransparency"},0,1.5)
wait(1.5)
tween(script.Parent.Image,{"ImageTransparency"},1,1.5)
wait(1.5)
script.Parent:Destroy()