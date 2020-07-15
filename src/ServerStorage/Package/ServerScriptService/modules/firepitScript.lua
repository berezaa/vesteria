
return
function()local a=game:GetService("ReplicatedStorage")
local b=require(a:WaitForChild("modules"))local c=b.load("network")local d=0;local _a=300
game.CollectionService:AddTag(script.Parent,"firepit")
if script.Parent:IsA("BasePart")then script.Parent.Anchored=true end
local aa=game.ReplicatedStorage:WaitForChild("sounds")if aa:FindFirstChild("fireLoop")then fireLoop=aa.fireLoop:Clone()
fireLoop.Parent=script.Parent end;if
aa:FindFirstChild("fireIgnite")then fireIgnite=aa.fireIgnite:Clone()
fireIgnite.Parent=script.Parent end
local function ba(da,_b)
if _b==script.Parent then if
fireIgnite then fireIgnite:Play()end
for ab,bb in
pairs(script.Parent:GetChildren())do pcall(function()bb.Enabled=true end)end;if fireLoop then fireLoop:Play()end
game.CollectionService:RemoveTag(script.Parent,"interact")d=os.time()end end
local function ca()for da,_b in pairs(script.Parent:GetChildren())do
pcall(function()_b.Enabled=false end)end
if fireLoop then fireLoop:Stop()end
game.CollectionService:AddTag(script.Parent,"interact")end
c:create("{00B764A1-3E25-4D07-9230-A642588CC6D1}","RemoteEvent","OnServerEvent",ba)
while wait(1)do if
script.Parent.Fire.Enabled and os.time()-d>_a then ca()end end end