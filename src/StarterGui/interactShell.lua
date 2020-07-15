local module = {}


function module.show(prompt)
	prompt.Parent = script.Parent.shell
	script.Parent.Visible = true
end

function module.hide()
	script.Parent.Visible = false
end

module.hide()

return module
