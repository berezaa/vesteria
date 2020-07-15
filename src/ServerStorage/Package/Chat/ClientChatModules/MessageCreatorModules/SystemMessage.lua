local _a=script.Parent.Parent
local aa=require(_a:WaitForChild("ChatSettings"))
local ba=require(_a:WaitForChild("ChatConstants"))
local ca=require(script.Parent:WaitForChild("Util"))
function CreateSystemMessageLabel(da,_b)
if _b~=da.OriginalChannel then if aa.ShowChannelsBar then return end end;local ab=da.Message;local bb=da.ExtraData or{}
local cb=bb.Font or aa.DefaultFont;local db=bb.TextSize or aa.ChatWindowTextSize;local _c=bb.ChatColor or
aa.DefaultMessageColor
local ac=Color3.fromRGB(255,0,0)local bc,cc=ca:CreateBaseMessage(ab,cb,db,_c)local dc=nil
if
_b~=da.OriginalChannel then
local __a=string.format("[%s] ",string.upper(da.OriginalChannel))
dc=ca:AddChannelButtonToBaseMessage(cc,ac,__a,da.OriginalChannel)local a_a=ca:GetNumberOfSpaces(__a,cb,db)cc.Text=
string.rep(" ",a_a)..ab end
local function _d(__a)return ca:GetMessageHeight(cc,bc,__a)end;local ad={}
ad[cc]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=cc.TextStrokeTransparency,FadedOut=1}}if dc then
ad[dc]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=cc.TextStrokeTransparency,FadedOut=1}}end
local bd,cd,dd=ca:CreateFadeFunctions(ad)
return
{[ca.KEY_BASE_FRAME]=bc,[ca.KEY_BASE_MESSAGE]=cc,[ca.KEY_UPDATE_TEXT_FUNC]=nil,[ca.KEY_GET_HEIGHT]=_d,[ca.KEY_FADE_IN]=bd,[ca.KEY_FADE_OUT]=cd,[ca.KEY_UPDATE_ANIMATION]=dd}end;return
{[ca.KEY_MESSAGE_TYPE]=ba.MessageTypeSystem,[ca.KEY_CREATOR_FUNCTION]=CreateSystemMessageLabel}