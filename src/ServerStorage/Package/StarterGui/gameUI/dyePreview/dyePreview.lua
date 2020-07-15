local ba={}local ca=game:GetService("RunService")local da
local _b=script.Parent;local ab={}local bb;function ba.forceClose()if da then bb=false end end;function ba.isPrompting()
return da end;function ba.prompt(cb)end;ba.PROMPT_EXPIRE_TIME=30
function ba.init(cb)
local db=cb.tween;_b.Visible=false;local _c={}local ac
local function bc(ad)local bd={}if ad:FindFirstChild("manifest")then
table.insert(bd,ad.manifest)end
for __a,a_a in pairs(ad:GetChildren())do
if
a_a:IsA("BasePart")then a_a.Color=Color3.new(1,1,1)a_a.Transparency=0.5 end;for b_a,c_a in pairs(a_a:GetChildren())do if c_a:IsA("BasePart")then
table.insert(bd,c_a)end end end;local cd=Vector3.new()local dd=0;for __a,a_a in pairs(bd)do
if a_a:IsA("BasePart")then
local b_a=a_a.Position;local c_a=a_a:GetMass()cd=cd+ (b_a*c_a)dd=dd+c_a end end
return cd/dd end
local function cc(ad)ac=ad;_b.curve.ImageColor3=Color3.fromRGB(30,30,30)
_b.Visible=true;_b.curve.yes.Visible=true;_b.curve.no.Visible=true
_b.curve.Visible=true;_b.curve.title.Text=ad.text;local bd=ad.itemBaseData
local cd=ad.dyeItemData;_b.curve.before:ClearAllChildren()
_b.curve.after:ClearAllChildren()local dd=bd.module;local __a
if dd:FindFirstChild("manifest")then
__a=Instance.new("Model")local baa=dd.manifest:Clone()baa.Parent=__a;__a.PrimaryPart=baa elseif
dd:FindFirstChild("container")then __a=dd.container:Clone()end;__a.Parent=_b.curve.before;local a_a=__a:GetExtentsSize()
local b_a=bc(__a)local c_a=Instance.new("Camera")
c_a.CFrame=CFrame.new(b_a+a_a*
Vector3.new(0.7,0,-0.7),b_a)c_a.Parent=_b.curve.before
_b.curve.before.CurrentCamera=c_a;local d_a=__a:Clone()d_a.Parent=_b.curve.after;local _aa={id=bd.id}
if
cd.applyScroll(game.Players.LocalPlayer,_aa,true)then local baa=_aa.dye
if baa then
for caa,daa in pairs(d_a:GetDescendants())do if daa:IsA("BasePart")then
daa.Color=Color3.new(
daa.Color.r*baa.r/255,daa.Color.g*baa.g/255,daa.Color.b*
baa.b/255)end end end end;local aaa=Instance.new("Camera")
aaa.CFrame=CFrame.new(b_a+a_a*
Vector3.new(0.7,0,-0.7),b_a)aaa.Parent=_b.curve.after;_b.curve.after.CurrentCamera=aaa end;local function dc(ad)table.insert(_c,ad)
if#_c==1 or _c[1]==ad then cc(ad)end end
local function _d(ad)
if ac then ac.userResponse=ad;for dd,__a in pairs(_c)do if __a==ac then
table.remove(_c,dd)break end end;ac=nil
local bd=_b.curve:Clone()bd.Name="transition"bd.ZIndex=bd.ZIndex+1;bd.Parent=_b;db(bd,{"Position"},UDim2.new(
-1,-10,0,0),0.6)
game.Debris:AddItem(bd,0.6)
spawn(function()wait(0.6)if not ac then _b.Visible=false end end)_b.curve.Visible=false;local cd=_c[1]if cd then cc(cd)end end end
function ba.prompt(ad,bd)local cd=tick()
local dd={text="Are you sure you want to apply "..ad.name.."?",timestamp=cd,dyeItemData=ad,itemBaseData=bd}dc(dd)repeat wait()until
dd.userResponse~=nil or tick()-cd>=ba.PROMPT_EXPIRE_TIME
if
tick()-cd>=ba.PROMPT_EXPIRE_TIME then
if dd==ac then _d(false)else for __a,a_a in pairs(_c)do
if a_a==ac then table.remove(_c,__a)break end end end end;return dd.userResponse or false end
_b.curve.no.MouseButton1Click:Connect(function()
_b.curve.ImageColor3=Color3.fromRGB(30,7,8)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
_d(false)end)
_b.curve.yes.MouseButton1Click:Connect(function()
_b.curve.ImageColor3=Color3.fromRGB(8,30,10)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
_d(true)end)
function ba.prompt_old(ad)if da then return false end
_b.Position=UDim2.new(0.5,0,0.5,0)local function bd()
local b_a=game:GetService("GuiService").SelectedObject
if b_a then return b_a:IsDescendantOf(_b)else return false end end
da=true;local cd;_b.curve.title.Text=ad
local dd=_b.curve.no.MouseButton1Click:Connect(function()
if
da then _b.curve.ImageColor3=Color3.fromRGB(30,7,8)
_b.curve.yes.Visible=false;_b.curve.no.Visible=false;bb=false end end)
local __a=_b.curve.yes.MouseButton1Click:Connect(function()if da then
_b.curve.ImageColor3=Color3.fromRGB(8,30,10)_b.curve.yes.Visible=false;_b.curve.no.Visible=false
bb=true end end)
db(_b.curve,{"Position"},UDim2.new(0,0,0,0),0)_b.curve.ImageColor3=Color3.fromRGB(30,30,30)
_b.Visible=true;_b.curve.yes.Visible=true;_b.curve.no.Visible=true
for i=1,3 do
local b_a=script.Parent.flare:Clone()b_a.Name="flareCopy"b_a.Parent=script.Parent;b_a.Visible=true
b_a.Size=UDim2.new(1,4,1,4)b_a.Position=UDim2.new(0,-2,0.5,0)
b_a.AnchorPoint=Vector2.new(0,0.5)local c_a=(180 -40 *i)local d_a=(14 -2 *i)
local _aa=UDim2.new(0,-d_a/2,0.5,0)local aaa=UDim2.new(1,c_a,1,d_a)db(b_a,{"Position","Size","ImageTransparency"},{_aa,aaa,1},
0.5 *i)end;repeat ca.Heartbeat:Wait()until bb~=nil;local a_a=bb;bb=nil
dd:Disconnect()__a:Disconnect()da=false
db(_b.curve,{"Position"},UDim2.new(-1,-10,0,0),0.6)
spawn(function()wait(0.6)if not da then _b.Visible=false end end)return a_a end end;return ba