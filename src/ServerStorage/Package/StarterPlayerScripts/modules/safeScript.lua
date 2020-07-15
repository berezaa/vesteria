local bb={}bb.isActive=false;bb.interactPrompt="Open"
local cb=game.Players.LocalPlayer
local db=require(game.ReplicatedStorage:WaitForChild("modules"))local _c=db.load("network")local ac=db.load("utilities")
local bc=db.load("tween")local cc=script.Parent.Parent;local dc=cc.AnimationController;local _d=cc.Open
local ad=dc:LoadAnimation(_d)local bd
function bb.init()if not bd then
game.ContentProvider:PreloadAsync({ad})bd=true end;ad:Stop()ad:Play()
ad:AdjustSpeed(1.5)
delay(2.75,function()if ad.IsPlaying then ad:AdjustSpeed(0)end end)end
function bb.close()ad:AdjustSpeed(1.5)
game.CollectionService:RemoveTag(script.Parent,"interact")
delay(1.5,function()
game.CollectionService:AddTag(script.Parent,"interact")end)end;return bb