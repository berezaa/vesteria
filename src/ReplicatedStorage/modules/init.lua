local module = {}

function module.load(moduleName, doClone)

	if script:FindFirstChild(moduleName) then
		return
			doClone and require(script[moduleName]:Clone())
			or require(script[moduleName])
	else
		-- if we're on the client, wait for the module in case
		-- it's still replicating, if it doesn't show up in a
		-- reasonable amount of time, assume it was scripter
		-- error and notify them as such
		if game:GetService("RunService"):IsClient() then
			local scr = script:WaitForChild(moduleName, 15)
			
			if not scr then
				error("Requesting module that probably doesn't exist: "..moduleName)
			end
			
			if doClone then
				return require(scr:Clone())
			else
				return require(scr)
			end
		end
	end
	
	return nil
end

return module