local ca=game:GetService("ReplicatedStorage")
local da=require(ca.modules)local _b=da.load("placeSetup")
local ab=_b.getPlaceFolder("resourceNodes")
local function bb(_c)local ac=ab:FindFirstChild(_c)if not ac then
ac=Instance.new("Folder")ac.Name=_c;ac.Parent=ab end;return ac end
local cb={mining=function(_c)local ac=script.mining:Clone()ac.Name="attackableScript"
ac.Parent=_c.PrimaryPart end}local function db()
for _c,ac in pairs(cb)do local bc=bb(_c)bc.ChildAdded:Connect(ac)for cc,dc in
pairs(bc:GetChildren())do ac(dc)end end end
db()return{}