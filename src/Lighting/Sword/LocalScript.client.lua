local player = game.Players.LocalPlayer
local humanoid
local animationTrack

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local detection = modules.load("detection")

local hitDebounceTable 			= {}
local canDamage 				= false
local SWORD_ATTACK_GRANULARITY = 20
		
local function onAnimationStopped()
	hitDebounceTable = {}
	canDamage = false
end

local function onEquipped(mouse)
	
end

script.Parent.Equipped:connect(onEquipped)