
return
function()local a=game:GetService("ReplicatedStorage")
local b=require(a:WaitForChild("modules"))local c=b.load("network")local d=b.load("configuration")
local _a={"chrisinator66","Guest40231","pup115888","inearthly","ReferalKing","Raqnaar","ivorfy","Axdreid","Avalian","Silent_Karasu","QuakeBeard","Harder_Dude","howdoisnarfsnarf","GusFront","longrod247","JokeChef","A4lt","FEIMZIGRON","cmack4243","buttmanthecool","in2dream","Linqed","Ascusis","RandomUsername64x","decaul","Fluxxxx_222","SpiritedNoFace","Yoclash","WrongStarZ","JosephCorozzo","YouKindaCutee","Triseria","Chronicxz","winter_soldat","ctjepkes","Gmasterjkh","aleccc","caine_felix","EchikaKurosaki","goithefat1","Kyene","AddictBloxy","Thyemium","RandoOof","Xena_SR","ASecretNote","MGsha3883","FlamingExpert","Alex_itk","Imperfectjosh","firestoney","certifiedkidfiddler","thebowmaster2345","willow","Dvcember","Cozmicc","insaisissable","GodzLightning","WhiiteBeard","swamp","TehChickenBoy","Gamer1OderSoHD","boobuu444","zxZTHeDeMonZxz","kerso","Wen3698","iRunBoYi","TrollLexBR2","VesteriaFreak","Storage_Magical6","link2uu","TheTruSucc","Dony164","sourtings","DevilsSoul","TheDark_Mage","LittlePeep","K4Kiva","Alekx1235x","Kain87","RONKLEY","I7906","chino146","lightdarksun","LokiCard","Thistlerow","4legitly","MikeGarciaAGM","teuwaiseuu","x0iAlan","Achillez","Christmas_Awaits","YoRHa_9S","shadowrider101","Zaharielekk","Maserq","Impossibilities","25nite","SaxoMaxyy","rayverberm24","Athynasius","Avalinity","Chro11oLucifer","Ansonabc","bf_g50","SpeedWolfBG","cghcgh25801","superbaconplayer1020","Gidein","m4nil410","SquishyRockets","kxlebs","VesteriaReferrals","YezzSirrr","Ezmaster01","Vesteriakills","Zinszo","0dd_1","Xorias","ViaDarkNessTH","AeonixTheFiend","nex_s2","Kain2212","Jank_z","ScroogeMcDuck3679","HieiSan","aleister90","BoneChills","Ros_ilia","darkghost110","DisastrousTemptation","overpath41","LesRocket","wraithies","JameO1818","Decryptional","F_oop","AltVaziec","alphabeto2444","decryptedMIRAGE","ThatCriminal","TurkiSD","VesteriaStoranger","CaterBois","GeeTeeArgh","decipheredENIGMA","theRGBKing","IIIIIlllllllIIllIIIl","MemezzMachine","BIGLIVERTHEMAX1212","xxxwomenbeater62","vsk_0","vsk_god","dad_killer69","EpicMetatableMoment","children_sniffer72","vsk_1","Legoracer","X6M","Draco7898"}local aa={}
spawn(function()for bd,cd in pairs(_a)do
pcall(function()
local dd=game.Players:GetUserIdFromNameAsync(cd)if dd then table.insert(aa,dd)end end)end end)
local function ba(bd)for cd,dd in pairs(_a)do
if bd.Name==dd then bd:Kick("Banned")return false end end
for cd,dd in pairs(aa)do if bd.userId==dd then
bd:Kick("Banned")return false end end;return true end;game.Players.PlayerAdded:Connect(ba)
local ca={}local da={}local _b={}local ab={}local bb={d="1"}
c:create("{B8C3BD66-AD7D-4A01-9121-E882FFFA1E44}","RemoteEvent")
game:GetService("MarketplaceService").ProcessReceipt=function(bd)
local cd=game.Players:GetPlayerByUserId(bd.PlayerId)
if not cd then warn("aborted purchase due to missing player")return
Enum.ProductPurchaseDecision.NotProcessedYet end
if cd:FindFirstChild("DataSaveFailed")then
warn("aborted purchase due to save failure")return Enum.ProductPurchaseDecision.NotProcessedYet end;local dd=tick()
repeat wait(0.1)until cd==nil or cd.Parent~=game.Players or
ca[cd]or tick()-dd>15
if cd and cd.Parent==game.Players and ca[cd]then
local __a=ca[cd]da[cd]=da[cd]or{}local a_a=da[cd]
a_a.payments=a_a.payments or{}local b_a;local c_a;if a_a.payments[bd.PurchaseId]then b_a=true else
b_a,c_a=c:invoke("{AC8010FE-86EF-4904-A51A-1F3D80B40CC1}",cd,bd,__a)end;if b_a and c_a then
a_a.payments[bd.PurchaseId]=true;__a=c_a;ca[cd]=c_a end
if b_a then
local d_a=os.time()ab[cd]=d_a;__a.version=__a.version+1
local _aa,aaa,baa=c:invoke("{D7CF503F-34C4-4C60-A03E-D16D199CC344}",cd,__a)if ab[cd]==d_a then ab[cd]=nil end
if _aa then a_a.globalDataVersion=baa
spawn(function()
local caa=bb[bd.ProductId]
if caa==nil then
local daa=game.MarketplaceService:GetProductInfo(bd.ProductId,Enum.InfoType.Product)
if daa then caa=daa.Name;bb[bd.ProductId]=caa else caa="unknown"end end;print("transaction recorded:",caa)
c:invoke("{D6C785B6-5995-421C-8056-66CCDBA04C5C}",cd,"Product",caa,bd.CurrencySpent)end)
c:fireClient("{B8C3BD66-AD7D-4A01-9121-E882FFFA1E44}",cd,__a)print("Transaction success")return
Enum.ProductPurchaseDecision.PurchaseGranted else warn("Transaction failed")return
Enum.ProductPurchaseDecision.NotProcessedYet end end end;warn("no player global data found")return
Enum.ProductPurchaseDecision.NotProcessedYet end
c:create("{382D6FC6-8F3C-45EE-936D-EBEB74BF5928}","RemoteFunction","OnServerInvoke",function(bd)
if not ba(bd)then return false end;print("starting new session")
_b[bd]=c:invoke("{CE411E74-1334-428C-8E1A-9480BE291C52}",bd)print(_b[bd])
local cd,dd,__a=c:invoke("{7BDAB86F-3DCD-4852-A080-DEE6722D7D05}",bd)
if cd then if dd==nil then local a_a=Instance.new("BoolValue")
a_a.Name="newPlayerTag"a_a.Parent=bd end
ca[bd]=dd or{}return cd,dd,__a end;return false,nil,__a end)
local cb=game:GetService("DataStoreService"):GetDataStore("Referrals2")local db;local _c,ac
spawn(function()
repeat
_c,ac=pcall(function()if db then db:Disconnect()db=nil end
db=game:GetService("MessagingService"):SubscribeAsync("acceptedReferrals",function(bd)
local cd=bd.Data;local dd
local __a,a_a=pcall(function()
cb:UpdateAsync(tostring(cd),function(c_a)dd=c_a;return true end)end)if not __a then warn("oh no!",a_a)end
local b_a=game.Players:GetPlayerByUserId(cd)
if b_a then if not dd then local c_a=Instance.new("BoolValue")
c_a.Name="acceptedReferral"c_a.Parent=b_a end end end)end)wait(10)until _c end)
c:create("{61693BA9-0B4F-47ED-B6F1-B1BC6D6C126A}","RemoteFunction","OnServerInvoke",function(bd,cd)
if not ba(bd)then return false end;if not(_c and db~=nil)then
return false,"Roblox's MessagingService is offline. Please wait or rejoin to attempt a referral"end;if
bd:FindFirstChild("acceptedReferral")then return false,"Already referred"end
if not
bd:FindFirstChild("newPlayerTag")then return false,"Invalid - not a new player"end;if bd:FindFirstChild("messagePending")then
return false,"Invalid - message is already sending"end;local dd
local __a,a_a=pcall(function()
dd=cb:GetAsync(tostring(bd.userId))end)if not __a then
return false,"DataStore error - ".. (a_a or"unknown")end
if dd then return false,"You've already referred"end;if cd==bd.Name then return false,"You're not funny"end;local b_a
local c_a=pcall(function()
b_a=game.Players:GetUserIdFromNameAsync(cd)end)
if not c_a then return false,"Failed to find player userId, try again."end;local d_a=Instance.new("StringValue")d_a.Name="messagePending"
d_a.Value=cd;d_a.Parent=bd;game.Debris:AddItem(d_a,10)
local _aa,aaa=pcall(function()
game:GetService("MessagingService"):PublishAsync(
"user-"..tostring(b_a),{messageType="referral",referredUserId=bd.userId,referredUsername=bd.Name})end)
if _aa then return true,"Awaiting a response, please do not leave this page..."else
d_a:Destroy()return false,"Message error - ".. (aaa or"unknown")end end)
game.Players.PlayerRemoving:Connect(function(bd)ca[bd]=nil;da[bd]=nil;_b[bd]=nil end)local bc=game:GetService("TeleportService")
local function cc(bd)local cd
local dd,__a=pcall(function()
local a_a=game:GetService("DataStoreService"):GetDataStore(
"mirrorWorld"..d.getConfigurationValue("mirrorWorldVersion"))cd=a_a:GetAsync(tostring(bd))
if cd==nil then
cd=bc:ReserveServer(bd)a_a:SetAsync(tostring(bd),cd)end end)return cd,dd,__a end
c:create("{67882DD1-4A1F-40EC-B406-F7B7D75C8932}","RemoteFunction","OnServerInvoke",function(bd,cd,dd,__a,a_a,b_a)
if not ba(bd)then return false end;local c_a=bd:GetRankInGroup(4238824)local d_a=true;local _aa=c_a>=2;local aaa=(d_a and 20)or(
_aa and 10)or 4;if not d_a then
bd:Kick("Not authorized.")return false end;if __a>aaa then
bd:Kick("Not authorized.")return false end
if b_a=="mirror"then if not d_a then
bd:Kick("Not authorized.")return false end;local baa=3372071669
print("Going to the mirror world")
local caa={destination=baa,dataTimestamp=dd,dataSlot=__a,playerAccessories=a_a,arrivingFrom=game.PlaceId,analyticsSessionId=bd:FindFirstChild("AnalyticsSessionId")and
bd.AnalyticsSessionId.Value,joinTime=bd:FindFirstChild("JoinTime")and
bd.JoinTime.Value}local daa=cc(baa)
if daa then
bc:TeleportToPrivateServer(baa,daa,{bd},nil,caa)else print("Mirror TP failed")
return false,"Failed to find key for mirror world teleport"end else local baa;local caa=ca[bd]
if caa and caa.saveSlotData then
local dba=caa.saveSlotData["-slot"..tostring(__a)]
if dba and dba.lastLocation then baa=dba.lastLocation else if game.GameId==712031239 then
baa=4041449372 else baa=2064647391 end end end
if ab[bd]then local dba=os.time()repeat wait()until ab[bd]==nil or bd==nil or
bd.Parent~=game.Players;if bd==nil or bd.Parent~=
game.Players then return false end end;local daa=baa or(game.GameId==712031239 and 4041449372)or
2064647391
local _ba=da[bd]
if _ba and _ba.globalDataVersion then dd=_ba.globalDataVersion end
local aba=bd:FindFirstChild("acceptedReferral")and true;local bba;if not baa then bba="newb"end
local cba={destination=daa,dataTimestamp=dd,dataSlot=__a,playerAccessories=a_a,arrivingFrom=game.PlaceId,analyticsSessionId=
bd:FindFirstChild("AnalyticsSessionId")and bd.AnalyticsSessionId.Value,joinTime=
bd:FindFirstChild("JoinTime")and bd.JoinTime.Value,wasReferred=aba,spawnLocation=bba}
c:fireClient("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}",bd,daa)
spawn(function()wait(0.5)
game:GetService("TeleportService"):Teleport(daa,bd,cba)end)end end)local dc=game:GetService("TeleportService")
local function _d(bd)local cd,dd,__a,a_a
for i=1,2 do
local b_a,c_a=pcall(function()
cd,dd,__a,a_a=dc:GetPlayerPlaceInstanceAsync(bd)end)if b_a or cd or a_a then break end end;return cd,dd,__a,a_a end
local function ad(bd,cd)print("!!start fetching")local dd={}
for __a,a_a in pairs(cd)do
if a_a.IsOnline then
if a_a.PlaceId and
a_a.PlaceId>0 then local b_a,c_a,d_a,_aa=_d(a_a.VisitorId)local aaa=a_a.LastLocation
if
d_a or _aa then
if d_a==2376885433 then aaa="Main Menu"else
pcall(function()
local baa=game.MarketplaceService:GetProductInfo(d_a)if baa then aaa="In "..baa.Name end end)end;a_a.LastLocation=aaa;table.insert(dd,a_a)end end end end;print("!!done fetching")return dd end
c:create("{DECA62CA-EC7F-47C3-84D9-F1525D445BC5}","RemoteFunction","OnServerInvoke",ad)end