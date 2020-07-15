local ba=game:GetService("RunService")
local ca=game:GetService("ReplicatedStorage")local da=require(ca.modules)local _b=da.load("network")
local ab=require(game.ReplicatedStorage:WaitForChild("itemData"))local bb={}
function bb.getSellValue(cb,db)local _c=cb.sellValue or 0;if db and db.enchantments then
for ac,bc in
pairs(db.enchantments)do local cc=ab[bc.id]_c=_c+cc.sellValue end end;return _c end;return bb