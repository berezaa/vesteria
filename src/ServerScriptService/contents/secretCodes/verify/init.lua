local module = {}

local httpService = game:GetService("HttpService")

local key = require(script.key)

function module.Verify(player, code)
	if player:FindFirstChild("VerifyCooldown") == nil then
		local tag = Instance.new("BoolValue")
		tag.Name = "VerifyCooldown"
		tag.Parent = player
		spawn(function()
			wait(10)
			if tag then
				tag:Destroy()
			end
		end)

		local playerRank = player:GetRankInGroup(1137635)
	
		if type(code)=="string" and code ~= "" then
	
	
			local rolesTable = {}
			rolesTable["Verified"] = true
			
			rolesTable["Vesterian"] = true

			
		
			local resp = httpService:GetAsync("http://104.236.92.94:8005/process?userId=" .. player.userId .. "&code=" .. code .. "&doPromote=" .. tostring(playerRank == 1) .. "&roles=" .. httpService:JSONEncode(rolesTable).."&key="..key)
			if string.lower(resp) == "true" or string.lower(resp) == "success" then
				
				return true
			else
				game.ReplicatedStorage.Error:FireClient(player, "Server denied code: Response: "..resp)
				return false
			end
			
		end
	else
		return false 
	end
end


return module
