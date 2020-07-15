local _a="UnknownMessage"local aa=script.Parent.Parent
local ba=require(aa:WaitForChild("ChatSettings"))
local ca=require(script.Parent:WaitForChild("Util"))function CreateUnknownMessageLabel(da)
print("No message creator for message: "..da.Message)end;return
{[ca.KEY_MESSAGE_TYPE]=_a,[ca.KEY_CREATOR_FUNCTION]=CreateUnknownMessageLabel}