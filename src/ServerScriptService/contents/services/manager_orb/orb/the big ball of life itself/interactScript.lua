-- magical magical floating ball of love :D
-- by bereza the second

local module = {}
module.isActive = false
--module.interactPrompt = "CALL OUT TO THE ORB"
module.interactPrompt = "Call out to the orb"
module.instant = false


local colorCorrection
local pulse
local pulse2
local blur

function module.init(Modules)
	Modules.enchant.open(script.Parent)
	
	if pulse then
		pulse:Destroy()
	end
	
	script.Parent.sound:Play()
	
	pulse = script.Parent.Parent.pulseBoy:Clone()
	pulse.Name = "pulseCopy"
	pulse.Parent = script.Parent
	pulse.Transparency = 1

	Modules.tween(pulse.Mesh, {"Scale"}, {Vector3.new(65, 65, 65)}, 0.7)
	Modules.tween(pulse, {"Transparency"}, {0.5}, 1)
	
	if pulse2 then
		pulse2:Destroy()
	end
	pulse2 = script.Parent.Parent.pulseBoyInvert:Clone()
	pulse.Name = "pulseCopy"
	pulse2.Parent = script.Parent
	pulse2.Transparency = 1
	
	Modules.tween(pulse2.Mesh, {"Scale"}, {Vector3.new(-60, -60, -60)}, 1)
	Modules.tween(pulse2, {"Transparency"}, {0.5}, 1)	


	script.Parent.spread:Emit(300)
	script.Parent.steady.Enabled = true

	
	if colorCorrection then
		colorCorrection:Destroy()
	end
	colorCorrection = script.Parent.ColorCorrection:Clone()
	local endColor = colorCorrection.TintColor
	colorCorrection.TintColor = Color3.new(1,1,1)
	colorCorrection.Parent = game.Lighting
	Modules.tween(colorCorrection, {"TintColor"}, {endColor}, 0.7)
	
	if blur then
		blur:Destroy()
	end
	blur = script.Parent.Blur:Clone()
	local endBlur = blur.Size
	blur.Size = 0
	blur.Parent = game.Lighting
	Modules.tween(blur, {"Size"}, {endBlur}, 0.7)
end

function module.close(Modules)
	
	script.Parent.steady.Enabled = false
	
	game.Debris:AddItem(colorCorrection, 0.5)
	game.Debris:AddItem(pulse, 0.5)
	game.Debris:AddItem(pulse2, 0.5)
	game.Debris:AddItem(blur, 0.5)
	if pulse then
		Modules.tween(pulse, {"Transparency"}, {1}, 0.5)
	end
	if pulse2 then
		Modules.tween(pulse2, {"Transparency"}, {1}, 0.5)
	end
	if colorCorrection then
		Modules.tween(colorCorrection, {"TintColor"}, {Color3.new(1,1,1)}, 0.5)
	end
	if blur then
		Modules.tween(blur, {"Size"}, {0}, 0.5)
	end
	Modules.enchant.close()
	
end

return module