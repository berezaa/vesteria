local __a=game:GetService("TeleportService")
local a_a=__a:GetTeleportSetting("sessionId")local b_a=__a:GetTeleportSetting("joinTime")
local c_a=__a:GetTeleportSetting("partyInfo")
local d_a=game.ReplicatedStorage:WaitForChild("teleportUI")
local _aa=game.ReplicatedStorage:WaitForChild("teleportUIDeath")local aaa;local baa=game.Players.LocalPlayer
spawn(function()
local dda=__a:GetArrivingTeleportGui()
if dda then dda.Status.Text="Arriving..."repeat wait()until
baa:FindFirstChild("PlayerGui")dda.Parent=baa.PlayerGui
local __b=game:GetService("ReplicatedStorage")local a_b=require(__b.modules)local b_b=a_b.load("network")
local c_b=a_b.load("tween")baa:WaitForChild("DataLoaded")
c_b(dda.Blackout,{"BackgroundTransparency"},1,1)c_b(dda.logo,{"ImageTransparency"},1,1)
c_b(dda.Description,{"TextTransparency","TextStrokeTransparency"},1,1)
c_b(dda.Destination,{"TextTransparency","TextStrokeTransparency"},1,1)
c_b(dda.Status,{"TextTransparency","TextStrokeTransparency"},1,1)wait(1)dda:Destroy()end
game.ContentProvider:PreloadAsync({d_a:WaitForChild("swoosh")})
game.ContentProvider:PreloadAsync({d_a:WaitForChild("gradient")})end)local caa=false
local daa=require(game.ReplicatedStorage:WaitForChild("modules"))local _ba=daa.load("network")local aba=daa.load("tween")
local bba=daa.load("utilities")
_ba:create("{13846E2D-5429-4A83-8237-4EC31C49F756}","BindableEvent")
_ba:create("{16271791-FB4E-416F-A6CE-758E22085188}","BindableEvent")
baa.CharacterAdded:Connect(function()wait()
_ba:fire("{16271791-FB4E-416F-A6CE-758E22085188}")end)
__a.TeleportInitFailed:connect(function(dda,__b,a_b)
if dda==game.Players.LocalPlayer then aaa=
__a:GetArrivingTeleportGui()or aaa;if aaa then aaa.Status.Text="Teleport failed! ("..
__b.Name..")"wait(1.5)
aaa:Destroy()caa=false end end end)local cba
local function dba(dda,__b)local a_b=bba.placeIdMapping;for dab,_bb in pairs(a_b)do
if dda==_bb then dda=tonumber(dab)break end end;if cba then return false end;cba=true
if
__b=="death"then local dab=_aa:Clone()dab.Parent=baa.PlayerGui;dab.Enabled=true
dab.Blackout.Visible=true;dab.Blackout.BackgroundTransparency=1
aba(dab.Blackout,{"BackgroundTransparency"},0,0.5)__a:SetTeleportGui(_aa)wait(0.5)
spawn(function()wait(1)cba=false end)return dab end
d_a.Thumbnail.Image="https://www.roblox.com/Thumbs/Asset.ashx?width=768&height=432&assetId="..dda;local b_b=nil
if not b_b then b_b=d_a:Clone()aaa=b_b
b_b.Blackout.BackgroundTransparency=0;b_b.Blackout.Position=UDim2.new(-1,0,0.5,0)
b_b.Thumbnail.ImageTransparency=1;b_b.gradient.ImageTransparency=1;b_b.logo.ImageTransparency=1
b_b.swoosh:Play()b_b.Description.TextTransparency=1
b_b.Destination.TextTransparency=1;b_b.Status.TextTransparency=1
aba(b_b.Blackout,{"Position"},UDim2.new(0,0,0.5,0),0.3)end;b_b.Parent=baa.PlayerGui;b_b.Enabled=true
__a:SetTeleportGui(d_a)local c_b=game:GetService("RunService")
b_b.spinner.Visible=true
spawn(function()while caa do b_b.spinner.Rotation=b_b.spinner.Rotation+2
c_b.RenderStepped:wait()end end)local d_b;local _ab
spawn(function()b_b.Status.Text="Loading..."wait(0.3)
aba(b_b.Status,{"TextTransparency"},0,0.5)end)
spawn(function()
game.ContentProvider:PreloadAsync({b_b.logo,b_b.Thumbnail})d_b=true end)local aab
spawn(function()
aab=game.MarketplaceService:GetProductInfo(dda,Enum.InfoType.Asset)_ab=true end)local bab=tick()
repeat wait()until d_b and _ab or(tick()-bab>10)local cab=tick()-bab;if cab<0.3 then wait(0.3 -cab)end
b_b.gradient.ImageTransparency=0;b_b.Thumbnail.UIScale.Scale=1
aba(b_b.logo,{"ImageTransparency"},0,0.7)aba(b_b.Thumbnail,{"ImageTransparency"},0,1)
aba(b_b.Thumbnail.UIScale,{"Scale"},1.05,1)
aba(b_b.Description,{"TextTransparency"},0,0.5)
aba(b_b.Destination,{"TextTransparency"},0,0.5)
if aab then b_b.Destination.Text=aab.Name
b_b.Description.Text=aab.Description;b_b.Status.Text="Preparing to travel..."
d_a.Destination.Text=aab.Name;d_a.Description.Text=aab.Description
d_a.Status.Text="Traveling to location..."__a:SetTeleportGui(d_a)else
b_b.Status.Text="Can't find travel info"d_a.Status.Text="Can't find travel info"end;spawn(function()wait(1)cba=false end)
return b_b end
_ba:connect("{EAD29A16-EBBD-48A0-A9D7-A0AF3A26FD09}","OnClientEvent",dba)
local function _ca(dda)local __b=game.Players.LocalPlayer
local a_b=game:GetService("TeleportService")if __b:FindFirstChild("AnalyticsSessionId")then
a_b:SetTeleportSetting("sessionId",__b.AnalyticsSessionId.Value)end;if
__b:FindFirstChild("JoinTime")then
a_b:SetTeleportSetting("joinTime",__b.JoinTime.Value)end;local b_b=dba(dda)
wait(0.5)b_b.Status.Text="Traveling to location..."wait(0.5)
b_b.Body.Position=UDim2.new(0,0,0,0)b_b.Blackout.BackgroundTransparency=0
game.GuiService.SelectedObject=nil;a_b:Teleport(dda,nil,nil,b_b)end
_ba:create("{983ED616-D349-44E8-BAED-1CE505A6CBFD}","BindableFunction","OnInvoke",_ca)local aca
local function bca(dda)
if aca then dda.CanCollide=true;if not
game.CollectionService:HasTag(dda,"interact")then
game.CollectionService:AddTag(dda,"interact")end else dda.CanCollide=false;if
game.CollectionService:HasTag(dda,"interact")then
game.CollectionService:RemoveTag(dda,"interact")end end end
local function cca(dda)local __b=dba(dda)local a_b=os.time()local b_b
if
baa:FindFirstChild("AnalyticsSessionId")then b_b=baa.AnalyticsSessionId.Value end;local c_b
if baa:FindFirstChild("JoinTime")then c_b=baa.JoinTime.Value end
local d_b=baa:FindFirstChild("dataSlot")and baa.dataSlot.Value or 1
local _ab=_ba:invokeServer("{D139FFE8-4215-4F17-96E1-BC8BB20C7B5F}")
if _ab then
if b_b then __a:SetTeleportSetting("sessionId",b_b)end
if c_b then __a:SetTeleportSetting("joinTime",c_b)end;__a:SetTeleportSetting("lastTimeStamp",_ab)
__a:SetTeleportSetting("arrivingTeleportId",game.PlaceId)__a:SetTeleportSetting("dataSlot",d_b)
__b.Status.Text="Traveling to location..."local aab=os.time()-a_b;if aab<=1 then wait(1 -aab)end
__b.Blackout.BackgroundTransparency=0;game.GuiService.SelectedObject=nil;wait()end;return _ab,__b end
local function dca(dda)if
baa:FindFirstChild("DataLoaded")==nil or
baa:FindFirstChild("teleporting")or caa then return false end;caa=true
local __b,a_b=cca(dda)if __b then __a:Teleport(dda,nil,nil,a_b)else end end
_ba:connect("{64244B09-51CA-49FE-9129-BB0281828AB0}","OnClientEvent",dca)
_ba:create("{1DEBF1E7-209E-4381-BC0E-1F5D2BF5564E}","BindableFunction","OnInvoke",function(dda)caa=true;local __b=dba(dda)end)
local function _da(dda)bca(dda)
local __b=dda:WaitForChild("teleportDestination").Value;local a_b=false
dda.Touched:connect(function(b_b)if
baa:FindFirstChild("DataLoaded")==nil or baa:FindFirstChild("teleporting")then
return false end
if baa.Character and b_b==
baa.Character.PrimaryPart and
(
baa.Character.PrimaryPart.Position-dda.Position).magnitude<50 then
if a_b then return false end;local c_b=aca~=nil
local d_b=dda:FindFirstChild("forced")and dda.forced.Value;if c_b and(not d_b)then
_ba:fire("{7EEEF31B-024D-429C-8220-4A6094CFA5B8}",dda.CFrame.lookVector*5)return end
if not caa then caa=true
local _ab=dba(__b)
local aab,bab=_ba:invokeServer("{E6EA6870-28C2-4310-AA18-85AF3489A3FF}",dda)if aab then else _ab:Destroy()caa=false end end end end)end
local ada=game.CollectionService:GetTagged("teleportPart")
game.CollectionService:GetInstanceAddedSignal("teleportPart"):connect(_da)
for dda,__b in pairs(ada)do spawn(function()_da(__b)end)end
game.ReplicatedStorage.ChildAdded:Connect(function(dda)if dda.Name=="spawnPoints"then
_ba:fire("{16271791-FB4E-416F-A6CE-758E22085188}")end end)
local function bda(dda)for __b,a_b in pairs(dda.members)do local b_b=a_b.player
if b_b and a_b.isLeader then return b_b.userId end end end
local function cda(dda)
dda=dda or _ba:invokeServer("{D2B7113F-C646-40B1-A09E-2DB52FB5C4E7}")aca=dda;for __b,a_b in
pairs(game.CollectionService:GetTagged("teleportPart"))do bca(a_b)end
if dda and
dda.teleportState=="teleporting"and not caa then
_ba:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)local __b={party_guid=dda.guid,partyLeaderUserId=bda(dda)}
__a:SetTeleportSetting("partyInfo",__b)if not aca.teleportDestination then
error("AHHHHHH PANIC NO TELEPORT DESTINATION WHY HAVE YOU FORSAKEN ME LIKE THIS")end;caa=true
local a_b=dba(aca.teleportDestination)
_ba:fireServer("{0BE6B8D2-2216-4FA3-9DF9-09EE98D714DF}")end end;cda()
_ba:connect("{52175EBD-EE9F-41F5-A81F-8F6BC2A6E040}","OnClientEvent",cda)for i=1,3 do wait()
_ba:fire("{16271791-FB4E-416F-A6CE-758E22085188}")end
baa:WaitForChild("DataLoaded",60)
if a_a and b_a then
_ba:invokeServer("{401B0523-3B30-4CF3-B61C-B13B9DE5AED2}",a_a,b_a)else
_ba:invokeServer("{C1A7A955-0F0C-4C2A-8248-35F563E8C99D}")end