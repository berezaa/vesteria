
local cc={cost=2,upgradeCost=2,maxRank=8,requirement=function(_ba)return true end,variants={regeneration={default=true,cost=0,requirement=function(_ba)return true end},darkRitual={cost=1,requirement=function(_ba)return
_ba.nonSerializeData.statistics_final.vit>=10 end},haste={cost=1,requirement=function(_ba)return
_ba.nonSerializeData.statistics_final.dex>=10 end}}}local dc=2;local _d=game:GetService("Debris")
local ad=game:GetService("RunService")
local bd=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local cd=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dd=cd.load("network")local __a=cd.load("damage")
local a_a=cd.load("placeSetup")local b_a=cd.load("tween")local c_a=cd.load("effects")
local d_a=cd.load("ability_utilities")local _aa=a_a.awaitPlaceFolder("entities")
local aaa={id=dc,metadata=cc}
local baa={id=dc,metadata=cc,name="Regeneration",image="rbxassetid://2528901754",description="Restore some health over time.",statistics={[1]={cooldown=12,healing=60,duration=5,manaCost=15},[2]={healing=100,duration=5,manaCost=25},[3]={healing=140,duration=7,manaCost=28},[4]={healing=210,duration=7,manaCost=42},[5]={healing=280,duration=7,manaCost=56},[6]={healing=360,duration=9,manaCost=60},[7]={healing=480,duration=9,manaCost=80},[8]={healing=700,duration=10,manaCost=100,tier=3}},maxRank=8,startAbility_server=function(_ba,aba,bba,cba)
local dba=dd:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bba)
if dba then local _ca=cba["ability-statistics"]local aca=_ca["duration"]
local bca=_ca["healing"]
local cca,dca=dd:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",bba.Character.PrimaryPart,"regenerate",{healthToHeal=bca,duration=_ca["duration"]},aba.Character.PrimaryPart,"ability",_ba.id,cba.variant)return cca,dca end;return false,"no player data"end,stopAbility_server=function(_ba,aba,bba)
end,execute=function(_ba,aba,bba,cba,dba)if not aba.PrimaryPart then return end
local _ca=script.regeneration_specks:Clone()_ca.Parent=aba.PrimaryPart
local aca=script.regeneration_sound:Clone()aca.Parent=aba.PrimaryPart;aca:Play()
game.Debris:AddItem(aca,3)
spawn(function()wait(1)_ca.Enabled=false end)game.Debris:AddItem(_ca,3)end,cleanup=function(_ba,aba)if
not aba.PrimaryPart then return end end,onStatusEffectBegan=function(_ba,aba)end,onStatusEffectEnded=function(_ba,aba)
end}
local caa={id=dc,metadata=cc,name="Haste",image="rbxassetid://4830540307",description="Temporarily increase movement speed and stamina recovery.",statistics={[1]={cooldown=20,walkspeed=1,staminaRecovery=0.5,duration=6,manaCost=10},[2]={staminaRecovery=1,manaCost=12},[3]={duration=9,manaCost=16},[4]={walkspeed=2,manaCost=22},[5]={duration=12,manaCost=26},[6]={staminaRecovery=1.5,manaCost=28},[7]={walkspeed=3,manaCost=34},[8]={cooldown=15,tier=3}},maxRank=8,startAbility_server=function(_ba,aba,bba,cba)
local dba=dd:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bba)
if dba then local _ca=cba["ability-statistics"]local aca=_ca["duration"]
local bca=_ca["healing"]
local cca,dca=dd:invoke("{964385B0-1F06-4732-A494-F5D6F84ABC61}",bba.Character.PrimaryPart,"empower",{modifierData={walkspeed=_ca["walkspeed"],staminaRecovery=_ca["staminaRecovery"]},duration=_ca["duration"],variant="haste"},aba.Character.PrimaryPart,"ability",_ba.id,cba.variant)return cca,dca end;return false,"no player data"end,execute=function(_ba,aba,bba,cba,dba)if
not aba.PrimaryPart then return end
local _ca=script.haste_specks:Clone()_ca.Parent=aba.PrimaryPart
local aca=script.haste_sound:Clone()aca.Parent=aba.PrimaryPart;aca:Play()
game.Debris:AddItem(aca,3)_ca.Enabled=false;_ca:Emit(10)
game.Debris:AddItem(_ca,5)end}
local daa={id=dc,metadata=cc,name="Dark Ritual",image="rbxassetid://4827276298",description="Sacrifice your own health to gain mana.",maxRank=8,LURCH_DURATION=0.75,LURCH_HITS=3,statistics={[1]={cooldown=1,manaCost=0,healthCost=100,manaRestored=50},[2]={healthCost=150,manaRestored=75},[3]={healthCost=200,manaRestored=100},[4]={healthCost=250,manaRestored=125},[5]={healthCost=300,manaRestored=150},[6]={healthCost=350,manaRestored=175},[7]={healthCost=400,manaRestored=200},[8]={healthCost=500,manaRestored=250,tier=3}},securityData={playerHitMaxPerTag=64,projectileOrigin="character"},disableAutoaim=true,darkEffect=function(_ba,aba,bba,cba,dba)
local _ca=script.dark:Clone()local aca=_ca.trail;_ca.CFrame=_ba.CFrame;_ca.Parent=_aa;local bca=
CFrame.Angles(0,0,bba)*CFrame.new(0,dba,0)
local cca=CFrame.Angles(0,0,
-bba)*CFrame.new(0,dba,0)
c_a.onHeartbeatFor(cba,function(dca,_da,ada)
local bda=CFrame.new(_ba.Position,aba.Position)local cda=CFrame.new(aba.Position,_ba.Position)
local dda=bda.Position;local __b=(bda*bca).Position;local a_b=(cda*cca).Position
local b_b=cda.Position;local c_b=dda+ (__b-dda)*ada
local d_b=a_b+ (b_b-a_b)*ada;local _ab=c_b+ (d_b-c_b)*ada
_ca.CFrame=CFrame.new(_ab)end)
delay(cba,function()_ca.Transparency=1;aca.Enabled=false
_d:AddItem(_ca,aca.Lifetime)end)end,execute_server=function(_ba,aba,bba,cba)if
not cba then return end;local dba=aba.Character;if not dba then return end
local _ca=dba.PrimaryPart;if not _ca then return end;local aca=_ca:FindFirstChild("health")if not aca then
return end;local bca=_ca:FindFirstChild("mana")
if not bca then return end;local cca=_ca:FindFirstChild("maxMana")if not cca then return end
local dca=bba["ability-statistics"]["healthCost"]
local _da=bba["ability-statistics"]["manaRestored"]local ada=_ca:FindFirstChild("health")if not ada then return end;local bda=dca/
_ba.LURCH_HITS
local cda=_ba.LURCH_DURATION/_ba.LURCH_HITS
spawn(function()local dda=ada.Value
for _=1,_ba.LURCH_HITS do
if ada.Value>0 then dda=ada.Value-bda
ada.Value=dda
if ada.Value<=0 then
if
aba.Character.PrimaryPart.health.Value<=0 then
local __b="☠ "..aba.Name.." sacrificed more than they could afford to ☠"
dd:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text=__b,Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,130,100)})end end;wait(cda)end end end)wait(_ba.LURCH_DURATION)
bca.Value=math.min(bca.Value+_da,cca.Value)end,execute=function(_ba,aba,bba,cba,dba)
local _ca=aba.PrimaryPart;if not _ca then return end;local aca=aba:FindFirstChild("entity")if not aca then
return end;local bca=aca:FindFirstChild("UpperTorso")
if not bca then return end
local cca=aba:FindFirstChild("clientHitboxToServerHitboxReference")if not cca then return end;local dca=cca.Value;if not dca then return end;if cba then
dd:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",bba,_ba.id)end
local _da=bba["ability-statistics"]["healthCost"]
local ada=aba.entity.AnimationController:LoadAnimation(bd["warlock_dark_ritual"])ada:Play()local bda=Instance.new("Attachment")
bda.Parent=bca;local cda=script.darkEmitter:Clone()cda.Parent=bda
local dda=script.manaEmitter:Clone()dda.Parent=bda;local __b=script.damage:Clone()__b.Parent=_ca
__b:Play()_d:AddItem(__b,__b.TimeLength)
wait(_ba.LURCH_DURATION-cda.Lifetime.Max)cda.Enabled=false;wait(cda.Lifetime.Max)
dda:Emit(64)local a_b=script.restore:Clone()a_b.Parent=_ca
a_b:Play()_d:AddItem(a_b,a_b.TimeLength)
_d:AddItem(bda,dda.Lifetime.Max)end}
function generateAbilityData(_ba,aba)aba=aba or{}if _ba then local bba;for cba,dba in pairs(_ba.abilities)do if dba.id==dc then
bba=dba.variant end end
aba.variant=bba or"regeneration"end
if
aba.variant=="regeneration"then return baa elseif aba.variant=="darkRitual"then return daa elseif
aba.variant=="haste"then return caa end;return aaa end;return generateAbilityData