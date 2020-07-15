
return
function()
local a=require(game.ReplicatedStorage:WaitForChild("modules"))local b=a.load("network")local c=a.load("utilities")
local d=a.load("tween")local _a={}local aa=script.Parent.Parent.AnimationController
local ba=aa:LoadAnimation(script.Parent.Parent.Animation)ba.Looped=false
local ca=aa:LoadAnimation(script.Parent.Parent.idle)ca:Play()local da
b:create("{A48814D7-0864-467B-B159-37C7A0D0F0EA}","RemoteEvent")
function BOOM(_b,ab)if ab~=script.Parent.Parent then return false end;da=_b
ba.Looped=false;ba:Play()local bb
bb=ba.KeyframeReached:connect(function(cb)if cb=="finish"then ba:Stop()
bb:disconnect()bb=nil end end)
script.Parent.Parent.target.CannonFire:Play()
b:fireClient("{A48814D7-0864-467B-B159-37C7A0D0F0EA}",_b,script.Parent.Parent)
script.Parent.Parent.target.smoke.Enabled=true
script.Parent.Parent.target.light.Enabled=true
script.Parent.Parent.target.explode:Emit(100)
script.Parent.Parent.target.light.Range=15
for i=5,1,-1 do wait(0.1)
script.Parent.Parent.target.explode:Emit(i)if da==_b then
script.Parent.Parent.target.light.Range=i*3 end end;wait(0.5)if da==_b then
script.Parent.Parent.target.smoke.Enabled=false
script.Parent.Parent.target.light.Enabled=false end;ba.Looped=false
spawn(function()
wait(5)if bb then bb:disconnect()end end)end
b:create("{E7B04DB3-26B9-43B4-B169-4DD66837696A}","RemoteEvent","OnServerEvent",BOOM)end