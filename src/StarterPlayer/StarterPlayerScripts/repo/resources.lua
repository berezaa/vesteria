-- Resources
-- Rocky28447
-- June 2, 2020



local resources = {}

local collectionService = game:GetService("CollectionService")
local replicatedStorage = game:GetService("ReplicatedStorage")

local modules
local thread
local network


local function getNodeTypeMetadataFromNode(node)
	local containingFolder = node:FindFirstAncestorWhichIsA("Folder")
	local isNodeGroup = collectionService:HasTag(containingFolder, "resourceNodeGroupFolder")
	local nodeTypeMetadata = isNodeGroup and containingFolder.Parent.Metadata or containingFolder.Metadata

	return nodeTypeMetadata
end


function resources:DoEffect(node, effect)
	local nodeMetadata = getNodeTypeMetadataFromNode(node)
	local effectFolder = nodeMetadata.EffectsStorage:FindFirstChild(effect)

	if effectFolder then
		for _, effect in pairs (effectFolder:GetChildren()) do
			local effectClone = effect:Clone()
			effectClone.Parent = node.PrimaryPart

			if effectClone:IsA("Sound") then
				effectClone:Play()
			elseif effectClone:IsA("ParticleEmitter") then
				effectClone:Emit(effectClone.Rate)
			end

			thread.Delay(10, function()
				effectClone:Destroy()
			end)
		end
	end
end


function resources:Start()

	network:connect("resourceHarvested", "OnClientEvent", function(node, dropPoint)
		local nodeMetadata = require(getNodeTypeMetadataFromNode(node))
		local onHarvest = nodeMetadata.Animations.OnHarvest

		if onHarvest and type(onHarvest) == "function" then
			onHarvest(node, dropPoint)
		else
			self:DoEffect(node, "Harvest")
		end

		if dropPoint then
			dropPoint.Transparency = 1
		end
	end)

	network:connect("resourceReplenished", "OnClientEvent", function(node)
		local nodeMetadata = require(getNodeTypeMetadataFromNode(node))
		local onReplenish = nodeMetadata.Animations.OnReplenish

		if nodeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.Transparency = 0
					c.CanCollide = true
				end
			end
		else
			if node:FindFirstChild("DropPoints") then
				for _, dropPoint in pairs (node.DropPoints:GetChildren()) do
					dropPoint.Value.Transparency = 0
				end
			end
		end

		if onReplenish and type(onReplenish) == "function" then
			onReplenish(node)
		else
			self:DoEffect(node, "Replenish")
		end

		collectionService:AddTag(node.PrimaryPart, "attackable")
	end)

	network:connect("resourceDepleted", "OnClientEvent", function(node)
		local nodeMetadata = require(getNodeTypeMetadataFromNode(node))
		local onDeplete = nodeMetadata.Animations.OnDeplete

		if nodeMetadata.DestroyOnDeplete then
			for _, c in pairs (node:GetDescendants()) do
				if c:IsA("BasePart") then
					c.Transparency = 1
					c.CanCollide = false
				end
			end
			if not onDeplete or type(onDeplete) ~= "function" then
				self:DoEffect(node, "Deplete")
			end
		end
		if onDeplete and type(onDeplete) == "function" then
			onDeplete(node)
		end
		collectionService:RemoveTag(node.PrimaryPart, "attackable")
	end)

	local depletedNodes = network:invokeServer("getDepletedResourceNodes")
	for _, node in pairs(depletedNodes) do
		for _, c in pairs (node:GetDescendants()) do
			if c:IsA("BasePart") then
				c.Transparency = 1
				c.CanCollide = false
			end
		end
	end

end


function resources:Init()
	modules = require(replicatedStorage.modules)
	network = modules.load("network")
	thread = modules.load("thread")
end


resources:Init()
resources:Start()

return resources
