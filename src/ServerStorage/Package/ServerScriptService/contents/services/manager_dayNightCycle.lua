DAY_TIME_SECONDS=1200;if
game.PlaceId==4561988219 or game.PlaceId==4041427413 then DAY_TIME_SECONDS=600 end;local cc={}local dc={}
local _d=Random.new(os.time())
for _ba,aba in pairs(workspace:GetDescendants())do if
aba.Name=="WindowPart"or(
aba.Name=="Light"and aba.Parent.Name=="Lantern")then
table.insert(dc,{Part=aba,Num=_d:NextNumber()})end end;local ad=game:GetService("RunService")
local bd=game.Lighting.ClockTime;game.ReplicatedStorage.timeOfDay.Value=bd
if
game.ReplicatedStorage:FindFirstChild("lightingSettings")and
game.ReplicatedStorage.lightingSettings:FindFirstChild("timeLock")then
game.ReplicatedStorage.timeOfDay.Value=game.ReplicatedStorage.lightingSettings.timeLock.Value
game.Lighting.ClockTime=game.ReplicatedStorage.timeOfDay.Value end
local function cd(_ba)
if _ba.Name=="WindowPart"then _ba.Material=Enum.Material.Neon
_ba.Color=
_ba:FindFirstChild("WindowColor")and _ba.WindowColor.Value or
Color3.fromRGB(141,140,108)local aba=_ba:FindFirstChild("WindowLight")
if aba==nil then
aba=Instance.new("PointLight")aba.Name="WindowLight"aba.Range=10;aba.Parent=_ba end;aba.Enabled=true elseif _ba.Name=="Light"and _ba.Parent and
_ba.Parent.Name=="Lantern"then
_ba.Color=Color3.fromRGB(248,217,109)_ba.Material=Enum.Material.Neon
local aba=_ba:FindFirstChild("LanternLight")_ba.Transparency=0.2
if aba then aba.Enabled=true;aba.Range=25;aba.Brightness=1 end end end
local function dd(_ba)
if _ba.Name=="WindowPart"then _ba.Material=Enum.Material.Plastic
_ba.Color=Color3.fromRGB(27,42,53)local aba=_ba:FindFirstChild("WindowLight")
if aba then aba.Enabled=false end elseif
_ba.Name=="Light"and _ba.Parent and _ba.Parent.Name=="Lantern"then _ba.Color=Color3.fromRGB(180,210,228)
_ba.Material=Enum.Material.Glass;_ba.Transparency=0.4
local aba=_ba:FindFirstChild("LanternLight")if aba then aba.Enabled=false end end end;local __a=false
local function a_a(_ba,aba,bba)local cba,dba,_ca=Color3.toHSV(_ba)
local aca,bca,cca=Color3.toHSV(aba)
return Color3.fromHSV(aca+ (cba-aca)*bba,bca+ (dba-bca)*bba,cca+
(_ca-cca)*bba)end;if game.Lighting:FindFirstChild("SunRays")==nil then
script.SunRays:Clone().Parent=game.Lighting end;if
game.Lighting:FindFirstChild("DepthOfField")==nil then
script.DepthOfField:Clone().Parent=game.Lighting end;if
game.Lighting:FindFirstChild("Sky")==nil then
script.Sky:Clone().Parent=game.Lighting end;if
game.Lighting:FindFirstChild("Atmosphere")==nil then
script.Atmosphere:Clone().Parent=game.Lighting end
game.Lighting.EnvironmentDiffuseScale=0.8;game.Lighting.EnvironmentSpecularScale=0.1;local function b_a()return
os.time()/DAY_TIME_SECONDS end
local c_a=Instance.new("NumberValue")c_a.Name="vesterianDay"c_a.Value=b_a()
c_a.Parent=game.ReplicatedStorage
spawn(function()
while wait(1 /5)do local _ba=b_a()c_a.Value=_ba
local aba=_ba-math.floor(_ba)bd=aba*24
if
game.ReplicatedStorage:FindFirstChild("lightingSettings")and
game.ReplicatedStorage.lightingSettings:FindFirstChild("timeLock")then
bd=game.ReplicatedStorage.lightingSettings.timeLock.Value end;game.ReplicatedStorage.timeOfDay.Value=bd
local bba=0
if bd<5.0 or bd>18.5 then
if not __a then __a=true
for bca,cca in pairs(dc)do local dca=cca.Part;if dca.Name=="Light"and
dca.Parent.Name=="Lantern"then cd(dca)elseif dca.Name=="WindowPart"then
dd(dca)end end end;bba=0
if bd>=22 and bd<=24 then local bca=(bd-22)/2;for cca,dca in pairs(dc)do local _da=dca.Part
if _da and
bca>=dca.Num then if _da.Name=="WindowPart"then dd(_da)end end end end elseif bd>=5.0 and bd<=6.5 then local bca=(bd-5.0)/1.5;bba=bca
for cca,dca in pairs(dc)do
local _da=dca.Part;if _da and bca>=dca.Num then dd(_da)end end elseif bd>=17.5 and bd<=18.5 then local bca=(bd-17.5)bba=1 -bca
for cca,dca in pairs(dc)do
local _da=dca.Part;if _da and bca>=dca.Num then cd(_da)end end else bba=1
if not __a then __a=true
for bca,cca in pairs(dc)do local dca=cca.Part;if dca.Name=="Light"and dca.Parent.Name==
"Lantern"then dd(dca)elseif dca.Name=="WindowPart"then
dd(dca)end end end end;game.Lighting.Brightness=1;local cba=0.47
if
game.ReplicatedStorage:FindFirstChild("fogEndMulti")then cba=game.ReplicatedStorage.fogEndMulti.Value end
local dba=game.ReplicatedStorage:FindFirstChild("lightingSettings")
local _ca=
dba and dba:FindFirstChild("dayAmbient")and dba.dayAmbient.Value or(Color3.fromRGB(100,100,100))
local aca=dba and dba:FindFirstChild("nightAmbient")and
dba.nightAmbient.Value or Color3.fromRGB(50,50,100)game.Lighting.OutdoorAmbient=Color3.new(0,0,0)end end)
local d_a=require(game.ReplicatedStorage.modules)local _aa=d_a.load("network")
local aaa=require(game.ReplicatedStorage.perkLookup)
local function baa(_ba,aba)
local bba=_aa:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",_ba)if not bba then return end
local cba=bba.nonSerializeData.statistics_final.activePerks
for dba,_ca in pairs(cba)do
if _ca then local aca=aaa[dba]if aca.onTimeOfDayUpdated then
aca.onTimeOfDayUpdated(_ba,game.Lighting.ClockTime,aba)end end end end
local function caa(_ba)for aba,bba in
pairs(game:GetService("Players"):GetPlayers())do baa(bba,_ba)end end;local function daa()while true do caa(wait(1))end end
spawn(daa)return cc