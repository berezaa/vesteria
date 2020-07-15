local animationTracks = {}

local animationController = script.Parent:WaitForChild("AnimationController")

script.Parent.PrimaryPart = script.Parent.HumanoidRootPart

local function weld(part0, part1)
	local motor6d 	= Instance.new("Motor6D")
	motor6d.Part0 	= part0
	motor6d.Part1	= part1
	motor6d.C0    	= CFrame.new()
	motor6d.C1 		= part1.CFrame:toObjectSpace(part0.CFrame)
	motor6d.Name 	= part1.Name
	motor6d.Parent	= part0
end

for i,Child in pairs(script.Parent:GetChildren()) do
	if Child:IsA("BasePart") and Child ~= script.Parent.PrimaryPart then
		
		for e,SuperChild in pairs(Child:GetChildren()) do
			if SuperChild:IsA("BasePart") then
				weld(Child, SuperChild)
				SuperChild.Anchored = false
				SuperChild.CanCollide = false
			end
		end
		
		Child.CanCollide = false
		Child.Anchored = false
	
		
	elseif Child:IsA("Animation") then
		animationTracks[Child.Name] = animationController:LoadAnimation(Child)	
	end
end	

	
--[[local bodyPosition = Instance.new("BodyPosition")
bodyPosition.Position = script.Parent.PrimaryPart.Position
bodyPosition.D = 10
bodyPosition.MaxForce = Vector3.new(100000000,100000000,100000000)
bodyPosition.P = 100000
bodyPosition.Parent = script.Parent.PrimaryPart]]--

--[[local bodyGyro = Instance.new("BodyGyro")
bodyGyro.CFrame = script.Parent.PrimaryPart.CFrame
bodyGyro.D = 30
bodyGyro.P = 1000
bodyGyro.MaxTorque = Vector3.new(10000000,10000000,10000000)
bodyGyro.Parent = script.Parent.PrimaryPart	]]--
	
script.Parent.PrimaryPart.Anchored = true
script.Parent.PrimaryPart.CanCollide = true

wait(math.random(1,300)/100) 
if animationTracks["idle"] then
	animationTracks.idle.Looped = true
	animationTracks.idle:Play()
end
--