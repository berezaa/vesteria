local module = {}

local statusEffectClass = {}
	statusEffectClass.__index = statusEffectClass

local STATUS_EFFECT_TICK 		= 1 / 3
local STATUS_EFFECTS_LOCATION 	= game:GetService("ReplicatedStorage"):FindFirstChild("statusEffectsV3")

local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules = require(replicatedStorage.modules)
		local entityUtilities = modules.load("entityUtilities")
		local network = modules.load("network")
		local events = modules.load("events")

local activeStatusEffects = {}

local function __hookStatusEffect(statusEffect)
	if statusEffect.__event then
		-- statusEffect already hooked, don't hook again.
		warn("attempt to hook statusEffect twice")
		
		return
	end
	
	local pauseEvent 		= Instance.new("BindableEvent")
	statusEffect.__event 	= pauseEvent
	
	if not statusEffect.isActive then
		-- statusEffect is uninitialized, busywait until we start
		pauseEvent.Event:wait()
	end
	
	if statusEffect.__onStatusEffectBegan then
		statusEffect.__onStatusEffectBegan(statusEffect)
	end
	
	local t = STATUS_EFFECT_TICK
	
	while statusEffect.isActive and statusEffect.timeElapsed < statusEffect.data.duration do
		if statusEffect.isPaused then
			-- pause ticking and don't count time
			pauseEvent.Event:wait()
		else
			-- clamp t so that we can adjust for lag causing overspill on the duration
			t = math.clamp(t, 0, statusEffect.data.duration - statusEffect.timeElapsed)
			
			-- add time elapsed
			statusEffect.timeElapsed = statusEffect.timeElapsed + t
			
			if statusEffect.__onStatusEffectTick then
				statusEffect.__onStatusEffectTick(statusEffect, t)
			end
			
			-- wait next tick
			t = wait(STATUS_EFFECT_TICK)
		end	
	end
	
	statusEffect:stop()
end

function statusEffectClass:start()
	if self.isActive == nil then
		-- uninitialized status effect
		warn("statusEffect is uninitialized")
		
		return
	elseif self.isActive then
		-- status effect already started
		
		return
	end
	
	-- activate the status effect and signal the pause event to end, if it was 
	self.isActive = true
	self.isPaused = false
	self.__event:Fire()
end

function statusEffectClass:pause()
	self.isPaused = true
end

function statusEffectClass:stop()
	if self.__event then
		self.isActive 	= false
		self.__event 	= nil
		
		activeStatusEffects[self.guid] = nil
		
		self.__onStatusEffectEnded(self)
	end
end

-- note: THIS COMPLETELY DISABLES THE STATUSEFFECT, FREEZES IT COMPLETELY
-- it can only be re-enabled by calling module.deserializeStatusEffect on the
-- statusEffect object WITH AN ENTITY TO REACTIVATE IT TO
-- this is necessary for data saving
function statusEffectClass:serialize()
	self:stop()
	
	-- disconnect entity association
	self.entity = nil
	
	-- strip away statusEffect type inheritence (not needed for data saving)
	if script:FindFirstChild(self.type) then
		local f = require(script[self.type])
		
		for i, v in pairs(self) do
			if f[i] then
				self[i] = nil
			end
		end
	end
end

function module.getStatusEffectByGUID(guid)
	return activeStatusEffects[guid]
end

function module.getStatusEffectByLabel(label)
	for guid, statusEffect in pairs(activeStatusEffects) do
		if statusEffect.label == label then
			return statusEffect
		end
	end
	
	return nil
end

function module.createStatusEffect(targetEntity, sourceEntity, statusEffectId, statusEffectData, statusEffectLabel)
	if not targetEntity or not targetEntity:FindFirstChild("state") or targetEntity.state.Value == "dead" then return end
	if not STATUS_EFFECTS_LOCATION:FindFirstChild(statusEffectId) then return end
	local statusEffectBaseData = require(STATUS_EFFECTS_LOCATION[statusEffectId])
	
	local targetEntityGUID = entityUtilities.getEntityGUIDByEntityManifest(targetEntity)
	local sourceEntityGUID = sourceEntity and entityUtilities.getEntityGUIDByEntityManifest(sourceEntity)
	
	local existingStatusEffect = statusEffectLabel and module.getStatusEffectByLabel(statusEffectLabel)
	
	if existingStatusEffect then
		if statusEffectBaseData.doesStack then
			-- statusEffect exists, does stack -- increment stacks
			existingStatusEffect.stacks = existingStatusEffect.stacks + 1
		end
		
		-- reset duration regardless of if its stacking, it already exists and we're reapplying it
		existingStatusEffect.timeElapsed = 0
		
		return existingStatusEffect
	else
		local newStatusEffect = {}
			newStatusEffect.isActive 	= false
			newStatusEffect.id 			= statusEffectId
			newStatusEffect.timeElapsed = 0
			newStatusEffect.data 		= statusEffectData
			newStatusEffect.tempData 	= {}
			newStatusEffect.guid 		= httpService:GenerateGUID(false)
			newStatusEffect.label 		= statusEffectLabel
			newStatusEffect.stacks 		= 1
			
			-- entityGUIDs for the statusEffect to uh.. function
			newStatusEffect.targetEntityGUID = targetEntityGUID
			newStatusEffect.sourceEntityGUID = sourceEntityGUID
		
		-- inherit
		for i, v in pairs(statusEffectBaseData) do
			newStatusEffect[i] = v
		end
		
		setmetatable(newStatusEffect, statusEffectClass)
		
		-- initialize the statusEffect
		coroutine.wrap(function()
			__hookStatusEffect(newStatusEffect)
		end)()
		
		activeStatusEffects[newStatusEffect.guid] = newStatusEffect
		
		return newStatusEffect
	end
end

-- note: nothing is returned because the table that gets fed into this
-- function is assumed to be a valid statusEffect that had :serialize()
-- called on itself; this just reactivates the statusEffect
function module.deserializeStatusEffect(statusEffectSerialized, entity)
	if getmetatable(statusEffectSerialized) or statusEffectSerialized.isActive or statusEffectSerialized.__event then
		-- if any of these conditions are true, the status effect was not
		-- correctly serialized; we dont want to risk statusEffects
		-- ticking twice as much so we should ignore this.
		
		warn("attempt to deserialize an initiated statusEffect")
		
		return
	end
	
	-- replenish inheritence that was stripped during serialization
	if STATUS_EFFECTS_LOCATION:FindFirstChild(statusEffectSerialized.id) then
		local f = require(STATUS_EFFECTS_LOCATION[statusEffectSerialized.id])
		
		for i, v in pairs(f) do
			statusEffectSerialized[i] = v
		end
	end
	
	-- establish entity connection again
	statusEffectSerialized.entity = entity
	
	-- connect metatable again
	setmetatable(statusEffectSerialized, statusEffectClass)
	
	-- initialize the statusEffect hook
	coroutine.wrap(function()
		__hookStatusEffect(statusEffectSerialized)
	end)()
end

network:create("createStatusEffectV3", "BindableFunction", "OnInvoke", module.createStatusEffect)

events:registerForEvent("statusEffectStopped", function(statusEffect)
	activeStatusEffects[statusEffect.guid] = nil
end)

events:registerForEvent("entityManifestDied", function(entityManifest)
	local guid = entityUtilities.getEntityGUIDByEntityManifest(entityManifest)
	
	if guid then
		for i, v in pairs(activeStatusEffects) do
			if v.targetEntityGUID == guid then
				v:stop()
				
				activeStatusEffects[i] = nil
			end
		end
	end
end)

return module