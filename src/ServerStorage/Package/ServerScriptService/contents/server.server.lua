
local bb=workspace:FindFirstChild("placeFolders")or
Instance.new("Folder",workspace)bb.Name="placeFolders"
local cb=script.Parent:WaitForChild("rootServices")
local db=script.Parent:WaitForChild("coreServices")local _c=script.Parent:WaitForChild("services")
local ac=game:GetService("HttpService")local bc=game:GetService("ReplicatedStorage")
local cc=require(bc.modules)local dc=cc.load("placeSetup")local _d=cc.load("network")
local ad=dc.getPlaceFolder("items")
local function bd()
for cd,dd in pairs(cb:GetChildren())do
local __a,a_a=pcall(function()require(dd)end)if not __a then
warn("root server service "..dd.Name.." failed to load!")warn(a_a)end end
for cd,dd in pairs(db:GetChildren())do
local __a,a_a=pcall(function()require(dd)end)if not __a then
warn("core server service "..dd.Name.." failed to load!")warn(a_a)end end
for cd,dd in pairs(_c:GetChildren())do
local __a,a_a=pcall(function()require(dd)end)if not __a then
warn("server service "..dd.Name.." failed to load!")warn(a_a)end end
_d:create("{9658901E-8F65-43C2-AC62-1A0E2E55839B}","RemoteEvent")
for cd,dd in
pairs(game.ReplicatedStorage.sounds:GetChildren())do
if dd:IsA("Sound")then local __a=Instance.new("StringValue")
__a.Name=dd.Name
local a_a={EmitterSize=dd.EmitterSize,Looped=dd.Looped,MaxDistance=dd.MaxDistance,PlaybackSpeed=dd.PlaybackSpeed,SoundId=dd.SoundId,Volume=dd.Volume,PlayOnRemove=dd.PlayOnRemove}__a.Value=ac:JSONEncode(a_a)for b_a,c_a in pairs(dd:GetChildren())do
c_a.Parent=__a end;dd:Destroy()
__a.Parent=game.ReplicatedStorage.sounds end end end;bd()