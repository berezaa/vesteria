local player = game:GetService("Players").LocalPlayer
local puzzle = script:WaitForChild("puzzleReference").Value

local remotes = puzzle:WaitForChild("remotes")
local stateUpdated = remotes:WaitForChild("stateUpdated")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local tween = modules.load("tween")
local effects = modules.load("effects")

-- acquire initial object data
local objectData do
	objectData = {}
	
	-- doors
	local function onDoorAdded(door)
		objectData[door] = {
			originalCFrame = door.CFrame,
		}
	end
	local doors = puzzle:WaitForChild("doors")
	doors.ChildAdded:Connect(onDoorAdded)
	for _, door in pairs(doors:GetChildren()) do
		onDoorAdded(door)
	end
	
	-- levers
	local function onLeverAdded(lever)
		objectData[lever] = {
			originalCFrame = lever.lever.CFrame,
		}
	end
	local levers = puzzle:WaitForChild("levers")
	levers.ChildAdded:Connect(onLeverAdded)
	for _, lever in pairs(levers:GetChildren()) do
		onLeverAdded(lever)
	end
end

-- move a door
local function setDoorState(door, state, animated)
	local goalCFrame = objectData[door].originalCFrame
	if state then
		goalCFrame = goalCFrame *
			CFrame.new(0, 0, door.Size.Z / 2) *
			CFrame.Angles(0, math.pi * 1.5, 0) *
			CFrame.new(0, 0, -door.Size.Z / 2)
	end
	
	if animated then
		local tweenDuration = 2
		local offset = CFrame.new(0, 0, door.Size.Z / 2)
		
		local pivot = Instance.new("Part")
		pivot.CFrame = door.CFrame * offset
		tween(pivot, {"CFrame"}, {goalCFrame * offset}, tweenDuration, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
		
		effects.onHeartbeatFor(tweenDuration, function()
			door.CFrame = pivot.CFrame * offset:Inverse()
		end)
	else
		door.CFrame = goalCFrame
	end
end

local function setLeverState(lever, state, animated)
	local goalCFrame = objectData[lever].originalCFrame
	if state then
		local baseCFrame = lever.PrimaryPart.CFrame
		goalCFrame = baseCFrame *
			CFrame.Angles(-math.pi / 2, 0, 0) *
			baseCFrame:ToObjectSpace(goalCFrame)
	end
	
	if animated then
		local tweenDuration = 1
		local offset = lever.PrimaryPart.CFrame:ToObjectSpace(objectData[lever].originalCFrame):Inverse()
		
		local pivot = Instance.new("Part")
		pivot.CFrame = lever.lever.CFrame * offset
		tween(pivot, {"CFrame"}, {goalCFrame * offset}, tweenDuration, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)
		
		effects.onHeartbeatFor(tweenDuration, function()
			lever.lever.CFrame = pivot.CFrame * offset:Inverse()
		end)
		lever.interactPart.door:Play()
	else
		lever.lever.CFrame = goalCFrame
	end
end

local function onStateUpdated(object, objectType, state, eventType)
	local animated = (eventType == "changed")
	
	if objectType == "door" then
		setDoorState(object, state, animated)
	elseif objectType == "lever" then
		setLeverState(object, state, animated)
	end
end
stateUpdated.OnClientEvent:Connect(onStateUpdated)
