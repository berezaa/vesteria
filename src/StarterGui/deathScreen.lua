local module = {}


function module.show()
	
end

local COUNTDOWN_TIME = 60

function module.init(Modules)

	local frame = script.Parent.gameUI.deathScreen
	
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
		frame.curve.exp.Text = "-" .. utilities.formatNumber(expLost) .. " XP"
		money.setLabelAmount(frame.curve.cost, -gold*0.1)
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
			if frame and script:FindFirstChild("chorus") then
				script.chorus:Play()
			end
			frame.gradient.ImageTransparency = 1
			frame.gradient.BackgroundTransparency = 1
			tween(frame.gradient, {"ImageTransparency"}, 0, 1)
--			tween(frame.gradient, {"BackgroundTransparency"}, 0.4, 2)	
			frame.Visible = true
			--[[
			for i=COUNTDOWN_TIME,0,-1 do
				frame.timer.Text = tostring(i)
				wait(1)
			end
			]]
			frame.curve.timer.progress.Size = UDim2.new(0,0,1,0)
			tween(frame.curve.timer.progress, {"Size"}, UDim2.new(1,0,1,0), COUNTDOWN_TIME, Enum.EasingStyle.Linear)
			wait(COUNTDOWN_TIME)
			module.accept()					
		end)
			
		
		
		

	end
	

	frame.curve.respawn.Activated:connect(module.accept)
	
	network:connect("deathGuiRequested", "OnClientEvent", module.show)
	
	local function onDataChange(key, value)
		if key == "gold" or key == "level" or key == "exp" then
			updateLabel()
		end
	end
	network:connect("propogationRequestToSelf", "Event", onDataChange)
end


return module
