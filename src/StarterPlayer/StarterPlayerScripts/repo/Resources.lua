-- Resources
-- Rocky28447
-- June 2, 2020



local Resources = {}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SharedModules
local Thread
local network


local function getNodeTypeMetadataFromNode(node)
	local containingFolder = node:FindFirstAncestorWhichIsA("Folder")
	local isNodeGroup = CollectionService:HasTag(containingFolder, "resourceNodeGroupFolder")
	local nodeTypeMetadata = isNodeGroup and containingFolder.Parent.Metadata or containingFolder.Metadata

	return nodeTypeMetadata
end


function Resources:DoEffect(node, effect)
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

			Thread.Delay(10, function()
				effectClone:Destroy()
			end)
		end
	end
end


function Resources:Start()

	network:connect("ResourceHarvested", "OnClientEvent", function(node, dropPoint)
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

	network:connect("ResourceReplenished", "OnClientEvent", function(node)
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

		CollectionService:AddTag(node.PrimaryPart, "attackable")
	end)

	network:connect("ResourceDepleted", "OnClientEvent", function(node)
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
		CollectionService:RemoveTag(node.PrimaryPart, "attackable")
	end)

end


function Resources:Init()

	SharedModules = require(ReplicatedStorage.modules)
	network = SharedModules.load("network")
	Thread = SharedModules.load("Thread")

end


Resources:Init()
Resources:Start()

return Resources