local b=game.Players.LocalPlayer
if
b.PlayerScripts:FindFirstChild("assetsLoaded")==nil then
for c,d in
pairs(game.StarterPlayer.StarterPlayerScripts:GetChildren())do if b.PlayerScripts:FindFirstChild(d.Name)==nil then
d.Parent=b.PlayerScripts end end end