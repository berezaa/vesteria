local b={}
function b.init(c)local d=c.network
game.Players.LocalPlayer.Chatted:Connect(function(_a)
if
_a=="/verify"then c.focus.toggle(script.Parent)end end)
script.Parent.Frame.send.Activated:connect(function()
local _a=d:invokeServer("{840FF608-DD62-4F28-9840-FBA87D59FF69}",script.Parent.Frame.code.TextBox.Text)
if _a then
local aa={text="You have been verified!",textColor3=Color3.new(0,0,0),backgroundColor3=Color3.fromRGB(0,255,150),backgroundTransparency=0,textStrokeTransparency=1}c.notifications.alert(aa,3)else
local aa={text="Invalid verification code.",textColor3=Color3.new(0,0,0),backgroundColor3=Color3.fromRGB(255,100,0),backgroundTransparency=0,textStrokeTransparency=1}c.notifications.alert(aa,3)end;c.focus.toggle(script.Parent)end)
script.Parent.Frame.close.Activated:connect(function()
c.focus.toggle(script.Parent)end)end;return b