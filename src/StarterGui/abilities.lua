local module = {}

local frame = script.Parent.gameUI.menu_abilities

function module.show()
	frame.Visible = not frame.Visible
end
function module.hide()
	frame.Visible = false
end

frame.close.Activated:connect(module.hide)

return module
