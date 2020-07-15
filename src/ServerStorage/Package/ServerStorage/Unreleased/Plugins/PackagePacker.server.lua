local aa=plugin;local ba=game:GetService("RunService")
local function ca()print("[[["..
string.rep("-",48).."]]]")end
local function da()ca()print()
print("Preparing package. Please wait, this takes a minute...")print()wait(1)local ab=Instance.new("Folder")
ab.Name="Package"
local bb={game:GetService("ReplicatedStorage"),game:GetService("ServerStorage"),game:GetService("ServerScriptService"),game:GetService("StarterGui"),game:GetService("StarterPlayer").StarterPlayerScripts,game:GetService("StarterPlayer").StarterCharacterScripts,game:GetService("StarterPack"),game:GetService("Chat")}
for cb,db in pairs(bb)do local _c=Instance.new("Folder")_c.Name=db.Name
_c.Parent=ab
for ac,bc in pairs(db:GetChildren())do bc:Clone().Parent=_c end end
do local cb=Instance.new("Folder")cb.Name="StarterPlayer"
cb.Parent=ab
for db,_c in
pairs(game:GetService("StarterPlayer"):GetChildren())do if(not _c:IsA("StarterPlayerScripts"))and(not
_c:IsA("StarterCharacterScripts"))then
_c:Clone().Parent=cb end end end;ab.Parent=game.ServerStorage;game.Selection:Set{ab}
aa:SaveSelectedToRoblox()
print("Package prepped for upload. Don't forget to delete the package from ServerStorage when you're done with it!")print()ca()end
local function _b()if not ba:IsStudio()then return end
local ab=aa:CreateToolbar("Vesteria Utilities")
local bb=ab:CreateButton("pack","Pack up Vesteria's data and upload it.","","Pack")bb.Click:Connect(da)end;_b()