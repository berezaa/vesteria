local module = {}

local ui = script.Parent.gameUI.dialogueFrame.contents.taxi

function module.init(Modules)

	local network = Modules.network
	local utilities = Modules.utilities

	local locations = network:invoke("getCacheValueByNameTag", "locations")

	local buttonCount

	local contents = ui.contents

	local buttonCount = 0

	for placeIdString, placeData in pairs(locations) do

		local placeId = tonumber(placeIdString)

		if placeId ~= game.PlaceId then
			local originPlaceId = utilities.originPlaceId(placeId)

			local button = ui.sample:Clone()
			button.Name = placeIdString
			button.LayoutOrder = math.floor((os.time() - placeData.visited) ^ 0.25)
			button.location.Text = "-"

			button.BGHolder.BG.Image = "https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..originPlaceId
			button.BGHolder.BG.Visible = true

			spawn(function()
				local info = game.MarketplaceService:GetProductInfo(originPlaceId ,Enum.InfoType.Asset)
				if info then
					button.location.Text = info.Name
				end
			end)
			button.location.Visible = true
			button.Parent = contents
			button.Active = true
			button.Selectable = true
			button.Visible = true
			buttonCount = buttonCount + 1
			button.location.TextWrapped = true
			button.Activated:connect(function()
				network:invoke("dialogueMoveToId", "spawns", {taxiLocation = placeIdString, taxiLocationName = button.location.Text})
			end)
		end
	end

	if buttonCount < 12 then
		for i = buttonCount, 11 do
			local button = ui.sample:Clone()
			button.Name = "empty"
			button.BGHolder.BG.Visible = false
			button.location.Visible = false
			button.empty.Visible = true
			button.LayoutOrder = 999

			local tooltip = Instance.new("StringValue")
			tooltip.Name = "tooltip"
			tooltip.Value = "Undiscovered location"
			tooltip.Parent = button

			button.Parent = contents
			button.Active = true
			button.Selectable = true
			button.Visible = true
			buttonCount = buttonCount + 1

			button.Activated:connect(function()
				network:invoke("dialogueMoveToId", "undiscovered")
			end)
		end
	end

	local rows = math.ceil(buttonCount / 2)
	contents.CanvasSize = UDim2.new(0, 0, 0, rows * (contents.UIGridLayout.CellSize.Y.Offset + contents.UIGridLayout.CellPadding.Y.Offset) + 10)

end

return module
