
for a,b in pairs{workspace,game.ServerStorage}do
for c,d in
pairs(b:GetDescendants())do
if d:IsA("BasePart")and d.Name=="seat"then d.Transparency=1;if
d:FindFirstChild("Decal")then d.Decal:Destroy()end end
if d:FindFirstChild("F2POnly")then if game.GameId==712031239 then d.Parent=game.Workspace else
d.Parent=game.ServerStorage end end
if d:FindFirstChild("PremiumOnly")then if game.GameId==833209132 then
d.Parent=game.Workspace else d.Parent=game.ServerStorage end end end end