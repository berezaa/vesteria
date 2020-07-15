
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("effects")
local ad=_c.load("ability_utilities")local bd=cc.awaitPlaceFolder("entities")
local cd={id=54,name="Prayer of Comfort",image="rbxassetid://4465750327",description="May they be at ease under the light of Vesra.",mastery="More healing.",layoutOrder=0,maxRank=10,statistics=ad.calculateStats{maxRank=10,static={cooldown=
60 *5,radius=36},staggered={duration={first=60 *2.5,final=60 *5,levels={2,3,5,6,8,9}},healing={first=6,final=12,levels={4,7,10}}},pattern={manaCost={base=50,pattern={2.5,2.5,5}}}},windupTime=1.5,securityData={}}
local function dd()local __a=Instance.new("Part")__a.Anchored=true
__a.CanCollide=false;__a.TopSurface=Enum.SurfaceType.Smooth
__a.BottomSurface=Enum.SurfaceType.Smooth;__a.CastShadow=false;return __a end
function cd:execute_server(__a,a_a,b_a)if not b_a then return end;local c_a=__a.Character;if not c_a then return end
local d_a=c_a.PrimaryPart;if not d_a then return end
local function _aa(aba)local bba=a_a["ability-statistics"]
ac:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",aba,"regenerate",{duration=bba.duration,healthToHeal=
bba.healing*bba.duration},d_a,"ability",self.id)end;local aaa=bc.getNeutrals(__a)local baa=a_a["cast-origin"]
local caa=a_a["ability-statistics"]["radius"]local daa=caa*caa;local _ba={}
for aba,bba in pairs(aaa)do local cba=(bba.Position-baa)local dba=
cba.X*cba.X+cba.Z*cba.Z;if dba<=daa then
table.insert(_ba,bba)_aa(bba)end end
ac:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",a_a,self.id,_ba)end
function cd:execute_client(__a,a_a)
for b_a,c_a in pairs(a_a)do local d_a={}local _aa=3;local aaa=math.pi*2 /_aa;for lightNumber=1,_aa do
local cba=script.light:Clone()cba.Parent=bd
table.insert(d_a,{part=cba,rotOffset=aaa* (lightNumber-1)})end;local baa=0;local caa=
math.pi*2;local daa=-2;local _ba=4;local aba=3;local bba=2
_d.onHeartbeatFor(bba,function(cba,dba,_ca)baa=baa+caa*cba;daa=
daa+_ba*cba
for aca,bca in pairs(d_a)do
if _ca<1 then local cca=baa+bca.rotOffset;local dca=
math.cos(cca)*aba;local _da=daa;local ada=math.sin(cca)*aba
bca.part.CFrame=
CFrame.new(c_a.Position)+Vector3.new(dca,_da,ada)elseif _ca==1 then
dc(bca.part,{"Transparency"},1,bca.part.trail.Lifetime)bca.part.trail.Enabled=false
db:AddItem(bca.part,bca.part.trail.Lifetime)end end end)end end
function cd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=_d.hideWeapons(__a.entity)
local aaa=__a.entity.AnimationController:LoadAnimation(cb["prayer"])aaa:Play()
if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(aaa.Length,function()
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)_aa()end)end;local baa=script.cast:Clone()baa.Parent=d_a;baa:Play()
db:AddItem(baa,baa.TimeLength)wait(self.windupTime)aaa:Stop(0.5)
local caa=script.prayer:Clone()caa.Parent=d_a;caa:Play()
db:AddItem(caa,caa.TimeLength)local daa=a_a["ability-statistics"]["radius"]
local _ba=daa*2
do local aba=0.25;local bba=1;local cba=script.ring:Clone()
cba.Position=d_a.Position;cba.Parent=bd
dc(cba,{"Size"},Vector3.new(_ba,2,_ba),aba)dc(cba,{"Transparency"},1,bba)
db:AddItem(cba,bba)end;if b_a then
ac:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",a_a,self.id)end end;return cd