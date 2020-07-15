local d={}local _a=game:GetService("RunService")
function d.open()script.Parent.Visible=
not script.Parent.Visible end;local aa
function d.init(ba)local ca=ba.network
script.Parent.close.Activated:connect(function()
ba.focus.toggle(script.Parent)end)
function d.open()
if not script.Parent.Visible then script.Parent.UIScale.Scale=(
ba.input.menuScale or 1)*0.75
ba.tween(script.Parent.UIScale,{"Scale"},(
ba.input.menuScale or 1),0.5,Enum.EasingStyle.Bounce)end;ba.focus.toggle(script.Parent)end
for da,_b in
pairs(script.Parent.contents:GetChildren())do
if
_b:FindFirstChild("productId")and _b:FindFirstChild("buy")then
_b.buy.Activated:connect(function()
game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer,_b.productId.Value)end)end end end;return d