
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ac=game:GetService("Debris")
local bc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cc=bc.load("network")local dc=bc.load("damage")
local _d=bc.load("placeSetup")local ad=bc.load("tween")local bd=bc.load("effects")
local cd=bc.load("ability_utilities")local dd=_d.awaitPlaceFolder("entities")
local __a={id=59,name="Dark Pulse",image="rbxassetid://124874141",description="Damage and slow nearby enemies.",mastery="More damage and harsher slow.",layoutOrder=0,maxRank=5,statistics=cd.calculateStats{maxRank=5,static={cooldown=8,duration=2,radius=12},staggered={damageMultiplier={first=1.5,final=2.25,levels={2,4}},slow={first=15,final=45,levels={3,5}}},pattern={manaCost={base=10,pattern={2,3}}}},windupTime=0.5,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"}}local a_a="warlockSimulacrumData"
local function b_a(d_a)local _aa=d_a:FindFirstChild(a_a)if _aa then return#
_aa:GetChildren()>0 end;return false end
local function c_a(d_a)local _aa=cd.getCastingPlayer(d_a)if not _aa then return end
local aaa=_aa:FindFirstChild(a_a)if not aaa then return end;local baa=aaa:GetChildren()if#baa==0 then return end
local caa=baa[1]if not caa then return end;local daa=caa:FindFirstChild("modelRef")if
not daa then return end;return daa.Value end
function __a._serverProcessDamageRequest(d_a,_aa)if d_a=="pulse"then return _aa,"magical","aoe"end end
function __a:execute_server(d_a,_aa,aaa,baa)if not aaa then return end;local caa=d_a.Character;if not caa then return end
local daa=caa.PrimaryPart;if not daa then return end
local function _ba(aca)local bca=_aa["ability-statistics"]
cc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",aca,"empower",{duration=bca.duration,modifierData={walkspeed_totalMultiplicative=
-bca.slow/100}},daa,"ability",self.id)
cc:fire("{9AF17239-FE35-48D5-B980-F2FA7DF2DBBC}",d_a,aca,aca.Position,"ability",self.id,"pulse",baa)end;local aba=dc.getDamagableTargets(d_a)
local bba=_aa["ability-statistics"]["radius"]local cba=bba*bba;local dba={}
local function _ca(aca)
for bca,cca in pairs(aba)do local dca=(cca.Position-aca)local _da=
dca.X*dca.X+dca.Z*dca.Z;if _da<=cba then
table.insert(dba,cca)_ba(cca)end end end;_ca(_aa["cast-origin"])if b_a(d_a)then
_ca(d_a[a_a]:GetChildren()[1].cframe.Value.Position)end
cc:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_aa,self.id,dba)end;function __a:execute_client(d_a,_aa)end
function __a:execute(d_a,_aa,aaa,baa)local caa=d_a.PrimaryPart
if not caa then return end
local daa=d_a.entity.AnimationController:LoadAnimation(_c["mage_cast_pulse"])daa:Play()local _ba=c_a(_aa)
if _ba then
local aca=_ba:FindFirstChild("animationController")if aca then
aca:LoadAnimation(_c["mage_cast_pulse"]):Play()end end
if aaa then
cc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(daa.Length,function()
cc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)end;local aba=script.cast:Clone()aba.Parent=caa;aba:Play()
ac:AddItem(aba,aba.TimeLength)wait(self.windupTime)local bba=script.hit:Clone()
bba.Parent=caa;bba:Play()ac:AddItem(bba,bba.TimeLength)
local cba=_aa["ability-statistics"]["radius"]local dba=cba*2
local function _ca(aca)local bca=0.25;local cca=1;local dca=script.ring:Clone()
dca.Position=aca;dca.Parent=dd
ad(dca,{"Size"},Vector3.new(dba,2,dba),bca)ad(dca,{"Transparency"},1,cca)
ac:AddItem(dca,cca)end;_ca(caa.Position)if _ba then
_ca(_ba.PrimaryPart.Position)end;if aaa then
cc:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",_aa,self.id,baa)end end;return __a