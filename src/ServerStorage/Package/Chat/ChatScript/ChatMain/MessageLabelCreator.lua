local bb=50;local cb={}local db=game:GetService("Chat")
local _c=db:WaitForChild("ClientChatModules")local ac=_c:WaitForChild("MessageCreatorModules")
local bc=require(ac:WaitForChild("Util"))local cc=script.Parent
local dc=require(_c:WaitForChild("ChatSettings"))local _d=require(cc:WaitForChild("ObjectPool"))
local ad=require(cc:WaitForChild("MessageSender"))local bd={}bd.__index=bd;function mergeProps(cd,dd)if not cd then return end
for __a,a_a in pairs(cd)do dd[__a]=a_a end end
function ReturnToObjectPoolRecursive(cd,dd)
local __a=cd:GetChildren()
for i=1,#__a do ReturnToObjectPoolRecursive(__a[i],dd)end;cd.Parent=nil;dd:ReturnInstance(cd)end
function GetMessageCreators()local cd={}local dd=ac:GetChildren()
for i=1,#dd do
if dd[i]:IsA("ModuleScript")then if
dd[i].Name~="Util"then local __a=require(dd[i])
cd[__a[bc.KEY_MESSAGE_TYPE]]=__a[bc.KEY_CREATOR_FUNCTION]end end end;return cd end
function bd:WrapIntoMessageObject(cd,dd)local __a=dd[bc.KEY_BASE_FRAME]local a_a=nil;if bc.KEY_BASE_MESSAGE then
a_a=dd[bc.KEY_BASE_MESSAGE]end;local b_a=dd[bc.KEY_UPDATE_TEXT_FUNC]
local c_a=dd[bc.KEY_GET_HEIGHT]local d_a=dd[bc.KEY_FADE_IN]local _aa=dd[bc.KEY_FADE_OUT]
local aaa=dd[bc.KEY_UPDATE_ANIMATION]local baa={}baa.ID=cd.ID;baa.BaseFrame=__a;baa.BaseMessage=a_a
baa.UpdateTextFunction=b_a or function()
warn("NO MESSAGE RESIZE FUNCTION")end;baa.GetHeightFunction=c_a;baa.FadeInFunction=d_a;baa.FadeOutFunction=_aa
baa.UpdateAnimFunction=aaa;baa.ObjectPool=self.ObjectPool;baa.Destroyed=false;function baa:Destroy()
ReturnToObjectPoolRecursive(self.BaseFrame,self.ObjectPool)self.Destroyed=true end
return baa end
function bd:CreateMessageLabel(cd,dd)cd.Channel=dd;local __a
pcall(function()
__a=db:InvokeChatCallback(Enum.ChatCallbackType.OnClientFormattingMessage,cd)end)cd.ExtraData=cd.ExtraData or{}
mergeProps(__a,cd.ExtraData)local a_a=cd.MessageType
if self.MessageCreators[a_a]then
local b_a=self.MessageCreators[a_a](cd,dd)
if b_a then return self:WrapIntoMessageObject(cd,b_a)end elseif self.DefaultCreatorType then
local b_a=self.MessageCreators[self.DefaultCreatorType](cd,dd)
if b_a then return self:WrapIntoMessageObject(cd,b_a)end else
error("No message creator available for message type: "..a_a)end end
function cb.new()local cd=setmetatable({},bd)cd.ObjectPool=_d.new(bb)
cd.MessageCreators=GetMessageCreators()cd.DefaultCreatorType=bc.DEFAULT_MESSAGE_CREATOR
bc:RegisterObjectPool(cd.ObjectPool)return cd end
function cb:GetStringTextBounds(cd,dd,__a,a_a)return bc:GetStringTextBounds(cd,dd,__a,a_a)end;return cb