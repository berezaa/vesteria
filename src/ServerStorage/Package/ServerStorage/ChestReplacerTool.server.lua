
function convertToNewChest(a)local b=a:FindFirstChild("Bottom")if not b then
warn("Chest ["..a:GetFullName()..
"] does not have a bottom! Is it already converted?")return a end;local c=b.CFrame*CFrame.new(0,-
b.Size.Y/2,0)
local d=Instance.new("Model")local _a=Instance.new("Part")
_a.BrickColor=BrickColor.new("Bright orange")_a.Anchored=true;_a.CanCollide=false
_a.RightSurface=Enum.SurfaceType.Weld;_a.Size=Vector3.new(3.5,4,6)_a.CFrame=c*
CFrame.new(0,_a.Size.Y/2,0)_a.Name="RootPart"_a.Parent=d
d.PrimaryPart=_a
local aa=
a:FindFirstChild("inventory")or a:FindFirstChild("ironChest")or a:FindFirstChild("goldChest")
if aa then
if aa.Name=="goldChest"then local ba=Instance.new("ModuleScript")
ba.Source="return { chestModel = \"goldChest\" }"ba.Name="chestProps"ba.Parent=d
_a.BrickColor=BrickColor.new("Gold")elseif aa.Name=="ironChest"then local ba=Instance.new("ModuleScript")
ba.Source="return { chestModel = \"ironChest\" }"ba.Name="chestProps"ba.Parent=d
_a.BrickColor=BrickColor.new("Fossil")end;aa.Parent=d end
if a:FindFirstChild("chestLevel")then a.chestLevel.Parent=d end
if a:FindFirstChild("minLevel")then a.minLevel.Parent=d end;d.Parent=a.Parent;d.Name=a.Name
game:GetService("CollectionService"):AddTag(d,"treasureChest")a:Destroy()return d end
function fixGoldAndIronChests(a)local b=a.PrimaryPart;if not b then
warn("Chest ["..
a:GetFullName().."] does not have a PrimaryPart! Check on it!")return end
local c=
a:FindFirstChild("inventory")or a:FindFirstChild("ironChest")or
a:FindFirstChild("goldChest")local d=a:FindFirstChild("chestProps")
if c and not d then
if
c.Name=="goldChest"then local _a=Instance.new("ModuleScript")
_a.Source="return { chestModel = \"goldChest\" }"_a.Name="chestProps"_a.Parent=a
b.BrickColor=BrickColor.new("Gold")elseif c.Name=="ironChest"then local _a=Instance.new("ModuleScript")
_a.Source="return { chestModel = \"ironChest\" }"_a.Name="chestProps"_a.Parent=a
b.BrickColor=BrickColor.new("Fossil")end end end
for a,b in pairs(workspace:GetChildren())do
if b:FindFirstChild("chestLevel")then
print(
"Converting ["..b:GetFullName().."] ...")local c=convertToNewChest(b)fixGoldAndIronChests(c)end end