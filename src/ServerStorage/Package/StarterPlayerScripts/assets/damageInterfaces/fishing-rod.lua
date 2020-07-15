local caa={}caa.isEquipped=false
local daa=game:GetService("UserInputService")local _ba=game:GetService("HttpService")
local aba=game:GetService("ReplicatedStorage")local bba=require(aba.modules)local cba=bba.load("network")
local dba=bba.load("utilities")local _ca=bba.load("detection")
local aca=bba.load("placeSetup")local bca=bba.load("projectile")
local cca=bba.load("client_utilities")local dca=_ba:GenerateGUID(false)
local _da=require(script.Parent.Parent.Parent:WaitForChild("repo"):WaitForChild("animationInterface"))local ada;local bda;local cda;local dda=false;local __b=false;local a_b=false;local b_b=false;local c_b;local d_b
local _ab=game.Players.LocalPlayer;local aab=false;local bab=false;local cab;local dab;local _bb=0
function caa:attack()
if not bab then bab=true
if not aab then _bb=_bb+1
local _cb=cba:invoke("{7FE9D2B7-10FB-4012-8803-C5D8D5E8DFCA}")if not _cb or not _cb:FindFirstChild("entity")then
return false end
local acb=cba:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",_cb.entity)local bcb=acb["1"]and acb["1"].manifest
if not bcb then return end;local ccb,dcb=cca.raycastFromCurrentScreenPoint({_cb})
_da:replicatePlayerAnimationSequence("fishing-rodAnimations","cast-line",
nil,{targetPosition=dcb})
cba:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
cba:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isFishing",true)else
_da:replicatePlayerAnimationSequence("fishing-rodAnimations","reel-line")aab=false
spawn(function()wait(1)bab=false end)end end end
local function abb()
local _cb=cba:invoke("{861EE202-C233-489B-8CF8-DF5C9F4248C1}",_ab,"fishingBob")
if _cb and _cb.Parent then local acb=_bb
_cb.CFrame=_cb.CFrame-Vector3.new(0,1,0)_cb.splash:Emit(40)
dba.playSound("fishing_FishBite",_cb)wait(0.15)if acb==_bb then
dba.playSound("fishing_FishSplashOutOfWater",_cb)end;wait(0.1)
if acb==_bb then _cb.CFrame=_cb.CFrame-
Vector3.new(0,0.25,0)_cb.splash:Emit(40)end end end;function caa:equip()
c_b=cba:invoke("{E1A443FB-62B9-4FA8-B0D1-0930199949A1}")end
function caa:unequip()
if aab then
cba:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isFishing",false)
cba:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)
local _cb=cba:invoke("{861EE202-C233-489B-8CF8-DF5C9F4248C1}",game.Players.LocalPlayer,"fishingBob")if _cb then
game:GetService("Debris"):AddItem(_cb,1 /30)end;if cab and cab:FindFirstChild("line")then cab.line.Attachment1=
nil;cab=nil end;aab=false end end;local function bbb(_cb,acb)if _cb=="abilities"then d_b=acb end end
local function cbb(_cb)
if
not _cb then aab=false
cba:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isFishing",false)
cba:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)spawn(function()wait(1)bab=false end)else
aab=true;bab=false end end
local function dbb()
bbb("abilities",cba:invoke("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","abilities"))
cba:create("{65FD0D6A-9D70-4721-9805-E6B71951577C}","BindableEvent","Event",cbb)
cba:connect("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","Event",bbb)
cba:connect("{13EFDC34-33BB-47A4-B0E8-95EBEA676878}","OnClientEvent",abb)end;dbb()return caa