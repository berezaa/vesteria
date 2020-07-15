local b_a=4392820921;local c_a=4786304777;local d_a=4392552992;local _aa=2376885433
local aaa=game:GetService("CollectionService")local baa=game:GetService("InsertService")
local caa=game:GetService("Players")local daa=game:GetService("ReplicatedStorage")
local _ba=game:GetService("RunService")local aba=game:GetService("SoundService")
local bba=game:GetService("StarterPlayer")local cba=game:GetService("StarterGui")
local function dba(c_b)
local d_b=Instance.new("BoolValue")d_b.Name="assetsLoaded"d_b.Value=true;d_b.Parent=c_b end;local function _ca(c_b)
return c_b:FindFirstChild("assetsLoaded")~=nil end
local function aca(c_b)return


(c_b:FindFirstChild("protected")~=nil)or(c_b:FindFirstChild("Protected")~=nil)or(aaa:HasTag(c_b,"BootstrapperProtected"))end
local function bca()local c_b=Instance.new("Folder")c_b.Name="StarterGuiFolder"
c_b.Parent=game:GetService("ReplicatedStorage")
if game.PlaceId==_aa then dba(c_b)else for d_b,_ab in pairs(cba:GetChildren())do
_ab.Parent=c_b end end end
local function cca()bba.CameraMaxZoomDistance=60;bba.CameraMinZoomDistance=10
local c_b=bba:WaitForChild("StarterPlayerScripts")
if not _ca(c_b)then
for _ab,aab in pairs(c_b:GetChildren())do if
(aab.Name~="ChatScript")and(aab.Name~=
"BubbleChat")and(not aca(aab))then if aab:IsA("BaseScript")then aab.Disabled=true end
aab:Destroy()end end end
do local _ab=c_b:FindFirstChild("CameraScript")if _ab then
_ab.Disabled=true;_ab:Destroy()end
local aab=c_b:FindFirstChild("PlayerScriptsLoader")if aab then aab.Disabled=true;aab:Destroy()end
local bab=c_b:FindFirstChild("PlayerModule")if bab then bab:Destroy()end end;local d_b=bba:WaitForChild("StarterCharacterScripts")if not
_ca(d_b)then d_b:ClearAllChildren()end end
local function dca()
local c_b,d_b=pcall(function()aba.RespectFilteringEnabled=true end)if not c_b then
print("PackageUnpacker was unable to set SoundService.RespectFilteringEnabled. Reason:\n\n"..d_b)end end;local function _da()local c_b=Instance.new("BoolValue")c_b.Name="mirrorWorld"
c_b.Value=true;c_b.Parent=daa end
local function ada()
local c_b=(
game.PrivateServerId~=nil)and(game.PrivateServerId~=0)and(
game.PrivateServerId~="")
local d_b=(daa:FindFirstChild("excludeLatestVersion")~=nil)return c_b and(not d_b)end
local function bda()
local c_b=(daa:FindFirstChild("useLatestVersion")~=nil)return
c_b or ada()or _ba:IsStudio()or _ba:IsRunMode()end
local function cda()local c_b
if bda()then
print("PackageUnpacker is loading the staging data package...")c_b=d_a elseif game.GameId==712031239 then
print("PackageUnpacker is loading the free to play data package...")c_b=c_a else
print("PackageUnpacker is loading the production data package...")c_b=b_a end;local d_b
repeat
local aab,bab=pcall(function()d_b=baa:LoadAsset(c_b)end)
if not aab then
print("PackageUnpacker failed to acquire the data package. Reason:\n\n"..bab.."\n\nRetrying in one second...")wait(1)end until success;local _ab=d_b:GetChildren()[1]return _ab end
local function dda(c_b,d_b)
for _ab,aab in pairs(c_b:GetChildren())do
local bab=d_b:FindFirstChild(aab.Name)
if bab then
print("PackageUnpacker has overridden existing object "..bab:GetFullName())if bab:IsA("BaseScript")then bab.Disabled=true end
bab:Destroy()end;aab.Parent=d_b end end
local function __b(c_b)local d_b={}
local function _ab(bab)
for cab,dab in pairs(bab:GetDescendants())do
if dab:IsA("BaseScript")and
(not dab.Disabled)then if(dab.Name=="PACKAGEHANDLER")or
(dab.Name=="TELEPORTATION")then dab:Destroy()else dab.Disabled=true
table.insert(d_b,dab)end end end end
local function aab(bab,cab)if not _ca(cab)then _ab(bab)dda(bab,cab)end end
for bab,cab in pairs(c_b:GetChildren())do
if cab.Name=="StarterGui"then
aab(cab,daa:WaitForChild("StarterGuiFolder"))elseif cab.Name=="StarterPlayerScripts"then
aab(cab,bba:WaitForChild("StarterPlayerScripts"))elseif cab.Name=="StarterCharacterScripts"then
aab(cab,bba:WaitForChild("StarterCharacterScripts"))else local dab=game:GetService(cab.Name)
if dab then aab(cab,dab)else
print(
"PackageUnpacker attempted to unpack generic service \""..
cab.Name.."\" but could not find it. Was it supposed to be a special case?")end end end;for bab,cab in pairs(d_b)do cab.Disabled=false end end;local function a_b()
for c_b,d_b in pairs(caa:GetPlayers())do d_b:LoadCharacter()end end
local function b_b()bca()cca()dca()
caa.CharacterAutoLoads=false;if ada()then _da()end;__b(cda())caa.CharacterAutoLoads=true;a_b()end;b_b()