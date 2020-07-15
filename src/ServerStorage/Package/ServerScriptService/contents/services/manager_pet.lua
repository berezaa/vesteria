local bd={}local cd=game:GetService("ReplicatedStorage")
local dd=require(cd.modules)local __a=dd.load("network")local a_a=dd.load("utilities")
local b_a=dd.load("physics")local c_a=dd.load("placeSetup")local d_a=dd.load("projectile")
local _aa=dd.load("mapping")local aaa=dd.load("levels")local baa=dd.load("pathfinding")
local caa=require(cd.itemData)local daa={}
local function _ba(cca)if daa[cca]then daa[cca].manifest:Destroy()daa[cca]=
nil end end
local function aba(cca,dca)
if not daa[cca]then
local _da=__a:invoke("{4761ABD9-42FB-4130-AB77-2EC70CD83955}",cca,dca.id,dca)local ada={}ada.id=dca.id;ada.manifest=_da;daa[cca]=ada end end
local function bba(cca,dca)for _da,ada in pairs(dca)do
if ada.position==_aa.equipmentPosition.pet then return ada end end;return nil end
local function cba(cca,dca)if dca and not daa[cca]then aba(cca,dca)elseif not dca and daa[cca]then
_ba(cca,dca)end end;local function dba(cca,dca)local _da=bba(cca,dca)cba(cca,_da)end
local function _ca(cca)local dca
do while not
dca and cca.Parent==game.Players do
dca=__a:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cca)wait(0.1)end end;if dca then dba(cca,dca.equipment)end end
local function aca(cca)if daa[cca]then _ba(cca)end;daa[cca]=nil end
local function bca()
for cca,dca in pairs(game.Players:GetPlayers())do _ca(dca)end;game.Players.PlayerAdded:connect(_ca)
game.Players.PlayerRemoving:connect(aca)
__a:connect("{04957DC0-5413-4615-AA71-FBE7E96AC10E}","Event",dba)end;spawn(bca)return bd