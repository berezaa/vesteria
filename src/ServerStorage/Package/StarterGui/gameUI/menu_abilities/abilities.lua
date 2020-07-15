local b={}function b.show()
script.Parent.Visible=not script.Parent.Visible end
function b.hide()script.Parent.Visible=false end
script.Parent.close.Activated:connect(b.hide)return b