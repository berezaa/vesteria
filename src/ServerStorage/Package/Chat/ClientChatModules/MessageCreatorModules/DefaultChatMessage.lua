local _a=script.Parent.Parent
local aa=require(_a:WaitForChild("ChatSettings"))
local ba=require(_a:WaitForChild("ChatConstants"))
local ca=require(script.Parent:WaitForChild("Util"))
function CreateMessageLabel(da,_b)
if _b~=da.OriginalChannel then if aa.ShowChannelsBar then return end end;local ab=da.FromSpeaker;local bb=da.Message;local cb=da.ExtraData or{}local db=cb.Font or
aa.DefaultFont
local _c=cb.TextSize or aa.ChatWindowTextSize;local ac=cb.NameColor or aa.DefaultNameColor
local bc=cb.ChatColor or aa.DefaultChatColor;local cc=cb.ChannelColor or bc;local dc=cb.Tags or{}
local _d=string.format("%s: ",ab)local ad=ca:GetStringTextBounds(_d,db,_c)
local bd=ca:GetNumberOfSpaces(_d,db,_c)local cd,dd=ca:CreateBaseMessage("",db,_c,bc)
local __a=ca:AddNameButtonToBaseMessage(dd,ac,_d,ab)local a_a=nil;local b_a=UDim2.new(0,0,0,0)
if _b~=da.OriginalChannel then
local aba=string.format("{%s} ",da.OriginalChannel)
a_a=ca:AddChannelButtonToBaseMessage(dd,cc,aba,da.OriginalChannel)b_a=UDim2.new(0,a_a.Size.X.Offset,0,0)bd=bd+
ca:GetNumberOfSpaces(aba,db,_c)end;local c_a={}local d_a=game.Players:FindFirstChild(ab)
if d_a and
d_a:FindFirstChild("level")then local aba=Color3.fromRGB(255,219,12)local bba="Lvl."..
d_a.level.Value;local cba=string.format("[%s] ",bba)
local dba=ca:AddTagLabelToBaseMessage(dd,aba,cba)dba.Position=b_a
bd=bd+ca:GetNumberOfSpaces(cba,db,_c)
b_a=b_a+UDim2.new(0,dba.Size.X.Offset,0,0)table.insert(c_a,dba)end
for aba,bba in pairs(dc)do
local cba=bba.TagColor or Color3.fromRGB(255,0,255)local dba=bba.TagText or"???"
local _ca=string.format("[%s] ",dba)local aca=ca:AddTagLabelToBaseMessage(dd,cba,_ca)
aca.Position=b_a;bd=bd+ca:GetNumberOfSpaces(_ca,db,_c)b_a=b_a+
UDim2.new(0,aca.Size.X.Offset,0,0)table.insert(c_a,aca)end;__a.Position=b_a
local function _aa(aba)if da.IsFiltered then
dd.Text=string.rep(" ",bd)..aba.Message else
dd.Text=string.rep(" ",bd)..string.rep("_",aba.MessageLength)end end;_aa(da)
local function aaa(aba)return ca:GetMessageHeight(dd,cd,aba)end;local baa={}
baa[__a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=dd.TextStrokeTransparency,FadedOut=1}}
baa[dd]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=dd.TextStrokeTransparency,FadedOut=1}}
for aba,bba in pairs(c_a)do local cba=string.format("Tag%d",aba)
baa[bba]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=dd.TextStrokeTransparency,FadedOut=1}}end;if a_a then
baa[a_a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=dd.TextStrokeTransparency,FadedOut=1}}end
local caa,daa,_ba=ca:CreateFadeFunctions(baa)
return
{[ca.KEY_BASE_FRAME]=cd,[ca.KEY_BASE_MESSAGE]=dd,[ca.KEY_UPDATE_TEXT_FUNC]=_aa,[ca.KEY_GET_HEIGHT]=aaa,[ca.KEY_FADE_IN]=caa,[ca.KEY_FADE_OUT]=daa,[ca.KEY_UPDATE_ANIMATION]=_ba}end;return
{[ca.KEY_MESSAGE_TYPE]=ba.MessageTypeDefault,[ca.KEY_CREATOR_FUNCTION]=CreateMessageLabel}