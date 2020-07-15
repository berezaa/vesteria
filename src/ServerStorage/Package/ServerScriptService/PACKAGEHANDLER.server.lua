local aa={}local ba=2043195291;local ca=2043195763
local da={StarterGui=2043190255,ServerStorage=2043190872,ServerScriptService=2043191391,ReplicatedStorage=2043191868,StarterPlayer=2043196240,StarterPack=2043196774}local _b=game:GetService("InsertService")
for ab,bb in pairs(da)do
if game[ab]and
game[ab]:FindFirstChild("assetsLoaded")==nil then
local cb,db=pcall(function()
local _c=_b:LoadAssetVersion(_b:GetLatestAssetVersionAsync(bb))
if _c then
for ac,bc in pairs(_c:GetDescendants())do
if bc:IsA("Script")or bc:IsA("LocalScript")and not
bc.Disabled then
if
bc.Name=="PACKAGEHANDLER"then bc:Destroy()else bc.Disabled=true;table.insert(aa,bc)end end end
for ac,bc in pairs(_c:GetChildren())do bc.Parent=game[ab]end;_c:Destroy()end end)if not cb then
warn(ab," failed to load contents from InsertService!")end end end;for ab,bb in pairs(aa)do bb.Disabled=false end;for ab,bb in
pairs(game.Players:GetPlayers())do bb:LoadCharacter()end