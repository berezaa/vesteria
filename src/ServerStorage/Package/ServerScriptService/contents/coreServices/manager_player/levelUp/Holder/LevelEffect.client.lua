script.Parent.Visible=true
script.Parent:WaitForChild("Image")
script.Parent.Image.Position=UDim2.new(0,0,0.333,0)script.Parent.Image.ImageTransparency=1
local d=game:GetService("ReplicatedStorage")local _a=require(d.modules)local aa=_a.load("tween")
aa(script.Parent.Image,{"Position"},UDim2.new(0,0,0,0),3,Enum.EasingStyle.Linear)
aa(script.Parent.Image,{"ImageTransparency"},0,1.5)wait(1.5)
aa(script.Parent.Image,{"ImageTransparency"},1,1.5)wait(1.5)script.Parent:Destroy()