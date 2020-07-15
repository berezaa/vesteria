local module = {
	data = {}
}

function module:set(player, key, val)
	if not self.data[player] then
		self.data[player] = {}
	end
	self.data[player][key] = val
end

function module:get(player, key)
	if self.data[player] then
		return self.data[player][key]
	end
end

function module:delete(player, key)
	if not self.data[player] then return end
	
	self.data[player][key] = nil
end

return module