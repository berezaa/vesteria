local _b={}local ab=game.Players.LocalPlayer
local bb=game:GetService("ReplicatedStorage")local cb=require(bb.modules)local db=cb.load("network")
local _c=cb.load("tween")local ac={}
local function bc(dc,_d)
if game.CollectionService:HasTag(dc,"ActivePart")then
game.CollectionService:RemoveTag(dc,"ActivePart")
spawn(function()wait(0.1)
game.CollectionService:AddTag(dc,"ActivePart")end)
if ab.Character and ab.Character.PrimaryPart and
dc:FindFirstChild("HitDebounce")==nil and
_d:IsDescendantOf(ab.Character)then for ad,bd in pairs(ac)do if bd==dc then
return end end
if
game.CollectionService:HasTag(dc,"Bounce")then local ad=dc.Size
local bd=(ab.Character.PrimaryPart.Position-dc.position).unit
if math.abs(bd.X)<0.2 then bd=Vector3.new(0,bd.Y,bd.Z)end
if math.abs(bd.Y)<0.2 then bd=Vector3.new(bd.X,0,bd.Z)end
if math.abs(bd.Z)<0.2 then bd=Vector3.new(bd.X,bd.Y,0)end;local cd=1 + ( (ad.X*ad.Y*ad.Z)^ (1 /3))
local dd=game.ReplicatedStorage.sounds:FindFirstChild("bounce")
if dd then local __a=Instance.new("Sound")for a_a,b_a in
pairs(game.HttpService:JSONDecode(dd.Value))do __a[a_a]=b_a end;__a.PlaybackSpeed=math.clamp(1.5 -
cd/50,0.5,1.5)
__a.Volume=math.clamp(cd/25,0.2,2)__a.Parent=dc;__a:Play()
game.Debris:AddItem(__a,10)end
spawn(function()local __a=dc.Size;table.insert(ac,dc)
_c(dc,{"Size"},{__a*1.5},.3,Enum.EasingStyle.Quad)wait(.3)
_c(dc,{"Size"},{__a},.7,Enum.EasingStyle.Bounce)wait(.7)for a_a,b_a in pairs(ac)do
if b_a==dc then table.remove(ac,a_a)end end end)
db:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",bd*cd*15)elseif dc.Name=="shopPart"then
db:invoke("{D839BF28-4985-4BB5-86EF-DCD6824CF09F}")end end end end
db:create("{14A8A03B-76C4-47BC-8191-E79E7C849059}","BindableEvent","Event",bc)
local function cc(dc)
if dc:IsA("BasePart")then
if

(dc.Parent.Name=="shroom"or dc.Parent.Name=="Flower")and dc.Parent:FindFirstChild("Destroyed")==nil then local _d=dc.Size
if _d.X*_d.Y*_d.Z<=25 then
game.CollectionService:AddTag(dc,"Destroyable")dc.CanCollide=false elseif dc.Name=="MushPart"then
game.CollectionService:AddTag(dc,"Bounce")
game.CollectionService:AddTag(dc,"ActivePart")dc.CanCollide=true end elseif dc.Name=="shopPart"then
game.CollectionService:AddTag(dc,"ActivePart")end end
if game.CollectionService:HasTag(dc,"ActivePart")then dc.Touched:connect(function(_d)
bc(dc,_d)end)end end
spawn(function()
for dc,_d in pairs(workspace:GetDescendants())do cc(_d)end;workspace.DescendantAdded:connect(cc)end)return _b