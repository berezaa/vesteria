local _a=game:GetService("CollectionService")
local aa=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ba=aa.load("network")local ca=aa.load("utilities")
ba:create("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}","RemoteEvent","OnServerEvent",function(da,_b,ab)if
not da then return end;if not da.Character then return end;if
not da.Character.PrimaryPart then return end
local bb=(_b.Position-da.Character.PrimaryPart.Position).Magnitude
local cb=4 +math.max(_b.Size.X,_b.Size.Y,_b.Size.Z)if bb<cb then
ba:fireAllClientsExcludingPlayer("{DE89E914-D0E2-44DA-BB30-C8D4CE035205}",da,da.Character.PrimaryPart.Position,ab)end end)
ba:create("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}","RemoteEvent","OnServerEvent",function(da,_b,ab)if not da then return end;if not da.Character then
return end
if not da.Character.PrimaryPart then return end;if not _a:HasTag(_b,"attackable")then return end
local bb=_b:FindFirstChild("attackableScript")if not bb then return end;bb=require(bb)
local cb=(_b.Position-
da.Character.PrimaryPart.Position).Magnitude
local db=4 +math.max(_b.Size.X,_b.Size.Y,_b.Size.Z)if cb>db then return end;bb.onAttackedServer(da)
ba:fireAllClientsExcludingPlayer("{9042BF38-39B3-490D-BF5E-1C0771CC5A55}",da,da,_b,ab)end)return{}