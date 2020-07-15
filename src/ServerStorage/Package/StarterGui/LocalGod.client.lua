
repeat wait()until script.Parent:FindFirstChild("gameUI")script.Parent.gameUI.Enabled=false;local cb={}local db="setup"
wait(0.1)
game.Players.LocalPlayer.PlayerGui:SetTopbarTransparency(1)local _c=game:GetService("ReplicatedStorage")
local ac=require(_c.modules)
local bc={"network","utilities","levels","tween","ability_utilities","mapping","placeSetup","projectile","configuration","economy","events","enchantment","localization"}local cc={}local dc;local function _d(...)local __a=...
spawn(function()error(__a)end)end
local function ad(__a)
local a_a,b_a=pcall(function()cb[__a.Name]=require(__a)end)if not a_a then
_d("Error requiring module "..__a.Name.."! Module failed to load")_d(b_a)end end
local function bd(__a)if __a:IsA("ModuleScript")then dc=__a.Name;ad(__a)end;for a_a,b_a in
pairs(__a:GetChildren())do bd(b_a)end end
local function cd()db="requiring"local __a=tick()cb.HasFinished=false;bd(script.Parent)for b_a,c_a in
pairs(bc)do cb[c_a]=ac.load(c_a)cc[c_a]=true end
local a_a={}__a=tick()
for b_a,c_a in pairs(cb)do
if c_a and cc[b_a]==nil and c_a["init"]then
db="init"local d_a=tick()dc=b_a;local _aa,aaa=pcall(c_a.init,cb)
if _aa then
local baa=tick()-d_a;if baa>0.1 then end else _d(b_a.." Error: "..aaa)end end;if c_a and cc[b_a]==nil and c_a["postInit"]then
a_a[b_a]=c_a["postInit"]end end
for b_a,c_a in pairs(a_a)do db="postinit"local d_a=tick()dc=b_a;c_a(cb)end;cb.HasFinished=true
print("------------------------------------------------------------")
print("If you see any errors BELOW THIS POINT, please report them to the dev.")
print("-----------------------------------------------------------")end;local dd=tick()spawn(cd)
repeat wait()until cb.HasFinished or tick()-dd>10;if not cb.HasFinished then
error(
"Module loading got stuck on ".. (dc or"???").." "..db or"???")end
script.Parent.gameUI.Enabled=true;wait(1)