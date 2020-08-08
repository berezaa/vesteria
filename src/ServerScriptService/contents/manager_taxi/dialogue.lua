local extraOptionsByPlaceId = {
	-- mushtown
	[2064647391] = {
		{
			response = "Where's your horse?",
			dialogue = {{text = "Taximan Dave doesn't need a horse, silly!"}},
		},
	},
	
	-- port fidelio
	[2546689567] = {
		{
			response = "Where's your swimsuit?",
			dialogue = {{text = "Taximan Dave doesn't get to have fun, silly!"}},
		}
	},
	
	-- warrior stronghold
	[2470481225] = {
		{
			response = "Where's your coat?",
			dialogue = {{text = "Taximan Dave doesn't get cold, silly!"}},
		}
	},
	
	-- guild hall
	[4653017449] = {
		{
			response = "Where's your cart?",
			dialogue = {{text = "Taximan Dave doesn't need a cart, silly!"}},
		}
	},
}

return {
	sound = "npc_male_ahaa",
	id = "startTalkingTo",
	canExit = true,
	
	dialogue = {{text = "Greetings Adventurer! You know me, the one and only Taximan Dave! I can take you to any location that you've visited before."}},
	options = function(util)
		local utilities = util.utilities
		local network = util.network
		local options = {
			{
				canExit = true,
				id = "choose";
				response = "Let's go somewhere.",
				responseButtonColor = Color3.fromRGB(234, 174, 53),
				dialogue = {{text = "Alright Adventurer! Where would you like me to take ya?"}},
				taxiMenu = true;
				
				options = {
						{
							id = "undiscovered";
							dialogue = {{text = "There's a lot of places that I don't know how to get to yet. Maybe if you discover them you can tell me how to get there!"}};
							moveToId = "choose";
						};
						{
							id = "spawns";
							dialogue = function(util, extraData)
								return {{text = "Alright! Where in"},{text = extraData.taxiLocationName,font = Enum.Font.SourceSansBold},{text = "should I take ya?"}};
							end;
							canExit = true;
							options = function(util, extraData)
								local locations = network:invoke("getCacheValueByNameTag", "locations")
								local placeData = locations[extraData.taxiLocation]
								local checkpointOptions = {}
								
								for spawnName,spawnData in pairs(placeData.spawns) do
									if spawnData.text then
										table.insert(checkpointOptions, {
											response = spawnData.text;
											dialogue = function(util)
												local success = network:invokeServer("playerRequest_taximanDave", extraData.taxiLocation, spawnName)
												if success then
													return {{text = "Giddy up, lets go!"}}
												else
													return {{text = "I can't help you right now. Sorry!"}}
												end
											end;
										})
									end
								end
								return checkpointOptions
							end
						};
				};
	
				--[[
				options = function(util)
					local player = game:GetService("Players").LocalPlayer
					
					local taxiInfo = util.network:invokeServer("getTaxiInfo")
					
					local options = {}
					
					for _, info in pairs(taxiInfo) do
						local color = Color3.fromRGB(234, 174, 53)
						if not info.enabled then
							color = Color3.new(0.4, 0.4, 0.4)
						end
						
						local option = {
							response = string.format("%s (%d Silver)", info.name, info.price),
							responseButtonColor = color,
							
							dialogue = function(util)
								local success, reason, message = util.network:invokeServer("takeTaxiToDestination", info.id)
								if success then
									return {{text = "All right, then! Giddy up, let's go!"}}
								else
									if reason == "notEnoughMoney" then
										return {{text = "Come back when you can afford the trip."}}
									elseif reason == "notValidDestination" then
										return {{text = "Sorry, uh, I've never heard of that place."}}
									elseif reason == "conditionUnfulfilled" then
										return {{text = message}}
									else
										return {{text = reason}}
									end
								end
							end,
						}
						table.insert(options, option)
					end
					
					return options
					
				end
				]]
			}
		}
		
		local extraOptions = extraOptionsByPlaceId[utilities.originPlaceId(game.PlaceId)]
		if extraOptions then
			for _, option in pairs(extraOptions) do
				table.insert(options, option)
			end
		end
		
		return options
	end
}