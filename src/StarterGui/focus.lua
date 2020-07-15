-- Focus handler by berezaa honestly kinda of an artifact but important for xbox selection

local module = {}

module.focused = nil

function module.toggle()
	warn("focus.toggle not ready")
end

local function getBestButton(gui)
	local hiv = Vector2.new(9999,9999)
	local top
	--[[
	for i, child in pairs (gui:GetDescendants()) do
		if child:IsA("GuiButton") and child.Visible then
			local vec = child.AbsolutePosition - gui.AbsolutePosition
			if vec.magnitude < hiv.magnitude then
				top = child
				hiv = vec
			end
		end
	end
	]]
	
	local function checkChildren(object)
		if (not object:IsA("GuiObject")) or object.Visible then
			if object:IsA("GuiButton") then
				local vec = object.AbsolutePosition - gui.AbsolutePosition
				if vec.magnitude < hiv.magnitude then
					top = object
					hiv = vec
				end				
			end
			for i,child in pairs(object:GetChildren()) do
				checkChildren(child)
			end
		end
	end
	
	checkChildren(gui)
	
	return top
end

module.getBestButton = getBestButton


function module.init(Modules) 

	local network = Modules.network
	local tween = Modules.tween
	
	local depth = game.Lighting:FindFirstChild("DepthOfField")
	
--	local gradient = script.Parent.gradient

	local function update()
		local isMenuInFocus = not (module.focused == nil or module.focused.Visible == false)
		network:fire("signal_menuFocusChanged", isMenuInFocus)
--		script.Parent.xboxMenuPrompt.Visible = isMenuInFocus
-- ??????????
	end

	function module.close()
		if module.focused then
			module.focused.Visible = false
			module.focused = nil
--			tween(gradient, {"ImageTransparency"}, 1, 0.5)
			tween(depth, {"FarIntensity", "FocusDistance", "InFocusRadius"}, {0.25, 200, 0}, 0)
		end		
		if Modules.input.mode.Value == "xbox" then

			game:GetService("GuiService").GuiNavigationEnabled = false
			game:GetService("GuiService").SelectedObject = nil		
			pcall(function()
				game:GetService("GuiService"):RemoveSelectionGroup("focus")
			end)			
		end
		update()
	end
	
	function module.cleanup()
		if Modules.input.mode.Value == "xbox" then

			game:GetService("GuiService").GuiNavigationEnabled = false
			game:GetService("GuiService").SelectedObject = nil		
			pcall(function()
				game:GetService("GuiService"):RemoveSelectionGroup("focus")
			end)			
		end		
	end
	
	function module.change(object)
		if Modules.input.mode.Value == "xbox" then
			game:GetService("GuiService").GuiNavigationEnabled = false
			game:GetService("GuiService").SelectedObject = nil		
			pcall(function()
				game:GetService("GuiService"):RemoveSelectionGroup("focus")
			end)
			object.Visible = true
			game.GuiService.GuiNavigationEnabled = true
			game.GuiService:AddSelectionParent("focus", object)
			game.GuiService.SelectedObject = getBestButton(object)	
--			tween(gradient, {"ImageTransparency"}, 0, 0.5)	
			tween(depth, {"FarIntensity", "FocusDistance", "InFocusRadius"}, {1, 4, 3}, 0)					
		end
	end
	
	function module.toggle(object)
		
		Modules.input.setCurrentFocusFrame(nil)
		
		if module.focused then
			if Modules.input.mode.Value == "xbox" then
				game:GetService("GuiService").GuiNavigationEnabled = false
				game:GetService("GuiService").SelectedObject = nil		
				pcall(function()
					game:GetService("GuiService"):RemoveSelectionGroup("focus")
				end)	
				if object:IsDescendantOf(module.focused) then
					module.focused.Visible = false
--					tween(gradient, {"ImageTransparency"}, 1, 0.5)
					tween(depth, {"FarIntensity", "FocusDistance", "InFocusRadius"}, {0.25, 200, 0}, 0)
				end
			end
		end
		
		if object.Visible then
			object.Visible = false
			module.focused = nil
			object.ZIndex = 2
--			tween(gradient, {"ImageTransparency"}, 1, 0.5)
			tween(depth, {"FarIntensity", "FocusDistance", "InFocusRadius"}, {0.25, 200, 0}, 0)
		else
			object.Visible = true
			if module.focused then
				module.focused.ZIndex = 2
			end
			object.ZIndex = 3
			module.focused = object
--			tween(gradient, {"ImageTransparency"}, 0, 0.5)
			tween(depth, {"FarIntensity", "FocusDistance", "InFocusRadius"}, {1, 4, 3}, 0)	
		end
		
		if module.focused then
			if Modules.input.mode.Value == "xbox" then
				game.GuiService:AddSelectionParent("focus", module.focused)
				game.GuiService.SelectedObject = getBestButton(module.focused)
				warn("$",game.GuiService.SelectedObject)
				game.GuiService.GuiNavigationEnabled = true
			end
		end
		update()
	end
	
		
end

return module
