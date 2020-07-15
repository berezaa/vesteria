local ba={}local ca=game:GetService("CollectionService")
local da=game:GetService("ReplicatedStorage")local _b;local ab;local bb
function ba:DoEffect(cb,db)local _c=cb.Parent.Metadata
local ac=_c.Effect:FindFirstChild(db)
if ac then
for bc,cc in pairs(ac:GetChildren())do local dc=cc:Clone()
dc.Parent=cb.PrimaryPart;if dc:IsA("Sound")then dc:Play()elseif dc:IsA("ParticleEmitter")then
dc:Emit(dc.Rate)end
bb.Delay(10,function()dc:Destroy()end)end end end
function ba:Start()
ab:connect("ResourceReplenished","OnClientEvent",function(cb)local db=cb.Parent.Metadata
if
db.DestroyOnDeplete.Value then
for _c,ac in pairs(cb:GetDescendants())do if ac:IsA("BasePart")then ac.Transparency=0
ac.CanCollide=true end end else for _c,ac in pairs(cb.DropPoints:GetChildren())do
ac.Value.Transparency=0 end end;self:DoEffect(cb,"Replenish")
ca:AddTag(cb.PrimaryPart,"attackable")end)
ab:connect("ResourceDepleted","OnClientEvent",function(cb)local db=cb.Parent.Metadata
if db.DestroyOnDeplete.Value then for _c,ac in
pairs(cb:GetDescendants())do
if ac:IsA("BasePart")then ac.Transparency=1;ac.CanCollide=false end end
self:DoEffect(cb,"Deplete")end;ca:RemoveTag(cb.PrimaryPart,"attackable")end)end;function ba:Init()_b=require(da.modules)ab=_b.load("network")
bb=_b.load("Thread")end;ba:Init()ba:Start()
return ba