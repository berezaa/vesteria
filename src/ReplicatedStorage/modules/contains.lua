return function(t, lookfor)
	for k,v in pairs(t) do
		if v == lookfor then
			return true, k
		end
	end
	return false
end