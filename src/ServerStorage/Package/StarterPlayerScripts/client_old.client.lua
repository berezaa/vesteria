script.Parent:WaitForChild("assets")
_G.print=function(...)if
game.PlaceId==2061558182 then print(...)end end
local da={"animationInterface","entityRenderer","playerDataPropogationCache"}local _b=script.Parent:WaitForChild("repo")
local ab=game:GetService("ReplicatedStorage")local bb=require(ab.modules)local cb=bb.load("network")local function db(bc)return
require(_b[bc])end
local function _c()
cb:create("{3C02ECC4-52C5-4A56-BA47-81CE51581A1E}","BindableFunction","OnInvoke",db)local bc={}
for cc,dc in pairs(da)do local _d=_b:FindFirstChild(dc)
if _d then local ad;local bd,cd=pcall(function()
ad=require(_d)end)if not bd then
warn("client service ".._d.Name..
" failed to load!")warn(cd)end;bc[dc]=ad end end
for cc,dc in pairs(_b:GetChildren())do
if
dc:IsA("ModuleScript")and not bc[dc.Name]then local _d
local ad,bd=pcall(function()_d=require(dc)end)if not ad then
warn("client service "..dc.Name.." failed to load!")warn(bd)end;bc[dc.Name]=_d end end end;_c()local ac=game:GetService("StarterGui")