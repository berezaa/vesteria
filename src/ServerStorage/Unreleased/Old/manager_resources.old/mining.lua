local CHANCE = 5

local replicatedStorage = game:GetService("ReplicatedStorage")

local modules = require(replicatedStorage:WaitForChild("modules"))
local network = modules.load("network")
local tween = modules.load("tween")
local effects = modules.load("effects")
local itemLookup = require(replicatedStorage:WaitForChild("itemData"))

local model = script.Parent.Parent
local itemId = model.PrimaryPart.itemId.Value

local function doesPlayerHavePickaxeEquipped(player)
	local data = network:invoke("getPlayerData", player)
	if (not data) or (not data.equipment) then return false end
	
	local mainHandItemId
	for _, slotData in pairs(data.equipment) do
		if slotData.position == 1 then
			mainHandItemId = slotData.id
			break
		end
	end
	if not mainHandItemId then return false end
	
	-- temporary check once we determine if there's a specific pickaxe type
	return mainHandItemId == 287
	
	--local itemData = itemLookup[mainHandItemId]
end

local attackable = {}

function attackable.onAttackedClient()
	
end

function attackable.onAttackedServer(player)
	if math.random(1, CHANCE) ~= 1 then return end
	if not doesPlayerHavePickaxeEquipped(player) then return end
	
	-- find a spot that's touching the rock near the player
	local here = model.PrimaryPart.Position
	local there = player.Character.PrimaryPart.Position
	local cframe = CFrame.new(here, there)
	local ray = Ray.new(there, here - there)
	local part, point = workspace:FindPartOnRayWithWhitelist(ray, {model})
	cframe = cframe + (point - cframe.Position)
	
	-- spawn the item
	local item = network:invoke("spawnItemOnGround", {id = 288}, cframe.Position, {player})
	
	local attachmentTarget
	
	if item:IsA("BasePart") then
		attachmentTarget = item
	elseif item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")) then
		local primaryPart = item.PrimaryPart or item:FindFirstChild("HumanoidRootPart")
		if primaryPart then
			attachmentTarget = primaryPart
		end
	end				
	
	if attachmentTarget then
		local topAttachment = Instance.new("Attachment", attachmentTarget)
			topAttachment.Position = Vector3.new(0, attachmentTarget.Size.Y / 2, 0)
		
		local bottomAttachment = Instance.new("Attachment", attachmentTarget)
			bottomAttachment.Position = Vector3.new(0, -attachmentTarget.Size.Y / 2, 0)
		
		local trail = script.trail:Clone()
			trail.Attachment0 	= topAttachment
			trail.Attachment1 	= bottomAttachment
			trail.Enabled 		= true
			trail.Parent 		= attachmentTarget
	end	
	
	local speed = 32
	item.Velocity = (cframe.LookVector * speed) + Vector3.new(0, speed, 0)
end

return attackable