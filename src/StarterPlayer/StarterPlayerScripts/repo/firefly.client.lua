-- Pretty fireflies
-- Author: Polymorphic

local runService 	= game:GetService("RunService")
local fireflies 	= {}
local player 		= game.Players.LocalPlayer

local fireflyVelocity 	= 5
local fireflyCount 		= 30

local fireflyOrigin
local fireflyOriginOffset = Vector3.new(200, 10, 200)

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local placeSetup = modules.load("placeSetup")
	local utilities = modules.load("utilities")
	local tween = modules.load("tween")

--local firefliesFolder = placeSetup.getPlaceFolder("fireflies")
local firefliesFolder = Instance.new("Folder")
firefliesFolder.Name = "fireflies"
firefliesFolder.Parent = workspace.CurrentCamera

local function assignTargetCFrame()
	return
		CFrame.new(workspace.CurrentCamera.CFrame.p)
		* CFrame.new(
			math.random(-fireflyOriginOffset.X / 2, fireflyOriginOffset.X / 2),
			math.random(-fireflyOriginOffset.Y / 2, fireflyOriginOffset.Y / 2),
			math.random(-fireflyOriginOffset.Z / 2, fireflyOriginOffset.Z / 2)
		)
end

local function updateFireflies(t, step)
	
	local currentTime = tick()
	for i, fireflyTable in pairs(fireflies) do
		local alpha 				= (currentTime - fireflyTable.startTime) / fireflyTable.duration
		fireflyTable.firefly.CFrame = fireflyTable.startCFrame:lerp(fireflyTable.targetCFrame, alpha) + Vector3.new(0, math.sin(currentTime - fireflyTable.offsetY), 0)
		
		if alpha >= 1 then
			local targetCFrame 	= assignTargetCFrame()
			
			local duration 		= utilities.magnitude(targetCFrame.p - fireflyTable.firefly.Position) / fireflyVelocity
			
			fireflyTable.duration 		= duration
			fireflyTable.startCFrame 	= fireflyTable.firefly.CFrame
			fireflyTable.targetCFrame 	= targetCFrame;
			fireflyTable.startTime 		= tick()
		end
	end
end

local function onCharacterAdded(character)
	--[[
	if game.PlaceId ~= 3323943158 then
		if not character.PrimaryPart then
			local hitbox = character:WaitForChild("hitbox", 15)
			
			if hitbox then
				character.PrimaryPart = hitbox
			end
		end
		
		fireflyOrigin = character.PrimaryPart
	else -- if cutscene
		fireflyOrigin = workspace:WaitForChild("path"):WaitForChild("cutscenewagon").PrimaryPart
	end
	]]
	
	
	
	
end

local fireflyConnection
local function main()
	if player.Character then
		onCharacterAdded(player.Character)
	end
	
	player.CharacterAdded:connect(onCharacterAdded)
	
	while wait(1) do
		local fireflyOrigin = workspace.CurrentCamera.CFrame
		if not fireflyOrigin then return end
		
		for i, fireflyTable in pairs(fireflies) do
			if utilities.magnitude(fireflyTable.firefly.Position - fireflyOrigin.Position) >= utilities.magnitude(fireflyOriginOffset) * 1.1 then
				game.Debris:AddItem(fireflyTable.firefly, 0.5)
				tween(fireflyTable.firefly, {"Transparency"}, 1, 0.5)
				table.remove(fireflies, i)
			end
		end
		
		if game.Lighting.ClockTime >= 18 or game.Lighting.ClockTime <= 6.15 then
			if not fireflyConnection then
				fireflyConnection = runService.Stepped:connect(updateFireflies)
			end
			
			if fireflyOrigin and #firefliesFolder:GetChildren() < fireflyCount then
				local firefly 	= game.ReplicatedStorage.firefly:Clone()
				
				
				if game.ReplicatedStorage:FindFirstChild("fireflyColor") then
					local col = game.ReplicatedStorage.fireflyColor.Value
					firefly.Color = col
					if firefly:FindFirstChild("ParticleEmitter") then
						firefly.ParticleEmitter.Color = ColorSequence.new(col)
					end
					if firefly:FindFirstChild("PointLight") then
						firefly.PointLight.Color = col
					end
				end
				
				firefly.Parent 	= firefliesFolder
				firefly.CFrame 	= assignTargetCFrame()
				
				firefly.Transparency = 1
				tween(firefly, {"Transparency"}, 0, 0.5)
				
				local targetCFrame 	= assignTargetCFrame()
				local duration 		= utilities.magnitude(targetCFrame.p - firefly.Position) / fireflyVelocity
				
				table.insert(fireflies, {
					firefly 		= firefly;
					duration 		= duration;
					startCFrame 	= firefly.CFrame;
					targetCFrame 	= targetCFrame;
					startTime 		= tick();
					offsetX 		= math.random(9001);
					offsetY 		= math.random(9001);
				})
			end
		else
			if #firefliesFolder:GetChildren() > 0 then
				local target = firefliesFolder:GetChildren()[1]
				for i, fireflyData in pairs(fireflies) do
					if fireflyData.firefly == target then
						table.remove(fireflies, i)
					end
				end
				
				target:Destroy()
			else
				if fireflyConnection then
					fireflyConnection:disconnect()
					fireflyConnection = nil
				end
			end
		end
	end
end

main()