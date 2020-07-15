local module = {}

local runService = game:GetService("RunService")

function module.open()
	script.Parent.Visible = not script.Parent.Visible
end




-- module.remapTarget

local userSettings

function module.init(Modules)
	
	local network = Modules.network
	
	script.Parent.close.Activated:connect(function()
		Modules.focus.toggle(script.Parent)
	end)
	
	function module.open()
		if not script.Parent.Visible then
			script.Parent.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(script.Parent.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end		
		Modules.focus.toggle(script.Parent)
	end
	
	for i,product in pairs(script.Parent.contents:GetChildren()) do
		if product:FindFirstChild("productId") and product:FindFirstChild("buy") then
			product.buy.Activated:connect(function()
				game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, product.productId.Value)
			end)
		end
	end	
	
	--network:invokeServer("requestChangePlayerSetting", "clearingInteraction", true)
	
end

return module