local ab={}local bb={}local cb=game:GetService("ReplicatedStorage")
local db=require(cb.modules)local _c=db.load("network")local ac=db.load("utilities")local function bc(ad,bd)
bb[ad]=bd
_c:fire("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}",ad,bd)end;local function cc(ad)
for bd,cd in pairs(ad)do bc(bd,cd)end end;local function dc()
local ad=_c:invokeServer("{73CDB750-FC4E-4308-B763-4FE043D23ED6}")cc(ad)end
function ab:flushPropogationCache()dc()end
function ab:getByPropogationNameTag(ad)
if bb[ad]then if type(bb[ad])=="table"then
return ac.copyTable(bb[ad])else return bb[ad]end end;return nil end
local function _d()
_c:create("{B5BFDE4F-1C2E-4D65-ACB4-277DB309BF6D}","BindableEvent")
_c:create("{05288419-8F5D-45CA-B2EC-0792049B3FD3}","BindableEvent")
_c:connect("{9658901E-8F65-43C2-AC62-1A0E2E55839B}","OnClientEvent",bc)
_c:connect("{52DBE4DB-B72C-4132-B3D1-D3D3255E271A}","OnClientEvent",cc)ab:flushPropogationCache()
_c:create("{4947D6C0-3492-484E-8D54-243215910D55}","BindableFunction","OnInvoke",function()return
bb end)
_c:create("{C3B3E1B8-2157-405E-ACA7-C64854E10A0A}","BindableFunction","OnInvoke",function(ad)
return ab:getByPropogationNameTag(ad)end)end;_d()return ab