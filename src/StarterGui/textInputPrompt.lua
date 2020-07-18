local module = {}

local ui = script.Parent.gameUI.textInputPrompt

function module.init(Modules)
	local network = Modules.network
	local connection
	local currentPrompt

	function module.hide()
		if connection then
			connection:disconnect()
			currentPrompt = nil
		end

		if ui.Visible then
			Modules.focus.toggle(ui)
		end
	end

	function module.prompt(info)

		local prompt = info.prompt or "....."

		if connection then
			connection:disconnect()
		end
		currentPrompt = prompt

		ui.Frame.code.TextBox.Text = ""
		ui.Frame.code.TextBox.PlaceholderText = prompt
		if not ui.Visible then
			Modules.focus.toggle(ui)
		end

		local input

		connection = ui.Frame.send.Activated:connect(function()
			input = ui.Frame.code.TextBox.Text
		end)

		repeat wait() until input or currentPrompt ~= prompt

		if input then
			module.hide()
			return input
		end

	end

	network:create("textInputPrompt", "BindableFunction", "OnInvoke", module.prompt)

	ui.Frame.close.Activated:connect(module.hide)
end

return module