local _a=script.Parent.Parent
local aa=require(_a:WaitForChild("ChatSettings"))
local ba=require(_a:WaitForChild("ChatConstants"))
local ca=require(script.Parent:WaitForChild("Util"))
function CreateSetCoreMessageLabel(da,_b)
if _b~=da.OriginalChannel then if aa.ShowChannelsBar then return end end;local ab=da.Message;local bb=da.ExtraData or{}
local cb=bb.Font or aa.DefaultFont;local db=bb.TextSize or aa.ChatWindowTextSize;local _c=bb.Color or
aa.DefaultMessageColor
local ac,bc=ca:CreateBaseMessage(ab,cb,db,_c)
local function cc(cd)return ca:GetMessageHeight(bc,ac,cd)end;local dc={}
dc[bc]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=bc.TextStrokeTransparency,FadedOut=1}}local _d,ad,bd=ca:CreateFadeFunctions(dc)
return
{[ca.KEY_BASE_FRAME]=ac,[ca.KEY_BASE_MESSAGE]=bc,[ca.KEY_UPDATE_TEXT_FUNC]=
nil,[ca.KEY_GET_HEIGHT]=cc,[ca.KEY_FADE_IN]=_d,[ca.KEY_FADE_OUT]=ad,[ca.KEY_UPDATE_ANIMATION]=bd}end;return
{[ca.KEY_MESSAGE_TYPE]=ba.MessageTypeSetCore,[ca.KEY_CREATOR_FUNCTION]=CreateSetCoreMessageLabel}