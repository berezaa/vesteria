local cd={}local dd=game:GetService("HttpService")
local __a=game:GetService("ReplicatedStorage")local a_a=require(__a.modules)local b_a=a_a.load("network")
local c_a=a_a.load("utilities")local d_a=a_a.load("ability_utilities")
local _aa=require(__a.abilityLookup)local aaa={}local baa={}local caa={}local daa=0.25;local _ba=100
local aba={id=0,name="Test Ability",image="rbxassetid://2528903781",description="This is just a test",execution={windupTime=0,animationName=""},statistics={abilityType="",abilityTypeData={},damaging=false,damage=0,maxLevel=0,manaCost=0,cooldown=0,increasingStat="",increaseExponent=0},prerequisites={playerLevel=0,playerClass="",classRestriction=false,developerOnly=false,abilities={}}}local bba={level=1,experience=0}
local function cba(_da)if _da.userId then aaa[_da]={}end end;local function dba(_da)aaa[_da]=nil end;local function _ca(_da,ada,bda)
if baa[_da]and baa[_da][ada]and
baa[_da][ada][bda]then return baa[_da][ada][bda]end;return false end
local function aca(_da,ada)if
aaa[_da]~=nil and aaa[_da][ada]~=nil then
aaa[_da][ada]=nil end end
local function bca(_da,ada,bda)local cda=tick()if not _da or not _da.PrimaryPart or not
c_a.isEntityManifestValid(_da.PrimaryPart)then
return"invalid_character"end;local dda=nil
local __b=game.Players:GetPlayerFromCharacter(_da)if __b then
dda=b_a:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",__b)else end;local a_b=bda.abilityId
local b_b=bda.abilityGuid;local c_b=_aa[a_b]if not dda or not c_b then return"failed"end
if
ada=="begin"then
if baa[__b][a_b]==nil then bda["state"]=ada;bda["guid"]=b_b
local d_b=c_b.statistics.manaCost;local _ab=c_b.statistics.cooldown
bda["ability-statistics"]=c_b;local aab,bab=d_a.calculateStats(dda,a_b)if aab and bab then end
if
__b.Character.PrimaryPart.mana.Value<d_b then return false,"lacking_mana"end;if aaa[__b]and(not aaa[__b][a_b]or
(tick()-aaa[__b][a_b])>= (_ab-daa))then
return false,"on_cooldown"end
if baa[__b][a_b]and
baa[__b][a_b][b_b]then return false,"already_begun"end;__b.Character.PrimaryPart.mana.Value=(
__b.Character.PrimaryPart.mana.Value-d_b)
local cab=bda.castTick()aaa[__b][a_b]=cda;c_b:execute_server()
local dab=c_a.returnNearbyPlayers(__b.Character.PrimaryPart.CFrame,_ba)if dab then
b_a:fireClients("replicateAbilityLocally",dab,bda,false)end else
warn("Ability already casted, player is attempting to re-cast from remote. Possible Exploiter or False Positive")end elseif ada=="update"then elseif ada=="end"then if baa[__b][a_b][b_b]~=nil then baa[__b][a_b][b_b]=
nil end end end;local function cca()end
local function dca()
game.Players.PlayerAdded:Connect(cba)
game.Players.PlayerRemoving:Connect(dba)
b_a:create("requestAbilityStateUpdate","RemoteEvent","OnServerEvent",bca)
b_a:create("validateAbilityGUID","RemoteFunction","OnServerInvoke",_ca)
b_a:create("resetAbilityCooldown","BindableEvent","Event",aca)end;spawn(dca)return cd