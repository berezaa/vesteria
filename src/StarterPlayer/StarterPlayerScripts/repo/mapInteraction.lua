-- a collection of interactable map elements
-- Author: berezaa

local module = {}

local player = game.Players.LocalPlayer

local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local network 	= modules.load("network")
		local tween = modules.load("tween")


local bouncingParts = {}

local function partTouched(part, hit)

	-- automatic debounce
	if game.CollectionService:HasTag(part, "ActivePart") then

		game.CollectionService:RemoveTag(part, "ActivePart")
		spawn(function()
			wait(0.1)
			game.CollectionService:AddTag(part, "ActivePart")
		end)

		if player.Character and player.Character.PrimaryPart and part:FindFirstChild("HitDebounce") == nil and hit:IsDescendantOf(player.Character) then

			for i, p in pairs(bouncingParts) do
				if p == part then
					return
				end
			end


			if game.CollectionService:HasTag(part,"Bounce") then
				local size = part.Size


				local difference = (player.Character.PrimaryPart.Position - part.position).unit
				if math.abs(difference.X) < 0.2 then
					difference = Vector3.new(0,difference.Y,difference.Z)
				end
				if math.abs(difference.Y) < 0.2 then
					difference = Vector3.new(difference.X,0,difference.Z)
				end
				if math.abs(difference.Z) < 0.2 then
					difference = Vector3.new(difference.X,difference.Y,0)
				end

				local coef = 1 + ((size.X * size.Y * size.Z) ^ (1/3))

				local soundMirror = game.ReplicatedStorage.assets.sounds:FindFirstChild("bounce")
				if soundMirror then
					local sound = Instance.new("Sound")
					for property, value in pairs(game.HttpService:JSONDecode(soundMirror.Value)) do
						sound[property] = value
					end
					sound.PlaybackSpeed = math.clamp(1.5 - coef / 50, 0.5, 1.5)
					sound.Volume = math.clamp(coef/25, 0.2, 2)
					sound.Parent = part
					sound:Play()
					game.Debris:AddItem(sound,10)
				end
				spawn(function()
					local initSize = part.Size
					table.insert(bouncingParts, part)

					--tween(part, {"Size"},{Vector3.new(part.Size.X*1.2, part.Size.Y*1.2, part.Size.Z*1.2)},.4)
					--wait(.4)
					tween(part, {"Size"},{initSize*1.5},.3, Enum.EasingStyle.Quad)
					wait(.3)
					tween(part, {"Size"},{initSize},.7, Enum.EasingStyle.Bounce)
					wait(.7)
					for i, p in pairs(bouncingParts) do
						if p == part then
							table.remove(bouncingParts,i)
						end
					end
				end)

				network:fire("applyJoltVelocityToCharacter", difference * coef * 15)
			elseif part.Name == "shopPart" then
				network:invoke("openShop")
			end
		end

	end
end

network:create("touchedActivePart","BindableEvent","Event",partTouched)

local function check(part)
	if part:IsA("BasePart") then
		if (part.Parent.Name == "shroom" or part.Parent.Name == "Flower") and part.Parent:FindFirstChild("Destroyed") == nil then
			local size = part.Size
			if size.X * size.Y * size.Z <= 25 then
				-- parts that a basic attack can destroy
				game.CollectionService:AddTag(part,"Destroyable")
				part.CanCollide = false
			elseif part.Name == "MushPart" then
				-- parts that you can bounce on
				game.CollectionService:AddTag(part,"Bounce")
				game.CollectionService:AddTag(part,"ActivePart")
				part.CanCollide = true
			end
		elseif part.Name == "shopPart" then
			game.CollectionService:AddTag(part,"ActivePart")
		end
	end
	if game.CollectionService:HasTag(part,"ActivePart") then
		part.Touched:connect(function(hit)
			partTouched(part, hit)
		end)
	end
end

spawn(function()
	for i,child in pairs(workspace:GetDescendants()) do
		check(child)
	end
	workspace.DescendantAdded:connect(check)
end)

return module
