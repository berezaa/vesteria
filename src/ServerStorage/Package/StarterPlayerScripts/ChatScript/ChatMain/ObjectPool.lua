local d={}local _a=script.Parent;local aa={}aa.__index=aa
function aa:GetInstance(ba)
if
self.InstancePoolsByClass[ba]==nil then self.InstancePoolsByClass[ba]={}end;local ca=#self.InstancePoolsByClass[ba]if ca>0 then
local da=self.InstancePoolsByClass[ba][ca]
table.remove(self.InstancePoolsByClass[ba])return da end;return
Instance.new(ba)end
function aa:ReturnInstance(ba)if self.InstancePoolsByClass[ba.ClassName]==nil then
self.InstancePoolsByClass[ba.ClassName]={}end
if#
self.InstancePoolsByClass[ba.ClassName]<self.PoolSizePerType then
table.insert(self.InstancePoolsByClass[ba.ClassName],ba)else ba:Destroy()end end
function d.new(ba)local ca=setmetatable({},aa)ca.InstancePoolsByClass={}
ca.Name="ObjectPool"ca.PoolSizePerType=ba;return ca end;return d