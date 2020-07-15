local ca=game:GetService("StarterGui")
local da=game:GetService("GuiService")local _b=game:GetService("Chat")local ab=10
local bb=_b:WaitForChild("ClientChatModules")
local cb=require(bb:WaitForChild("ChatSettings"))
local function db()
local _c=require(script:WaitForChild("ChatMain"))local ac={}ac.ChatWindow={}ac.SetCore={}ac.GetCore={}
ac.ChatWindow.ChatTypes={}
ac.ChatWindow.ChatTypes.BubbleChatEnabled=cb.BubbleChatEnabled
ac.ChatWindow.ChatTypes.ClassicChatEnabled=cb.ClassicChatEnabled;local function bc(cd)local dd=Instance.new("BindableEvent")dd.Name=cd
ac.ChatWindow[cd]=dd
dd.Event:connect(function(...)_c[cd](_c,...)end)end;local function cc(cd)
local dd=Instance.new("BindableFunction")dd.Name=cd;ac.ChatWindow[cd]=dd
dd.OnInvoke=function(...)return _c[cd](_c,...)end end;local function dc(cd)
local dd=Instance.new("BindableEvent")dd.Name=cd;ac.ChatWindow[cd]=dd
_c[cd]:connect(function(...)dd:Fire(...)end)end
local function _d(cd)
local dd=Instance.new("BindableEvent")dd.Name=cd;ac.ChatWindow[cd]=dd;dd.Event:connect(function(...)
_c[cd]:fire(...)end)end;local function ad(cd)local dd=Instance.new("BindableEvent")dd.Name=cd
ac.SetCore[cd]=dd
dd.Event:connect(function(...)_c[cd.."Event"]:fire(...)end)end;local function bd(cd)
local dd=Instance.new("BindableFunction")dd.Name=cd;ac.GetCore[cd]=dd
dd.OnInvoke=function(...)return _c["f"..cd](...)end end
bc("ToggleVisibility")bc("SetVisible")bc("FocusChatBar")
bc("EnterWhisperState")cc("GetVisibility")cc("GetMessageCount")
bc("TopbarEnabledChanged")cc("IsFocused")dc("ChatBarFocusChanged")
dc("VisibilityStateChanged")dc("MessagesChanged")dc("MessagePosted")
_d("CoreGuiEnabled")ad("ChatMakeSystemMessage")ad("ChatWindowPosition")
ad("ChatWindowSize")bd("ChatWindowPosition")bd("ChatWindowSize")
ad("ChatBarDisabled")bd("ChatBarDisabled")bc("SpecialKeyPressed")
SetCoreGuiChatConnections(ac)end
function SetCoreGuiChatConnections(_c)local ac=0
while ac<ab do ac=ac+1
local bc,cc=pcall(function()
ca:SetCore("CoreGuiChatConnections",_c)end)if bc then break end;if not bc and ac==ab then
error("Error calling SetCore CoreGuiChatConnections: "..cc)end;wait()end end
function checkBothChatTypesDisabled()
if cb.BubbleChatEnabled~=nil then if cb.ClassicChatEnabled~=nil then
return not(cb.BubbleChatEnabled or
cb.ClassicChatEnabled)end end;return false end
if(not da:IsTenFootInterface())and(not
game:GetService('UserInputService').VREnabled)then
if not
checkBothChatTypesDisabled()then db()else local _c={}_c.ChatWindow={}
_c.ChatWindow.ChatTypes={}_c.ChatWindow.ChatTypes.BubbleChatEnabled=false
_c.ChatWindow.ChatTypes.ClassicChatEnabled=false;SetCoreGuiChatConnections(_c)end end