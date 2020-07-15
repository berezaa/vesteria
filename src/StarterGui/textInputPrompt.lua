local module = {}

function module.init(Modules)
	
	local network = Modules.network
	
	local connection
	local currentPrompt
	
	function module.hide()
		if connection then
			connection:disconnect()
			currentPrompt = nil
		end		
		
		if script.Parent.Visible then
			Modules.focus.toggle(script.Parent)
		end
	end
	
	function module.prompt(info)
		
		local prompt = info.prompt or "....."
		
		if connection then
			connection:disconnect()
		end		
		currentPrompt = prompt

		script.Parent.Frame.code.TextBox.Text = ""
		script.Parent.Frame.code.TextBox.PlaceholderText = prompt
		if not script.Parent.Visible then
			Modules.focus.toggle(script.Parent)
		end
		
		local input
		
		connection = script.Parent.Frame.send.Activated:connect(function()
			input = script.Parent.Frame.code.TextBox.Text
		end)
		
		repeat wait() until input or currentPrompt ~= prompt
		
		if input then
			module.hide()
			return input
		end
	
	end

	network:create("textInputPrompt", "BindableFunction", "OnInvoke", module.prompt)

	script.Parent.Frame.close.Activated:connect(module.hide)
end

return module