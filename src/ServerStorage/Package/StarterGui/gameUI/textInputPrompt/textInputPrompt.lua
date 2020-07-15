local b={}
function b.init(c)local d=c.network;local _a;local aa;function b.hide()
if _a then _a:disconnect()aa=nil end
if script.Parent.Visible then c.focus.toggle(script.Parent)end end
function b.prompt(ba)
local ca=ba.prompt or"....."if _a then _a:disconnect()end;aa=ca
script.Parent.Frame.code.TextBox.Text=""
script.Parent.Frame.code.TextBox.PlaceholderText=ca;if not script.Parent.Visible then
c.focus.toggle(script.Parent)end;local da
_a=script.Parent.Frame.send.Activated:connect(function()
da=script.Parent.Frame.code.TextBox.Text end)repeat wait()until da or aa~=ca;if da then b.hide()return da end end
d:create("{24640DF3-5DD8-42D6-86BE-8308D69CD158}","BindableFunction","OnInvoke",b.prompt)
script.Parent.Frame.close.Activated:connect(b.hide)end;return b