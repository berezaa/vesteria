local dd={Client={}}
local __a=game:GetService("ReplicatedStorage")local a_a;local b_a;local c_a;local d_a;local _aa;local aaa="HarvestResource"local baa="ResourceDepleted"
local caa="ResourceReplenished"local daa;local _ba={}local aba={}local bba={}
local function cba(bda)local cda={}bba[bda]=cda;return cda end
local function dba(bda)local cda={}local dda=bda.Parent.Metadata
local __b=bda:FindFirstChild("DropPoints")cda.HarvestsLeft=dda.Harvests.Value
cda.Durability=dda.Durability.Value
cda.DropPoints=__b and __b:GetChildren()or{}return cda end
local function _ca(bda,cda)
if bba[cda]and bba[cda][bda]then return bba[cda][bda]end;local dda=dba(bda)if not bba[cda]then cba(cda)[bda]=dda else
bba[cda][bda]=dda end;return dda end;local function aca(bda)if aba[bda]then return aba[bda]end;local cda=dba(bda)aba[bda]=cda
return cda end
local function bca(bda)local cda=0;for dda,__b in pairs(bda)do cda=cda+
__b.Value end;return cda end
local function cca(bda)local cda=Random.new()local dda=cda:NextNumber(0,1)
local __b=bca(bda)*dda
for a_b,b_b in pairs(bda)do __b=__b-b_b.Value;if __b<0 then return b_b.Item end end end
local function dca(bda,cda)local dda=bda.Parent.Metadata;local __b=dda.Global.Value;local a_b=__b and aca(bda)or
_ca(bda,cda)
local b_b=bda:FindFirstChild("DropPoints")a_b.HarvestsLeft=dda.Harvests.Value;a_b.DropPoints=
b_b and b_b:GetChildren()or{}
if __b then if dda.DestroyOnDeplete.Value then
for c_b,d_b in
pairs(bda:GetDescendants())do if d_b:IsA("BasePart")then d_b.CanCollide=true end end end
b_a:fireAllClients(caa,bda)else b_a:fireClient(caa,cda,bda)end end
local function _da(bda,cda)local dda=bda.Parent.Metadata;local __b=dda.Global.Value;local a_b=__b and aca(bda)or
_ca(bda,cda)if(dda.Replenish.Value)then
d_a.Delay(dda.Replenish.Time.Value,dca,bda,cda)end
if __b then if dda.DestroyOnDeplete.Value then
for b_b,c_b in
pairs(bda:GetDescendants())do if c_b:IsA("BasePart")then c_b.CanCollide=false end end end
b_a:fireAllClients(baa,bda)else b_a:fireClient(baa,cda,bda)end end
local function ada(bda,cda)local dda
if bda:IsA("BasePart")then dda=bda elseif bda:IsA("Model")and(bda.PrimaryPart or
bda:FindFirstChild("HumanoidRootPart"))then
local __b=
bda.PrimaryPart or bda:FindFirstChild("HumanoidRootPart")if __b then dda=__b end end;dda.Velocity=cda end
function dd:HarvestResource(bda,cda)local dda=cda.Character
if dda then
if typeof(bda)=="Instance"then
if bda:IsA("Model")and
bda.Parent.Parent==daa then
local __b=bda:GetBoundingBox().Position;local a_b=dda:GetPrimaryPartCFrame().Position
local b_b=(__b-a_b).Magnitude
if
b_b<bda:GetExtentsSize().Magnitude*1.25 then local c_b=bda.Parent.Metadata;local d_b=c_b.Global.Value
local _ab=c_b.ItemRolls.Value;local aab=d_b and aca(bda)or _ca(bda,cda)
local bab=aab.HarvestsLeft;local cab=aab.Durability
if bab>0 then
if cab==0 then local dab=Random.new()
local _bb=dab:NextInteger(1,#aab.DropPoints)local abb=aab.DropPoints[_bb]
local bbb=
abb and abb.Value.DropAttachment.WorldPosition or bda.PrimaryPart.Position+
Vector3.new(0,bda.PrimaryPart.Size.Y/2 +0.5,0)_aa.FastRemove(aab.DropPoints,_bb)bab=bab-1
aab.HarvestsLeft=bab;aab.Durability=c_b.Durability.Value
if bab==0 then _da(bda,cda)end
for i=1,_ab do local cbb=cca(c_b.Drops:GetChildren())
local dbb=dab:NextInteger(cbb.Min.Value,cbb.Max.Value)
for i=1,dbb do local _cb={id=cbb.Value}
local acb=
abb and
CFrame.new(Vector3.new(bda.PrimaryPart.Position.X,0,bda.PrimaryPart.Position.Z),Vector3.new(bbb.X,5,bbb.Z)).LookVector*32 or
CFrame.new(Vector3.new(0,0,0),Vector3.new(dab:NextNumber(-1,1),2,dab:NextNumber(-1,1))).LookVector*32;for ccb,dcb in pairs(cbb.Modifiers:GetChildren())do
_cb[dcb.Name]=dab:NextInteger(dcb.Min.Value,dcb.Max.Value)end
local bcb=b_a:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",_cb,bbb,
not d_b and{cda}or{})ada(bcb,acb)end end;return abb and abb.Value or nil else aab.Durability=cab-1 end end end end end end end;function dd:Start()end
function dd:Init()a_a=require(__a.modules)
b_a=a_a.load("network")c_a=a_a.load("placeSetup")d_a=a_a.load("Thread")
_aa=a_a.load("TableUtil")daa=c_a.getPlaceFolder("resourceNodes")
b_a:create(aaa,"RemoteFunction","OnServerInvoke",function(bda,cda)return
self:HarvestResource(cda,bda)end)b_a:create(baa,"RemoteEvent")
b_a:create(caa,"RemoteEvent")end;dd:Init()dd:Start()return dd