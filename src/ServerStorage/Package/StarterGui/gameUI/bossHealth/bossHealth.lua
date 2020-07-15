local b={}
function b.init(c)local d=c.network;script.Parent.Visible=false
d:create("{62930EB2-D79E-4277-AC23-50E9C793046D}","BindableFunction","OnInvoke",function(_a)
if
_a.portrait then script.Parent.thumbnail.Image=_a.portrait end;script.Parent.Visible=true;return script.Parent end)end;return b