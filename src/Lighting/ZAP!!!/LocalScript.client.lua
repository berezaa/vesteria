local function drawLine(startPos, finishPos)
	local mag = (finishPos - startPos).magnitude
	
	local line = Instance.new("Part")
	line.Anchored = true
	line.CanCollide = false
	line.TopSurface = Enum.SurfaceType.Smooth
	line.BottomSurface = Enum.SurfaceType.Smooth
	line.Material = Enum.Material.Neon
	line.BrickColor = BrickColor.new("Electric blue")
	
	line.Size = Vector3.new(0.1, 0.1, mag)
	line.CFrame = CFrame.new(startPos, finishPos) * CFrame.new(0, 0, -mag/2)
	
	--line.Parent = workspace.lightning
end

local function plotPoint(cf)
	local line = Instance.new("Part")
	line.Anchored = true
	line.CanCollide = false
	line.TopSurface = Enum.SurfaceType.Smooth
	line.BottomSurface = Enum.SurfaceType.Smooth
	line.FrontSurface = Enum.SurfaceType.Hinge
	
	line.Size = Vector3.new(0.4, 0.4, 0.4)
	line.CFrame = cf
	
	--line.Parent = workspace.lightning
end

local segmentLength = 2

local function fireLightning2(startPos, finishPos, doBranch)
	local mag = (finishPos-startPos).magnitude
	local maximumOffset = math.sqrt(mag)
	local numGenerations = 5
	
	local segments = {{startPos, finishPos}}
	for i = 1, numGenerations do
		local newSegmentsList = {}
		for ind, segment in pairs(segments) do
			local start 	= segment[1]
			local finish 	= segment[2]
			
			local r = 360 * math.random()
			local d = maximumOffset * math.random()
			
			local facing = CFrame.new(start, finish)
			local mag = (finish - start).magnitude
			
			local cf = facing * CFrame.new(0, 0, -mag * math.random(40, 60) / 100) * CFrame.Angles(0, 0, math.rad(r)) * CFrame.new(0, d * math.random(80, 120) / 100, 0)
			
			table.insert(newSegmentsList, {start, cf.p})
			table.insert(newSegmentsList, {cf.p, finish})
			
			if doBranch and ((math.random(1, 4)==2) or i == 1) then
				table.insert(newSegmentsList, {cf.p, cf.p + facing.lookVector * (mag / 2)})
			end
		end
		
		maximumOffset = maximumOffset / 2
		segments = newSegmentsList
	end
	
	for i, segment in pairs(segments) do
		drawLine(segment[1], segment[2])
		if i%10 ==0 then
			wait()
		end
	end
end

local function onEquipped(mouse)
	mouse.Button1Down:connect(function()
		--workspace.lightning:ClearAllChildren()
		fireLightning2(script.Parent.Handle.Position, mouse.Hit.p, true)
	end)
end

script.Parent.Equipped:connect(onEquipped)