-- Anim Viewer
-- Rocky28447
-- April 29, 2020



local anims = {}
local currentAnim

local function GetAnims()
	for _, animation in pairs (script.Parent.animations:GetChildren()) do
		anims[#anims + 1] = script.Parent.AnimationController:LoadAnimation(animation)
	end
end

local function playAnim(new, prev)
	if (prev) then anims[prev]:Stop() end
	anims[new]:Play()
	print(anims[new])
end

script.Cycle:GetPropertyChangedSignal("Value"):Connect(function()
	if (script.Cycle.Value) then
		script.Cycle.Value = false
		local new = math.max((currentAnim and currentAnim + 1 or 1) % #anims, 1)
		playAnim(new, currentAnim)
		currentAnim = new
	end
end)

script.Repeat:GetPropertyChangedSignal("Value"):Connect(function()
	if (script.Repeat.Value) then
		script.Repeat.Value = false
		playAnim(currentAnim)
	end
end)

GetAnims()