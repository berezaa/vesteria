-- Client Script

local Modules = {}

for _, moduleScript in pairs(script:GetChildren()) do
	Modules[moduleScript.Name] = require(moduleScript)
end

for _, module in pairs(Modules) do
	if module.init then
		module.init(Modules)
	end
end