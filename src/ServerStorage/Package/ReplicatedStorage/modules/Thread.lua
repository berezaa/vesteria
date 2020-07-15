local c={}
local d=game:GetService("RunService").Heartbeat
function c.SpawnNow(_a,...)local aa=table.pack(...)
local ba=Instance.new("BindableEvent")
ba.Event:Connect(function()_a(table.unpack(aa,1,aa.n))end)ba:Fire()ba:Destroy()end;function c.Spawn(_a,...)local aa=table.pack(...)local ba
ba=d:Connect(function()ba:Disconnect()
_a(table.unpack(aa,1,aa.n))end)end
function c.Delay(_a,aa,...)
local ba=table.pack(...)local ca=(tick()+_a)local da
da=d:Connect(function()if(tick()>=ca)then da:Disconnect()
aa(table.unpack(ba,1,ba.n))end end)return da end
function c.DelayRepeat(_a,aa,...)local ba=table.pack(...)local ca=(tick()+_a)local da
da=d:Connect(function()
if
(tick()>=ca)then ca=(tick()+_a)aa(table.unpack(ba,1,ba.n))end end)return da end;return c