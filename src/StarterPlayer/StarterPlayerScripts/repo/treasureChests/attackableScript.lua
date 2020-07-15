local modules = require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))
local network = modules.load("network")
local tween = modules.load("tween")
local effects = modules.load("effects")
local utilities = modules.load("utilities")

local model = script.Parent.Parent
local chestRootModel = model.Parent
local originalCFrame = model:GetPrimaryPartCFrame()

local attackable = {}

local health = 5
local isOpen = false

local heartbeatConnection = nil
local activeTween = nil

local animControl = script.Parent.Parent:FindFirstChild("AnimationController")
local glow = script.Parent.Parent:FindFirstChild("Glow")

local loop = animControl:LoadAnimation(script.Parent.Parent.chestOpenLoop)
local openAnim = animControl:LoadAnimation(script.Parent.Parent.chestOpen)

openAnim.Looped = false
openAnim.Priority = Enum.AnimationPriority.Action

loop.Looped = true
loop.Priority = Enum.AnimationPriority.Core

local function openChest()
	local rewards, status = network:invoke("openTreasureChest_client", chestRootModel)
	if rewards then
		isOpen = true
	elseif status then
		network:fire("alert", {text = status}, 1)
	end
end

local function doHealthReduction()
	health = math.max(health - 1, 0)
	
	if health <= 0 and not isOpen then
		openChest()
	end
end

local function doShake()
	local primaryPart = model.PrimaryPart
	local rootCFrame =	originalCFrame * CFrame.new(0, -primaryPart.Size.Y/2, 0) * CFrame.Angles(0, math.pi * 2 * math.random(), 0)
	local offset = rootCFrame:ToObjectSpace(originalCFrame)
	
	local dummyPart = Instance.new("Part")
	dummyPart.CFrame = rootCFrame
	
	local easeInTime = 0.2
	local easeOutTime = 1
	
	if heartbeatConnection then
		heartbeatConnection:Disconnect()
		heartbeatConnection = nil
	end
	
	if activeTween then activeTween:Pause() activeTween:Destroy() activeTween = nil end
	
	activeTween = tween(dummyPart, {"CFrame"}, rootCFrame * CFrame.Angles(0, 0, 0.2), easeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	activeTween.Completed:connect(function()
		activeTween = tween(dummyPart, {"CFrame"}, rootCFrame, easeOutTime, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)
		activeTween.Completed:connect(function()
			activeTween = nil
			dummyPart:Destroy()
			if heartbeatConnection then
				heartbeatConnection:Disconnect()
				heartbeatConnection = nil
			end
		end)
	end)
	
	heartbeatConnection = effects.onHeartbeatFor(easeInTime + easeOutTime, function()
		model:SetPrimaryPartCFrame(dummyPart.CFrame:ToWorldSpace(offset))
	end)
end

function attackable.onAttackedClient()
	doShake()
	doHealthReduction()
end

function attackable.onAttackedServer(player)

end

return attackable