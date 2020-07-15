-- Fluid day and night script
-- berezaa 6/26/18

DAY_TIME_SECONDS = 1200

if game.PlaceId == 4561988219 or game.PlaceId == 4041427413 then
	DAY_TIME_SECONDS = 600
end

local module = {}

local dynamicParts = {}

-- Run the clock and handle dynamic map elements on the server.
-- Set Lighting.ClockTime on the client. Tween using the server
-- time only as a reference. 

local Rand = Random.new(os.time())

for i,v in pairs(workspace:GetDescendants()) do
	if v.Name == "WindowPart" or (v.Name == "Light" and v.Parent.Name == "Lantern") then
		table.insert(dynamicParts,{Part = v, Num = Rand:NextNumber()})
	end
end

-- Sunrise: 5.0 - 6.5
-- Sunset: 17.6 - 18.6

local RunService = game:GetService("RunService")
--[[
game.ReplicatedStorage.timeOfDay.Value = 10
game.Lighting.ClockTime = 10
game.Lighting.ShadowSoftness = 0.2
]]


local ClockTime = game.Lighting.ClockTime
game.ReplicatedStorage.timeOfDay.Value = ClockTime

		if game.ReplicatedStorage:FindFirstChild("lightingSettings") and game.ReplicatedStorage.lightingSettings:FindFirstChild("timeLock") then
			game.ReplicatedStorage.timeOfDay.Value = game.ReplicatedStorage.lightingSettings.timeLock.Value
			game.Lighting.ClockTime = game.ReplicatedStorage.timeOfDay.Value
		end

-- Start at sunset

local function on(Part)
	if Part.Name == "WindowPart" then
		Part.Material = Enum.Material.Neon
		Part.Color = Part:FindFirstChild("WindowColor") and Part.WindowColor.Value or Color3.fromRGB(141, 140, 108)
		local Light = Part:FindFirstChild("WindowLight")
		if Light == nil then
			Light = Instance.new("PointLight")
			Light.Name = "WindowLight"
			Light.Range = 10
			Light.Parent = Part
		end
		Light.Enabled = true
	elseif Part.Name == "Light" and Part.Parent and Part.Parent.Name == "Lantern" then
		Part.Color = Color3.fromRGB(248,217,109)
		Part.Material = Enum.Material.Neon
		local Light = Part:FindFirstChild("LanternLight")
		Part.Transparency = 0.2
		if Light then
			Light.Enabled = true
			Light.Range = 25
			Light.Brightness = 1
		end

	end	
end

local function off(Part)
	if Part.Name == "WindowPart" then
		Part.Material = Enum.Material.Plastic
		Part.Color = Color3.fromRGB(27,42,53)	
		local Light = Part:FindFirstChild("WindowLight")
		if Light then
			Light.Enabled = false
		end
	elseif Part.Name == "Light" and Part.Parent and Part.Parent.Name == "Lantern" then
		Part.Color= Color3.fromRGB(180, 210, 228)
		Part.Material = Enum.Material.Glass
		Part.Transparency = 0.4
		local Light = Part:FindFirstChild("LanternLight")
		if Light then
			Light.Enabled = false
		end
	end	
end

local initiated = false

local function mergeColors(dayColor, nightColor, Brightness)
	local dr, dg, db = Color3.toHSV(dayColor)
	local nr, ng, nb = Color3.toHSV(nightColor)
	
	return Color3.fromHSV(nr + (dr - nr) * Brightness, ng + (dg - ng) * Brightness, nb + (db - nb) * Brightness)	
end



if game.Lighting:FindFirstChild("SunRays") == nil then
	script.SunRays:Clone().Parent = game.Lighting
end
if game.Lighting:FindFirstChild("DepthOfField") == nil then
	script.DepthOfField:Clone().Parent = game.Lighting
end
if game.Lighting:FindFirstChild("Sky") == nil then
	script.Sky:Clone().Parent = game.Lighting
end
if game.Lighting:FindFirstChild("Atmosphere") == nil then
	script.Atmosphere:Clone().Parent = game.Lighting
end


game.Lighting.EnvironmentDiffuseScale = 0.8
game.Lighting.EnvironmentSpecularScale = 0.1

local function getVesterianDay()
	return os.time() / DAY_TIME_SECONDS
end

local vesterianDayTag = Instance.new("NumberValue")
vesterianDayTag.Name = "vesterianDay"
vesterianDayTag.Value = getVesterianDay()
vesterianDayTag.Parent = game.ReplicatedStorage

spawn(function()
--	if game.PlaceId == 2061558182 then return end
	
	while wait(1/5) do
		
		local vesterianDay = getVesterianDay()
		vesterianDayTag.Value = vesterianDay
		local vesterianDayProgress = vesterianDay - math.floor(vesterianDay)
		
		ClockTime = vesterianDayProgress * 24
		
		if game.ReplicatedStorage:FindFirstChild("lightingSettings") and game.ReplicatedStorage.lightingSettings:FindFirstChild("timeLock") then
			ClockTime = game.ReplicatedStorage.lightingSettings.timeLock.Value
		end
		
		game.ReplicatedStorage.timeOfDay.Value = ClockTime
		
				
		
--		game.Lighting.ClockTime = ClockTime
		
		local Brightness = 0	
		-- Night	
		if ClockTime < 5.0 or ClockTime > 18.5 then
			
			
			if not initiated then
				initiated = true
				for i,Object in pairs(dynamicParts) do
					local Part = Object.Part
					if Part.Name == "Light" and Part.Parent.Name == "Lantern" then
						on(Part)
					elseif Part.Name == "WindowPart" then
						off(Part)
					end
				end
			end			
			
			Brightness = 0		
			-- Turn off the window lights throughout the night.
			if ClockTime >= 22 and ClockTime <= 24 then
				local Progress = (ClockTime - 22) / 2
				for i,Object in pairs(dynamicParts) do
					local Part = Object.Part
					if Part and Progress >= Object.Num then				
						if Part.Name == "WindowPart" then
							off(Part)
						end
					end
				end
			end			
		-- Sunrise
		elseif ClockTime >= 5.0 and ClockTime <= 6.5 then
			local Progress = (ClockTime - 5.0) / 1.5
			Brightness = Progress
			for i,Object in pairs(dynamicParts) do
				local Part = Object.Part
				if Part and Progress >= Object.Num then
					-- Turn off everything in the morning 
					off(Part)
				end
			end
		-- Sunset
		elseif ClockTime >= 17.5 and ClockTime <= 18.5 then
			local Progress = (ClockTime - 17.5)
			Brightness = 1 - Progress
			for i,Object in pairs(dynamicParts) do
				local Part = Object.Part
				if Part and Progress >= Object.Num then
					-- Turn on lanterns and windows at sunset
					on(Part)
				end
			end
		-- Day		
		else
			Brightness = 1
			
			if not initiated then
				initiated = true
				for i,Object in pairs(dynamicParts) do
					local Part = Object.Part
					if Part.Name == "Light" and Part.Parent.Name == "Lantern" then
						off(Part)
					elseif Part.Name == "WindowPart" then
						off(Part)
					end
				end
			end					
			
		end
		
		
		game.Lighting.Brightness = 1
		
		
		local fogEndMulti = 0.47
		if game.ReplicatedStorage:FindFirstChild("fogEndMulti") then
			fogEndMulti = game.ReplicatedStorage.fogEndMulti.Value
		end

		local light = game.ReplicatedStorage:FindFirstChild("lightingSettings")

		local dayAmbient = light and light:FindFirstChild("dayAmbient") and light.dayAmbient.Value or (Color3.fromRGB(100, 100, 100))
		local nightAmbient = light and light:FindFirstChild("nightAmbient") and light.nightAmbient.Value or Color3.fromRGB(50, 50, 100)
		
		
--		local dayOutdoorAmbient = light and light:FindFirstChild("dayOutdoorAmbient") and light.dayOutdoorAmbient.Value or Color3.fromRGB(140, 140, 140)	
--		local nightOutdoorAmbient = light and light:FindFirstChild("nightOutdoorAmbient") and light.nightOutdoorAmbient.Value or Color3.fromRGB(110, 110, 120)
--		game.Lighting.OutdoorAmbient = mergeColors(dayOutdoorAmbient, nightOutdoorAmbient, Brightness)		
		game.Lighting.OutdoorAmbient = Color3.new(0,0,0)
		--[[
		game.Lighting.Ambient = mergeColors(dayAmbient, nightAmbient, Brightness)
		local dayFogColor = light and light:FindFirstChild("dayFogColor") and light.dayFogColor.Value or Color3.fromRGB(151, 213, 214)	
		local nightFogColor = light and light:FindFirstChild("nightFogColor") and light.nightFogColor.Value or Color3.fromRGB(0, 66, 120)
		game.Lighting.FogColor = mergeColors(dayFogColor, nightFogColor, Brightness)
		
		game.Lighting.Atmosphere.Density = 0.438 - 0.164 * Brightness
		game.Lighting.Atmosphere.Color = mergeColors(dayFogColor, nightFogColor, Brightness)
		game.Lighting.Atmosphere.Haze = 2.15 - 2.15 * Brightness
		game.Lighting.Atmosphere.Glare = 10 * Brightness
		
		game.Lighting.ExposureCompensation = Brightness
		
		game.Lighting.FogEnd = (500 + 2500 * Brightness) * fogEndMulti
		]]
--		game.Lighting.Ambient = Color3.fromRGB(50 + 50 * Brightness, 50 + 50 * Brightness, 50 + 50 * Brightness)	
--		game.Lighting.OutdoorAmbient = Color3.fromRGB(90 + 50 * Brightness, 90 + 50 * Brightness, 90 + 50 * Brightness)	
	end
end)


-- some time of day perks are handled here
local modules = require(game.ReplicatedStorage.modules)
local network = modules.load("network")

local perkLookup = require(game.ReplicatedStorage.perkLookup)

local function updateTimeOfDayPerksForPlayer(player, dt)
	local playerData = network:invoke("getPlayerData", player)
	if not playerData then return end
	
	local perks = playerData.nonSerializeData.statistics_final.activePerks
	for perkName, active in pairs(perks) do
		if active then
			local perkData = perkLookup[perkName]
			if perkData.onTimeOfDayUpdated then
				perkData.onTimeOfDayUpdated(player, game.Lighting.ClockTime, dt)
			end
		end
	end
end

local function update(dt)
	for _, player in pairs(game:GetService("Players"):GetPlayers()) do
		updateTimeOfDayPerksForPlayer(player, dt)
	end
end

local function startUpdating()
	while true do
		update(wait(1))
	end
end

spawn(startUpdating)



return module
