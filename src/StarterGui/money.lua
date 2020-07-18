-- WOAH MONEY XDDDDDDD
-- hand crafted in San Mateo, CA by Andrew "the rock" Berezaa ;P

local module = {}

local player = game:GetService("Players").LocalPlayer
local gui = player.PlayerGui.gameUI.bottomRight.money

module.suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG","TGN","UTG","DTG","tsTG","qtTG","QnTG","ssTG","SpTG","OcTG","NoTG","QdDR","uQDR","dQDR","tQDR","qdQDR","QnQDR","sxQDR","SpQDR","OQDDr","NQDDr","qQGNT","uQGNT","dQGNT","tQGNT","qdQGNT","QnQGNT","sxQGNT","SpQGNT", "OQQGNT","NQQGNT","SXGNTL"}                                              


local function shorten(Input)
	local Negative = Input < 0
	Input = math.abs(Input)

	local Paired = false
	for i,v in pairs(module.suffixes) do
		if not (Input >= 10^(3*i)) then
			Input = Input / 10^(3*(i-1))
			local isComplex = (string.find(tostring(Input),".") and string.sub(tostring(Input),4,4) ~= ".")
			Input = string.sub(tostring(Input),1,(isComplex and 4) or 3) .. (module.suffixes[i-1] or "")
			Paired = true
			break;
		end
	end
	if not Paired then
		local Rounded = math.floor(Input)
		Input = tostring(Rounded)
	end

	if Negative then
		return "-"..Input
	end
	return Input
end

function module.setLabelAmount(label, amount, costInfo)
	
	local negative = false
	if amount < 0 then
		negative = true
		amount = math.abs(amount)
	end
	
	if costInfo and costInfo.costType and costInfo.costType ~= "money" then
		label.icon.Image = costInfo.icon or ""
		label.amount.TextColor3 = costInfo.textColor or Color3.new(1,1,1)
		label.amount.Text =  shorten(amount)
	else
		if amount >= 10^6 then
			label.icon.Image = "rbxassetid://2536432897"
			label.amount.TextColor3 = Color3.fromRGB(255, 236, 123)
			if amount >= 10^8 then
				-- no decimals
				label.amount.Text = tostring(math.floor(amount/10^6))
			else
				-- one decimal point
				label.amount.Text = tostring(math.floor(amount/10^5)/10)
			end			
		elseif amount >= 10^3 then
			-- silver
			label.icon.Image = "rbxassetid://2535600034"
			label.amount.TextColor3 = Color3.fromRGB(223, 223, 223)
			if amount >= 10^5 then
				-- no decimals
				label.amount.Text = tostring(math.floor(amount/10^3))
			else
				-- one decimal point
				label.amount.Text = tostring(math.floor(amount/10^2)/10)
			end
		else
			-- bronze
			label.icon.Image = "rbxassetid://2535600080"
			label.amount.TextColor3 = Color3.fromRGB(255, 170, 149)
			label.amount.Text = tostring(math.floor(amount))
		end		
	end
	
	if negative then
		label.amount.Text = "-"..label.amount.Text
	end
	
	local len = game.TextService:GetTextSize(label.amount.Text, label.amount.TextSize, label.amount.Font, Vector2.new(0,0)).X + 2
	
	local padding = label:FindFirstChild("padding") and label.padding.Value or 0
	
	label.amount.Size = UDim2.new(0, len + padding, label.amount.Size.Y.Scale, label.amount.Size.Y.Offset + padding)
	
end
	
module.labels = {}	
	
local lastGoldValue = 0	

function module.subscribeToPlayerMoney(label)
	local lastMouseOver
	label.MouseEnter:connect(function()
		if lastGoldValue > 999 then
			if not label.Parent:FindFirstChild("exactMoney") then return end
			local thisMouseOver = tick()
			lastMouseOver = thisMouseOver
			label.Parent.exactMoney.Visible = true
			wait(10)
			if lastMouseOver == thisMouseOver then
				label.Parent.exactMoney.Visible = false
			end
		end
	end)
	label.MouseLeave:connect(function()
		if not label.Parent:FindFirstChild("exactMoney") then return end
		label.Parent.exactMoney.Visible = false
	end)			
	
	table.insert(module.labels, label)
end

function module.init(Modules)
	
	local network = Modules.network
	

	

	
	function module.subscribeToPlayerMoney(label)
		
		local gold = network:invoke("getCacheValueByNameTag", "gold")
		module.setLabelAmount(label, gold)
		lastGoldValue = gold

		
		if label.Parent:FindFirstChild("exactMoney") then
			label.Parent.exactMoney.Text = math.floor(lastGoldValue)
			local xBounds = game.TextService:GetTextSize(label.Parent.exactMoney.Text, label.Parent.exactMoney.TextSize, label.Parent.exactMoney.Font, Vector2.new(0,0)).X
			label.Parent.exactMoney.Size = UDim2.new(0, xBounds + 16 + 10, 0, 26 + 10)	
			
			local lastMouseOver
			label.MouseEnter:connect(function()
				if lastGoldValue > 999 then
					local thisMouseOver = tick()
					lastMouseOver = thisMouseOver
					label.Parent.exactMoney.Visible = true
					wait(10)
					if lastMouseOver == thisMouseOver then
						label.Parent.exactMoney.Visible = false
					end
				end
			end)
			label.MouseLeave:connect(function()
				label.Parent.exactMoney.Visible = false
			end)				
		end
		
		table.insert(module.labels, label)


	
	end	
	
	
	local function onDataChange(key, value)
		if key == "gold" then
			lastGoldValue = value
			for i,label in pairs(module.labels) do
				module.setLabelAmount(label, value)
				
				if label.Parent:FindFirstChild("exactMoney") then
					label.Parent.exactMoney.Text = math.floor(lastGoldValue)
					local xBounds = game.TextService:GetTextSize(label.Parent.exactMoney.Text, label.Parent.exactMoney.TextSize, label.Parent.exactMoney.Font, Vector2.new(0,0)).X
					label.Parent.exactMoney.Size = UDim2.new(0, xBounds + 16 + 10, 0, 26 + 10)	
				end				
			end

		end
	end	
	
	-- update any subscribed labels from before module.init
	onDataChange("gold", network:invoke("getCacheValueByNameTag", "gold"))
	module.subscribeToPlayerMoney(gui)
	
	network:connect("propogationRequestToSelf", "Event", onDataChange)	
end

return module
