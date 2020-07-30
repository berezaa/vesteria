-- Vesteria custom camera to support custom characters
-- Authors: Polymorphic, berezaa

local runService 		= game:GetService("RunService")
local camera 			= workspace.CurrentCamera
local userInputService 	= game:GetService("UserInputService")

local player = game.Players.LocalPlayer
local character

local zoom = 10
game.Players.LocalPlayer.CameraMinZoomDistance = 5

local modules = require(game.ReplicatedStorage:WaitForChild("modules"))
	local network 			= modules.load("network")
	local tween				= modules.load("tween")
	local terrainUtil		= modules.load("terrainUtil")
	local cameraShaker      = modules.load("camera_shaker")
	local configuration 	= modules.load("configuration")

local xRotation = -math.rad(20)
local yRotation = -math.rad(20)

local maxYRotation = math.rad(90)
local maxXRotation = math.rad(80)

local fullRotation = math.rad(720)

local zoomIncrement = 3

local overridden = false
local IS_PLAYER_CAMERA_LOCKED = false

local function raycastDownIgnoreCancollideFalse(ray, ignoreList)
	local hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
	
	local items = workspace.placeFolders:FindFirstChild("items")
	
	-- edit: ignore water and dropped items
	while hitPart and not (hitPart.CanCollide and hitMaterial ~= Enum.Material.Water and (items == nil or not hitPart:IsDescendantOf(items))) do
		ignoreList[#ignoreList + 1] = hitPart
		hitPart, hitPosition, hitDown, hitMaterial = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList, true)
	end
	
	return hitPart, hitPosition, hitDown, hitMaterial
end

-------
local zoomCFrame = CFrame.new(0, 0, zoom)


local defaultReverb = game.SoundService.AmbientReverb

local Par = workspace.CurrentCamera

if game.PlaceId == 2376885433 or game.PlaceId == 2015602902 or game.PlaceId == 4623219432 then
	Par = game.ReplicatedStorage
end

local cameraCFrameVal = Instance.new("CFrameValue")
cameraCFrameVal.Name = "CFrameValue"
cameraCFrameVal.Parent = Par

local lockTarget


local rotationLocked

network:create("lockCameraTarget", "BindableFunction", "OnInvoke", function(target)
	lockTarget = target
	rotationLocked = false
	if target then
		if workspace.CurrentCamera:FindFirstChild("overridden") == nil then
			local tag = Instance.new("BoolValue")
			tag.Name = "overridden"
			tag.Parent = workspace.CurrentCamera
		end			
	else
		if workspace.CurrentCamera:FindFirstChild("overridden") then
			workspace.CurrentCamera.overridden:Destroy()
		end
	end
end)
network:create("lockCameraTargetWithOrientation", "BindableFunction", "OnInvoke", function(target, xRotate, yRotate, zoomCf)
	lockTarget = target
	rotationLocked = false
	if target then
		if workspace.CurrentCamera:FindFirstChild("overridden") == nil then
			local tag = Instance.new("BoolValue")
			tag.Name = "overridden"
			tag.Parent = workspace.CurrentCamera
		end		
		rotationLocked = true
		xRotation = xRotate or xRotation
		yRotation = yRotate or yRotation
		zoomCFrame = zoomCf or zoomCFrame
	else
		if workspace.CurrentCamera:FindFirstChild("overridden") then
			workspace.CurrentCamera.overridden:Destroy()
		end
	end
end)

local function updateCamera(step)
	if not character or not character.PrimaryPart then return end
	local characterCFrame do
		if IS_PLAYER_CAMERA_LOCKED then
			characterCFrame = CFrame.new(character.PrimaryPart.Position) + Vector3.new(0, 0.25 + 0.05 * zoom, 0) + (CFrame.new(Vector3.new(), camera.CFrame.RightVector) * CFrame.Angles(0, math.rad(10), 0)).lookVector * 1.75
		else
			characterCFrame = CFrame.new(character.PrimaryPart.Position) + Vector3.new(0, 0.25 + 0.05 * zoom, 0)
		end
	end
	
	if lockTarget then
		characterCFrame = CFrame.new(lockTarget.Position) + Vector3.new(0,1,0)
	end
	
	if not overridden then
		local intendedCFrame = (characterCFrame * CFrame.Angles(0, yRotation, 0) * CFrame.Angles(xRotation, 0, 0)) * zoomCFrame
		
		local ignoreList = {workspace.CurrentCamera}
		if workspace:FindFirstChild("placeFolders") then
			table.insert(ignoreList, workspace.placeFolders)
		end
		
--		camera.CFrame = intendedCFrame
		
		local direction = intendedCFrame.Position - characterCFrame.Position
		
		local ray = Ray.new(characterCFrame.Position, direction)
		--local hitPart, hitPosition = game.Workspace:FindPartOnRayWithIgnoreList(ray,ignoreList,false,true)
		local hitPart, hitPosition = raycastDownIgnoreCancollideFalse(ray, ignoreList)
		
		--tween(camera,{"CFrame"},intendedCFrame,0.1)
--		camera.CFrame = CFrame.new(hitPosition - direction.unit, characterCFrame.p)
		cameraCFrameVal.Value = CFrame.new(hitPosition - direction.unit, characterCFrame.p)
	end
	
	camera.Focus = camera.CFrame
end

local function lockCamera(cf, duration, easeStyle)
	if cf then
		overridden = true
		if duration then
			tween(cameraCFrameVal,{"Value"},cf,duration,easeStyle)
		else
			cameraCFrameVal.Value = cf
		end
		if workspace.CurrentCamera:FindFirstChild("overridden") == nil then
			local tag = Instance.new("BoolValue")
			tag.Name = "overridden"
			tag.Parent = workspace.CurrentCamera
		end
		
	else
		if workspace.CurrentCamera:FindFirstChild("overridden") then
			workspace.CurrentCamera.overridden:Destroy()
		end
		overridden = false
	end
end

local primaryCameraShaker



	primaryCameraShaker = cameraShaker.new(--[[Enum.RenderPriority.Camera.Value]] 2, function(shakeCF)
		camera.CFrame = cameraCFrameVal.Value * shakeCF
	end)
	primaryCameraShaker:Start()


network:create("cameraShake", "BindableFunction", "OnInvoke", function(preset)
	local camShake = primaryCameraShaker
	if preset == nil then
		camShake:Shake(cameraShaker.Presets.Explosion)
	elseif preset == "bump" then
		camShake:Shake(cameraShaker.Presets.Bump)
	end
end)



-- at the moment can only be played during a cutscene
local function lockCameraWithCameraShake(cf, duration, timeUntilExplosion, easeStyle, preset, explodeDuration)
	
	if cf then
		overridden = true
		if duration then
			tween(camera,{"CFrame"},cf,duration,easeStyle)
			spawn(function()
				
				wait(timeUntilExplosion)
				--[[
				local camShake = cameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
					camera.CFrame = cf * shakeCf
				end)
				camShake:Start()
				]]
				
				local camShake = primaryCameraShaker
				
				if preset == nil then
					camShake:Shake(cameraShaker.Presets.Explosion)
				elseif preset == "bump" then
					camShake:Shake(cameraShaker.Presets.Bump)
				end
				--[[
				wait(explodeDuration or 4)
				camShake:Stop()
				]]
			end)
		else
			cameraCFrameVal.Value = cf
		end
		if workspace.CurrentCamera:FindFirstChild("overridden") == nil then
			local tag = Instance.new("BoolValue")
			tag.Name = "overridden"
			tag.Parent = workspace.CurrentCamera
		end
		
	else
		if workspace.CurrentCamera:FindFirstChild("overridden") then
			workspace.CurrentCamera.overridden:Destroy()
		end
		overridden = false
	end
	

end

network:create("lockCameraPosition","BindableFunction","OnInvoke",lockCamera)
network:create("lockCameraPositionWithCameraShake","BindableFunction","OnInvoke",lockCameraWithCameraShake)


local lockOrigin


local function onInputBegan(inputObject, Absorbed)
	
	
	if Absorbed then
		return false
	end

	if inputObject.KeyCode == Enum.KeyCode.ButtonR3 then
		zoom = zoom - 7
		if zoom < player.CameraMinZoomDistance then
			zoom = player.CameraMaxZoomDistance
		end
		if not rotationLocked then
			zoomCFrame = CFrame.new(0, 0, zoom)
		end
	end

	if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
		lockOrigin = inputObject.Position
	elseif inputObject.KeyCode == Enum.KeyCode.Left then
		while inputObject.UserInputState ~= Enum.UserInputState.Cancel and inputObject.UserInputState ~= Enum.UserInputState.End do
			game:GetService("RunService").RenderStepped:wait()
			yRotation = (yRotation + 0.04) % fullRotation
		end
	elseif inputObject.KeyCode == Enum.KeyCode.Right then
		while inputObject.UserInputState ~= Enum.UserInputState.Cancel and inputObject.UserInputState ~= Enum.UserInputState.End do
			game:GetService("RunService").RenderStepped:wait()
			yRotation = (yRotation - 0.04) % fullRotation
		end	
	elseif inputObject.KeyCode == Enum.KeyCode.I then
		zoom = math.clamp(zoom - 7, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		-- update the zoomCFrame
		if not rotationLocked then
			zoomCFrame = CFrame.new(0, 0, zoom)
		end			
	elseif inputObject.KeyCode == Enum.KeyCode.O then
		zoom = math.clamp(zoom + 7, player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		-- update the zoomCFrame
		if not rotationLocked then
			zoomCFrame = CFrame.new(0, 0, zoom)		
		end			
	end
end

local function onInputChanged(inputObject, absorbed)
	
	if absorbed then
		return false
	end
	
	if inputObject.UserInputType == Enum.UserInputType.MouseMovement and (IS_PLAYER_CAMERA_LOCKED or lockOrigin) then
		
		local yConversion = inputObject.Delta.X / 5
		local xConversion = inputObject.Delta.Y	/ 5
		if not rotationLocked then
			xRotation = math.clamp(xRotation - math.rad(xConversion), -maxXRotation, maxXRotation)
			yRotation = (yRotation - math.rad(yConversion)) % fullRotation
		end
	elseif inputObject.UserInputType == Enum.UserInputType.MouseWheel then
		
		
		
		zoom = math.clamp(zoom - ( inputObject.Position.Z)   , player.CameraMinZoomDistance, player.CameraMaxZoomDistance)

--		zoom = math.clamp(zoom - zoomIncrement * inputObject.Position.Z   , player.CameraMinZoomDistance, player.CameraMaxZoomDistance)
		
		-- update the zoomCFrame
		if not rotationLocked then
			zoomCFrame = CFrame.new(0, 0, zoom)
		end
	end
end

local function onInputEnded(inputObject)
	if inputObject.UserInputType == Enum.UserInputType.MouseButton2 then
		lockOrigin = nil
		
	elseif inputObject.KeyCode == Enum.KeyCode.Left then
		
	end
end
	
local UserInputService = game:GetService("UserInputService")	
	
ddy = 0
ddx = 0	

local mobileCameraRotation

network:create("mobileCameraRotationChanged", "BindableEvent", "Event", function(rotation)
	mobileCameraRotation = rotation
end)
	
game:GetService("RunService").RenderStepped:connect(function()
	
	if mobileCameraRotation and mobileCameraRotation.magnitude > 0.1 then
		local dy = 	mobileCameraRotation.Y
		local dx =	mobileCameraRotation.X		
		
		if math.abs(dy) < 0.1 then
			dy = 0
			ddy = 0
		elseif math.abs(dy) > 0.5 then
			ddy = math.clamp(ddy + math.abs(dy/10),0,4) 
		end		
		
		if math.abs(dx) < 0.1 then
			dx = 0
			ddx = 0
		elseif math.abs(dx) > 0.5 then
			ddx = math.clamp(ddx + math.abs(dx/10),0,4)
		end

		local yConversion =  dx * (1 + ddx)
		local xConversion =  dy * (1 + ddy)
		if not rotationLocked then
			xRotation = math.clamp(xRotation - math.rad(xConversion), -maxXRotation, maxXRotation)
			yRotation = (yRotation - math.rad(yConversion)) % fullRotation	
		end		
	end
	
	local inputs = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1)
	
	if inputs then

		for index, inputObject in pairs(inputs) do

			
			if inputObject.KeyCode == Enum.KeyCode.Thumbstick2 then
				
		
				local dy = 	inputObject.Position.Y
				local dx =	inputObject.Position.X		
				
				if math.abs(dy) < 0.1 then
					dy = 0
					ddy = 0
				elseif math.abs(dy) > 0.5 then
					ddy = math.clamp(ddy + math.abs(dy/10),0,4) 
				end		
				
				if math.abs(dx) < 0.1 then
					dx = 0
					ddx = 0
				elseif math.abs(dx) > 0.5 then
					ddx = math.clamp(ddx + math.abs(dx/10),0,4)
				end

				local yConversion = dx * (1 + ddx)
				local xConversion = -dy * (1 + ddy)
				if not rotationLocked then
					xRotation = math.clamp(xRotation - math.rad(xConversion), -maxXRotation, maxXRotation)
					yRotation = (yRotation - math.rad(yConversion)) % fullRotation					
				end
			end
		end	
	
	end
end)

local function onCharacterAdded(newCharacter)
	character = newCharacter
	
	if IS_PLAYER_CAMERA_LOCKED then
		userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
	else
		userInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

local function main()
	if player.Character then
		onCharacterAdded(player.Character)
	end
	
	player.CharacterAdded:connect(onCharacterAdded)
	
	userInputService.InputBegan:connect(onInputBegan)
	userInputService.InputChanged:connect(onInputChanged)
	userInputService.InputEnded:connect(onInputEnded)
	
	
	network:create("toggleCameraLockChanged", "BindableEvent")
	network:create("getIsPlayerCameraLocked", "BindableFunction", "OnInvoke", function()
		return IS_PLAYER_CAMERA_LOCKED
	end)
	
	network:create("toggleCameraLock", "BindableFunction", "OnInvoke", function(setValue)

		if setValue ~= nil then
			IS_PLAYER_CAMERA_LOCKED = not not setValue
		else
			IS_PLAYER_CAMERA_LOCKED = not IS_PLAYER_CAMERA_LOCKED
		end
		
		if IS_PLAYER_CAMERA_LOCKED then
			userInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		else
			userInputService.MouseBehavior = Enum.MouseBehavior.Default
		end
		
		if character and character.PrimaryPart then
			character.PrimaryPart.hitboxGyro.D 			= 5000
			character.PrimaryPart.hitboxGyro.MaxTorque 	= Vector3.new(100000000, 100000000, 100000000)
			character.PrimaryPart.hitboxGyro.P 			= 3000000
		end
		
		network:fire("toggleCameraLockChanged", IS_PLAYER_CAMERA_LOCKED)
	
	end)
	
	runService:BindToRenderStep("cameraRenderUpdate", --[[Enum.RenderPriority.Camera.Value - 1]] 1, updateCamera)
end

main()