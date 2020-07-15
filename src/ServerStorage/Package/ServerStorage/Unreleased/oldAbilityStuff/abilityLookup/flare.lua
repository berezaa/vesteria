
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("effects")
local ad=_c.load("ability_utilities")local bd=cc.awaitPlaceFolder("entities")
local cd={id=50,name="Flare",image="rbxassetid://4079575823",description="Release a large blast of Light magic, damaging enemies and healing allies. (Requires staff.)",mastery="More damage and healing.",layoutOrder=0,maxRank=10,statistics=ad.calculateStats{maxRank=10,static={radius=64,cooldown=30},staggered={damageMultiplier={first=1,final=2,levels={2,4,6,8,10}},healing={first=100,final=200,levels={3,5,7,9}}},pattern={manaCost={base=20,pattern={3,4}}}},windupTime=0.9,securityData={playerHitMaxPerTag=256,isDamageContained=true},equipmentTypeNeeded="staff",disableAutoaim=true}local dd=0.05;function cd._serverProcessDamageRequest(__a,a_a)
if __a=="flare"then return a_a,"magical","aoe"end end
function cd:execute_server(__a,a_a,b_a,c_a)
if not b_a then return end
local function d_a(bba)local cba=a_a["ability-statistics"]["healing"]
local dba=bba:FindFirstChild("health")if not dba then return end;local _ca=bba:FindFirstChild("maxHealth")if
not _ca then return end
dba.Value=math.min(dba.Value+cba,_ca.Value)end;local function _aa(bba)
ac:fire("{9AF17239-FE35-48D5-B980-F2FA7DF2DBBC}",__a,bba,bba.Position,"ability",self.id,"flare",c_a)end
local aaa=a_a["cast-origin"]local baa=a_a["ability-statistics"]["radius"]
local caa=baa*baa;local daa=bc.getDamagableTargets(__a)local _ba={}
for bba,cba in pairs(daa)do
local dba=(cba.Position-aaa)local _ca=dba.X*dba.X+dba.Z*dba.Z;if _ca<=caa then
table.insert(_ba,{enemy=cba,distanceSq=_ca})end end;local aba=bc.getNeutrals(__a)for bba,cba in pairs(aba)do local dba=(cba.Position-aaa)local _ca=
dba.X*dba.X+dba.Z*dba.Z
if _ca<=caa then d_a(cba)end end
table.sort(_ba,function(bba,cba)return
bba.distanceSq<cba.distanceSq end)
spawn(function()for bba,cba in pairs(_ba)do _aa(cba.enemy)wait(dd)end end)
ac:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",a_a,self.id,_ba)end
function cd:execute_client(__a,a_a)local b_a=1
spawn(function()
for c_a,d_a in pairs(a_a)do local _aa=d_a.enemy
local aaa=script.spark:Clone()aaa.Transparency=1;aaa.Size=aaa.Size*3
aaa.CFrame=
CFrame.new(_aa.Position)*
CFrame.Angles(math.pi*2 *math.random(),0,math.pi*2 *math.random())aaa.Parent=bd
dc(aaa,{"Transparency","Size"},{0,Vector3.new(0,0,0)},b_a)
_d.onHeartbeatFor(b_a,function()local baa=_aa.Position-aaa.Position
aaa.CFrame=aaa.CFrame+baa end)db:AddItem(aaa,b_a)wait(dd)end end)end
function cd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=ac:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",__a.entity)local aaa=_aa["1"]and _aa["1"].manifest
if not aaa then return end;local baa=aaa:FindFirstChild("magic")if not baa then return end
local caa=baa:FindFirstChild("castEffect")if not caa then return end;caa.Enabled=true
local daa=__a.entity.AnimationController:LoadAnimation(cb["mage_strike_down"])daa:Play()if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)end
local _ba=script.channel:Clone()_ba.Parent=d_a;_ba:Play()
db:AddItem(_ba,_ba.TimeLength)
do local cba=script.flare:Clone()local dba=cba.emitter;cba.Parent=bd
dc(cba,{"Size","Transparency"},{Vector3.new(4,4,4),1},self.windupTime)local _ca=script.beam:Clone()
_ca.Size=Vector3.new(128,1,1)_ca.Parent=bd
dc(_ca,{"Transparency"},1,self.windupTime)
_d.onHeartbeatFor(self.windupTime,function(aca,bca,cca)cba.CFrame=baa.WorldCFrame
_ca.CFrame=CFrame.new(baa.WorldPosition+
Vector3.new(0,64,0))*
CFrame.Angles(0,0,math.pi/2)if cca==1 then _ca:Destroy()dba.Enabled=false
wait(dba.Lifetime.Max)cba:Destroy()end end)end;wait(self.windupTime)if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end;daa:Stop(0.25)
caa.Enabled=false;local aba=script.cast:Clone()aba.Parent=d_a;aba:Play()
db:AddItem(aba,aba.TimeLength)local bba=a_a["ability-statistics"]["radius"]
do
local cba=0.25;local dba=0.75;local _ca=script.flare:Clone()local aca=_ca.emitter
_ca.Position=d_a.Position;_ca.Transparency=0.75;_ca.Parent=bd;dc(_ca,{"Size"},
Vector3.new(1,1,1)*bba*2,cba)
delay(cba,function()
dc(_ca,{"Transparency"},1,dba)wait(dba)aca.Enabled=false;wait(aca.Lifetime.Max)
_ca:Destroy()end)end;if b_a then
ac:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",a_a,self.id,c_a)end end;return cd