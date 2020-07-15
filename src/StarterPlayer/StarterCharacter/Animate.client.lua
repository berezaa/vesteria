--[[
local userInputService = game:GetService("UserInputService")
-- todo: implement particle support for sprinting
-- todo: do not play when jumping, or not sprinting

local tweenService 	= game:GetService("TweenService")
local camera 		= workspace.CurrentCamera
local player 		= game.Players.LocalPlayer
local character 	= player.Character

local TWEEN_INFO = TweenInfo.new(1 / 3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0)

local cameraSprinting 	= tweenService:Create(camera, TWEEN_INFO, {FieldOfView = 80})
local cameraWalking 	= tweenService:Create(camera, TWEEN_INFO, {FieldOfView = 70})

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")

local animations = require(replicatedStorage.playerAnimationData)
local currentlyPlayingAnimations = {}

local function playAnimation(animationName, blendingId, doPlayRepeat)
	if not animationName then return end
	if not blendingId then return end
	
	if not currentlyPlayingAnimations[blendingId] or (doPlayRepeat or currentlyPlayingAnimations[blendingId] ~= animations[animationName].animationTrack) then
		if currentlyPlayingAnimations[blendingId] then
			currentlyPlayingAnimations[blendingId]:Stop()
			currentlyPlayingAnimations[blendingId] = nil
		end
		
		local animationTrack 					= animations[animationName].animationTrack
		currentlyPlayingAnimations[blendingId] 	= animationTrack
		
		-- play it
		animationTrack:Play(0.15, 1, animations[animationName].speed or 1)
	end
end

local function onHumanoid_Jumping(isActive)
	if isActive then
		playAnimation("jumping", "action", true)
	end
end

local function onCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid")
	
	humanoid.Jumping:connect(function(isActive)
		states.isInAir = true
		
		character.RightFoot.ParticleEmitter.Enabled = false
		character.LeftFoot.ParticleEmitter.Enabled 	= false
	end)
	
	humanoid.FreeFalling:connect(function(isActive)
		if not states.isActive then
			states.isInAir = false
			
			if states.isSprinting then
				character.RightFoot.ParticleEmitter.Enabled = true
				character.LeftFoot.ParticleEmitter.Enabled 	= true
			end
		end
	end)
end

local function main()
	network:create("characterStateChanged", "BindableEvent")
	
	userInputService.InputBegan:connect(onInputBegan)
	userInputService.InputEnded:connect(onInputEnded)
end

main()
]]