local bc={Client={}}local cc;local dc;local _d;local ad;local bd;local cd="HarvestResource"
local dd="ResourceDepleted"local __a="ResourceReplenished"local a_a;local b_a={}local c_a={}
local function d_a(caa)local daa={}c_a[caa]=daa;return daa end
local function _aa(caa,daa)local _ba={}_ba.HarvestsLeft=daa.Metadata.Harvests.Value
_ba.DropPoints=daa.Metadata.DropPoints:GetChildren()c_a[caa][daa]=_ba;return _ba end
local function aaa(caa)local daa=0;for _ba,aba in pairs(caa)do daa=daa+aba.Value end;return daa end
local function baa(caa)local daa=Random.new()local _ba=daa:NextNumber(0,1)
local aba=aaa(caa)*_ba
for bba,cba in pairs(caa)do aba=aba-cba.Value;if aba<0 then return cba.Item end end end
function bc:ResourceNodeDepleted(caa,daa)local _ba=c_a[caa]local aba=_ba[daa]local bba=daa.Metadata;if
(bba.Replenish.Value)then
bd.Delay(bba.Replenish.Time.Value,self.ResourceNodeReplenished,self,caa,daa)end
self:FireClient(dd,caa,daa)end
function bc:ResourceNodeReplenished(caa,daa)local _ba=c_a[caa]local aba=_ba[daa]local bba=daa.Metadata
aba.HarvestsLeft=bba.Harvests.Value;aba.DropPoints=bba.DropPoints:GetChildren()
self:FireClient(__a,caa,daa)end
function bc:HarvestResource(caa,daa)local _ba=caa.Character
if _ba then
if typeof(daa)=="Instance"then
if daa:IsA("Folder")and
daa.Parent.Parent==a_a then
local aba=daa.Model:GetBoundingBox().Position;local bba=_ba:GetPrimaryPartCFrame().Position
local cba=(aba-bba).Magnitude
if
cba<daa.Model:GetExtentsSize().Magnitude*1.25 then local dba=c_a[caa]or d_a(caa)
local _ca=dba[daa]or _aa(caa,daa)local aca=_ca.HarvestsLeft
if aca>0 then local bca=Random.new()local cca=daa.Metadata
local dca=baa(cca.Drops:GetChildren())
local _da=bca:NextInteger(dca.Min.Value,dca.Max.Value)local ada=bca:NextInteger(1,#_ca.DropPoints)
local bda=_ca.DropPoints[ada]
local cda=bda and bda.Value.DropAttachment.WorldPosition or
daa.Model.PrimaryPart.Position+
Vector3.new(0,daa.Model.PrimaryPart.Size.Y/2 +0.1,0)
local dda=
bda and

(
CFrame.new(Vector3.new(daa.Model.PrimaryPart.Position.X,0,daa.Model.PrimaryPart.Position.Z),Vector3.new(cda.X,0,cda.Z))*CFrame.Angles(math.rad(45),0,0)).LookVector*32 or
(CFrame.new(0,math.pi*2 *math.random(),0)*CFrame.new(-
math.pi/4,0,0)).LookVector*32
local __b=dc:SpawnItemOnGround({id=dca.Value},cda,{caa})
__b.Velocity=
(CFrame.new(0,math.pi*2 *math.random(),0)*CFrame.new(
-math.pi/4,0,0)).LookVector*32;ad.FastRemove(_ca.DropPoints,ada)aca=aca-1
_ca.HarvestsLeft=aca
if aca==0 then self:ResourceNodeDepleted(caa,daa)end;return bda and bda.Value or nil end end end end end end;function bc:Start()a_a=_d:GetPlaceFolder("ResourceNodes")
self:ConnectClientEvent(cd,function(caa,daa)
self:HarvestResource(caa,daa)end)end
function bc:Init()
cc=self.Modules.GameServices;dc=self.Services.InventoryService;_d=self.Shared.PlaceSetup
ad=self.Shared.TableUtil;bd=self.Shared.Thread;self:RegisterClientEvent(cd)
self:RegisterClientEvent(dd)self:RegisterClientEvent(__a)end;return bc