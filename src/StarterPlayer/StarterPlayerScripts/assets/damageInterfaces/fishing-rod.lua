local fishingPole 			= {}
	fishingPole.isEquipped = false

local userInputService 	= game:GetService("UserInputService")
local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 			= modules.load("network")
		local utilities 		= modules.load("utilities")
		local detection 		= modules.load("detection")
		local placeSetup 		= modules.load("placeSetup")
		local projectile 		= modules.load("projectile")
		local client_utilities 	= modules.load("client_utilities")

local currentDamageGUID = httpService:GenerateGUID(false)
		
local animationInterface = require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))--network:invoke("getPlayerCoreService", "animationInterface")

-- internal stuff specific to the fishingPole
local animationControllerLoaded
local attackSequenceLength

local slashAnimationConnection

local isWithinSlash1Window 		= false
local isWithinSlash2Window 		= false
local isWithinDamageSequence 	= false
local canPlayerDoubleSlash 		= false

local currentWeaponManifest
local playerAbilitiesSlotDataCollection

local player = game.Players.LocalPlayer

local isFishing 			= false
local isProcessing 			= false
local fishingPoleManifest
local currentBob

local timesFishing = 0 



function fishingPole:attack()
	if not isProcessing then
		isProcessing = true
		
		if not isFishing then
			timesFishing = timesFishing + 1
			local myClientCharacterContainer = network:invoke("getMyClientCharacterContainer")
			if not myClientCharacterContainer or not myClientCharacterContainer:FindFirstChild("entity") then return false end
			
			local currentlyEquipped 	= network:invoke("getCurrentlyEquippedForRenderCharacter", myClientCharacterContainer.entity)
			local currentWeaponManifest = currentlyEquipped["1"] and currentlyEquipped["1"].manifest
			if not currentWeaponManifest then return end
			
			local _, targetPosition = client_utilities.raycastFromCurrentScreenPoint({myClientCharacterContainer})
			
			animationInterface:replicatePlayerAnimationSequence("fishing-rodAnimations", "cast-line", nil, {targetPosition = targetPosition})
						
			network:invoke("setCharacterArrested", true)
			network:invoke("setCharacterMovementState", "isFishing", true)
			--network:invokeServer("playerRequest_startFishing")
		else
			animationInterface:replicatePlayerAnimationSequence("fishing-rodAnimations", "reel-line")
			
			isFishing 		= false
			
			
			
			spawn(function()
				wait(1)
				isProcessing 	= false
			end)
		end
	end
end

local function onFishingBobBobbed()
	local clientFishingBob = network:invoke("getPlayerRenderDataByNameTag", player, "fishingBob")
	
	if clientFishingBob and clientFishingBob.Parent then
		local currentFishing = timesFishing
		
		clientFishingBob.CFrame = clientFishingBob.CFrame - Vector3.new(0, 1, 0)
		clientFishingBob.splash:Emit(40)
		
		utilities.playSound("fishing_FishBite", clientFishingBob)
		wait(0.15)
		if currentFishing == timesFishing then
			utilities.playSound("fishing_FishSplashOutOfWater", clientFishingBob)
		end
		
		
		wait(0.1)
		if currentFishing == timesFishing then
			clientFishingBob.CFrame = clientFishingBob.CFrame - Vector3.new(0, 0.25, 0)
			clientFishingBob.splash:Emit(40)
		end
		
		
	end
end

function fishingPole:equip()
	currentWeaponManifest = network:invoke("getCurrentWeaponManifest")
end

function fishingPole:unequip()
	if isFishing then
		network:invoke("setCharacterMovementState", "isFishing", false)
		network:invoke("setCharacterArrested", false)
		
		local currentBob = network:invoke("getPlayerRenderDataByNameTag", game.Players.LocalPlayer, "fishingBob")
		
		if currentBob then
			game:GetService("Debris"):AddItem(currentBob, 1 / 30)
		end
			
		if fishingPoleManifest and fishingPoleManifest:FindFirstChild("line") then
			fishingPoleManifest.line.Attachment1 = nil
			fishingPoleManifest = nil
		end
		
		isFishing = false
	end
end

local function onPropogationRequestToSelf(propogationNameTag, propogationValue)
	if propogationNameTag == "abilities" then
		playerAbilitiesSlotDataCollection = propogationValue
	end
end

local function onFishingBobHit(hitWater)
	if not hitWater then
		isFishing = false
		
		network:invoke("setCharacterMovementState", "isFishing", false)
		network:invoke("setCharacterArrested", false)
		spawn(function()
			wait(1)
			isProcessing 	= false
		end)
	else
		isFishing = true
		isProcessing 	= false
	end
	
	
end

local function main()
	onPropogationRequestToSelf("abilities", network:invoke("getCacheValueByNameTag", "abilities"))
	
	network:create("fishingBobHit", "BindableEvent", "Event", onFishingBobHit)
	network:connect("propogationRequestToSelf", "Event", onPropogationRequestToSelf)
	network:connect("signal_fishingBobBobbed", "OnClientEvent", onFishingBobBobbed)
end

main()

return fishingPole