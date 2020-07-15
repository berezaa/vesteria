local attach0 = Instance.new("Attachment", game.Workspace.Terrain);
local attach1 = Instance.new("Attachment", game.Workspace.Terrain);

local beam = Instance.new("Beam", game.Workspace.Terrain);
beam.Attachment0 = attach0;
beam.Attachment1 = attach1;

-- credits to: EgoMoose
local function beamProjectile(g, v0, x0, t1)
	
	-- calculate the bezier points
	local c 	= 0.5*0.5*0.5
	local p3 	= 0.5*g*t1*t1 + v0*t1 + x0
	local p2 	= p3 - (g*t1*t1 + v0*t1)/3
	local p1 	= (c*g*t1*t1 + 0.5*v0*t1 + x0 - c*(x0+p3))/(3*c) - p2
	
	-- the curve sizes
	local curve0 = (p1 - x0).magnitude
	local curve1 = (p2 - p3).magnitude
	
	-- build the world CFrames for the attachments
	local b 	= (x0 - p3).unit
	local r1 	= (p1 - x0).unit
	local u1 	= r1:Cross(b).unit
	local r2 	= (p2 - p3).unit
	local u2 	= r2:Cross(b).unit
	b 			= u1:Cross(r1).unit
	
	local cf1 = CFrame.new(
		x0.x, x0.y, x0.z,
		r1.x, u1.x, b.x,
		r1.y, u1.y, b.y,
		r1.z, u1.z, b.z
	)
	
	local cf2 = CFrame.new(
		p3.x, p3.y, p3.z,
		r2.x, u2.x, b.x,
		r2.y, u2.y, b.y,
		r2.z, u2.z, b.z
	)
	
	return curve0, -curve1, cf1, cf2
end

local x0 	= Vector3.new(0, 50, 0)
local v0 	= Vector3.new(10, 25, 0)
local g  	= Vector3.new(0, -10, 0)
local t 	= 1

local p = Instance.new("Part", workspace)
p.Anchored = true
p.CFrame = CFrame.new(x0, x0+v0)
p.Size = Vector3.new(1, 1, 1)
p.FrontSurface = Enum.SurfaceType.Hinge

local curve0, curve1, cf1, cf2 = beamProjectile(g, v0, x0, t)

beam.CurveSize0 = curve0
beam.CurveSize1 = curve1

-- convert world space CFrames to be relative to the attachment parent
attach0.CFrame = attach0.Parent.CFrame:inverse() * cf1
attach1.CFrame = attach1.Parent.CFrame:inverse() * cf2