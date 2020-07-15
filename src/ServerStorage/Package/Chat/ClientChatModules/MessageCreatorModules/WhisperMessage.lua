local ba=game:GetService("Players")local ca=ba.LocalPlayer;while not ca do
ba.ChildAdded:wait()ca=ba.LocalPlayer end
local da=script.Parent.Parent
local _b=require(da:WaitForChild("ChatSettings"))
local ab=require(da:WaitForChild("ChatConstants"))
local bb=require(script.Parent:WaitForChild("Util"))
function CreateMessageLabel(cb,db)
if db~=cb.OriginalChannel then if _b.ShowChannelsBar then return end end;local _c=cb.FromSpeaker;local ac=cb.Message;local bc=cb.ExtraData or{}local cc=bc.Font or
_b.DefaultFont
local dc=bc.TextSize or _b.ChatWindowTextSize;local _d=bc.NameColor or _b.DefaultNameColor
local ad=bc.ChatColor or _b.DefaultChatColor;local bd=bc.ChannelColor or ad;local cd=bc.Tags or{}
local dd=string.format("[%s]: ",_c)local __a=bb:GetStringTextBounds(dd,cc,dc)
local a_a=bb:GetNumberOfSpaces(dd,cc,dc)local b_a,c_a=bb:CreateBaseMessage("",cc,dc,ad)
local d_a=bb:AddNameButtonToBaseMessage(c_a,_d,dd,_c)local _aa=nil;local aaa=UDim2.new(0,0,0,0)
if db~=cb.OriginalChannel then
local dba=cb.OriginalChannel;if cb.FromSpeaker~=ca.Name then
dba=string.format("From %s",cb.FromSpeaker)end
local _ca=string.format("{%s} ",dba)
_aa=bb:AddChannelButtonToBaseMessage(c_a,bd,_ca,cb.OriginalChannel)aaa=UDim2.new(0,_aa.Size.X.Offset,0,0)a_a=a_a+
bb:GetNumberOfSpaces(_ca,cc,dc)end;local baa={}
for dba,_ca in pairs(cd)do
local aca=_ca.TagColor or Color3.fromRGB(255,0,255)local bca=_ca.TagText or"???"
local cca=string.format("[%s] ",bca)local dca=bb:AddTagLabelToBaseMessage(c_a,aca,cca)
dca.Position=aaa;a_a=a_a+bb:GetNumberOfSpaces(cca,cc,dc)aaa=aaa+
UDim2.new(0,dca.Size.X.Offset,0,0)table.insert(baa,dca)end;d_a.Position=aaa
local function caa(dba)if cb.IsFiltered then
c_a.Text=string.rep(" ",a_a)..dba.Message else
c_a.Text=string.rep(" ",a_a)..string.rep("_",dba.MessageLength)end end;caa(cb)
local function daa(dba)return bb:GetMessageHeight(c_a,b_a,dba)end;local _ba={}
_ba[d_a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=c_a.TextStrokeTransparency,FadedOut=1}}
_ba[c_a]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=c_a.TextStrokeTransparency,FadedOut=1}}
for dba,_ca in pairs(baa)do local aca=string.format("Tag%d",dba)
_ba[_ca]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=c_a.TextStrokeTransparency,FadedOut=1}}end;if _aa then
_ba[_aa]={TextTransparency={FadedIn=0,FadedOut=1},TextStrokeTransparency={FadedIn=c_a.TextStrokeTransparency,FadedOut=1}}end
local aba,bba,cba=bb:CreateFadeFunctions(_ba)
return
{[bb.KEY_BASE_FRAME]=b_a,[bb.KEY_BASE_MESSAGE]=c_a,[bb.KEY_UPDATE_TEXT_FUNC]=caa,[bb.KEY_GET_HEIGHT]=daa,[bb.KEY_FADE_IN]=aba,[bb.KEY_FADE_OUT]=bba,[bb.KEY_UPDATE_ANIMATION]=cba}end;return
{[bb.KEY_MESSAGE_TYPE]=ab.MessageTypeWhisper,[bb.KEY_CREATOR_FUNCTION]=CreateMessageLabel}