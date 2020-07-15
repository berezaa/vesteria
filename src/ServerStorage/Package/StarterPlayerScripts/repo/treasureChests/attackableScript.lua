
local ad=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bd=ad.load("network")local cd=ad.load("tween")
local dd=ad.load("effects")local __a=ad.load("utilities")local a_a=script.Parent.Parent
local b_a=a_a.Parent;local c_a=a_a:GetPrimaryPartCFrame()local d_a={}local _aa=5;local aaa=false
local baa=nil;local caa=nil
local daa=script.Parent.Parent:FindFirstChild("AnimationController")
local _ba=script.Parent.Parent:FindFirstChild("Glow")
local aba=daa:LoadAnimation(script.Parent.Parent.chestOpenLoop)
local bba=daa:LoadAnimation(script.Parent.Parent.chestOpen)bba.Looped=false;bba.Priority=Enum.AnimationPriority.Action
aba.Looped=true;aba.Priority=Enum.AnimationPriority.Core
local function cba()
local aca,bca=bd:invoke("{52EA54C2-60BA-461B-8A07-678C59CAD99F}",b_a)if aca then aaa=true elseif bca then
bd:fire("{97822377-6CF7-4275-B2B8-3E4E2E50F11C}",{text=bca},1)end end
local function dba()_aa=math.max(_aa-1,0)if _aa<=0 and not aaa then cba()end end
local function _ca()local aca=a_a.PrimaryPart
local bca=
c_a*CFrame.new(0,-aca.Size.Y/2,0)*CFrame.Angles(0,math.pi*2 *math.random(),0)local cca=bca:ToObjectSpace(c_a)
local dca=Instance.new("Part")dca.CFrame=bca;local _da=0.2;local ada=1
if baa then baa:Disconnect()baa=nil end;if caa then caa:Pause()caa:Destroy()caa=nil end
caa=cd(dca,{"CFrame"},
bca*CFrame.Angles(0,0,0.2),_da,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
caa.Completed:connect(function()
caa=cd(dca,{"CFrame"},bca,ada,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out)
caa.Completed:connect(function()caa=nil;dca:Destroy()if baa then baa:Disconnect()
baa=nil end end)end)
baa=dd.onHeartbeatFor(_da+ada,function()
a_a:SetPrimaryPartCFrame(dca.CFrame:ToWorldSpace(cca))end)end;function d_a.onAttackedClient()_ca()dba()end
function d_a.onAttackedServer(aca)end;return d_a