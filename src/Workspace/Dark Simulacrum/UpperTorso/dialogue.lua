local dialogue = {
	id = "startTalkingTo",
	dialogue = {{text = "Would you like to see the future?"}},
	options = {
		{
			response = "Yes",
			dialogue = function(util)
				local level = util.network:invoke("getCacheValueByNameTag", "level") or 0
				if level < 30 then
					return {{text = "Only level 30 players can withstand the future."}}
				end
				
				local success = util.network:invokeServer("testNpcTeleportToTest")
				if success then
					return {{text = "TO THE FUTURE!"}}
				else
					return {{text = "You can't."}}
				end
			end,
		},
	}
}

return dialogue