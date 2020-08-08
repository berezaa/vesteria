local debris = game:GetService("Debris")

local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
local effects = modules.load("effects")
local placeSetup = modules.load("placeSetup")
local tween = modules.load("tween")
local utilities = modules.load("utilities")
local projectile = modules.load("projectile")

local entitiesFolder = placeSetup.awaitPlaceFolder("entities")

local function createEffectPart()
	local part = Instance.new("Part")
	part.Anchored = true
	part.CanCollide = false
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	part.CastShadow = false
	return part
end

local function lerp(a, b, w)
	return a + (b - a) * w
end

local effectFunctions
effectFunctions = {
	acidSplash = function(args)
		local part = script.acidSplash:Clone()
		part.Position = args.position
		part.Parent = entitiesFolder
		
		tween(part, {"Size", "Transparency"}, {Vector3.new(2, 2, 2) * args.radius, 1}, args.duration)
		
		delay(args.duration, function()
			part.emitter.Enabled = false
			debris:AddItem(part, part.emitter.Lifetime.Max)
		end)
	end,
	
	bloodHeal = function(args)
		local playerManifest = args.playerManifest
		local target = args.target
		
		if not playerManifest then return end
		if not target then return end
		
		local renderContainer = network:invoke("getPlayerRenderFromManifest", playerManifest)
		if not renderContainer then return end
		local entity = renderContainer:FindFirstChild("entity")
		if not entity then return end
		local root = renderContainer.PrimaryPart
		if not root then return end
		local upperTorso = entity:FindFirstChild("UpperTorso")
		if not upperTorso then return end
		
		local function createEffectPart()
			local part = Instance.new("Part")
			part.Anchored = true
			part.CanCollide = false
			part.TopSurface = Enum.SurfaceType.Smooth
			part.BottomSurface = Enum.SurfaceType.Smooth
			return part
		end
		
		local function bloodEffect(partA, partB, spin)
			local duration = 1
			local bezierStretch = 16
			
			local blood = script.blood:Clone()
			local trail = blood.trail
			blood.CFrame = partA.CFrame
			blood.Parent = workspace.CurrentCamera
			
			local offsetB = CFrame.Angles(0, 0, spin) * CFrame.new(0, bezierStretch, 0)
			local offsetC = CFrame.Angles(0, 0, -spin) * CFrame.new(0, bezierStretch, 0)
			
			effects.onHeartbeatFor(duration, function(dt, t, w)
				local startToFinish = CFrame.new(partA.Position, partB.Position)
				local finishToStart = CFrame.new(partB.Position, partA.Position)
				
				local a = startToFinish.Position
				local b = (startToFinish * offsetB).Position
				local c = (finishToStart * offsetC).Position
				local d = finishToStart.Position
			
				local ab = a + (b - a) * w
				local cd = c + (d - c) * w
				local p = ab + (cd - ab) * w
				
				blood.CFrame = CFrame.new(p)
			end)
			
			delay(duration, function()
				blood.Transparency = 1
				trail.Enabled = false
				game:GetService("Debris"):AddItem(blood, trail.Lifetime)
			end)
		end
		
		local function lifeStealEffect(target)
			for blood = 1, 3 do
				local spin = (blood - 2) * (math.pi / 3)
				bloodEffect(target, upperTorso, spin)
			end
			
			delay(1, function()
				-- restore sound
				local restoreSound = script.restore:Clone()
				restoreSound.Parent = root
				restoreSound:Play()
				debris:AddItem(restoreSound, restoreSound.TimeLength)
				
				-- blood poof
				local duration = 1
				
				local sphere = createEffectPart()
				sphere.Shape = Enum.PartType.Ball
				sphere.Color = script.blood.Color
				sphere.Material = Enum.Material.Neon
				sphere.Size = Vector3.new()
				sphere.CFrame = CFrame.new(upperTorso.Position)
				sphere.Parent = entitiesFolder
				
				tween(sphere, {"Size", "Transparency"}, {Vector3.new(8, 8, 8), 1}, duration)
				effects.onHeartbeatFor(duration, function()
					sphere.CFrame = CFrame.new(upperTorso.Position)
				end)
				debris:AddItem(sphere, duration)
			end)
		end
		
		lifeStealEffect(target)
	end,
	
	lightning = function(args)
		local startCFrame = args.startCFrame
		local pointCount = args.pointCount or 14
		local segmentDeltaY = args.segmentDeltaY or 4
		local maxStutter = args.maxStutter or 4
		local duration = args.duration or 0.5
		local color = args.color or BrickColor.new("Electric blue").Color
		
		local function lightningSegment(a, b)
			local duration = 0.5
			
			local part = createEffectPart()
			part.Color = color
			part.Material = Enum.Material.Neon
			
			local distance = (b - a).magnitude
			local midpoint = (a + b) / 2
			
			part.Size = Vector3.new(0.25, 0.25, distance)
			part.CFrame = CFrame.new(midpoint, b)
			part.Parent = entitiesFolder
			
			tween(
				part,
				{"Transparency"},
				1,
				duration
			)
			debris:AddItem(part, duration)
		end
		
		-- create a column of points above the spot
		-- and move them randomly around a circle
		-- to create a jagged line like lightning
		-- don't bother storing the points, we don't
		-- need to do that, we only need the previous
		local cframe = startCFrame
		
		-- start at 2 because the target point is a point, too
		for pointNumber = 2, pointCount do
			local theta = math.pi * 2 * math.random()
			local dx = math.cos(theta) * maxStutter * math.random()
			local dy = (pointNumber - 1) * segmentDeltaY
			local dz = math.sin(theta) * maxStutter * math.random()
			
			local nextCFrame = cframe * CFrame.new(dx, dy, dz)
			
			lightningSegment(cframe.Position, nextCFrame.Position)
			cframe = nextCFrame
		end
	end,
	
	orbArrival = function(args)
		effectFunctions.orbAnnouncement()
		
		local rand = Random.new(1231996)
		
		local orb = args.orb
		local position = orb.PrimaryPart.Position
		
		local orbParent = orb.Parent
		orb.Parent = nil
		
		local effect = script.orbArrival:Clone()
		effect.Position = position
		effect.Parent = entitiesFolder
		
		effect.loop:Play()
		
		-- repeated, accelerating lightning strikes
		local maxPause = 1
		local minPause = 0.05
		local strikeCount = 32
		for strikeNumber = 1, strikeCount do
			for _ = 1, rand:NextInteger(1, 2) do
				local cframe = CFrame.new(position) * CFrame.Angles(0, math.pi * 2 * rand:NextNumber(), 0) * CFrame.Angles(math.pi * 0.125 * rand:NextNumber(), 0, 0)
				effectFunctions.lightning{startCFrame = cframe}
			end
			
			effect["strike"..rand:NextInteger(1, 6)]:Play()
			
			local pause = lerp(maxPause, minPause, (strikeNumber - 1) / strikeCount)
			wait((pause * 0.5) + (pause * 0.5 * rand:NextNumber()))
		end
		
		-- expand the circle in an explosion
		local fadeDuration = 4
		effect.emitter.Enabled = false
		effect.BrickColor = BrickColor.new("Electric blue")
		effect.explosion:Play()
		wait(1)
		tween(effect, {"Size"}, {Vector3.new(1, 1, 1) * 128}, fadeDuration / 4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		tween(effect, {"Transparency"}, {1}, fadeDuration, Enum.EasingStyle.Linear)
		effect.loop:Stop()
		debris:AddItem(effect, fadeDuration)
		
		-- make burning cracks on the ground
		local raycastIgnoreList = projectile.makeIgnoreList{
			placeSetup.awaitPlaceFolder("entityManifestCollection"),
			placeSetup.awaitPlaceFolder("entityRenderCollection")
		}
		
		local function crack(cframe, stepLength, stepCount, sign)
			if sign == nil then sign = 1 end
			
			local here = cframe.Position
			local wiggle = math.pi * 0.4
			local castDelta = Vector3.new(0, 6, 0)
			
			for stepNumber = 2, stepCount do
				local there = here + cframe.LookVector * stepLength
				local ray = Ray.new(there + castDelta, -castDelta * 2)
				local part, point = workspace:FindPartOnRayWithIgnoreList(ray, raycastIgnoreList)
				there = point
				
				local segment = createEffectPart()
				segment.Material = Enum.Material.Neon
				segment.BrickColor = BrickColor.new("Electric blue")
				segment.CFrame = CFrame.new((here + there) / 2, there)
				segment.Size = Vector3.new(0.2, 0.2, (there - here).Magnitude)
				
				local emitter = script.orbEmitter:Clone()
				emitter.Parent = segment
				
				segment.Parent = entitiesFolder
				
				spawn(function()
					for i=5,0,-1 do
						emitter.Rate = math.random(0, i*2)
						wait(2)
					end
					local segmentFadeDuration = 5
					tween(segment, {"Transparency"}, {1}, segmentFadeDuration)
					debris:AddItem(segment, segmentFadeDuration)					
				end)
				
				if (stepNumber + 1) % 2 == 0 then
					crack(cframe, stepLength, stepCount - stepNumber, sign)
				end
				
				here = there
				sign = -sign
				cframe = cframe * CFrame.Angles(0, wiggle * rand:NextNumber() * sign, 0)
				cframe = cframe + (here - cframe.Position)
			end
		end
		
		local crackStartPosition do
			local ray = Ray.new(position, Vector3.new(0, -8, 0))
			local part, point = workspace:FindPartOnRayWithIgnoreList(ray, raycastIgnoreList)
			crackStartPosition = point
		end
		
		local startTheta = math.pi * 2 * rand:NextNumber()
		local crackCount = 7
		local deltaTheta = math.pi * 2 / crackCount
		for crackNumber = 1, crackCount do
			local theta = startTheta + deltaTheta * crackNumber
			crack(CFrame.new(crackStartPosition) * CFrame.Angles(0, theta, 0), 2, 8)
		end
		
		orb.Parent = orbParent
		orb.PrimaryPart.loop:Play()
	end,
	
	orbAnnouncement = function()
		--[[
		local adjectives = {
			"a mystic",
			"an electrifying",
			"an arcane",
			"a powerful",
			"an evocative",
			"an ancient",
			"an overwhelming",
			"a great",
		}
		local adjective = adjectives[math.random(1, #adjectives)]
		]]
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "You feel a mystic presence echo through the night..."--[[..adjective.." presence echo through the night..."]],
			Color = BrickColor.new("Electric blue").Color,
			Font = Enum.Font.SourceSansBold,
		})
	end,
	
	orbDeparture = function(args)
		local orb = args.orb
		local cframe = orb:GetPrimaryPartCFrame()
		
		local dy = 0
		local vy = 0
		local ay = 0
		local aya = 16
		
		effects.onHeartbeatFor(5, function(dt, t, w)
			ay = ay + aya * dt
			vy = vy + ay * dt
			dy = dy + vy * dt
			orb:SetPrimaryPartCFrame(cframe + Vector3.new(0, dy, 0))
		end)
	end,
}

network:connect("effects_requestEffect", "OnClientEvent", function(effectName, args)
	effectFunctions[effectName](args)
end)