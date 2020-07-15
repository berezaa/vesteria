local module = {}

function module.show()
	script.Parent.Visible = not script.Parent.Visible
end
function module.hide()
	script.Parent.Visible = false
end

script.Parent.close.Activated:connect(module.hide)

return module
