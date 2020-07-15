
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ac=game:GetService("Debris")
local bc=game:GetService("RunService")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("network")local _d=cc.load("damage")
local ad=cc.load("placeSetup")local bd=cc.load("tween")local cd=cc.load("ability_utilities")
local dd=cc.load("effects")local __a=cc.load("projectile")
local a_a=ad.awaitPlaceFolder("entities")
local b_a={id=52,name="Earthcall",image="rbxassetid://4079577918",description="Hurl a boulder at your target, damaging and stunning them if it hits.",mastery="",maxRank=10,statistics=cd.calculateStats{maxRank=10,static={cooldown=4},staggered={damageMultiplier={first=1,final=3,levels={2,4,6,8,10}},stunDuration={first=1,final=3,levels={3,5,7,9}}},pattern={manaCost={base=6,pattern={2,4}}}},windupTime=0.9,castingSpeed=1.5,securityData={playerHitMaxPerTag=1,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true,equipmentTypeNeeded="staff",disableAutoaim=true,projectileSpeed=128,targetingData={targetingType="projectile",projectileSpeed="projectileSpeed",projectileGravity=1,onStarted=function(d_a,_aa)
local aaa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)["1"].manifest.magic;local baa=script.targetingEmitter:Clone()
baa.Parent=aaa;return{emitter=baa,projectionPart=aaa}end,onEnded=function(d_a,_aa,aaa)
aaa.emitter.Enabled=false
game:GetService("Debris"):AddItem(aaa.emitter,aaa.emitter.Lifetime.Max)end}}function b_a._serverProcessDamageRequest(d_a,_aa)
if d_a=="boulder"then return _aa,"magical","projectile"end end
local function c_a(d_a,_aa,aaa)
local baa=d_a.Character;if not baa then return end;local caa=baa.PrimaryPart;if not caa then return end
local daa=_aa["ability-statistics"]
dc:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",aaa,"stunned",{duration=daa.stunDuration,modifierData={walkspeed_totalMultiplicative=-1}},caa,"ability",b_a.id)end
function b_a:execute_server(d_a,_aa,aaa)if not aaa then return end
local baa=Instance.new("RemoteEvent")baa.Name="EarthcallTemporarySecureRemote"
baa.OnServerEvent:Connect(function(...)
c_a(...)baa:Destroy()end)baa.Parent=game.ReplicatedStorage;ac:AddItem(baa,30)return baa end
function b_a:execute(d_a,_aa,aaa,baa)local caa=self.windupTime/self.castingSpeed
local daa=d_a.PrimaryPart;if not daa then return end;local _ba=d_a:FindFirstChild("entity")if not _ba then
return end
local aba=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local bba=aba["1"]and aba["1"].manifest
if not bba then return end;local cba=bba:FindFirstChild("magic")if not cba then return end
local dba=cba:FindFirstChild("castEffect")if not dba then return end
local _ca=d_a.clientHitboxToServerHitboxReference.Value;if not _ca then return end
local function aca()if not aaa then return end
local bca=dc:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",b_a.id,_aa)bca["ability-state"]="update"bca["ability-guid"]=baa
dc:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"update",bca,baa)end
if _aa["ability-state"]=="begin"then
local bca=_ba.AnimationController:LoadAnimation(_c["mage_strike_down_top"])bca:Play(nil,nil,self.castingSpeed)dba.Enabled=true
local cca=script.charge:Clone()cca.Parent=daa;cca:Play()
do
local dca=script.boulder:Clone()dca:ClearAllChildren()local _da=dca.Size
dca.Size=Vector3.new(0,0,0)dca.Parent=a_a
dd.onHeartbeatFor(caa,function(ada,bda,cda)dca.Size=_da*cda;dca.CFrame=cba.WorldCFrame;if
cda==1 then dca:Destroy()end end)end;wait(caa)bca:Stop(0.25)dba.Enabled=false;cca:Stop()
cca:Destroy()aca()elseif _aa["ability-state"]=="update"then local bca;if aaa then
bca=dc:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",_aa,self.id)end
local cca=script.cast:Clone()cca.Parent=daa;cca:Play()
ac:AddItem(cca,cca.TimeLength)local dca=_aa["mouse-target-position"]
local _da=cd.getCastingPlayer(_aa)local ada=script.boulder:Clone()local bda=ada.trail
local cda=ada.emitter;ada.Parent=a_a;local dda=__a.makeIgnoreList{d_a,_ca}
local __b=__a.getUnitVelocityToImpact_predictive(cba.WorldPosition,self.projectileSpeed,dca,Vector3.new(),1)
__a.createProjectile(cba.WorldPosition,__b or(dca-cba.WorldPosition).Unit,self.projectileSpeed,ada,function(a_b)
ada.Transparency=1;bda.Enabled=false;cda:Emit(8)
ac:AddItem(ada,math.max(bda.Lifetime,cda.Lifetime.Max))ada.hit:Play()
local b_b,c_b=_d.canPlayerDamageTarget(_da,a_b)
if b_b then if aaa then bca:FireServer(_aa,c_b)
dc:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",c_b,ada.Position,"ability",self.id,"boulder",baa)end end end,function(a_b)return
CFrame.new()end,dda,false,1)
dc:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
dc:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",b_a.id,"end")end end;return b_a