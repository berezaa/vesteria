local baa={}local caa=game:GetService("TeleportService")
local daa=game:GetService("HttpService")local _ba=game:GetService("ReplicatedStorage")
local aba=require(_ba.modules)local bba=aba.load("network")local cba=aba.load("placeSetup")
local dba=aba.load("physics")local _ca=aba.load("utilities")local aca=6;local bca={}local cca={}
local function dca(cbb)for dbb,_cb in pairs(bca)do
for acb,bcb in
pairs(_cb.members)do if bcb.player==cbb then return _cb,bcb end end end;return nil,nil end;local function _da(cbb)return dca(cbb)end;local function ada(cbb)local dbb=dca(cbb)
if dbb then return dbb.members end;return nil end
local function bda(cbb)
if cbb.isNew then
if cbb.removeIsNewNextPropogate then
cbb.isNew=false;cbb.removeIsNewNextPropogate=false else cbb.removeIsNewNextPropogate=true end end;for dbb,_cb in pairs(cbb.members)do
bba:fireClient("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}",_cb.player,cbb)end end;local cda={}
local function dda(cbb,dbb)local _cb,acb=dca(cbb)local bcb,ccb=dca(dbb)
if cbb~=dbb and not bcb then
if
not cda[cbb]or(tick()-cda[cbb]>3)then cda[cbb]=tick()
local dcb=daa:GenerateGUID(false)cca[dcb]={partyData=_cb,playerInviting=cbb,player=dbb}
bba:fireClient("{CCBCB53C-5971-4DAB-B1C7-DA15F8D4C8C9}",dbb,cbb,dcb)return true,"Invitation sent."else return false,"Sending invites too fast!"end end;return false,"Invalid player."end;local function __b(cbb)for dbb,_cb in pairs(bca)do if cbb==_cb then return true end end
return false end
local function a_b(cbb,dbb)local _cb=dca(cbb)
if not _cb then
local acb=cca[dbb]
if acb and acb.player==cbb then
if
__b(acb.partyData)or acb.partyData==nil then local bcb=dca(acb.playerInviting)
if
acb.playerInviting and acb.playerInviting.Parent then
if bcb then cca[dbb]=nil
if#bcb.members<aca then local ccb={}ccb.isLeader=false
ccb.isPowerUser=false;ccb.player=cbb;table.insert(bcb.members,ccb)
bcb.newestMember=ccb;local dcb=acb.playerInviting
bcb.status={text=cbb.Name..
" joined the party. (Invited by "..dcb.Name..")"}bda(bcb)return true,"Joined party"else return false,"Party is full"end else local ccb={}ccb.guid=daa:GenerateGUID(false)ccb.members={}local dcb={}
dcb.isLeader=false;dcb.isPowerUser=false;dcb.player=cbb
table.insert(ccb.members,dcb)ccb.newestMember=dcb;local _db={}_db.isLeader=true;_db.isPowerUser=true
_db.player=acb.playerInviting;table.insert(ccb.members,_db)
table.insert(bca,ccb)ccb.isNew=true
ccb.status={text=cbb.Name.." joined the party. (Invited by "..
acb.playerInviting.Name..")"}bda(ccb)return true,"Joined party"end else return false,"Invalid leader."end end end end;return nil,"eof"end
local function b_b(cbb)
for dbb,_cb in pairs(bca)do
if _cb==cbb then
if#_cb.members<=1 then
if#_cb.members==1 then
bba:fireClient("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}",_cb.members[1].player,
nil)_cb.members[1].player=nil;_cb.members[1]=nil
_cb.members={}end;table.remove(bca,dbb)end end end end
local function c_b(cbb,dbb)local _cb,acb=dca(cbb)
if _cb then
if dbb and acb and acb.isPowerUser then local bcb,ccb=dca(dbb)
if
bcb==_cb and not ccb.isLeader then
for dcb,_db in pairs(_cb.members)do
if _db.player==dbb then
table.remove(_cb.members,dcb)_cb.newestMember=nil;if cbb==dbb then
_cb.status={text=cbb.Name.." left the party."}else
_cb.status={text=dbb.Name.." was kicked from the party."}end;bda(_cb)bba:fireClient("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}",dbb,
nil)
b_b(_cb)return true end end end elseif not dbb then
for bcb,ccb in pairs(_cb.members)do
if ccb.player==cbb then
table.remove(_cb.members,bcb)_cb.newestMember=nil
_cb.status={text=cbb.Name.." left the party."}bda(_cb)
bba:fireClient("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}",cbb,nil)b_b(_cb)return true end end else end end;return false end
local function d_b(cbb,dbb)local _cb,acb=dca(cbb)
if _cb and acb.isLeader and dbb and
dbb:FindFirstChild("teleportDestination")then
if _cb.teleportState=="none"or
_cb.teleportState==nil then _cb.teleportState="pending"
_cb.teleportDestination=dbb.teleportDestination.Value;_cb.status=nil;_cb.teleportPosition=dbb.Position;_cb.teleportPart=dbb
bda(_cb)
spawn(function()
while _cb.teleportState=="pending"and cbb.Parent do local bcb=true
for ccb,dcb in
pairs(_cb.members)do
if not dcb.player.Character or
not dcb.player.Character.PrimaryPart or
_ca.magnitude(
dcb.player.Character.PrimaryPart.Position-dbb.Position)>20 then
bcb=false end end
if bcb then _cb.teleportState="teleporting"break else wait(1 /2)end end
if _cb.teleportState=="teleporting"then bda(_cb)local bcb=tick()local ccb=true
while
tick()-bcb<15 and ccb do ccb=false;for cdb,ddb in pairs(_cb.members)do if not ddb.isReadyToTeleport then
ccb=true end end;if ccb then
wait(1 /4)end end;local dcb={}local _db=0;for cdb,ddb in pairs(_cb.members)do
if ddb.isReadyToTeleport then
table.insert(dcb,ddb.player)if ddb.isLeader then _db=ddb.player.userId end end end
local adb=false;local bdb={}
for cdb,ddb in pairs(dcb)do if ddb:FindFirstChild("DataSaveFailed")then adb=true
table.insert(bdb,ddb)end end
if adb then local cdb="Teleport failed: "
for ddb,__c in pairs(bdb)do cdb=cdb..__c.Name..
(bdb[ddb+1]and", "or"")end
cdb=cdb.." "..
(#bdb==1 and"is"or"are").." experiencing a DataStore outage."
_cb.status={text=cdb,textColor3=Color3.fromRGB(255,57,60)}_cb.teleportState="none"bda(_cb)return false,"Datastore outage."end
if#dcb>0 and _db then
local cdb,ddb=bba:invoke("{3CF9481C-6B35-4D71-B2CE-FAD7DE6716B1}",dcb,dbb.teleportDestination.Value,_db)return cdb,ddb else
warn("manager_party::no leader or no one ready")end end end)return true end end;return false end;local function _ab(cbb)
for dbb,_cb in pairs(bca)do if _cb.guid==cbb then return _cb end end;return nil end;local function aab(cbb)for dbb,_cb in
pairs(cbb.members)do if _cb.isLeader then return _cb end end
return nil end
local function bab(cbb,dbb,_cb)if
not dbb or not _cb then return end;local acb=_ab(dbb)
if not acb then local bcb=cbb:GetJoinData()
local ccb={}ccb.guid=dbb;ccb.isTeleportParty=true;ccb.partyLeaderUserId=_cb
ccb.members={}local dcb={}dcb.isLeader=cbb.userId==_cb;dcb.isPowerUser=true
dcb.player=cbb;table.insert(ccb.members,dcb)
table.insert(bca,ccb)bda(ccb)elseif acb and acb.isTeleportParty then local bcb={}
bcb.isLeader=acb.partyLeaderUserId==cbb.userId;bcb.isPowerUser=true;bcb.player=cbb
table.insert(acb.members,bcb)bda(acb)end end
bba:create("{B72FD5E1-83AD-4FB2-A8A0-B93945527CE6}","BindableFunction","OnInvoke",bab)
bba:create("{5DFABB0B-88B1-42D8-B9A5-B42E5190FE3B}","RemoteFunction","OnServerInvoke",function()
warn("playerRequest_acceptMyPartyInvitationByTeleportation has been moved to the server.")end)
local function cab(cbb)local dbb,_cb=dca(cbb)if dbb and dbb.teleportState=="pending"then
dbb.teleportState="none"bda(dbb)end end;local function dab(cbb)local dbb,_cb=dca(cbb)
if dbb and _cb then _cb.isReadyToTeleport=true end end;local function _bb(cbb)
local dbb=cbb:GetJoinData()end
local function abb(cbb)cda[cbb]=nil
if cbb:FindFirstChild("teleporting")==
nil then local dbb,_cb=dca(cbb)
if dbb then
for acb,bcb in pairs(dbb.members)do
if bcb.player==cbb then
table.remove(dbb.members,acb)if bcb.isLeader then
if dbb.members[1]then dbb.members[1].isLeader=true end end;dbb.newestMember=nil;dbb.status={text=cbb.Name..
" left the party."}bda(dbb)
b_b(dbb)return true end end end end end
local function bbb()game.Players.PlayerAdded:connect(_bb)for cbb,dbb in
pairs(game.Players:GetPlayers())do _bb(dbb)end
game.Players.PlayerRemoving:connect(abb)
bba:create("{1E3EA8F8-D41E-4286-AC46-CB5E0A373F94}","RemoteFunction","OnServerInvoke",ada)
bba:create("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}","RemoteFunction","OnServerInvoke",_da)
bba:create("{AB032646-DB09-4482-B67B-0F1EA25F97EF}","RemoteFunction","OnServerInvoke",dda)
bba:create("{936CA026-12FD-4855-A76F-072C1F16E9AD}","RemoteFunction","OnServerInvoke",a_b)
bba:create("{8E8FADC7-1F67-4F9B-BD17-CD405776FEFC}","RemoteFunction","OnServerInvoke",c_b)
bba:create("{C8FF76F3-4805-4CB9-8AD8-BF8F5539EDE0}","RemoteFunction","OnServerInvoke",d_b)
bba:create("{FDAD7B5A-1DB0-4879-9677-FA4C0DEDB98D}","RemoteFunction","OnServerInvoke",cab)
bba:create("{0BE6B8D2-2216-4FA3-9DF9-09EE98D714DF}","RemoteEvent","OnServerEvent",dab)
bba:create("{312290ED-5E69-4F68-B25D-503E29A1CE28}","BindableFunction","OnInvoke",dca)
bba:create("{CCBCB53C-5971-4DAB-B1C7-DA15F8D4C8C9}","RemoteEvent")
bba:create("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}","RemoteEvent")end;bbb()return baa