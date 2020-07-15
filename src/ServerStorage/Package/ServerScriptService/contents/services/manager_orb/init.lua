local db=game:GetService("CollectionService")
local _c=require(game.ReplicatedStorage.modules)local ac=_c.load("network")local bc
do
if game.GameId==833209132 then
bc={2119298605}elseif game.GameId==712031239 then
bc={4787415375,4042431927,4041618739,4042399045,4041616995,4041642879,4041449372,4042577479,4042595899,4042356215,4042533453,4042327457,4784800626,4787417227,4786263828,4784798551,4042381342,4042493740,4042553675}end end;local cc
do local b_a=db:GetTagged("orbSpawn")
assert(#b_a==1,"There must be only one part in the game tagged \"orbSpawn\"")cc=Instance.new("Vector3Value")cc.Name="orbSpawn"
cc.Value=b_a[1].Position;cc.Parent=game:GetService("ReplicatedStorage")
b_a[1]:Destroy()end;local dc=script.orb;local _d=true
local function ad(b_a)if dc.Parent==workspace then
ac:fireClient("{CE48DECD-5222-4973-B0AB-89B662749171}",b_a,"orbAnnoucement")end end;game.Players.PlayerAdded:Connect(ad)
local function bd()
dc:SetPrimaryPartCFrame(CFrame.new(cc.Value))dc.Parent=workspace;dc.PrimaryPart.loop:Play()
ac:fireAllClients("{CE48DECD-5222-4973-B0AB-89B662749171}","orbArrival",{orb=dc})end
local function cd()
ac:fireAllClients("{CE48DECD-5222-4973-B0AB-89B662749171}","orbDeparture",{orb=dc})delay(5,function()dc.Parent=script end)end
local function dd()
local b_a=game:GetService("ReplicatedStorage"):FindFirstChild("vesterianDay")if not b_a then return 0 end;return math.floor(b_a.Value+0.5)end
local function __a()local b_a=game.Lighting.ClockTime
local c_a=(b_a<5.9)or(b_a>18.6)
if c_a then
if _d then _d=false;local d_a=dd()local _aa=Random.new(d_a)
local aaa=bc[_aa:NextInteger(1,#bc)]if game.PlaceId==aaa then bd()end
print("manager_orb chose "..aaa.." as the spawn location. This place is "..
game.PlaceId..".")end else
if not _d then _d=true;if dc.Parent~=script then cd()end end end end;local function a_a()while true do __a()wait(1)end end;spawn(a_a)
spawn(function()if
game.PlaceId==2061558182 then bd()wait(30)cd()end end)return{}