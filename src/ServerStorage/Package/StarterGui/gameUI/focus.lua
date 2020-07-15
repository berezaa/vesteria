local c={}c.focused=nil
function c.toggle()warn("focus.toggle not ready")end
local function d(_a)local aa=Vector2.new(9999,9999)local ba
local function ca(da)
if(not da:IsA("GuiObject"))or
da.Visible then
if da:IsA("GuiButton")then
local _b=da.AbsolutePosition-_a.AbsolutePosition;if _b.magnitude<aa.magnitude then ba=da;aa=_b end end;for _b,ab in pairs(da:GetChildren())do ca(ab)end end end;ca(_a)return ba end;c.getBestButton=d
function c.init(_a)local aa=_a.network;local ba=_a.tween
local ca=game.Lighting:FindFirstChild("DepthOfField")
local function da()
local _b=not(c.focused==nil or c.focused.Visible==false)
aa:fire("{20F87B18-E1C4-453E-9CE1-1F4E6F225EC2}",_b)script.Parent.xboxMenuPrompt.Visible=_b end
function c.close()if c.focused then c.focused.Visible=false;c.focused=nil
ba(ca,{"FarIntensity","FocusDistance","InFocusRadius"},{0.25,200,0},0)end
if
_a.input.mode.Value=="xbox"then
game:GetService("GuiService").GuiNavigationEnabled=false
game:GetService("GuiService").SelectedObject=nil
pcall(function()
game:GetService("GuiService"):RemoveSelectionGroup("focus")end)end;da()end
function c.cleanup()
if _a.input.mode.Value=="xbox"then
game:GetService("GuiService").GuiNavigationEnabled=false
game:GetService("GuiService").SelectedObject=nil
pcall(function()
game:GetService("GuiService"):RemoveSelectionGroup("focus")end)end end
function c.change(_b)
if _a.input.mode.Value=="xbox"then
game:GetService("GuiService").GuiNavigationEnabled=false
game:GetService("GuiService").SelectedObject=nil
pcall(function()
game:GetService("GuiService"):RemoveSelectionGroup("focus")end)_b.Visible=true;game.GuiService.GuiNavigationEnabled=true
game.GuiService:AddSelectionParent("focus",_b)game.GuiService.SelectedObject=d(_b)
ba(ca,{"FarIntensity","FocusDistance","InFocusRadius"},{1,4,3},0)end end
function c.toggle(_b)_a.input.setCurrentFocusFrame(nil)
if c.focused then
if
_a.input.mode.Value=="xbox"then
game:GetService("GuiService").GuiNavigationEnabled=false
game:GetService("GuiService").SelectedObject=nil
pcall(function()
game:GetService("GuiService"):RemoveSelectionGroup("focus")end)if _b:IsDescendantOf(c.focused)then c.focused.Visible=false
ba(ca,{"FarIntensity","FocusDistance","InFocusRadius"},{0.25,200,0},0)end end end
if _b.Visible then _b.Visible=false;c.focused=nil;_b.ZIndex=2
ba(ca,{"FarIntensity","FocusDistance","InFocusRadius"},{0.25,200,0},0)else _b.Visible=true;if c.focused then c.focused.ZIndex=2 end;_b.ZIndex=3
c.focused=_b
ba(ca,{"FarIntensity","FocusDistance","InFocusRadius"},{1,4,3},0)end
if c.focused then
if _a.input.mode.Value=="xbox"then
game.GuiService:AddSelectionParent("focus",c.focused)game.GuiService.SelectedObject=d(c.focused)
warn("$",game.GuiService.SelectedObject)game.GuiService.GuiNavigationEnabled=true end end;da()end end;return c