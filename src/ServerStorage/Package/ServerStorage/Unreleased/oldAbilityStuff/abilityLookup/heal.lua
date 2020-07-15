
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("effects")
local ad=_c.load("ability_utilities")local bd=_c.load("utilities")
local cd=cc.awaitPlaceFolder("entities")
local dd={id=38,name="Heal",image="rbxassetid://4079577292",description="Heal yourself and nearby party members. (Requires staff.)",mastery="More healing.",layoutOrder=0,maxRank=10,statistics=ad.calculateStats{maxRank=10,static={cooldown=4},staggered={healing={first=200,final=500,levels={2,3,5,6,8,9}},radius={first=16,final=20,levels={4,7,10}}},pattern={manaCost={base=10,pattern={2,2,4}}}},windupTime=0.25,securityData={playerHitMaxPerTag=64,projectileOrigin="character"},equipmentTypeNeeded="staff",disableAutoaim=true}
function dd:execute_server(__a,a_a,b_a)if not b_a then return end;local function c_a(daa)
local _ba=a_a["ability-statistics"]["healing"]
bd.healEntity(__a.Character.PrimaryPart,daa,_ba)end
local d_a=bc.getNeutrals(__a)local _aa=a_a["cast-origin"]
local aaa=a_a["ability-statistics"]["radius"]local baa=aaa*aaa;local caa={}
for daa,_ba in pairs(d_a)do local aba=(_ba.Position-_aa)local bba=
aba.X*aba.X+aba.Z*aba.Z;if bba<=baa then c_a(_ba)
table.insert(caa,_ba)end end
ac:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",a_a,self.id,caa)end
function dd:execute_client(__a,a_a)local b_a=1
for c_a,d_a in pairs(a_a)do local _aa=script.spark:Clone()
_aa.Transparency=1;_aa.Size=_aa.Size*3
_aa.CFrame=CFrame.new(d_a.Position)*
CFrame.Angles(math.pi*
2 *math.random(),0,math.pi*2 *math.random())_aa.Parent=cd
dc(_aa,{"Transparency","Size"},{0,Vector3.new(0,0,0)},b_a)
_d.onHeartbeatFor(b_a,function()local aaa=d_a.Position-_aa.Position
_aa.CFrame=_aa.CFrame+aaa end)db:AddItem(_aa,b_a)end end
function dd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)local aaa=_aa["1"]and _aa["1"].manifest
if not aaa then return end;local baa=aaa:FindFirstChild("magic")if not baa then return end
local caa=baa:FindFirstChild("castEffect")if not caa then return end;caa.Enabled=true
local daa=__a.entity.AnimationController:LoadAnimation(cb["mage_circle_quick"])daa:Play()if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end;wait(self.windupTime)if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;daa:Stop(0.25)
caa.Enabled=false;local _ba=script.cast:Clone()_ba.Parent=d_a;_ba:Play()
db:AddItem(_ba,_ba.TimeLength)local aba=a_a["ability-statistics"]["radius"]
do
local bba=0.2;local cba=0.8;local dba=script.ring:Clone()
dba.CFrame=CFrame.new(d_a.Position)dba.Parent=cd
dc(dba,{"Size"},Vector3.new(aba*2,1,aba*2),bba)local _ca=script.spark:Clone()
_ca.CFrame=
CFrame.new(d_a.Position)*
CFrame.Angles(math.pi*2 *math.random(),0,math.pi*2 *math.random())_ca.Parent=cd;dc(_ca,{"Size"},_ca.Size*3,bba)
delay(bba,function()
dc(dba,{"Transparency"},1,cba,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
dc(_ca,{"Transparency"},1,cba,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)wait(cba)dba:Destroy()_ca:Destroy()end)end;if b_a then
ac:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",a_a,self.id)end end;return dd