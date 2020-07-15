local b={}
function b.init(c)local d=c.tween;local _a=c.events;local aa;local ba=script.Parent
_a:registerForEvent("playerRespawnPointChanged",function(ca)
if
ca:FindFirstChild("description")then aa=ca;ba.Text=ca.description.Value;ba.TextStrokeTransparency=1
ba.TextTransparency=1;ba.Visible=true
d(ba,{"TextTransparency","TextStrokeTransparency"},0,1)
delay(3,function()if aa==ca then
d(ba,{"TextTransparency","TextStrokeTransparency"},1,1)end end)end end)end;return b