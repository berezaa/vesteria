assert(game.ReplicatedStorage:FindFirstChild("itemData"), "Vesteria Item Manager - item data not found")

-- Create new "DockWidgetPluginGuiInfo" object
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,  -- Widget will be initialized in floating panel
	true,   -- Widget will be initially enabled
	true,  -- Don't override the previous enabled state
	200,    -- Default width of the floating window
	300,    -- Default height of the floating window
	150,    -- Minimum width of the floating window
	150     -- Minimum height of the floating window
)
 
-- Create new widget GUI
local testWidget = plugin:CreateDockWidgetPluginGui("TestWidget", widgetInfo)
testWidget.Title = "Vesteria Item Manager"  -- Optional widget title

--[[
local testButton = Instance.new("TextButton")
testButton.BorderSizePixel = 0
testButton.TextSize = 20
testButton.TextColor3 = Color3.new(1,0.2,0.4)
testButton.AnchorPoint = Vector2.new(0.5,0.5)
testButton.Size = UDim2.new(1,0,1,0)
testButton.Position = UDim2.new(0.5,0,0.5,0)
testButton.SizeConstraint = Enum.SizeConstraint.RelativeYY
testButton.Text = "Click Me"
testButton.Parent = testWidget
]]

local objects = {}

local topbar = Instance.new("Frame")
topbar.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground)
topbar.Size = UDim2.new(1,0,0,30)
topbar.Parent = testWidget

local holder = Instance.new("ScreenGui")
holder.Name = "bersItemPlugin_hover"
holder.Parent = game.PluginGuiService

local frame

function sort()
	
end

local function main()
	if frame then
		frame:Destroy()
	end
	frame = Instance.new("ScrollingFrame")
	frame.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ScrollBarBackground)
	frame.Size = UDim2.new(1,0,1,-30)
	frame.Position = UDim2.new(0,0,0,30)
	
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	
	function sort()
		layout.SortOrder = (layout.SortOrder == Enum.SortOrder.LayoutOrder) and Enum.SortOrder.Name or Enum.SortOrder.LayoutOrder
	end
	
	layout.Parent = frame

	local idmax = 0
	local n = 0
	
	
	local itemData = require(game.ReplicatedStorage.itemData:Clone())
	
	for _, module in pairs(game.ReplicatedStorage.itemData:GetChildren()) do
		local item = itemData[module.Name]
		
		local entry = Instance.new("TextButton")
		entry.Size = UDim2.new(1,0,0,20)
		entry.Text = ""
		
		
		local buttonLayout = Instance.new("UIListLayout")
		buttonLayout.FillDirection = Enum.FillDirection.Horizontal
		buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		buttonLayout.Parent = entry
		buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
		buttonLayout.Padding = UDim.new(0,3)
		
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Size = UDim2.new(0,20,0,20)
		imageLabel.Image = item.image
		imageLabel.BackgroundTransparency = 1
		imageLabel.Parent = entry
		
		-- I know for a fact there's a better way to do this but I can't be bothered rn
		local id = tostring(item.id)
		if #id == 2 then
			id = "0" .. id
		elseif #id == 1 then
			id = "00" .. id
		end
		
		local textLabelID = Instance.new("TextLabel")
		textLabelID.Size = UDim2.new(0,50,0,20)
		textLabelID.Text = "ID: " .. id .. " - "
		textLabelID.TextSize = 17
		textLabelID.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
		textLabelID.Font = Enum.Font.SourceSans
		textLabelID.TextXAlignment = Enum.TextXAlignment.Left
		textLabelID.BackgroundTransparency = 1
		textLabelID.Parent = entry
		
		local imageLabel = Instance.new("ImageLabel")
		imageLabel.Size = UDim2.new(0,16,0,16)
		imageLabel.Image = "rbxgameasset://Images/category_" .. item.itemType
		imageLabel.ImageColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
		imageLabel.BackgroundTransparency = 1
		imageLabel.Parent = entry
		
		local textLabelName = Instance.new("TextLabel")
		textLabelName.Size = UDim2.new(1,0,0,20)
		textLabelName.Text = item.name
		textLabelName.TextSize = 17
		textLabelName.TextColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonText)
		textLabelName.Font = Enum.Font.SourceSansBold
		textLabelName.TextXAlignment = Enum.TextXAlignment.Left
		textLabelName.BackgroundTransparency = 1
		textLabelName.Parent = entry	

		idmax = item.id > idmax and item.id or idmax
		n = n + 1
		
		entry.Name = item.itemType
		entry.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
		entry.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
		entry.LayoutOrder = item.id
		
		entry.Activated:connect(function()
			plugin:OpenScript(module)
		end)
		
		entry.Parent = frame

		table.insert(objects, entry)
	end
	
	frame.CanvasSize = UDim2.new(0,0,0,n*20)
	frame.Parent = testWidget
	
end
 
main()

local barLayout = Instance.new("UIListLayout")
barLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
barLayout.VerticalAlignment = Enum.VerticalAlignment.Center
barLayout.FillDirection = Enum.FillDirection.Horizontal
barLayout.Padding = UDim.new(0,5)
barLayout.Parent = topbar

local refresh = Instance.new("ImageButton")
refresh.Image = "rbxassetid://61995002"
refresh.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
refresh.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
refresh.Size = UDim2.new(0,20,0,20)
refresh.Activated:connect(main)
refresh.Parent = topbar

local sortButton = Instance.new("ImageButton")
sortButton.Image = "rbxassetid://38186580"
sortButton.BackgroundColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Button)
sortButton.BorderColor3 = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.ButtonBorder)
sortButton.Size = UDim2.new(0,20,0,20)
sortButton.Activated:connect(function() sort() end)
sortButton.Parent = topbar

print("Setup complete")