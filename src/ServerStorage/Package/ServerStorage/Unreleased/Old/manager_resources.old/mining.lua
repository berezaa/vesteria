local bb=5;local cb=game:GetService("ReplicatedStorage")
local db=require(cb:WaitForChild("modules"))local _c=db.load("network")local ac=db.load("tween")
local bc=db.load("effects")local cc=require(cb:WaitForChild("itemData"))
local dc=script.Parent.Parent;local _d=dc.PrimaryPart.itemId.Value
local function ad(cd)
local dd=_c:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",cd)if(not dd)or(not dd.equipment)then return false end;local __a
for a_a,b_a in
pairs(dd.equipment)do if b_a.position==1 then __a=b_a.id;break end end;if not __a then return false end;return __a==287 end;local bd={}function bd.onAttackedClient()end
function bd.onAttackedServer(cd)
if math.random(1,bb)~=1 then return end;if not ad(cd)then return end;local dd=dc.PrimaryPart.Position
local __a=cd.Character.PrimaryPart.Position;local a_a=CFrame.new(dd,__a)local b_a=Ray.new(__a,dd-__a)
local c_a,d_a=workspace:FindPartOnRayWithWhitelist(b_a,{dc})a_a=a_a+ (d_a-a_a.Position)
local _aa=_c:invoke("{78025E79-97CB-44A8-B433-4A2DDD1FEE21}",{id=288},a_a.Position,{cd})local aaa
if _aa:IsA("BasePart")then aaa=_aa elseif _aa:IsA("Model")and(_aa.PrimaryPart or
_aa:FindFirstChild("HumanoidRootPart"))then
local caa=
_aa.PrimaryPart or _aa:FindFirstChild("HumanoidRootPart")if caa then aaa=caa end end
if aaa then local caa=Instance.new("Attachment",aaa)caa.Position=Vector3.new(0,
aaa.Size.Y/2,0)
local daa=Instance.new("Attachment",aaa)
daa.Position=Vector3.new(0,-aaa.Size.Y/2,0)local _ba=script.trail:Clone()_ba.Attachment0=caa
_ba.Attachment1=daa;_ba.Enabled=true;_ba.Parent=aaa end;local baa=32
_aa.Velocity=(a_a.LookVector*baa)+Vector3.new(0,baa,0)end;return bd