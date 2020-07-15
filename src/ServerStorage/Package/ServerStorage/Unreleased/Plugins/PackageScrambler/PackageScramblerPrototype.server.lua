local ab=plugin;local bb=game:GetService("RunService")
local cb=game:GetService("HttpService")local db=require(ab.PackageScrambler.minify)local _c={}local function ac()
print(
"[[["..string.rep("-",48).."]]]")end
local function bc(ad)local bd=[[network:create%(".-"]]
while true do
local cd,dd=ad:find(bd)if not cd then break end;local __a=ad:sub(cd,dd)
local a_a=__a:match([[".-"]])local b_a=a_a:sub(2,-2)_c[b_a]=cb:GenerateGUID()
ad=ad:sub(dd+1)end end
local function cc(ad)local bd=ad.Source;local cd
print("In script "..ad:GetFullName()..":")
for dd,__a in pairs(_c)do
bd,cd=bd:gsub("\""..dd.."\"","\""..__a.."\"")if cd>0 then
print("\tReplaced "..cd.." instance"..
(cd>1 and"s"or"").." of \""..dd.."\"")end end;return bd end
local function dc()ac()print()
print("Preparing package. Please wait, this takes a minute...")print()wait(1)local ad=Instance.new("Folder")
ad.Name="Package"
local bd={game:GetService("ReplicatedStorage"),game:GetService("ServerStorage"),game:GetService("ServerScriptService"),game:GetService("StarterGui"),game:GetService("StarterPlayer").StarterPlayerScripts,game:GetService("StarterPlayer").StarterCharacterScripts,game:GetService("StarterPack"),game:GetService("Chat")}
for dd,__a in pairs(bd)do local a_a=Instance.new("Folder")a_a.Name=__a.Name
a_a.Parent=ad
for b_a,c_a in pairs(__a:GetChildren())do c_a:Clone().Parent=a_a end end
do local dd=Instance.new("Folder")dd.Name="StarterPlayer"
dd.Parent=ad
for __a,a_a in
pairs(game:GetService("StarterPlayer"):GetChildren())do if(not a_a:IsA("StarterPlayerScripts"))and(not
a_a:IsA("StarterCharacterScripts"))then
a_a:Clone().Parent=dd end end end;local cd={}
for dd,__a in pairs(ad:GetDescendants())do if __a:IsA("LuaSourceContainer")then
table.insert(cd,__a)end end
print("Found "..#cd.." scripts. Scrambling...")for dd,__a in pairs(cd)do bc(__a.Source)end
for dd,__a in pairs(cd)do local a_a=cc(__a)
local b_a,c_a=db(a_a)if b_a then __a.Source=c_a else
print("Failed to minify script "..__a:GetFullName())end end;ad.Parent=game.ServerStorage;game.Selection:Set{ad}
ab:SaveSelectedToRoblox()
print("Package prepped for upload. Don't forget to delete the package from ServerStorage when you're done with it!")print()ac()end
local function _d()if not bb:IsStudio()then return end
local ad=ab:CreateToolbar("Vesteria Utilities")
local bd=ad:CreateButton("pack","Pack up Vesteria's data, scramble it, and upload it.","","Pack + Scramble")bd.Click:Connect(dc)end;_d()