-- Written by @Quenty
-- Lights only turn on at night and when grounded (so when destroying this guy it won't derpaherp)

local Lighting = game:GetService("Lighting")

local function WaitForChild(Parent, Name, TimeLimit)
	-- Waits for a child to appear. Not efficient, but it shoudln't have to be. It helps with debugging. 
	-- Useful when ROBLOX lags out, and doesn't replicate quickly.
	-- @param TimeLimit If TimeLimit is given, then it will return after the timelimit, even if it hasn't found the child.

	assert(Parent ~= nil, "Parent is nil")
	assert(type(Name) == "string", "Name is not a string.")

	local Child     = Parent:FindFirstChild(Name)
	local StartTime = tick()
	local Warned    = false

	while not Child and Parent do
		wait(0)
		Child = Parent:FindFirstChild(Name)
		if not Warned and StartTime + (TimeLimit or 5) <= tick() then
			Warned = true
			warn("Infinite yield possible for WaitForChild(" .. Parent:GetFullName() .. ", " .. Name .. ")")
			if TimeLimit then
				return Parent:FindFirstChild(Name)
			end
		end
	end

	if not Parent then
		warn("Parent became nil.")
	end

	return Child
end


local function CallOnChildren(Instance, FunctionToCall)
	-- Calls a function on each of the children of a certain object, using recursion.  

	FunctionToCall(Instance)

	for _, Child in next, Instance:GetChildren() do
		CallOnChildren(Child, FunctionToCall)
	end
end

local function Modify(Instance, Values)
	-- Modifies an Instance by using a table.  

	assert(type(Values) == "table", "Values is not a table");

	for Index, Value in next, Values do
		if type(Index) == "number" then
			Value.Parent = Instance
		else
			Instance[Index] = Value
		end
	end
	return Instance
end

local function Make(ClassType, Properties)
	-- Using a syntax hack to create a nice way to Make new items.  

	return Modify(Instance.new(ClassType), Properties)
end

local Model = script.Parent

local EasyConfiguration = require(WaitForChild(script, "EasyConfiguration"))

local ConfigurationModel    = EasyConfiguration.AddSubDataLayer("Configuration", Model)
local Configuration         = EasyConfiguration.MakeEasyConfiguration(ConfigurationModel)

Configuration.AddValue("BoolValue", {
	Name = "LightsEnabled";
	Value = true;
})

Configuration.AddValue("BoolValue", {
	Name = "LightShadows";
	Value = true;
})

Configuration.AddValue("IntValue", {
	Name = "LightRange";
	Value = 60;
})

Configuration.AddValue("Color3Value", {
	Name = "LightColor";
	Value = Color3.new(1, 237/255, 183/255);
})

Configuration.AddValue("IntValue", {
	Name = "LightAngle";
	Value = 120;
})

Configuration.AddValue("IntValue", {
	Name = "LightBrightness";
	Value = 1;
})


local function AttachedToBase(Part)
	--[[if Part:IsDescendantOf(Model) then
		local Attached = Part:GetConnectedParts()
		if #Attached >= 2 then
			return true
		else
			return false
		end
	end--]]
	
	return Part:IsGrounded()
end

local LightPartList = {}
local Connections = {}
local LightStatus = {}

local function RemovePartFromList(Part)
	if Connections[Part] then
		Connections[Part]:disconnect()
		Connections[Part] = nil
	end
	
	LightStatus[Part] = nil
	LightPartList[Part] = nil
end

local function FlickerLightOff(Part, Light, Time)
	spawn(function()
		local StartTime = tick()
		
		while LightStatus[Part] == nil and StartTime + Time >= tick() do
			Light.Enabled = math.random(1,2) == 1
			wait(0.1)
		end
		
		Light.Enabled = false
	end)
end

local function FadeLightOff(Part, Light, Time)
	spawn(function()
		local StartTime = tick()
		Light.Enabled = true

		while LightStatus[Part] == nil and StartTime + Time >= tick() do
			
			local TimeElapsed = tick() - StartTime
			local Percent = TimeElapsed/Time
						
			Light.Brightness = Configuration.LightBrightness*(1-Percent)
			wait(0.05)
		end
		
		Light.Brightness = 0
		Light.Enabled = false
	end)
end

local function FadeLightOn(Part, Light, Time)
	spawn(function()
		local StartTime = tick()
		Light.Enabled = true

		while LightStatus[Part] == true and StartTime + Time >= tick() do
			
			local TimeElapsed = tick() - StartTime
			local Percent = TimeElapsed/Time
			
			Light.Brightness = Configuration.LightBrightness*(Percent)
			wait(0.05)
		end
		
		Light.Brightness = Configuration.LightBrightness
		Light.Enabled = true
	end)
end

local function ToggleLightStatus(Part, Light)
	Modify(Light, {
		Brightness = Configuration.LightBrightness;
		Face       = "Bottom";
		Name       = "qSpotLight";
		Angle      = Configuration.LightAngle;
		Range      = Configuration.LightRange;
		Shadows    = Configuration.LightShadows;
		Color      = Configuration.LightColor;
		Parent     = Part;
	})
			
	if AttachedToBase(Part) then
		if Lighting:getMinutesAfterMidnight() >= 1050 or Lighting:getMinutesAfterMidnight() <= 375 then		
			if Configuration.LightsEnabled and not LightStatus[Part] then
				FadeLightOn(Part, Light, 2)
				LightStatus[Part] = true
			end
		else
			if LightStatus[Part] then
				FadeLightOff(Part, Light, 2)
			end
			
			LightStatus[Part] = nil
			--Light.Enabled = false
		end
	else
		--Light.Enabled = false
		
		if LightStatus[Part] then
			FlickerLightOff(Part, Light, 1)
		end
		LightStatus[Part] = nil
		
		if not Part:IsDescendantOf(Model) then
			RemovePartFromList(Part)
		end
	end
end

CallOnChildren(Model, function(Part)
	if Part:IsA("BasePart") and Part.Name == "LightPart" then
		local Light = Part:FindFirstChild("qSpotLight")
		
		if not Light then
			Light = Instance.new("SpotLight")
			Light.Enabled = false
			Light.Brightness = 0
		end
		
		LightPartList[Part] = Light
		
		Connections[Part] = Part.Touched:connect(function()
			ToggleLightStatus(Part, Light)
		end)
		
		ToggleLightStatus(Part, Light)
	end
end)

local function ProcessList()
	for Part, Light in pairs(LightPartList) do
		ToggleLightStatus(Part, Light)
	end
end

Lighting.Changed:connect(function()
	ProcessList()
end)

local AcceptableTypes = {
	["StringValue"]         = true;
	["IntValue"]            = true;
	["NumberValue"]         = true;
	["BrickColorValue"]     = true;
	["BoolValue"]           = true;
	["Color3Value"]         = true;
	["Vector3Value"]        = true;
	["IntConstrainedValue"] = true;
}

for _, Item in pairs(ConfigurationModel:GetChildren()) do
	if AcceptableTypes[Item.ClassName] then
		Item.Changed:connect(function()
			ProcessList()
		end)
	end
end
-- Written by @Quenty