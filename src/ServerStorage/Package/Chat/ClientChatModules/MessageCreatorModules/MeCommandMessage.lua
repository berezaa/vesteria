local _a=script.Parent.Parent
local aa=require(_a:WaitForChild("ChatSettings"))
local ba=require(_a:WaitForChild("ChatConstants"))
local ca=require(script.Parent:WaitForChild("Util"))
function CreateMeCommandMessageLabel(da,_b)
if _b~=da.OriginalChannel then if aa.ShowChannelsBar then return end end;local ab=da.FromSpeaker;local bb=da.Message;local cb=da.ExtraData or{}local db=cb.Font or
Enum.Font.SourceSansItalic
local _c=cb.TextSize or aa.ChatWindowTextSize;local ac=cb.NameColor or aa.DefaultNameColor
local bc=cb.ChatColor or aa.DefaultChatColor;local cc=cb.ChannelColor or bc;local dc=cb.Tags or{}
local _d=string.format("%s ",ab)local ad=ca:GetStringTextBounds(_d,db,_c)
local bd=ca:GetNumberOfSpaces(_d,db,_c)local cd=UDim2.new(0,0,0,0)
local dd,__a=ca:CreateBaseMessage("",db,_c,bc)local a_a=ca:AddNameButtonToBaseMessage(__a,ac,_d,ab)
local b_a=nil
if _b~=da.OriginalChannel then
local _ba=string.format("{%s} ",da.OriginalChannel)
b_a=ca:AddChannelButtonToBaseMessage(__a,cc,_ba,da.OriginalChannel)bd=bd+ca:GetNumberOfSpaces(_ba,db,_c)
cd=UDim2.new(0,b_a.Size.X.Offset,0,0)end;local c_a={}
for _ba,aba in pairs(dc)do
local bba=aba.TagColor or Color3.fromRGB(255,0,255)local cba=aba.TagText or"???"
local dba=string.format("[%s] ",cba)local _ca=ca:AddTagLabelToBaseMessage(__a,bba,dba)
_ca.Position=cd;bd=bd+ca:GetNumberOfSpaces(dba,db,_c)cd=cd+
UDim2.new(0,_ca.Size.X.Offset,0,0)table.insert(c_a,_ca)end;a_a.Position=cd
local function d_a(_ba)
if da.IsFiltered then __a.Text=string.rep(" ",bd)..
string.sub(_ba.Message,5)else
local aba=
string.len(_ba.FromSpeaker)+_ba.MessageLength-4
__a.Text=string.rep(" ",bd)..string.rep("_",aba)end end;d_a(da)
local function _aa(_ba)return ca:GetMessageHeight(__a,dd,_ba)end;local aaa={}
aaa[a_a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=__a.TextStrokeTransparency,FadedOut=1}}
aaa[__a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=__a.TextStrokeTransparency,FadedOut=1}}
for _ba,aba in pairs(c_a)do local bba=string.format("Tag%d",_ba)
aaa[aba]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=__a.TextStrokeTransparency,FadedOut=1}}end;if b_a then
aaa[b_a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=__a.TextStrokeTransparency,FadedOut=1}}end
local baa,caa,daa=ca:CreateFadeFunctions(aaa)
return
{[ca.KEY_BASE_FRAME]=dd,[ca.KEY_BASE_MESSAGE]=__a,[ca.KEY_UPDATE_TEXT_FUNC]=d_a,[ca.KEY_GET_HEIGHT]=_aa,[ca.KEY_FADE_IN]=baa,[ca.KEY_FADE_OUT]=caa,[ca.KEY_UPDATE_ANIMATION]=daa}end;return
{[ca.KEY_MESSAGE_TYPE]=ba.MessageTypeMeCommand,[ca.KEY_CREATOR_FUNCTION]=CreateMeCommandMessageLabel}