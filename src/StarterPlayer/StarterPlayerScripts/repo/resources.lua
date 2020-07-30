-- Resources
-- Rocky28447
-- June 2, 2020



local Resources = {}

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Modules
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


function Resources:NodeReplenished(node)
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
end


function Resources:NodeDepleted(node)
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
end


function Resources:Start()

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
			dropPoint.CanCollide = false
		end
	end)

	network:connect("resourceReplenished", "OnClientEvent", function(node)
		self:NodeReplenished(node)
	end)

	network:connect("resourceDepleted", "OnClientEvent", function(node)
		self:NodeDepleted(node)
	end)

	local depletedNodes = network:invokeServer("getDepletedResourceNodes")
	for _, node in pairs(depletedNodes) do
		self:NodeDepleted(node)
	end

end


function Resources:Init()
	Modules = require(ReplicatedStorage.modules)
	Thread = Modules.load("thread")
	network = Modules.load("network")
end


Resources:Init()
Resources:Start()

return Resources
