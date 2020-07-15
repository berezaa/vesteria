local c={}local d
function c.init(_a)local aa=_a.network
local ba=require(game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("repo"):WaitForChild("animationInterface"))
function c.show(ca)d=ca
if _a.input.mode.Value~="mobile"then
script.Parent.contents.username.Text=ca.Name
script.Parent.contents.level.Text="Lvl. "..
tostring(
ca:FindFirstChild("level")and ca.level.Value or 0)script.Parent.interact.Visible=true
script.Parent.options.Visible=false;script.Parent.Size=UDim2.new(0,700,0,105)
script.Parent.Visible=true end end;function c.activate(ca)_a.inspectPlayer.open(ca)
ba:replicatePlayerAnimationSequence("emoteAnimations","interaction_greeting")end;function c.hide()d=nil
script.Parent.Visible=false end;c.hide()end;return c