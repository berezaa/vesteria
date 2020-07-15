local c=game:GetService("RunService")local d={}
function d.onHeartbeatFor(_a,aa)local ba;local ca=0
local function da(_b)ca=ca+
_b;if(_a>0)and(ca>=_a)then ba:Disconnect()end;local ab=(_a>0)and math.min(
ca/_a,1)or 0;if aa(_b,ca,ab)then
ba:Disconnect()end end;ba=c.Heartbeat:Connect(da)da(0)return ba end
function d.hideWeapons(_a)
local aa=require(game.ReplicatedStorage.modules).load("network")
local ba=aa:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",_a)if not ba then return end;local ca={}
for _b,ab in pairs(ba)do local bb=ab.manifest;if bb:IsA("BasePart")then
table.insert(ca,{part=bb,transparency=bb.Transparency})bb.Transparency=1 end
for cb,db in
pairs(bb:GetDescendants())do if db:IsA("BasePart")then
table.insert(ca,{part=db,transparency=db.Transparency})db.Transparency=1 end end end;local function da()
for _b,ab in pairs(ca)do ab.part.Transparency=ab.Transparency end end;return da end;return d