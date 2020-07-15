local da={}local _b={}_b.__index=_b;local ab=game:GetService("Chat")
local bb=ab:WaitForChild("ClientChatModules")local cb=bb:WaitForChild("CommandModules")
local db=require(cb:WaitForChild("Util"))local _c=script.Parent
local ac=require(bb:WaitForChild("ChatSettings"))
function _b:SetupCommandProcessors()local bc=cb:GetChildren()
for i=1,#bc do
if bc[i]:IsA("ModuleScript")then
if
bc[i].Name~="Util"then local cc=require(bc[i])
local dc=cc[db.KEY_COMMAND_PROCESSOR_TYPE]local _d=cc[db.KEY_PROCESSOR_FUNCTION]
if
dc==db.IN_PROGRESS_MESSAGE_PROCESSOR then
table.insert(self.InProgressMessageProcessors,_d)elseif dc==db.COMPLETED_MESSAGE_PROCESSOR then
table.insert(self.CompletedMessageProcessors,_d)end end end end end
function _b:ProcessCompletedChatMessage(bc,cc)
for i=1,#self.CompletedMessageProcessors do
local dc=self.CompletedMessageProcessors[i](bc,cc,ac)if dc then return true end end;return false end
function _b:ProcessInProgressChatMessage(bc,cc,dc)
for i=1,#self.InProgressMessageProcessors do
local _d=self.InProgressMessageProcessors[i](bc,cc,dc,ac)if _d then return _d end end;return nil end
function da.new()local bc=setmetatable({},_b)bc.CompletedMessageProcessors={}
bc.InProgressMessageProcessors={}bc:SetupCommandProcessors()return bc end;return da