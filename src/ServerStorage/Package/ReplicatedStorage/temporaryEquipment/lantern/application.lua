
return
function(a)
if not a:FindFirstChild("LowerTorso")then return false end
if a:FindFirstChild("LANTERN_TEMP_EQUIP")then return false end;local b=script.Parent:Clone()
b.application:Destroy()b.Name="LANTERN_TEMP_EQUIP"
for d,_a in pairs(b:GetChildren())do if _a:IsA("BasePart")then
_a.CanCollide=false;_a.Anchored=false end end;local c=Instance.new("Motor6D")c.Part0=a.LowerTorso
c.Part1=b.Main
c.C1=

CFrame.new(a.LowerTorso.Size.X/2 -0.1,
b.Main.Size.Y/2,-0.15)*CFrame.Angles(0,0,0)*CFrame.Angles(0,0,math.pi/6)+Vector3.new(0,0.5,0)c.Parent=b.Main;b.Parent=a
warn("applying temporary equipment :angrycry:")end