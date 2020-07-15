
local function b(c)local d=workspace.bowImposeModel
if
not c:FindFirstChild("AnimationController")then Instance.new("AnimationController",c)end
local _a=c.bottomCorner.CFrame:toObjectSpace(c.slackRopeRepresentation.CFrame)local aa=Instance.new("Attachment")aa.Position=Vector3.new(_a.X,
c.bottomCorner.Size.Y/2,_a.Z)
aa.Parent=c.bottomCorner
local ba=c.topCorner.CFrame:toObjectSpace(c.slackRopeRepresentation.CFrame)local ca=Instance.new("Attachment")
ca.Position=Vector3.new(ba.X,-
c.topCorner.Size.Y/2,ba.Z)ca.Parent=c.topCorner
local da=Instance.new("Attachment",c.slackRopeRepresentation)
for _b,ab in pairs(d:GetChildren())do
if ab:IsA("BasePart")then
for bb,cb in
pairs(ab:GetChildren())do
if cb:IsA("Motor6D")then print("copying Motor6D from",ab.Name)
local db=cb:Clone()db.Parent=c[ab.Name]
db.Part0=cb.Part0 and c[cb.Part0.Name]db.Part1=cb.Part1 and c[cb.Part1.Name]end end elseif ab:IsA("RopeConstraint")then
print("rigging RopeConstraint",ab.Name)
c[ab.Name].Attachment0=c[ab.Attachment0.Parent.Name].Attachment
c[ab.Name].Attachment1=c[ab.Attachment1.Parent.Name].Attachment end end end;b(game.Selection:Get()[1])