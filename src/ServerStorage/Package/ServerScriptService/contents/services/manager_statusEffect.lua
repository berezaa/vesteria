local a_a={}local b_a=game:GetService("HttpService")
local c_a=game:GetService("ReplicatedStorage")local d_a=require(c_a.modules)local _aa=d_a.load("network")
local aaa=d_a.load("placeSetup")local baa=d_a.load("physics")local caa=d_a.load("utilities")
local daa=d_a.load("configuration")local _ba=d_a.load("terrainUtil")
local aba=require(c_a.statusEffectLookup)local bba={}local function cba(a_b)end
local function dba(a_b)local b_b={}
for c_b,d_b in pairs(bba)do if d_b.affecteeEntityGUID==a_b then
table.insert(b_b,d_b)end end;return b_b end
local function _ca(a_b,b_b)local c_b=caa.getEntityGUIDByEntityManifest(a_b)
if c_b then for d_b,_ab in pairs(bba)do
if
_ab.affecteeEntityGUID==c_b and _ab.sourceType==b_b then return true end end end;return false end
local function aca(a_b)local b_b=bba[a_b]table.remove(bba,a_b)
local c_b=aba[b_b.statusEffectType]
if c_b and c_b.onEnded_server then
local d_b=caa.getEntityManifestByEntityGUID(b_b.affecteeEntityGUID)if d_b then c_b.onEnded_server(b_b,d_b)end end end
local function bca(a_b)local b_b=dba(a_b)
local c_b=caa.getEntityManifestByEntityGUID(a_b)
if c_b and c_b:FindFirstChild("statusEffectsV2")then
local d_b,_ab=caa.safeJSONEncode(b_b)
if d_b then c_b.statusEffectsV2.Value=_ab
if c_b.Parent then
local aab=game.Players:GetPlayerFromCharacter(c_b.Parent)
if aab then
local bab=_aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",aab)if bab then
bab.nonSerializeData.playerDataChanged:Fire("statusEffects")end end end end end end
local function cca(a_b,b_b)local c_b=caa.getEntityGUIDByEntityManifest(a_b)
if c_b then
for i=#bba,1,-1 do
local d_b=bba[i]
if d_b.affecteeEntityGUID==c_b and d_b.sourceType==b_b then
local _ab=aba[d_b.statusEffectType]
if _ab._serverCleanupFunction then _ab._serverCleanupFunction(d_b,a_b)end;aca(i)bca(c_b)end end end;return false end
local function dca(a_b)if not a_b:FindFirstChild("entityGUID")then
warn("FAILED TO FIND PLAYER ENTITYGUID FOR STATUS EFFECTS PACKAGING")return false end
local b_b=a_b.entityGUID.Value;local c_b={}
for i=#bba,1,-1 do local d_b=bba[i]local _ab=aba[d_b.statusEffectType]
local aab=
(d_b.DO_NOT_SAVE)or(_ab and _ab.notSavedToPlayerData)if d_b.affecteeEntityGUID==b_b and not aab then aca(i)
table.insert(c_b,d_b)end end;return c_b end
local function _da(a_b,b_b)if not a_b:FindFirstChild("entityGUID")then
warn("FAILED TO FIND PLAYER ENTITYGUID")return false end
for c_b,d_b in pairs(b_b)do
d_b.affecteeEntityGUID=a_b.entityGUID.Value;table.insert(bba,d_b)end end
local function ada()
local a_b=daa.getConfigurationValue("activeStatusEffectTickTimePerSecond")
local function b_b()local aab={}local bab={}
for i=#bba,1,-1 do local cab=bba[i]
local dab,_bb=caa.getEntityManifestByEntityGUID(cab.affecteeEntityGUID)local abb=false
if dab then local bbb=aba[cab.statusEffectType]if bbb and bbb.execute then
bbb.execute(cab,dab,a_b)end
if cab.ticksMade then cab.ticksMade=cab.ticksMade+1;if
cab.ticksMade>=cab.ticksNeeded then aca(i)end;abb=true end elseif not _bb then abb=true;aca(i)end;if abb then local bbb=cab.affecteeEntityGUID
if bbb and not aab[bbb]then aab[bbb]=true end end end;for cab,dab in pairs(aab)do bca(cab)end end;local c_b=0;local d_b=1 /a_b;local function _ab(aab)c_b=c_b+aab
while c_b>d_b do c_b=c_b-d_b;b_b()end end
game:GetService("RunService").Heartbeat:Connect(_ab)end
local function bda(a_b,b_b,c_b,d_b,_ab,aab,bab)if not aba[b_b]then return false,"invalid status effect"end
local cab=daa.getConfigurationValue("activeStatusEffectTickTimePerSecond")local dab=caa.getEntityGUIDByEntityManifest(d_b)
local _bb=caa.getEntityGUIDByEntityManifest(a_b)local abb=aba[b_b]local bbb={}bbb.sourceType=_ab;bbb.sourceId=aab;if bab then
bbb.variant=bab end;bbb.sourceEntityGUID=dab;bbb.statusEffectType=b_b
bbb.statusEffectModifier=c_b;bbb.statusEffectGUID=b_a:GenerateGUID(false)
bbb.affecteeEntityGUID=_bb;bbb.timestamp=tick()
if bbb.statusEffectModifier.duration then bbb.ticksMade=0;bbb.ticksNeeded=
bbb.statusEffectModifier.duration*cab else bbb.isPermanent=true end;if abb.hideInStatusBar then bbb.hideInStatusBar=true end;if
bbb.statusEffectModifier.DO_NOT_SAVE then bbb.DO_NOT_SAVE=true end
if
bbb.statusEffectModifier.icon then bbb.icon=bbb.statusEffectModifier.icon else if(_ab~="item")and
(_ab~="ability")then bbb.icon=abb.image end end
for i=#bba,1,-1 do local cbb=bba[i]local dbb=cbb.sourceType==_ab
local _cb=cbb.sourceId==aab;local acb=cbb.affecteeEntityGUID==_bb
if dbb and _cb and acb then aca(i)end end
if abb._serverExecutionFunction then abb._serverExecutionFunction(bbb,a_b)end
if abb.onStarted_server then abb.onStarted_server(bbb,a_b)end;table.insert(bba,bbb)bca(_bb)if aab=="item"then
caa.playSound("item_buff",a_b)end;return true,bbb.statusEffectGUID end
_aa:create("{964385B0-1F06-4732-A494-F5D6F84ABC61}","BindableFunction","OnInvoke",bda)
local function cda(a_b)
for i=#bba,1,-1 do local b_b=bba[i]if b_b.statusEffectGUID==a_b then aca(i)
bca(b_b.affecteeEntityGUID)return true end end;return false end
_aa:create("{7598B3E9-CD41-4A4D-845C-1A19A35ACBFB}","BindableFunction","OnInvoke",cda)
local function dda(a_b,b_b)local c_b=a_b.Character;if not c_b then return end;local d_b=c_b.PrimaryPart
if not d_b then return end;local _ab=caa.getEntityGUIDByEntityManifest(d_b)
if not _ab then return end;if not _ba.isPointUnderwater(b_b)then return end
local aab=6 ^2;local bab=b_b-d_b.Position
local cab=bab.X^2 +bab.Y^2 +bab.Z^2;if cab>aab then return end;local dab=false
for index=#bba,1,-1 do local _bb=bba[index]if
_bb.affecteeEntityGUID==_ab then
if _bb.statusEffectType=="ablaze"then aca(index)dab=true end end end;if dab then bca(_ab)end end
_aa:create("{A7BDA262-3811-4DBB-9B06-CFEB16E25D3B}","RemoteEvent","OnServerEvent",dda)
local function __b()
_aa:create("{2A1ACCC4-EEC3-4808-A491-9E1808FE42A3}","BindableFunction","OnInvoke",cca)
_aa:create("{92229A3F-1BDF-4320-B433-0C162EC3491D}","BindableFunction","OnInvoke",_ca)
_aa:create("{743BBCD2-A0CD-415E-A96E-F6ED58AADD73}","BindableFunction","OnInvoke",function(a_b,b_b)if not a_b then return false end
local c_b=caa.getEntityGUIDByEntityManifest(a_b)if not c_b then return false end
local d_b=_aa:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",c_b)
for _ab,aab in pairs(d_b)do if aab.statusEffectType==b_b then return true,aab end end;return false end)
_aa:create("{5E232F74-B2D2-4ECA-8874-A7C3E681398C}","BindableFunction","OnInvoke",bca)
_aa:create("{D9E9266C-A8D0-478F-A0CF-A39D56B75ED8}","BindableFunction","OnInvoke",dca)
_aa:create("{717D2424-F19C-4CD6-B586-633A9D34A768}","BindableFunction","OnInvoke",_da)
_aa:create("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}","BindableFunction","OnInvoke",dba)
_aa:create("{525D23EC-4205-463F-9570-0244085FD9B6}","BindableFunction","OnInvoke",function(a_b)if not a_b then return false end
local b_b=caa.getEntityGUIDByEntityManifest(a_b)if not b_b then return false end
local c_b=_aa:invoke("{12EE4C27-216F-434F-A9C3-6771B8E6F6CF}",b_b)
for d_b,_ab in pairs(c_b)do if _ab.statusEffectType=="stunned"then return true end end;return false end)spawn(ada)end;__b()return a_a