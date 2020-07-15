
local bc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local cc=game:GetService("Debris")
local dc=game:GetService("RunService")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("network")local bd=_d.load("damage")
local cd=_d.load("placeSetup")local dd=_d.load("tween")
local __a=_d.load("ability_utilities")local a_a=_d.load("effects")local b_a=_d.load("projectile")
local c_a=cd.awaitPlaceFolder("entities")
local d_a={id=41,name="Switch Strike",image="rbxassetid://4079576879",description="Fling a whimsical spell which harms its target and then makes it switch places with you.",mastery="More damage.",maxRank=10,statistics=__a.calculateStats{maxRank=10,static={cooldown=6},staggered={damageMultiplier={first=2,final=3.6,levels={2,3,5,6,8,9}},projectileSpeed={first=50,final=100,levels={4,7,10}}},pattern={manaCost={base=10,pattern={2,2,4}}}},windupTime=0.55,securityData={playerHitMaxPerTag=1,isDamageContained=true,projectileOrigin="character"},abilityDecidesEnd=true,resetCooldownOnKill=true,targetingData={targetingType="projectile",projectileSpeed=64,projectileGravity=0.0001,onStarted=function(caa,daa)
local _ba=caa.entity.AnimationController:LoadAnimation(bc.left_hand_targeting_sequence)_ba:Play()local aba=caa.entity.LeftHand
return{track=_ba,projectionPart=aba}end,onEnded=function(caa,daa,_ba)
_ba.track:Stop()end}}
local _aa={BrickColor.new("Bright red"),BrickColor.new("Bright orange"),BrickColor.new("Bright yellow"),BrickColor.new("Bright green"),BrickColor.new("Bright blue"),BrickColor.new("Bright violet")}local aaa=#_aa
function createEffectPart()local caa=Instance.new("Part")caa.Anchored=true
caa.CanCollide=false;caa.TopSurface=Enum.SurfaceType.Smooth
caa.BottomSurface=Enum.SurfaceType.Smooth;return caa end;function d_a._serverProcessDamageRequest(caa,daa)
if caa=="bolt"then return daa,"magical","projectile"end end
local function baa(caa)return
caa:FindFirstChild("resilient")~=nil end
function swap(caa,daa)local _ba=caa.Character;if not _ba then return end;local aba=_ba.PrimaryPart
if not aba then return end;local bba=aba.CFrame;local cba=daa.CFrame;if not baa(daa)then
ad:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",caa,cba)daa.CFrame=bba end end
function d_a:execute_server(caa,daa,_ba)if not _ba then return end
local aba=Instance.new("RemoteEvent")aba.Name="SwitchStrikeTemporarySecureRemote"
aba.OnServerEvent:Connect(function(...)
swap(...)aba:Destroy()end)aba.Parent=game.ReplicatedStorage;cc:AddItem(aba,30)return aba end
function d_a:execute(caa,daa,_ba,aba)local bba=caa.PrimaryPart;if not bba then return end
local cba=caa:FindFirstChild("entity")if not cba then return end;local dba=cba:FindFirstChild("LeftHand")if
not dba then return end
local _ca=caa.clientHitboxToServerHitboxReference.Value;if not _ca then return end
if daa["ability-state"]=="begin"then
local aca=caa.entity.AnimationController:LoadAnimation(bc["mage_cast_left_hand_top"])aca:Play()local bca=Instance.new("Attachment")
bca.Name="SwitchStrikeEmitterAttachment"bca.Parent=dba;local cca=script.whimsyEmitter:Clone()
cca.Parent=bca;local dca=script.charge:Clone()dca.Parent=dba
dca:Play()
delay(self.windupTime-cca.Lifetime.Max,function()cca.Enabled=false end)wait(self.windupTime)dca:Stop()dca:Destroy()
local _da=script.cast:Clone()_da.Parent=dba;_da:Play()
cc:AddItem(_da,_da.TimeLength)
if _ba then
local ada=ad:invoke("{0659F187-209D-48FD-AE95-040A0C31DB94}",d_a.id,daa)ada["ability-state"]="update"ada["ability-guid"]=aba
ad:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",d_a.id,"update",ada,aba)end elseif daa["ability-state"]=="update"then local aca;if _ba then
aca=ad:invokeServer("{7EE4FFC2-5AFD-40AB-A7C0-09FE74A020C3}",daa,self.id)end;local bca=dba.Position
local cca=daa["ability-statistics"]["projectileSpeed"]local dca=daa["mouse-target-position"]local _da=(dca-bca).Unit
local ada=__a.getCastingPlayer(daa)local bda=script.bolt:Clone()
local cda={bda.trailBot,bda.trailTop}bda.Parent=c_a;local dda=b_a.makeIgnoreList{caa,_ca}local __b=
math.pi*8 *math.random()
local a_b=math.pi*8 *math.random()
b_a.createProjectile(bca,_da,cca,bda,function(b_b)bda.Transparency=1
for _ab,aab in pairs(cda)do aab.Enabled=false end;cc:AddItem(bda,cda[1].Lifetime)
local c_b,d_b=bd.canPlayerDamageTarget(ada,b_b)
if c_b then
for _ab,aab in pairs{_ca,d_b}do local bab=script.swap:Clone()bab.Parent=aab
bab:Play()cc:AddItem(bab,bab.TimeLength)
local cab=script.smokePart:Clone()cab.Position=aab.Position;cab.Parent=c_a
spawn(function()
cab.emitter:Emit(32)wait(cab.emitter.Lifetime.Max)
cab:Destroy()end)end
if _ba then
ad:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",d_b,bda.Position,"ability",self.id,"bolt",aba)aca:FireServer(d_b)end end end,function(b_b)local c_b=
aaa*2
local d_b=math.floor(b_b*c_b)%aaa+1;bda.BrickColor=_aa[d_b]
return CFrame.Angles(__b*b_b,0,a_b*b_b)end,dda,true,0)if _ba then
ad:fire("{51252262-788E-447C-A950-A8E92643DAEA}",false)
ad:invoke("{C8F2171C-1C77-4D97-89FD-DBA03550755B}",d_a.id,"end")end end end;return d_a