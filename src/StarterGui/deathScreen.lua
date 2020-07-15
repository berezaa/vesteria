local module = {}


function module.show()
	
end

local COUNTDOWN_TIME = 60

function module.init(Modules)
	
	local network = Modules.network
	local tween = Modules.tween
	local focus = Modules.focus
	local utilities = Modules.utilities
	local money = Modules.money
	local levels = Modules.levels
	
	if game.Lighting:FindFirstChild("deathEffect") then
		game.Lighting.deathEffect:Destroy()
	end
	if game.Lighting:FindFirstChild("deathBlur") then
		game.Lighting.deathBlur:Destroy()
	end	
	
	local function updateLabel()
		local gold = network:invoke("getCacheValueByNameTag", "gold")
		local exp = network:invoke("getCacheValueByNameTag", "exp")		
		local level = network:invoke("getCacheValueByNameTag", "level")
		local expForNextLevel = levels.getEXPToNextLevel(level)
		local expLost = math.min(exp, expForNextLevel*0.2)
		script.Parent.curve.exp.Text = "-" .. utilities.formatNumber(expLost) .. " XP"
		money.setLabelAmount(script.Parent.curve.cost, -gold*0.1)
	end
	
	spawn(function()
		updateLabel()
	end)
	
	local pendingDeath = false
	network:invoke("ambienceSetIsDead", false)
	
	function module.accept()
		if pendingDeath then
			network:fireServer("deathGuiAccepted")
			pendingDeath = false
		end
	end	
	
	function module.show()
		
		pendingDeath = true
		
		focus.close()
		
		local color = Instance.new("ColorCorrectionEffect")
		color.Saturation = 0
		color.Name = "deathEffect"
		color.Parent = game.Lighting
		tween(color, {"Saturation", "Contrast"}, {-1, 0.1}, 0.1)
		
		local blur = Instance.new("BlurEffect")
		blur.Size = 0
		blur.Enabled = true
		blur.Name = "deathBlur"
		blur.Parent = game.Lighting
		tween(blur, {"Size"}, 10, 4)
		
		network:invoke("ambienceSetIsDead", true)
		delay(4, function()
			if script.Parent and script:FindFirstChild("chorus") then
				script.chorus:Play()
			end
			script.Parent.gradient.ImageTransparency = 1
			script.Parent.gradient.BackgroundTransparency = 1
			tween(script.Parent.gradient, {"ImageTransparency"}, 0, 1)
--			tween(script.Parent.gradient, {"BackgroundTransparency"}, 0.4, 2)	
			script.Parent.Visible = true
			--[[
			for i=COUNTDOWN_TIME,0,-1 do
				script.Parent.timer.Text = tostring(i)
				wait(1)
			end
			]]
			script.Parent.curve.timer.progress.Size = UDim2.new(0,0,1,0)
			tween(script.Parent.curve.timer.progress, {"Size"}, UDim2.new(1,0,1,0), COUNTDOWN_TIME, Enum.EasingStyle.Linear)
			wait(COUNTDOWN_TIME)
			module.accept()					
		end)
			
		
		
		

	end
	

	script.Parent.curve.respawn.Activated:connect(module.accept)
	
	network:connect("deathGuiRequested", "OnClientEvent", module.show)
	
	local function onDataChange(key, value)
		if key == "gold" or key == "level" or key == "exp" then
			updateLabel()
		end
	end
	network:connect("propogationRequestToSelf", "Event", onDataChange)
end


return module
