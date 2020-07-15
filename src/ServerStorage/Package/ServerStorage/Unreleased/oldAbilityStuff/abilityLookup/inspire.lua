
local cb=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local db=game:GetService("Debris")
local _c=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ac=_c.load("network")local bc=_c.load("damage")
local cc=_c.load("placeSetup")local dc=_c.load("tween")local _d=_c.load("effects")
local ad=_c.load("ability_utilities")local bd=cc.awaitPlaceFolder("entities")
local cd={id=46,name="Inspire",image="rbxassetid://4079576394",description="Grant a defense buff to yourself and nearby party members.",mastery="Bigger buff.",layoutOrder=0,maxRank=10,statistics=ad.calculateStats{maxRank=10,static={cooldown=
60 *5,radius=32},staggered={duration={first=60 *2.5,final=60 *5,levels={2,3,5,6,8,9}},buff={first=5,final=15,levels={4,7,10}}},pattern={manaCost={base=50,pattern={2.5,2.5,5}}}},windupTime=0.5,securityData={}}
local function dd()local __a=Instance.new("Part")__a.Anchored=true
__a.CanCollide=false;__a.TopSurface=Enum.SurfaceType.Smooth
__a.BottomSurface=Enum.SurfaceType.Smooth;__a.CastShadow=false;return __a end
function cd:execute_server(__a,a_a,b_a)if not b_a then return end;local c_a=__a.Character;if not c_a then return end
local d_a=c_a.PrimaryPart;if not d_a then return end
local function _aa(aba)local bba=a_a["ability-statistics"]
ac:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",aba,"empower",{duration=bba.duration,modifierData={damageTakenMulti=
-bba.buff/100}},d_a,"ability",self.id)end;local aaa=bc.getNeutrals(__a)local baa=a_a["cast-origin"]
local caa=a_a["ability-statistics"]["radius"]local daa=caa*caa;local _ba={}
for aba,bba in pairs(aaa)do local cba=(bba.Position-baa)local dba=
cba.X*cba.X+cba.Z*cba.Z;if dba<=daa then
table.insert(_ba,bba)_aa(bba)end end
ac:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",a_a,self.id,_ba)end
function cd:execute_client(__a,a_a)local b_a=4
for c_a,d_a in pairs(a_a)do local _aa=script.shield:Clone()
local aaa=_aa.Size;_aa.Size=Vector3.new()dc(_aa,{"Size"},aaa,0.5)
_d.onHeartbeatFor(b_a,function(daa,_ba,aba)
_aa.CFrame=
CFrame.new(d_a.Position)*CFrame.new(0,6,0)*CFrame.Angles(0,_ba*6,0)_aa.Transparency=aba;if aba==1 then _aa:Destroy()end end)_aa.Parent=bd;local baa=dd()baa.Size=Vector3.new(4,1,4)
baa.Transparency=1;local caa=script.emitter:Clone()caa.Parent=baa
_d.onHeartbeatFor(1,function(daa,_ba,aba)baa.CFrame=
CFrame.new(d_a.Position)*CFrame.new(0,-2,0)
if aba==1 then
caa.Enabled=false;wait(caa.Lifetime.Max)baa:Destroy()end end)baa.Parent=bd end end
function cd:execute(__a,a_a,b_a,c_a)local d_a=__a.PrimaryPart;if not d_a then return end
local _aa=__a.entity.AnimationController:LoadAnimation(cb["fist_pump"])_aa:Play()
if b_a then
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(_aa.Length,function()
ac:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)end;local aaa=script.cast:Clone()aaa.Parent=d_a;aaa:Play()
db:AddItem(aaa,aaa.TimeLength)wait(self.windupTime)for number=0,2 do
delay(number/3,function()
local daa=script.hit:Clone()daa.Parent=d_a;daa:Play()
db:AddItem(daa,daa.TimeLength)end)end
local baa=a_a["ability-statistics"]["radius"]local caa=baa*2
do local daa=0.25;local _ba=1;local aba=script.ring:Clone()
aba.Position=d_a.Position;aba.Parent=bd
dc(aba,{"Size"},Vector3.new(caa,2,caa),daa)dc(aba,{"Transparency"},1,_ba)
db:AddItem(aba,_ba)end;if b_a then
ac:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",a_a,self.id)end end;return cd