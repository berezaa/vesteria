local a_b=game:GetService("HttpService")
local b_b=game:GetService("TeleportService")local c_b=game:GetService("ReplicatedStorage")
local d_b=require(c_b.modules)local _ab=d_b.load("network")local aab=d_b.load("utilities")
local bab=d_b.load("configuration")local cab={}local dab={member=1,officer=2,general=3,leader=4}
local function _bb(a_d)return dab[a_d]end
_ab:create("{94AC3EAB-26B8-4F63-B824-AD872ABD0E10}","BindableFunction","OnInvoke",_bb)local abb=5
local bbb=game:GetService("DataStoreService"):GetDataStore("guildNames")
local cbb={createGuild=1e6,level={[1]={members=10},[2]={members=20,cost=10e6},[3]={members=40,cost=100e6},[4]={members=80,cost=1e9},[5]={members=140,cost=10e9}}}local dbb=Instance.new("Folder")dbb.Name="guildDataFolder"
dbb.Parent=game.ReplicatedStorage;local _cb=game:GetService("MessagingService")local acb={}local bcb={}
_ab:create("{9590082C-4DE4-47CD-8548-28FED87E836A}","RemoteEvent")
local function ccb(a_d,b_d)acb[a_d]=b_d;local c_d=dbb:FindFirstChild(a_d)if c_d==nil then
c_d=Instance.new("StringValue")c_d.Name=a_d;c_d.Parent=dbb end
c_d.Value=a_b:JSONEncode(b_d)
for d_d,_ad in pairs(game.Players:GetPlayers())do if
_ad:FindFirstChild("guildId")and _ad.guildId.Value==a_d then
_ab:fireClient("{9590082C-4DE4-47CD-8548-28FED87E836A}",_ad,b_d)end end end
local function dcb(a_d,b_d)local c_d=b_d.Data;local d_d=b_d.Sent
if c_d.messageType=="chat"then local _ad=c_d.sender
local aad=c_d.message
for bad,cad in pairs(game.Players:GetPlayers())do
if
cad:FindFirstChild("guildId")and cad.guildId.Value==a_d then local dad="[Guild] ".._ad..
": "..c_d.message
_ab:fireClient("{006F08C2-1541-41ED-90BE-192482E14530}",cad,{Text=dad,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(160,116,255)})end end elseif c_d.messageType=="data_update"then local _ad=acb[a_d]if _ad then _ad.lastUpdated=d_d
_ad[c_d.key]=c_d.value;ccb(a_d,_ad)end elseif
c_d.messageType=="member_data"then local _ad=acb[a_d]if _ad then local aad=c_d.userId
_ad.members[tostring(aad)]=c_d.memberData;ccb(a_d,_ad)end end
if c_d.notice then local _ad=c_d.sender or"???"
if
game.Players:FindFirstChild(_ad)==nil or not c_d.notice.Out then if
c_d.notice.Color then
c_d.notice.Color=Color3.fromRGB(c_d.notice.Color.r,c_d.notice.Color.g,c_d.notice.Color.b)end
for aad,bad in
pairs(game.Players:GetPlayers())do if
bad:FindFirstChild("guildId")and bad.guildId.Value==a_d then
_ab:fireClient("{006F08C2-1541-41ED-90BE-192482E14530}",bad,c_d.notice)end end end end end;local function _db(a_d,b_d)
local c_d,d_d=pcall(function()_cb:PublishAsync("guild-"..a_d,b_d)end)return c_d,d_d end
_ab:create("{48D8AB3E-9206-407F-A7C9-4A1A173D8C2E}","BindableFunction","OnInvoke",_db)
local function adb(a_d,b_d)
local c_d=a_d:FindFirstChild("guildId")and a_d.guildId.Value
if c_d and c_d~=""then local d_d
local _ad,aad=pcall(function()
d_d=game.Chat:FilterStringForBroadcast(b_d,a_d)end)
if not _ad then return false,"filter error: "..aad elseif#d_d>200 then return false,
"Message may not be longer than 200 characters."elseif#d_d<2 then
return false,"Message must be at least 2 characters long"end;return
_db(c_d,{messageType="chat",sender=a_d.Name,senderId=a_d.userId,message=d_d})else return false,"You're not in a guild!"end end
_ab:create("{3F92CCFE-DCB7-4562-B0B9-29CEEC621B81}","BindableFunction","OnInvoke",adb)
local function bdb(a_d,b_d)
if a_d:FindFirstChild("guildId")then a_d.guildId.Value=b_d or""end
local c_d=_ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",a_d)if c_d and c_d.globalData then c_d.globalData.guildId=b_d
c_d.nonSerializeData.setPlayerData("globalData",c_d.globalData)end end
local function cdb(a_d,b_d)if b_d==""then return nil end;local c_d=acb[b_d]
if c_d then return c_d else
local d_d=game:GetService("DataStoreService"):GetDataStore("guild",b_d)
local _ad,aad=pcall(function()c_d=d_d:GetAsync("guildData")end)
if _ad then
if c_d then local bad=c_d.members;if
bad and(not bad[tostring(a_d.UserId)])then bdb(a_d,nil)return nil end
ccb(b_d,c_d)return c_d else bdb(a_d,nil)return nil end else
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Guild Get Fail: ".. (aad or"???"))end end end
_ab:create("{E27BCFB9-6E3A-43F2-B2B7-5DCE385BD801}","BindableFunction","OnInvoke",cdb)
_ab:create("{C402DDE8-9E32-4EC1-8C38-4B07B3A7F2FB}","RemoteFunction","OnServerInvoke",function(a_d,b_d)
local c_d=b_d:FindFirstChild("guildId")if not c_d then return false,"No guildId found."end;return
cdb(b_d,c_d.Value)end)
local function ddb(a_d,b_d)local c_d=cdb(a_d,b_d)
if c_d==nil then return false,"Guild data not found."end;local d_d=c_d.members;local _ad=d_d[tostring(a_d.userId)]if
_ad==nil then return false,"Not a member of guild."end;return _ad end
_ab:create("{7EFA8F01-8D3D-4C15-89E1-4C0D30C3C32C}","BindableFunction","OnInvoke",ddb)
_ab:create("{577F6AD7-4F84-498A-9017-2915402E9F92}","RemoteFunction","OnServerInvoke",function(a_d,b_d)
local c_d=b_d:FindFirstChild("guildId")if not c_d then return false,"No guildId found."end;return
ddb(b_d,c_d.Value)end)
local function __c(a_d,b_d,c_d,d_d,_ad,aad,bad)c_d=c_d or"set"local cad=cdb(a_d,b_d)
if cad==nil then return false,"No guild data."end
if os.time()-cad.lastModified>=abb then
local dad=game:GetService("DataStoreService"):GetDataStore("guild",b_d)local _bd
local abd,bbd=pcall(function()
dad:UpdateAsync("guildData",function(cbd)
if aad then cad.lastModified=os.time()cbd=cad end
if c_d=="increment"then cbd[d_d]=(cbd[d_d]or 0)+_ad elseif c_d=="set"then
cbd[d_d]=_ad else _bd="Invalid operation"return nil end;ccb(b_d,cbd)return cbd end)end)
if not abd then
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Failed to update guild value: "..bbd)return false,"DataStore error"elseif _bd then return false,_bd else return true,"Success!"end else return false,"Try again later."end end
local function a_c(a_d)acb[a_d]=nil
if bcb[a_d]then bcb[a_d]:Disconnect()bcb[a_d]=nil end;local b_d=dbb:FindFirstChild(a_d)
if b_d then b_d:Destroy()end end
local function b_c(a_d)
if bcb[a_d]then return false,"Guild subscription already exists."end
if acb[a_d]==nil then return false,"Guild data does not exist."end
local b_d,c_d=pcall(function()
local d_d=_cb:SubscribeAsync("guild-"..a_d,function(_ad)dcb(a_d,_ad)end)bcb[a_d]=d_d end)if b_d then return true,"Subscribed!"else return false,c_d end end
local function c_c(a_d,b_d)local c_d={}if b_d then c_d[b_d]=true end;if b_d and not acb[b_d]then
cdb(a_d,b_d)end
for d_d,_ad in pairs(game.Players:GetPlayers())do
if


_ad~=a_d and _ad:FindFirstChild("teleporting")==nil and _ad:FindFirstChild("DataSaveFailed")==nil then local aad=_ad:FindFirstChild("guildId")if aad and aad.Value~=""then
c_d[aad.Value]=true end end end
for d_d,_ad in pairs(acb)do if not c_d[d_d]then a_c(d_d)end end
for d_d,_ad in pairs(c_d)do
if _ad and bcb[d_d]==nil then local aad=acb[d_d]
if aad then local bad,cad=b_c(b_d)if
not bad then
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Failed to build guild subscription: "..cad)end else
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"critical","Attempt to build subscription for guild with no data!")return end end end end;local function d_c(a_d)
if a_d:FindFirstChild("guildId")==nil then
local b_d=Instance.new("StringValue")b_d.Name="guildId"b_d.Parent=a_d end end;for a_d,b_d in
pairs(game.Players:GetPlayers())do d_c(b_d)end
game.Players.PlayerAdded:connect(d_c)
local function _ac(a_d,b_d)local c_d=a_d.guildId;local d_d=b_d.globalData
if d_d and d_d.guildId then local _ad=d_d.guildId
local aad=cdb(a_d,_ad)
if aad then
if aad.members[tostring(a_d.userId)]then c_d.Value=_ad
c_c(a_d,_ad)else
local bad=_ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",a_d)if bad.globalData then bad.globalData.guildId=nil
bad.nonSerializeData.setPlayerData("globalData",bad.globalData)end
_ab:fireClient("{BC18AF47-3634-4FA8-B5D3-2BDED15718FD}",a_d,{text="You were removed from your guild.",textColor3=Color3.fromRGB(255,57,60)},10)c_c(a_d,nil)end end end
a_d.level.Changed:connect(function()local _ad=a_d.guildId.Value
if _ad~=""then
local aad=cdb(a_d,_ad)
if aad then local bad=aad.members[tostring(a_d.userId)]
if bad then
bad.level=a_d.level.Value;bad.lastUpdate=os.time()
local cad={Text=a_d.Name..
" has reached Lvl."..a_d.level.Value.."!",Font="SourceSansBold",Color={r=161,g=132,b=194},Out=true}
_db(_ad,{messageType="member_data",memberData=bad,sender=a_d.Name,senderId=a_d.userId,notice=cad})end end end end)
a_d.class.Changed:connect(function()local _ad=a_d.guildId.Value
if _ad~=""then
local aad=cdb(a_d,_ad)
if aad then local bad=aad.members[tostring(a_d.userId)]
if bad then
bad.class=a_d.class.Value
local cad={Text=a_d.Name.." has become a "..a_d.class.Value.."!",Font="SourceSansBold",Color={r=161,g=132,b=194}}
_db(_ad,{messageType="member_data",memberData=bad,sender=a_d.Name,senderId=a_d.userId,notice=cad})end end end end)end
_ab:connect("{2ECD2D2F-8941-4664-B665-7ED91347531F}","Event",_ac)local function aac(a_d)c_c(a_d,nil)end
game.Players.PlayerRemoving:connect(aac)
local function bac(a_d,b_d)
local c_d=_ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",a_d)if c_d==nil then return false,"no player data."end
local d_d=c_d.globalData;if d_d==nil then return false,"no global data."end
local _ad=game:GetService("RunService"):IsStudio()
if
a_d:FindFirstChild("teleporting")or a_d:FindFirstChild("DataSaveFail")then return false,"There is an issue accessing your data, please try again later."end;if d_d.guildId then return false,"Already in a guild."end
local aad=_ab:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",a_d)
if aad==nil then return false,"Only the leader of a full party can found a guild."end;local bad=0;local cad={}
for _bd,abd in pairs(aad.members)do bad=bad+1;local bbd=abd.player
local cbd=_ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bbd)
if cbd==nil or cbd.globalData==nil then
return false,"A player in your party is missing data."elseif cbd.globalData.guildId then
return false,"A player in your party is already in a guild."elseif abd.isLeader and bbd~=a_d then
return false,"Only the leader of a full party can found a guild."elseif bbd.level.Value<10 then
return false,"All players in your party must be at least Lvl. 10 to found a guild."end
cad[tostring(bbd.userId)]={lastUpdate=os.time(),name=bbd.Name,userId=bbd.userId,level=bbd.level.Value,class=bbd.class.Value,rank=(
abd.isLeader and"leader")or"member",founder=true,points=0}end;if(bad~=6)and(not _ad)then
return false,"There must be exactly six members in your party to found a guild."end
local dad=cbb.createGuild
if c_d.gold>=dad then local _bd=a_b:GenerateGUID(false)local abd=b_d.name
if
b_d.name==nil then return false,"No guild name provided."elseif typeof(b_d.name)~="string"then return false,
"Guild name must be a string."end;local bbd
local cbd,dbd=pcall(function()
bbd=game.Chat:FilterStringForBroadcast(abd,a_d)end)
if not cbd then return false,"filter error: "..dbd elseif
not bbd or string.find(bbd,"#")then return false,"Guild name rejected by Roblox filter."elseif#bbd>20 then return false,
"Guild name must be no more than 20 characters long."elseif#bbd<3 then
return false,"Guild name must be at least 3 characters long."end;local _cd
local acd,bcd=pcall(function()_cd=bbb:GetAsync(bbd)end)
if not acd then
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Guild namestore fail: ".. (bcd or"???"))return false,"Guild name lookup failed due to DataStore error."elseif _cd then return false,
"That Guild name is already taken."end;local ccd=bbd
local dcd=game:GetService("DataStoreService"):GetDataStore("guild",_bd)local _dd;local add;local bdd
local function cdd(a__a)
for b__a,c__a in pairs(cad)do
local d__a=game.Players:GetPlayerByUserId(tonumber(b__a))if d__a and d__a.Parent then bdb(d__a,a__a)end end end;cdd(_bd)
local ddd,___a=pcall(function()
dcd:UpdateAsync("guildData",function(a__a)if a__a~=nil then _dd=true;return nil end
add={name=ccd,previousNames={},members=cad,lastModified=os.time(),id=_bd,version=1,level=1,points=0,bank=0}bdd=true;return add end)end)
if not ddd then
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Guild DataStore fail: ".. (___a or"???"))cdd(nil)return false,"DataStore failure!"elseif _dd then cdd(nil)
return false,"Guild ID already exists!"end
if bdd then local a__a=c_d.globalData
if
a__a==nil or a_d.Parent==nil or
a_d:FindFirstChild("teleporting")or a_d:FindFirstChild("DataSaveFail")then cdd(nil)return false,"Issue with founder data"end;a__a.lastCreatedGuild=os.time()
c_d.nonSerializeData.incrementPlayerData("gold",-dad,"guild:create")a__a.guildId=_bd
c_d.nonSerializeData.setPlayerData("globalData",a__a)
spawn(function()local b__a=1;local c__a;local d__a
repeat
local _a_a,aa_a=pcall(function()bbb:SetAsync(bbd,true)end)
if _a_a then c__a=true else
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Guild name claim fail: ".. (aa_a or"???"))wait(2 ^b__a)end until c__a end)c_c(a_d,_bd)return true,"A new guild has been born!"else cdd(nil)return false,
"Guild failed to be created for some reason"end else return false,"You don't have enough money to found a guild."end end
_ab:create("{91AF18D8-BD4E-470C-853D-524A4FB703DE}","RemoteFunction","OnServerInvoke",bac)local cac={}
_ab:create("{782A106B-5F02-45F9-95BE-423B80E888BD}","RemoteFunction")
local function dac(a_d,b_d)
if b_d.guildId.Value~=""then return false,"Player is already in a guild."end;local c_d=a_d.guildId.Value;local d_d=ddb(a_d,c_d)
if d_d==nil then
return false,"Could not find your guild."elseif d_d.rank~="leader"and d_d.rank~="officer"and
d_d.rank~="general"then
return false,"You do not have permission to invite new members."end;local _ad=cdb(a_d,c_d)
if _ad==nil then return false,"Could not find guild data."end;local aad=cbb.level[_ad.level].members;local bad=0;for dad,_bd in
pairs(_ad.members)do bad=bad+1 end;if bad>=aad then
return false,"Your guild is already at full capacity."end
local cad=_ab:invokeClient("{782A106B-5F02-45F9-95BE-423B80E888BD}",b_d,a_d,c_d)
if cad then
if a_d and a_d.Parent and b_d and b_d.Parent and
b_d.guildId.Value==""then local dad=cdb(a_d,c_d)
local _bd=ddb(a_d,c_d)
if dad and _bd then local abd=dad.members
abd[tostring(b_d.userId)]=
abd[tostring(b_d.userId)]or
{lastUpdate=os.time(),name=b_d.Name,userId=b_d.userId,level=b_d.level.Value,class=b_d.class.Value,rank="member",points=0}
local bbd={Text=b_d.Name.." has joined the Guild. (Invited by "..a_d.Name..")",Font="SourceSansBold",Color={r=161,g=132,b=194}}local cbd,dbd=__c(a_d,c_d,"set","members",abd,true,bbd)
if cbd then
_db(c_d,{messageType="member_data",memberData=abd[tostring(b_d.userId)],sender=a_d.Name,senderId=a_d.userId,notice=bbd})bdb(b_d,c_d)ccb(c_d,dad)end;return cbd,dbd end else
return false,"Something changed during the player input and they can no longer be added."end else return false,"Player did not accept the guild invite."end end
_ab:create("{E46E6401-03C7-4A5C-95E9-0E0CF6F1E0B4}","RemoteFunction","OnServerInvoke",dac)
local function _bc(a_d,b_d)local c_d=a_d.guildId.Value;local d_d=ddb(a_d,c_d)if not d_d then
return false,"Could not find your guild."end;local _ad=cdb(a_d,c_d)if _ad==nil then
return false,"Guild data not found"end
local aad=_ad.members[tostring(b_d)]
if aad==nil then return false,"Player is not in your guild."end;local bad=aad.name;local cad=dab[d_d.rank]local dad=dab[aad.rank]
if cad<=dad then return false,
"You cannot exile someone who does not rank beneath you."elseif
aad.founder and d_d.rank~="leader"then return false,"Only the leader can exile a founding member."end;local _bd=_ad.members;_bd[tostring(b_d)]=nil
local abd={Text=bad.." has been exiled from the guild by "..
a_d.Name.."!",Font="SourceSansBold",Color={r=161,g=132,b=194}}local bbd,cbd=__c(a_d,c_d,"set","members",_bd,true,abd)
if bbd then
local dbd=game.Players:GetPlayerByUserId(b_d)if dbd then bdb(dbd,nil)end
_db(c_d,{messageType="member_data",memberData=nil,sender=a_d.Name,senderId=a_d.userId,notice=abd})ccb(c_d,_ad)return true,"Successfully exiled player."else return false,
"Failed to exile: "..cbd end end
_ab:create("{0AE9AA93-FDFB-467D-839E-EC578CA8D574}","RemoteFunction","OnServerInvoke",_bc)
local function abc(a_d,b_d)
local c_d,d_d=pcall(function()bdb(a_d,nil)
local _ad=game:GetService("DataStoreService"):GetDataStore("guild",b_d)local aad=_ad:RemoveAsync("guildData")
bbb:RemoveAsync(aad.name)end)return c_d,d_d end
local function bbc(a_d,b_d)local c_d=a_d.guildId.Value;local d_d=ddb(a_d,c_d)if d_d==nil then
return false,"Could not find your guild."end;local _ad=cdb(a_d,c_d)if _ad==nil then
return false,"Guild data not found"end
if d_d.rank=="leader"then local abd=0;for bbd,cbd in pairs(_ad.members)do
abd=abd+1 end;if abd>1 then
return false,"If you wish to abandon your guild, you must first exile all other members."end
if b_d then return abc(a_d,c_d)end;return false,"confirmAbandon"end;local aad=a_d.userId;local bad=_ad.members;bad[tostring(aad)]=nil
local cad={Text=a_d.Name..
" has left the guild.",Font="SourceSansBold",Color={r=161,g=132,b=194}}local dad,_bd=__c(a_d,c_d,"set","members",bad,true,cad)
if dad then
_db(c_d,{messageType="member_data",memberData=
nil,sender=a_d.Name,senderId=a_d.userId,notice=cad})bdb(a_d,nil)ccb(c_d,_ad)return true,"Successfully left the guild."else return false,
"Failed to leave: ".._bd end end
_ab:create("{C3523747-A76C-466F-AE06-499AE786F5B1}","RemoteFunction","OnServerInvoke",bbc)
local function cbc(a_d,b_d,c_d)local d_d=a_d.guildId.Value;local _ad=ddb(a_d,d_d)if not _ad then
return false,"Could not find your guild."end;local aad=cdb(a_d,d_d)if aad==nil then
return false,"Guild data not found"end
local bad=aad.members[tostring(b_d)]
if bad==nil then return false,"Player is not in your guild."end;local cad=bad.name;local dad=dab[_ad.rank]local _bd=dab[bad.rank]local abd=(dad==4)and
(c_d==4)
if(c_d>=dad)and(not abd)then return false,
"You cannot rank someone to a rank that is not beneath you."elseif _bd>=dad then return false,
"You cannot change the rank of someone who does not rank beneath you."end;local bbd="member"
for bcd,ccd in pairs(dab)do if c_d==ccd then bbd=bcd end end;local cbd=aad.members;cbd[tostring(b_d)].rank=bbd
local dbd={Text=cad..
"'s rank has been changed to "..bbd.." by "..a_d.Name..".",Font="SourceSansBold",Color={r=161,g=132,b=194}}if abd then cbd[tostring(a_d.UserId)].rank=3
dbd.Text=
a_d.Name..
" has stepped down as leader, appointing "..cad.." as the new leader!"end
local _cd,acd=__c(a_d,d_d,"set","members",cbd,true,dbd)
if _cd then ccb(d_d,aad)
_db(d_d,{messageType="member_data",memberData=cbd[tostring(b_d)],sender=a_d.Name,senderId=a_d.userId,notice=dbd})return true,"Successfully ranked player."else
return false,"Failed to rank: "..acd end end
_ab:create("{8C82C83C-8EA5-4F8B-90BA-70CBEA15BD68}","RemoteFunction","OnServerInvoke",cbc)local dbc=4653017449
local _cc={[2064647391]="mushtown",[2119298605]="nilgarf",[2470481225]="warriorStronghold",[3112029149]="treeOfLife",[2546689567]="portFidelio"}
local acc={["mushtown"]="Mushtown",["nilgarf"]="Nilgarf",["warriorStronghold"]="Warrior Stronghold",["treeOfLife"]="Tree of Life",["portFidelio"]="Port Fidelio"}function getHallLocationFromPlaceId()return _cc[game.PlaceId]end
_ab:create("{4BFB5386-903B-4062-9571-FC14E7942993}","RemoteFunction","OnServerInvoke",getHallLocationFromPlaceId)function getPlaceIdFromHallLocation(a_d)
for b_d,c_d in pairs(_cc)do if c_d==a_d then return b_d end end;return nil end
_ab:create("{78A2C6B6-59A9-4DC5-83CE-28057C5B0785}","RemoteFunction","OnServerInvoke",function(a_d,b_d)return
getPlaceIdFromHallLocation(b_d)end)
_ab:create("{13DF8320-CF4D-49BD-BE0D-0EE9DBA8E272}","BindableFunction","OnInvoke",getPlaceIdFromHallLocation)local function bcc()end
local function ccc(a_d)local b_d=a_d:FindFirstChild("guildId")if not b_d then
return false,"No guildId."end;local c_d=b_d.Value;local d_d=cdb(a_d,c_d)if not d_d then
return false,"No guildData."end;local _ad=ddb(a_d,c_d)
if not _ad then return false,"No memberData."end;if _ad.rank~="leader"then return false,"Not leader."end
local aad=getHallLocationFromPlaceId()
if not aad then return false,"No guild hall at this location."end;local bad
if d_d.hallLocation then
bad={Text="The Guild Hall has been moved from "..acc[d_d.hallLocation]..
" to "..acc[aad].."!"}else
bad={Text="The Guild Hall has been established at "..acc[aad].."!"}end;bad.Font="SourceSansBold"bad.Color={r=161,g=132,b=194}
local cad=b_b:ReserveServer(dbc)local dad,_bd=__c(a_d,c_d,"set","hallServerId",cad,false)if not dad then return
false,_bd end
local abd,bbd=__c(a_d,c_d,"set","hallLocation",aad,false,bad)
if abd then
_db(c_d,{messageType="data_update",key="hallLocation",value=aad,sender=a_d.Name,senderId=a_d.userId,notice=bad})bcc()return true,""else return false,bbd end end
_ab:create("{6014AB62-9ECD-419B-9232-F364529DA7A5}","RemoteFunction","OnServerInvoke",ccc)
local function dcc(a_d)local b_d=a_d:FindFirstChild("guildId")
if not b_d then return nil,"No guildId."end;local c_d=b_d.Value;local d_d=cdb(a_d,c_d)
if not d_d then return nil,"No guildData."end;local _ad=d_d.level+1;if cbb.level[_ad]then
return cbb.level[_ad].cost,""else return nil,"No next level."end end
_ab:create("{15F7DCD7-2531-4A0B-B164-FA6DFAD0EC58}","RemoteFunction","OnServerInvoke",dcc)
local function _dc(a_d)
if
(game.PlaceId~=2546689567)and(game.PlaceId~=2061558182)and(game.PlaceId~=3372071669)then return false,
"Not in Port Fidelio."end;local b_d=a_d:FindFirstChild("guildId")if not b_d then
return false,"No guildId."end;local c_d=b_d.Value;local d_d=cdb(a_d,c_d)if not d_d then
return false,"No guildData."end;local _ad=ddb(a_d,c_d)
if not _ad then return false,"No memberData."end;if _ad.rank~="leader"then return false,"Not leader."end
local aad,bad=dcc(a_d)if not aad then return false,bad end;if d_d.bank<aad then
return false,"Not enough funds in guild bank."end
local cad=game:GetService("DataStoreService"):GetDataStore("guild",c_d)
local dad,_bd=pcall(function()
cad:UpdateAsync("guildData",function(abd)if not abd then return end;if not abd.level then return end;if
not abd.bank then return end;if abd.bank<aad then return end
abd.bank=abd.bank-aad;abd.level=abd.level+1;ccb(c_d,abd)return abd end)end)
if not dad then
_ab:invoke("{79598458-CED2-488B-A719-1E295449F68E}",a_d,"warning","Failed to upgrade guild level: ".._bd)return false,"DataStore error"end;return true,""end
_ab:create("{E099DBCD-C79B-4BD1-8D65-14628890FAE1}","RemoteFunction","OnServerInvoke",_dc)
local function adc(a_d,b_d)
if typeof(b_d)~="number"then return false,"Trying to donate not a number."end;b_d=math.floor(b_d)if b_d<0 then
return false,"Trying to donate a negative number."end
local c_d=a_d:FindFirstChild("guildId")if not c_d then return false,"No guildId."end;local d_d=c_d.Value
local _ad=cdb(a_d,d_d)if not _ad then return false,"No guildData."end
local aad=_ab:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",a_d)if not aad then return false,"No playerData."end;if aad.gold<b_d then return false,
"Not enough gold."end
aad.nonSerializeData.incrementPlayerData("gold",
-b_d,"guild:donate")local bad,cad=__c(a_d,d_d,"increment","bank",b_d,true)if not bad then
aad.nonSerializeData.incrementPlayerData("gold",b_d,"guild:donateFailed")return false,cad end
return true,""end
_ab:create("{DF2F2995-D912-4C8E-B250-0D82CF100328}","RemoteFunction","OnServerInvoke",adc)
local function bdc(a_d,b_d)local c_d=a_d[1]local d_d=cdb(c_d,b_d)
if not d_d then return false,"No guildData."end;local _ad=d_d.hallServerId
if not _ad then return false,"No hallServerId."end
_ab:invoke("{B95C5E85-0C22-4055-B2AF-C8C75989CC05}",a_d,dbc,b_d,nil,nil,_ad)return true,""end
_ab:create("{D93DBFF1-1A80-43FD-8B9A-80056868C1ED}","BindableFunction","OnInvoke",bdc)
_ab:create("{7FBB1B38-FDEC-4D23-AADA-3D1560390745}","RemoteFunction","OnServerInvoke",function(a_d)
local b_d=a_d:FindFirstChild("guildId")if not b_d then return false,"No guildId."end;local c_d=b_d.Value;if c_d==""then return false,
"No guild."end
local d_d=_ab:invoke("{312290ED-5E69-4F68-B25D-503E29A1CE28}",a_d)
if d_d then local _ad={}local aad
for bad,cad in pairs(d_d.members)do local dad=cad.player;if cad.isLeader then aad=dad else
table.insert(_ad,dad)end end;if a_d~=aad then
return false,"Only the party leader may teleport everyone to a guild hall."end
table.insert(_ad,1,aad)bdc(_ad,c_d)else bdc({a_d},c_d)end end)
local function cdc(a_d,b_d)
_ab:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=b_d.Name.." has been expelled by "..a_d.Name,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,127,127)})
_ab:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",b_d,game.ReplicatedStorage.lastLocationOverride.Value,"guildHall")end
local function ddc(a_d,b_d)
if(game.PlaceId~=dbc)and(game.PlaceId~=2061558182)then return false,
"This command can only be used in the guild hall."end
local c_d=game.ReplicatedStorage:FindFirstChild("guildId")
if c_d then c_d=c_d.Value else
if game.PlaceId==2061558182 then
c_d="73370A17-4486-4E7D-AD49-4597D93C52B0"else return false,"Couldn't find guildId."end end;local d_d=a_d:FindFirstChild("guildId")
local _ad=b_d:FindFirstChild("guildId")
if(not d_d)then return false,"You are not a member of a guild."else if d_d.Value~=c_d then return false,
"You are not a member of this guild."end
if(not _ad)then
cdc(a_d,b_d)return true,""else
if _ad.Value~=c_d then cdc(a_d,b_d)return true,""else local aad=ddb(a_d,c_d)
local bad=ddb(b_d,c_d)
if
(not aad)or(not bad)or(not aad.rank)or(not bad.rank)then return false,"There was an issue with player data."end;local cad=_bb(aad.rank)local dad=_bb(bad.rank)
if cad<=dad then return false,
"You must be a higher rank than your target in order to expel them."else cdc(a_d,b_d)return true,""end end end end end
_ab:create("{C9FBA844-B9C8-4A26-9EC1-C55089506DFD}","RemoteFunction","OnServerInvoke",ddc)local function __d(a_d)
_ab:invoke("{B8DB181F-39DB-4695-BAAB-5AF049CC046D}",a_d,game.ReplicatedStorage.lastLocationOverride.Value,"guildHall")end
_ab:create("{3E1D19F9-1FF3-4A7A-860C-CAB28A08D429}","RemoteFunction","OnServerInvoke",__d)return cab