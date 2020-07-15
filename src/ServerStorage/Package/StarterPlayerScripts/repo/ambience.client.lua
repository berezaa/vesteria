workspace:WaitForChild("Camera")if
game.ReplicatedStorage:FindFirstChild("overrideAmbience")then return end
local c_a=require(game.ReplicatedStorage:WaitForChild("modules"))local d_a=c_a.load("network")local _aa=c_a.load("tween")
local aaa=c_a.load("placeSetup")
local baa=script.Parent.Parent:WaitForChild("assets")local caa=workspace.CurrentCamera;local daa;local _ba={}local function aba(_ab)_ab.Parent=caa
table.insert(_ba,_ab)_ab.Volume=0;_ab.Looped=true end;for _ab,aab in
pairs(baa.tracks:GetChildren())do aba(aab)end
baa.tracks.ChildAdded:Connect(aba)
local function bba(_ab,aab,bab)local cab,dab,_bb=Color3.toHSV(_ab)local abb,bbb,cbb=Color3.toHSV(aab)return
Color3.fromHSV(
abb+ (cab-abb)*bab,bbb+ (dab-bbb)*bab,cbb+ (_bb-cbb)*bab)end;local cba=1 /5;local dba;local _ca;local aca=Enum.EasingStyle.Linear
local function bca()
local _ab=game.ReplicatedStorage:FindFirstChild("lightingSettings")
local aab=
_ab and _ab:FindFirstChild("dayAmbient")and _ab.dayAmbient.Value or(Color3.fromRGB(100,100,100))
local bab=_ab and _ab:FindFirstChild("nightAmbient")and
_ab.nightAmbient.Value or Color3.fromRGB(50,50,100)local cab=game.Lighting.ClockTime;local dab=0
if cab<5.0 or cab>18.5 then dab=0 elseif
cab>=5.0 and cab<=6.5 then local _bb=(cab-5.0)/1.5;dab=_bb elseif
cab>=17.5 and cab<=18.5 then local _bb=(cab-17.5)dab=1 -_bb else dab=1 end;if _ca then cba=tick()-_ca end
_aa(game.Lighting,{"ClockTime"},game.ReplicatedStorage.timeOfDay.Value,cba,aca)
if dab~=dba then
local _bb=_ab and _ab:FindFirstChild("dayFogColor")and
_ab.dayFogColor.Value or Color3.fromRGB(151,213,214)
local abb=_ab and _ab:FindFirstChild("nightFogColor")and
_ab.nightFogColor.Value or Color3.fromRGB(0,66,120)local bbb=bba(aab,bab,dab)local cbb=bba(_bb,abb,dab)
_aa(game.Lighting,{"Ambient","FogColor","ExposureCompensation"},{bbb,cbb,dab},cba,aca)
_aa(game.Lighting.Atmosphere,{"Density","Color","Haze","Glare"},{0.438 -0.164 *dab,cbb,
2.15 -2.15 *dab,10 *dab},cba,aca)end;dab=dba;_ca=tick()end
game.ReplicatedStorage.timeOfDay.Changed:connect(bca)bca()
game.SoundService:GetPropertyChangedSignal("AmbientReverb"):connect(function(_ab)
if
game.SoundService.AmbientReverb==Enum.ReverbType.UnderWater then if
game.SoundService:FindFirstChild("Underwater")then
for aab,bab in pairs(_ba)do bab.SoundGroup=game.SoundService.Underwater end end else for aab,bab in
pairs(_ba)do bab.SoundGroup=nil end end end)local cca=""local dca=0.5
local function _da(_ab)dca=1 *_ab;for aab,bab in pairs(_ba)do
if bab.Name==cca then bab.Volume=dca*0.27 end end end
function playTrack(_ab)
if cca~=_ab then cca=_ab;for aab,bab in pairs(_ba)do
if bab.Name==_ab then bab:Play()
bab.Volume=dca*0.27 elseif bab.Volume>0 then bab:Stop()bab.Volume=0 end end end end;local ada=false;local function bda(_ab)
if not ada then ada=true;aba(_ab)playTrack(_ab.Name)end end
if
game.ReplicatedStorage:FindFirstChild("backgroundMusic")then
bda(game.ReplicatedStorage.backgroundMusic)else playTrack("Village")end
game.ReplicatedStorage.ChildAdded:connect(function(_ab)if
_ab.Name=="backgroundMusic"then bda(_ab)end end)local cda=Instance.new("Sound")cda.Parent=script;cda.Volume=0.1
cda.Looped=true;cda.Name="noise"
local function dda(_ab)if cda.SoundId~=_ab then cda:Stop()cda.SoundId=_ab
cda:Play()end end
local function __b()if
game.PlaceId==3232913902 or game.PlaceId==2544075708 then return end
if game.Lighting.ClockTime<=6.5 or
game.Lighting.ClockTime>=18 then
dda("rbxassetid://"..2049803364)cda.Volume=0.27 else if workspace:FindFirstChild("forest")then
dda("rbxassetid://"..2050179392)cda.Volume=0.4 else dda("rbxassetid://"..2050176819)
cda.Volume=0.75 end end end;__b()
game.Lighting:GetPropertyChangedSignal("ClockTime"):connect(__b)
daa=d_a:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","userSettings")
if daa.musicVolume then _da(daa.musicVolume or 0.5)end
d_a:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",function(_ab,aab)if _ab=="userSettings"then daa=aab
_da(aab.musicVolume or 0.5)end end)
d_a:create("{483BF873-91D4-45C3-9E92-87532E15EB8A}","BindableEvent","Event",_da)
local function a_b()return
game.Lighting.ClockTime<5.9 or game.Lighting.ClockTime>18.6 end
local function b_b()
if
game.Lighting.ClockTime<5.9 or game.Lighting.ClockTime>18.6 then return 1 elseif game.Lighting.ClockTime>=5.6 and
game.Lighting.ClockTime<=6.6 then return 1 elseif game.Lighting.ClockTime>=17.6 and
game.Lighting.ClockTime<=18.6 then return 1 else return 1 end end;local c_b;local function d_b(_ab)c_b=_ab
for aab,bab in pairs(_ba)do bab.PlaybackSpeed=(c_b and 0.4 or b_b())end end
d_a:create("{AC36B45C-65E9-405C-B6C1-E88A3F28A29E}","BindableFunction","OnInvoke",d_b)while wait(1)do
for _ab,aab in pairs(_ba)do aab.PlaybackSpeed=(c_b and 0.4 or b_b())end end