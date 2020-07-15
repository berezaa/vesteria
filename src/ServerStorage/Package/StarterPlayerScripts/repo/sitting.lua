local bb={}local cb=game:GetService("ReplicatedStorage")
local db=require(cb.modules)local _c=db.load("network")local ac=nil
local bc=game.Players.LocalPlayer
local function cc(cd)if
not bc or not bc.Character or not bc.Character.PrimaryPart then return false end
bc.Character.PrimaryPart.CFrame=
script.Parent.CFrame+Vector3.new(0,0.5,0)bc.Character.PrimaryPart.Anchored=true
_c:invoke("{F9682973-5852-429E-9BAC-8EBECA22DD97}","isSitting",true,script.Parent)ac=cd;return true end;local function dc()end;local function _d()end;local function ad()end
local function bd()
_c:create("{1676D160-1E78-4D25-BD95-49CEC36F7D16}","BindableFunction","OnInvoke",cc)
_c:create("{9D1FEFDF-7934-4331-B61F-CEEE05B519C0}","BindableFunction","OnInvoke",dc)
_c:create("{0345D965-6C3C-48BC-AF07-5C2B50F67C2D}","BindableFunction","OnInvoke",ad)end;return bb