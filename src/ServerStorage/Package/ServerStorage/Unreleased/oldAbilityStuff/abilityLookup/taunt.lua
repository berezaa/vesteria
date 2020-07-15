
local db=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local _c=game:GetService("Debris")
local ac=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local bc=ac.load("network")local cc=ac.load("damage")
local dc=ac.load("placeSetup")local _d=ac.load("tween")local ad=ac.load("effects")
local bd=ac.load("ability_utilities")local cd=dc.awaitPlaceFolder("entities")
local dd={id=58,name="Taunt",image="rbxassetid://3296042264",description="Force nearby enemies to attack you and reduce their damage resistance.",mastery="Larger area, shorter cooldown.",layoutOrder=0,maxRank=10,statistics=bd.calculateStats{maxRank=10,static={radius=24,statusDuration=10},staggered={cooldown={first=30,final=15,levels={2,4,6,8,10}},weakness={first=10,final=20,levels={3,5,7,9}}},pattern={manaCost={base=10,pattern={3,4}}}},windupTime=0.5,securityData={}}
local function __a()local b_a=Instance.new("Part")b_a.Anchored=true
b_a.CanCollide=false;b_a.TopSurface=Enum.SurfaceType.Smooth
b_a.BottomSurface=Enum.SurfaceType.Smooth;b_a.CastShadow=false;return b_a end;local function a_a(b_a,c_a,d_a)return b_a+ (c_a-b_a)*d_a end
function dd:execute_server(b_a,c_a,d_a)if
not d_a then return end;local _aa=b_a.Character;if not _aa then return end
local aaa=_aa.PrimaryPart;if not aaa then return end
local baa=c_a["ability-statistics"]["radius"]^2;local caa={}
local function daa(aba)local bba=aba:FindFirstChild("entityType")
if not bba then return end;if bba.Value~="monster"then return end
local cba=(aba.Position-aaa.Position)local dba=cba.X^2 +cba.Z^2;if dba>baa then return end
bc:invoke("{32CCFE53-543A-4794-AD57-82DE027EA7E4}",aba,aaa,"ability",3)local _ca=c_a["ability-statistics"]
bc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",aba,"taunted",{duration=_ca.statusDuration,target=aaa,modifierData={damageTakenMulti=(
_ca.weakness/100)}},aba,"ability",self.id)table.insert(caa,aba)end;local _ba=cc.getDamagableTargets(b_a)
for aba,bba in pairs(_ba)do daa(bba)end
bc:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",c_a,self.id,caa)end
function dd:execute_client(b_a,c_a)local d_a=bd.getCastingPlayer(b_a)if not d_a then return end
local _aa=d_a.Character;if not _aa then return end;local aaa=_aa.PrimaryPart;if not aaa then return end;local baa=0.5
for caa,daa in
pairs(c_a)do local _ba=__a()_ba.Shape=Enum.PartType.Ball
_ba.Size=Vector3.new(4,4,4)_ba.Color=script.ring.Color;_ba.Transparency=0.25
_ba.Material=Enum.Material.Neon;_ba.Position=daa.Position;_ba.Parent=cd
ad.onHeartbeatFor(baa,function(aba,bba,cba)local dba=cba^2
_ba.Position=a_a(daa.Position,aaa.Position,dba)_ba.Transparency=a_a(0.25,1,dba)
_ba.Size=a_a(Vector3.new(4,4,4),Vector3.new(),dba)end)_c:AddItem(_ba,baa)end end
function dd:execute(b_a,c_a,d_a,_aa)local aaa=b_a.PrimaryPart;if not aaa then return end
local baa=b_a.entity.AnimationController:LoadAnimation(db["fist_pump"])baa:Play()
if d_a then
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(baa.Length,function()
bc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)end;local caa=script.cast:Clone()caa.Parent=aaa;caa:Play()
_c:AddItem(caa,caa.TimeLength)wait(self.windupTime)local daa=script.hit:Clone()
daa.Parent=aaa;daa:Play()_c:AddItem(daa,daa.TimeLength)
local _ba=c_a["ability-statistics"]["radius"]local aba=_ba*2
do local bba=0.25;local cba=1;local dba=script.ring:Clone()
dba.Position=aaa.Position;dba.Parent=cd
_d(dba,{"Size"},Vector3.new(aba,2,aba),bba)_d(dba,{"Transparency"},1,cba)
_c:AddItem(dba,cba)end;if d_a then
bc:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",c_a,self.id)end end;return dd