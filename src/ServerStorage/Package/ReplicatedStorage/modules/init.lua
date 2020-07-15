local b={}
function b.load(c,d)
if script:FindFirstChild(c)then
return d and
require(script[c]:Clone())or require(script[c])else
if game:GetService("RunService"):IsClient()then
local _a=script:WaitForChild(c,15)if not _a then
error("Requesting module that probably doesn't exist: "..c)end;if d then return require(_a:Clone())else return
require(_a)end end end;return nil end;return b