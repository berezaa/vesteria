local ba=game:GetService("Chat")
local ca=ba:WaitForChild("ClientChatModules")
local da=require(ca:WaitForChild("ChatConstants"))local _b=da.StandardPriority;if _b==nil then _b=10 end;local ab={}ab.__index=ab;local bb={}
do
local cb={}cb.__index=cb
function cb:RebuildProcessCommandsPriorities()self.RegisteredPriorites={}
for db,_c in
pairs(self.FunctionMap)do local ac=true;for bc,cc in pairs(_c)do ac=false;break end;if not ac then
table.insert(self.RegisteredPriorites,db)end end
table.sort(self.RegisteredPriorites,function(db,_c)return db>_c end)end;function cb:HasFunction(db)
if self.RegisteredFunctions[db]==nil then return false end;return true end
function cb:RemoveFunction(db)
local _c=self.RegisteredFunctions[db]self.RegisteredFunctions[db]=nil;self.FunctionMap[_c][db]=
nil
self:RebuildProcessCommandsPriorities()end
function cb:AddFunction(db,_c,ac)if ac==nil then ac=_b end;if self.RegisteredFunctions[db]then
error(db.." is already in use!")end
self.RegisteredFunctions[db]=ac
if self.FunctionMap[ac]==nil then self.FunctionMap[ac]={}end;self.FunctionMap[ac][db]=_c
self:RebuildProcessCommandsPriorities()end
function cb:GetIterator()local db=1;local _c=nil;local ac=nil
return
function()
while true do
if db>#self.RegisteredPriorites then return end;local bc=self.RegisteredPriorites[db]
_c,ac=next(self.FunctionMap[bc],_c)if _c==nil then db=db+1 else return _c,ac,bc end end end end
function bb.new()local db=setmetatable({},cb)db.RegisteredFunctions={}
db.RegisteredPriorites={}db.FunctionMap={}return db end end;function ab:NewSortedFunctionContainer()return bb.new()end;return ab