local module = {}

local paymentDataCache = {}
local ProductCache = {d = "1"}

local httpService 		= game:GetService("HttpService")
local replicatedStorage = game:GetService("ReplicatedStorage")
	local modules 		= require(replicatedStorage.modules)
		local network 		= modules.load("network")
		local utilities 	= modules.load("utilities")

local function processPayment(player, receiptInfo, playerGlobalData)
	if playerGlobalData == nil then
		local playerData = network:invoke("getPlayerData", player)
		if playerData and playerData.globalData then
			playerGlobalData = playerData.globalData
		else
			return false
		end
	end
	
	local additionalInfo = {}

	local doFinishTransaction = false

	-- 300 ethyr
	if receiptInfo.ProductId == 509935760 then
		playerGlobalData.ethyr = (playerGlobalData.ethyr or 0) + 300
--		additionalInfo.broadcast = {Text = player.Name .. " just purchased 300 Ethyr!"; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(115, 255, 251)}
		doFinishTransaction = true
		spawn(function()
			network:invoke("reportCurrency", player, "ethyr", 300, "product:ethyr300")
		end)
	-- 120 ethyr
	elseif receiptInfo.ProductId == 509934399 then
		playerGlobalData.ethyr = (playerGlobalData.ethyr or 0) + 120	
--		additionalInfo.broadcast = {Text = player.Name .. " just purchased 120 Ethyr!"; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(115, 255, 251)}	
		doFinishTransaction = true
		spawn(function()
			network:invoke("reportCurrency", player, "ethyr", 120, "product:ethyr120")
		end)		
	-- 750 ethyr
	elseif receiptInfo.ProductId == 509935018 then
		playerGlobalData.ethyr = (playerGlobalData.ethyr or 0) + 750
--		additionalInfo.broadcast = {Text = player.Name .. " just purchased 750 Ethyr!"; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(115, 255, 251)}
		doFinishTransaction = true		
		spawn(function()
			network:invoke("reportCurrency", player, "ethyr", 750, "product:ethyr750")
		end)			
	elseif receiptInfo.ProductId == 539152241 then
	-- 3500 ethyr (3000 + 500 bonus)
		playerGlobalData.ethyr = (playerGlobalData.ethyr or 0) + 3500
--		additionalInfo.broadcast = {Text = player.Name .. " just purchased 3000 Ethyr and received 500 bonus Ethyr!"; Font = Enum.Font.SourceSansBold; Color = Color3.fromRGB(115, 255, 251)}
		doFinishTransaction = true	
		spawn(function()
			network:invoke("reportCurrency", player, "ethyr", 3500, "product:ethyr3500")
		end)							
	end	
	
	return doFinishTransaction, playerGlobalData, additionalInfo
end

network:create("processPayment", "BindableFunction", "OnInvoke", processPayment)

network:create("signal_productPurchaseConfirmed", "RemoteEvent")

if game.PlaceId ~= 2376885433 and game.PlaceId ~= 2015602902 then
	game:GetService("MarketplaceService").ProcessReceipt = function(receiptInfo)
		
	
		
		local player = game.Players:GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then
			-- no player, abort.
			warn("aborted purchase due to missing player")
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		
		if player:FindFirstChild("DataSaveFailed") then
			-- player data has failed to save, abort.
			warn("aborted purchase due to save failure")
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		
		local processingStartTime = tick()
		
		repeat wait(0.1) until player == nil or player.Parent ~= game.Players or network:invoke("getPlayerData", player) or tick() - processingStartTime > 15
		
		local playerData = network:invoke("getPlayerData", player)
		if playerData == nil then
			warn("aborted purchase due to player missing")
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		
		local playerGlobalData = playerData.globalData
		if playerGlobalData == nil then
			warn("aborted purchase due to player global data missing")
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		
		paymentDataCache[player] = paymentDataCache[player] or {}
		local playerPaymentDataCache = paymentDataCache[player]
		playerPaymentDataCache.payments = playerPaymentDataCache.payments or {}		
		
		

		local doFinishTransaction
		local modifiedGlobalPlayerData
		local additionalInfo
		
		-- Do not modify data if payment has already been cached this session
		if playerPaymentDataCache.payments[receiptInfo.PurchaseId] then
			doFinishTransaction = true
		else
			doFinishTransaction, modifiedGlobalPlayerData, additionalInfo = network:invoke("processPayment", player, receiptInfo, playerGlobalData)
		end		
		
		if doFinishTransaction and modifiedGlobalPlayerData then
			
			playerData.nonSerializeData.setPlayerData("globalData", modifiedGlobalPlayerData)
			playerPaymentDataCache.payments[receiptInfo.PurchaseId] = true
			
			
			spawn(function()
--				network:fireClient("signal_productPurchaseConfirmed", player, receiptInfo, additionalInfo)

				
				if additionalInfo.broadcast then
					network:fireAllClients("signal_alertChatMessage", additionalInfo.broadcast)
				end
						
				local ProductName = ProductCache[receiptInfo.ProductId]
				if ProductName == nil then
					local Product = game.MarketplaceService:GetProductInfo(receiptInfo.ProductId,Enum.InfoType.Product)
					if Product then
						ProductName = Product.Name
						ProductCache[receiptInfo.ProductId] = ProductName
					else
						ProductName = "unknown"
					end
				end
				network:invoke("purchaseMade", player, "Product", ProductName, receiptInfo.CurrencySpent)
			end)		
			
			
--			network:fireClient("globalDataUpdated", player, playerGlobalData)
			return Enum.ProductPurchaseDecision.PurchaseGranted			
		end
		
			
	end	
end

return module
