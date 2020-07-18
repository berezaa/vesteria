local module = {}

local runService = game:GetService("RunService")
local ui = script.Parent.gameUI.products

function module.open()
	ui.Visible = not ui.Visible
end

-- module.remapTarget

local userSettings

function module.init(Modules)

	local network = Modules.network

	ui.close.Activated:connect(function()
		Modules.focus.toggle(ui)
	end)

	function module.open()
		if not ui.Visible then
			ui.UIScale.Scale = (Modules.input.menuScale or 1) * 0.75
			Modules.tween(ui.UIScale, {"Scale"}, (Modules.input.menuScale or 1), 0.5, Enum.EasingStyle.Bounce)
		end
		Modules.focus.toggle(ui)
	end

	for i,product in pairs(ui.contents:GetChildren()) do
		if product:FindFirstChild("productId") and product:FindFirstChild("buy") then
			product.buy.Activated:connect(function()
				game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, product.productId.Value)
			end)
		end
	end

	--network:invokeServer("requestChangePlayerSetting", "clearingInteraction", true)

end

return module