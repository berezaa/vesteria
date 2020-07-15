local module = {}

local debugPlaceIds 	= {[2061558182] = true}
local IS_DEBUG_PLACE 	= debugPlaceIds[game.PlaceId]

function module.print(...)
	if IS_DEBUG_PLACE then
		print(...)
	end
end

return module