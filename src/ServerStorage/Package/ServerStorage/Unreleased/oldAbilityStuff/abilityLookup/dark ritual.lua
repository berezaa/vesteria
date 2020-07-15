
local dc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local _d=game:GetService("Debris")
local ad=game:GetService("RunService")
local bd=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local cd=bd.load("network")local dd=bd.load("damage")
local __a=bd.load("placeSetup")local a_a=bd.load("tween")local b_a=bd.load("effects")
local c_a=bd.load("ability_utilities")local d_a=__a.awaitPlaceFolder("entities")
local _aa={id=39,name="Dark Ritual",image="rbxassetid://4079576139",description="Sacrifice your own health to gain mana.",mastery="",layoutOrder=0,maxRank=1,statistics={[1]={cooldown=1,manaCost=0,healthCost=100,manaRestored=50}},securityData={playerHitMaxPerTag=64,projectileOrigin="character"},disableAutoaim=true}local aaa=0.75;local baa=3;local caa="warlockSimulacrumData"local function daa(bba)
local cba=bba:FindFirstChild(caa)if cba then return#cba:GetChildren()>0 end
return false end
local function _ba(bba)
local cba=c_a.getCastingPlayer(bba)if not cba then return end;local dba=cba:FindFirstChild(caa)
if not dba then return end;local _ca=dba:GetChildren()if#_ca==0 then return end;local aca=_ca[1]
if not aca then return end;local bca=aca:FindFirstChild("modelRef")if not bca then return end;return
bca.Value end
function injureOverTime(bba,cba,dba,_ca)local aca=bba:FindFirstChild("health")
if not aca then return end;local bca=cba/_ca;local cca=dba/_ca
spawn(function()local dca=aca.Value;for _=1,_ca do
dca=math.max(1,aca.Value-bca)aca.Value=dca;wait(cca)end end)end
function _aa:execute_server(bba,cba,dba)if not dba then return end;local _ca=bba.Character;if not _ca then return end
local aca=_ca.PrimaryPart;if not aca then return end;local bca=aca:FindFirstChild("health")if not bca then
return end;local cca=aca:FindFirstChild("mana")
if not cca then return end;local dca=aca:FindFirstChild("maxMana")if not dca then return end
local _da=cba["ability-statistics"]["healthCost"]
local ada=cba["ability-statistics"]["manaRestored"]if daa(bba)then ada=ada*2 end
injureOverTime(aca,_da,aaa,baa)wait(aaa)
cca.Value=math.min(cca.Value+ada,dca.Value)end
local function aba(bba,cba,dba,_ca,aca)local bca=script.dark:Clone()local cca=bca.trail
bca.CFrame=bba.CFrame;bca.Parent=d_a
local dca=CFrame.Angles(0,0,dba)*CFrame.new(0,aca,0)
local _da=CFrame.Angles(0,0,-dba)*CFrame.new(0,aca,0)
b_a.onHeartbeatFor(_ca,function(ada,bda,cda)
local dda=CFrame.new(bba.Position,cba.Position)local __b=CFrame.new(cba.Position,bba.Position)
local a_b=dda.Position;local b_b=(dda*dca).Position;local c_b=(__b*_da).Position
local d_b=__b.Position;local _ab=a_b+ (b_b-a_b)*cda
local aab=c_b+ (d_b-c_b)*cda;local bab=_ab+ (aab-_ab)*cda
bca.CFrame=CFrame.new(bab)end)
delay(_ca,function()bca.Transparency=1;cca.Enabled=false
_d:AddItem(bca,cca.Lifetime)end)end
function _aa:execute(bba,cba,dba,_ca)local aca=bba.PrimaryPart;if not aca then return end
local bca=bba:FindFirstChild("entity")if not bca then return end;local cca=bca:FindFirstChild("UpperTorso")if not
cca then return end
local dca=bba:FindFirstChild("clientHitboxToServerHitboxReference")if not dca then return end;local _da=dca.Value;if not _da then return end;if dba then
cd:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",cba,self.id)end
local ada=cba["ability-statistics"]["healthCost"]
local bda=bba.entity.AnimationController:LoadAnimation(dc["warlock_dark_ritual"])bda:Play()local cda=Instance.new("Attachment")
cda.Parent=cca;local dda=script.darkEmitter:Clone()dda.Parent=cda
local __b=script.manaEmitter:Clone()__b.Parent=cda;injureOverTime(_da,ada,aaa,baa)
local a_b=script.damage:Clone()a_b.Parent=aca;a_b:Play()
_d:AddItem(a_b,a_b.TimeLength)local b_b=c_a.getCastingPlayer(cba)
if b_b and daa(b_b)then
local d_b=_ba(cba)local _ab=d_b.PrimaryPart;local aab=aca;for _=1,2 do
aba(_ab,aab,math.pi*2 *math.random(),aaa,4)end end;wait(aaa-dda.Lifetime.Max)dda.Enabled=false
wait(dda.Lifetime.Max)__b:Emit(64)local c_b=script.restore:Clone()
c_b.Parent=aca;c_b:Play()_d:AddItem(c_b,c_b.TimeLength)
_d:AddItem(cda,__b.Lifetime.Max)end;return _aa