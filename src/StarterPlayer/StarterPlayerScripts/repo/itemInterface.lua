-- Author: Polymorphic

local module 			= {}
local itemsToRenderSFX 	= {}

local characterHitboxPart
local runService 	= game:GetService("RunService")
local player 		= game.Players.LocalPlayer

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local utilities = modules.load("utilities")
		local placeSetup = modules.load("placeSetup")
	local itemLookup = require(replicatedStorage.itemData)	
		
local itemsFolder = placeSetup.awaitPlaceFolder("items")

local function onCharacterAdded(character)
	characterHitboxPart = character.PrimaryPart
end
-- todo: optimize items not relevant to player
local function onItemAdded(item)
	if item:WaitForChild("MASK_MOTOR", 20) then
		local degreeOffset = math.random(360)
		local offset = CFrame.Angles(math.pi * math.sin(16 * degreeOffset), degreeOffset, math.pi * math.cos(16 * degreeOffset))
		table.insert(itemsToRenderSFX, {manifest = item; offset = offset})
	end
	
	-- make items that you cannot pick up transparent
	if item:WaitForChild("owners", 20) then
		wait()
		if utilities.playerCanPickUpItem(player, item) then
			
			
			if item:FindFirstChild("Legendary") then
				utilities.playSound("legendaryItemDrop", item)
				item:WaitForChild("Trail",1)
				item.Trail.Color = ColorSequence.new(Color3.fromRGB(138, 11, 170))	
			elseif item:FindFirstChild("Rare",1) then
				utilities.playSound("rareItemDrop", item)
				item:WaitForChild("Trail",1)
				item.Trail.Color = ColorSequence.new(Color3.fromRGB(255, 213, 0))
			elseif item.Name == "monster idol" then
				utilities.playSound("idolDrop", item)
			else
				utilities.playSound("itemDrop", item)
			end
		else
			for i,part in pairs(item:GetDescendants()) do
				if part:IsA("BasePart") and part.Transparency < 1 then
					part.Transparency = 1 - ((1 - part.Transparency) * 0.3)
					if part.Material == Enum.Material.Glass then
						part.Material = Enum.Material.SmoothPlastic
					end
				elseif part:IsA("ParticleEmitter") or part:IsA("Beam") or part:IsA("Trail") or part:IsA("PointLight") or part:IsA("Light") then
					part.Enabled = false
				end
			end
			
			if item:IsA("BasePart") then
				item.Transparency = 1 - ((1 - item.Transparency) * 0.3)
				if item.Material == Enum.Material.Glass then
					item.Material = Enum.Material.SmoothPlastic
				end
			end			
		end
	end
end



local tau = 2 * math.pi
local function renderItemSFX()
	local degree 			= math.rad(tick() % 360)
	local applicationOffset = Vector3.new(0, 0.75 + 0.35 * math.sin(32 * degree), 0)
	local rotationOffset 	= CFrame.Angles(0, math.pi * math.cos(16 * degree), math.pi / 6)
	
	for i, item in pairs(itemsToRenderSFX) do
		if item.manifest and item.manifest.Parent then
			item.manifest.MASK_MOTOR.C1 = (rotationOffset * item.offset) + applicationOffset
		else
			table.remove(itemsToRenderSFX, i)
		end
	end
end

local function main()
	-- queue character
	if player.Character then
		onCharacterAdded(player.Character)
	end

	player.CharacterAdded:connect(onCharacterAdded)
	
	-- add items to queue
	for i, item in pairs(itemsFolder:GetChildren()) do
		spawn(function() onItemAdded(item) end)
	end
	
	itemsFolder.ChildAdded:connect(onItemAdded)
	runService.Heartbeat:connect(renderItemSFX)
end

main()

return module