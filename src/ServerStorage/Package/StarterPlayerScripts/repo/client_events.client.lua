local _a=game:GetService("ReplicatedStorage")
local aa=require(_a:WaitForChild("modules"))local ba=aa.load("network")local ca=aa.load("events")
ba:connect("{6DEF77D4-5CCF-4793-98CB-E7ADE2B46F5F}","OnClientEvent",function(...)
ca:fireEventLocal(...)end)