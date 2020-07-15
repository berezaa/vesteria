local da=game.Players.LocalPlayer
da:WaitForChild("dataLoaded",60)
local _b=require(game.ReplicatedStorage:WaitForChild("modules"))local ab=_b.load("network")local bb={}
local cb=ab:invokeServer("{9339B97A-B65E-4057-9C3E-38152E673557}")
for bc,cc in pairs(cb)do if workspace:FindFirstChild(cc[1])then
bb[cc[1]]=ab:invoke("{BA6DED4C-C2A5-4478-AABB-913C685E8DE0}",workspace:WaitForChild(cc[1]),cc[2],cc[3])end end
local function db(bc,cc,dc)if workspace:FindFirstChild(bc)and bb[bc]then
ab:invoke("{BFD65964-2D21-4001-9E3C-C0959AE35DFC}",bb[bc],cc,dc)end end
ab:connect("{7D49E50B-B400-470E-B16A-EF7B6E37BE08}","OnClientEvent",db)
ab:create("{5F65C927-3FC6-4F76-B110-3EBEA8BFA675}","BindableEvent","Event",db)local _c={}
local function ac(bc,cc,dc,_d,ad)local bd=_c[bc]if not bd then
bd=ab:invoke("{BA6DED4C-C2A5-4478-AABB-913C685E8DE0}",bc,_d,ad)_c[bc]=bd end
ab:invoke("{BFD65964-2D21-4001-9E3C-C0959AE35DFC}",bd,cc,dc)end
ab:connect("{C14AEAAA-F0F8-41F3-A1F6-3C75E311F28C}","OnClientEvent",ac)