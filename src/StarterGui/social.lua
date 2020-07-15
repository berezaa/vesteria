local module = {}

module.friends = {}

module.places = {
	["Main Menu"] = 2376885433;
	["Free Demo"] = 2015602902;
	["Mushtown"] = 2064647391;
	["Mushroom Forest"] = 2035250551;
	["Mushroom Grotto"] = 2060360203;
	["The Clearing"] = 2060556572;
	["Altdorf"] = 2119298605;
	["Farmlands"] = 2180867434;
	["Enchanted Forest"] = 2260598172;
	["Redwood Pass"] = 2376890690;
	["Seaside Path"] = 2093766642;
	["Testing Environment"] = 2061558182;	
}

local places = module.places

local function isPlaceInGame(placeId)
	for i,place in pairs(places) do
		if place == placeId then
			return true
		end
	end
end


local player = game.Players.LocalPlayer

function module.init(Modules)
	
	local function updateFriends()
		local success, err = pcall(function()
			local friendsInfo = player:GetFriendsOnline()
			local friendsList = {}
			for i,friend in pairs(friendsInfo) do
				if friend.IsOnline and friend.PlaceId and isPlaceInGame(friend.PlaceId) then
					friendsList[friend.VisitorId] = friend
				end
			end
			module.friends = friendsList
		end)
		if not success then
			warn("Failed to fetch online friends")
			warn(err)
		end
	end
	
	spawn(function()
		updateFriends()
		while wait(30) do
			updateFriends()
		end
	end)
	
	
end

return module
