local abilityAnimations = game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local debris = game:GetService("Debris")
local runService = game:GetService("RunService")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
	local network 			= modules.load("network")
	local damage 			= modules.load("damage")
	local placeSetup 		= modules.load("placeSetup")
	local tween	 			= modules.load("tween")
	local ability_utilities = modules.load("ability_utilities")
	local effects           = modules.load("effects")
	local detection 		= modules.load("detection")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local abilityData = {
	id = 53,
	
	name = "Step Through Shadow",
	image = "rbxassetid://92931029",
	description = "Create a shadow at your location. If you have a shadow already, immediately warp back to it. Doesn't break stealth.",
	mastery = "Longer window of time to reactivate.",
	
	maxRank = 3,
	
	statistics = ability_utilities.calculateStats{
		maxRank = 3,
		static = {
			cooldown = 15,
		},
		dynamic = {
			manaCost = {10, 50},
			duration = {15, 45},
		}
	},
	
	securityData = {
	},
	
	doesNotBreakStealth = true,
}

local function createShadow(entity)
	local shadow = Instance.new("Model")
	
	for _, object in pairs(entity:GetDescendants()) do
		if object:IsA("BasePart") then
			local part = object:Clone()
			for _, child in pairs(part:GetChildren()) do
				if (not child:IsA("SpecialMesh")) then
					child:Destroy()
				end
			end
			part.Anchored = true
			if part.Transparency < 1 then
				part.Color = Color3.new(0, 0, 0)
				part.Transparency = 0.5
				part.Material = Enum.Material.SmoothPlastic
			end
			part.Parent = shadow
			
			if object == entity.PrimaryPart then
				shadow.PrimaryPart = part
			end
		end
	end
	
	return shadow
end

local TAG_NAME = "StepThroughShadowActiveTag"

local function createShadowGuid()
	local httpService = game:GetService("HttpService")
	local guid = httpService:GenerateGUID()
	
	return "StepThroughShadowShadow_"..guid
end

function abilityData:execute_server(player, abilityExecutionData, isAbilitySource)
	if not isAbilitySource then return end
	
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local tag = player:FindFirstChild(TAG_NAME)
	
	if tag then
		network:invoke("teleportPlayerCFrame_server", player, tag.CFrame.Value)
		network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "removeShadow", tag.Value)
		network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "disappearShadow")
		tag:Destroy()
	else
		tag = Instance.new("StringValue")
		tag.Name = TAG_NAME
		tag.Value = createShadowGuid()
		
		local cframe = Instance.new("CFrameValue")
		cframe.Name = "CFrame"
		cframe.Value = manifest.CFrame
		cframe.Parent = tag
		
		tag.Parent = player
		
		network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "createInitialShadow", tag.Value)
		network:invoke("abilityCooldownReset_server", player, self.id)
		
		delay(abilityExecutionData["ability-statistics"]["duration"], function()
			if tag.Parent ~= player then return end
			
			network:fireAllClients("abilityFireClientCall", abilityExecutionData, self.id, "removeShadow", tag.Value)
			tag:Destroy()
		end)
	end
end

function abilityData:execute_client(abilityExecutionData, func, ...)
	self[func](self, abilityExecutionData, ...)
end

function abilityData:createInitialShadow(abilityExecutionData, shadowGuid)
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not player then return end
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local renderCharacterContainer = network:invoke("getRenderCharacterContainerByEntityManifest", manifest)
	if not renderCharacterContainer then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local shadow = createShadow(entity)
	shadow.Name = shadowGuid
	shadow.Parent = entitiesFolder
end

function abilityData:disappearShadow(abilityExecutionData)
	local player = ability_utilities.getCastingPlayer(abilityExecutionData)
	if not player then return end
	local char = player.Character
	if not char then return end
	local manifest = char.PrimaryPart
	if not manifest then return end
	
	local renderCharacterContainer = network:invoke("getRenderCharacterContainerByEntityManifest", manifest)
	if not renderCharacterContainer then return end
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local shadow = createShadow(entity)
	shadow.Parent = entitiesFolder
	
	local duration = 0.5
	for _, desc in pairs(shadow:GetDescendants()) do
		if desc:IsA("BasePart") then
			tween(desc, {"Transparency"}, 1, duration)
		end
	end
	debris:AddItem(shadow, duration)
end

function abilityData:removeShadow(abilityExecutionData, shadowGuid)
	local shadow = entitiesFolder:FindFirstChild(shadowGuid)
	if not shadow then return end
	
	-- clear the shadow
	shadow:Destroy()
end

function abilityData:execute(renderCharacterContainer, 	abilityExecutionData, isAbilitySource, guid)
	local root = renderCharacterContainer.PrimaryPart
	if not root then return end
	
	local entity = renderCharacterContainer:FindFirstChild("entity")
	if not entity then return end
	
	if isAbilitySource then
		network:fireServer("abilityFireServerCall", abilityExecutionData, self.id)
	end
end

return abilityData