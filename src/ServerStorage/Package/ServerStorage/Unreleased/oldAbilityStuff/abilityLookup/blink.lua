
local dc=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")
local _d=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local ad=_d.load("projectile")local bd=_d.load("placeSetup")
local cd=_d.load("client_utilities")local dd=_d.load("network")local __a=_d.load("damage")
local a_a=_d.load("detection")
local b_a=bd.awaitPlaceFolder("entityManifestCollection")local c_a=bd.awaitPlaceFolder("entityRenderCollection")
local d_a=bd.awaitPlaceFolder("entities")
local _aa=require(game:GetService("ReplicatedStorage"):WaitForChild("itemData"))local aaa=game:GetService("HttpService")
local baa={cost=1,upgradeCost=2,maxRank=8,layoutOrder=3,requirement=function(bba)
return bba.class=="Mage"end}
local caa={id=9,metadata=baa,name="Blink",image="rbxassetid://3736597962",description="Launch your character forward faster than one can blink.",animationName={"mage_blink"},windupTime=0.2,layoutOrder=2,maxRank=5,prerequisite={{id=4,rank=1}},layoutOrder=1,statistics={[1]={power=15,cooldown=4,manaCost=12},[2]={power=18,manaCost=14},[3]={power=21,manaCost=16},[4]={power=24,manacost=18},[5]={power=30,manaCost=22,tier=3},[6]={power=36,manaCost=26},[7]={power=42,manaCost=30},[8]={power=51,manaCost=36,tier=4}},dontDisableSprinting=true}
function caa.__serverValidateMovement(bba,cba,dba)
local _ca=dd:invoke("{1116BB97-A7FB-4554-BDEC-B014207542AD}",caa,dd:invoke("{85D4FB3D-CC96-464E-96A9-E796B8EA4DA5}",bba,caa.id))return(dba-cba).magnitude<=_ca.power*2.5 end
function caa._serverProcessDamageRequest(bba,cba,dba,_ca,aca)
local bca=dd:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",aca)
if bca then local cca=bca.nonSerializeData.statistics_final
if
cca.activePerks["poisonblink"]then if bba=="poison"then return cba*0.25,"magical","dot"end end;if bba=="warpDamage"then
if cca.str>=70 then return cba*2.00,"magical","direct"elseif cca.str>=30 then return cba*
1.50,"magical","direct"end end end end
function caa._abilityExecutionDataCallback(bba,cba)
if bba then local dba=bba.nonSerializeData.statistics_final
cba["poisonblink"]=dba.activePerks["poisonblink"]cba["holymagic"]=dba.activePerks["holymagic"]
cba["solar wind"]=dba.activePerks["solar wind"]cba["warpDamage"]=dba.str>=30 end end;local daa=4
local function _ba(bba,cba,dba,_ca,aca)local bca=script.particlePart:Clone()
local cca=(bba-cba).magnitude;bca.Size=Vector3.new(2,5,cca)
bca.CFrame=CFrame.new((bba+cba)/2,cba)bca.Parent=workspace.CurrentCamera;if aca then
bca.Fire.Color=ColorSequence.new(aca)end;bca.Fire:Emit(40)
local dca=script.blonk:Clone()dca.Parent=bca;dca:Play()
game.Debris:AddItem(bca,5)end
local function aba(bba)local cba=script.sparklePart:Clone()
cba.CFrame=CFrame.new(bba)cba.Parent=workspace.CurrentCamera
cba.Attachment.Sparks:Emit(40)game.Debris:AddItem(cba,1)end
function caa:execute_server(bba,cba,dba)
local _ca=dd:invoke("{7C72E2AC-71AE-4B44-BFAF-6CE59C3E833B}",bba)
if _ca then local aca=_ca.nonSerializeData.statistics_final;local bca=0;if aca.vit>=20 then
bca=15 end;if aca.vit>=50 then bca=40 end
if aca.vit>=120 then bca=100 end;local cca=bba.Character;if not cca then return end;local dca=cca.PrimaryPart
if not dca then return end;local _da=dca:FindFirstChild("health")if not _da then return end
local ada=dca:FindFirstChild("maxHealth")if not ada then return end
_da.Value=math.min(_da.Value+bca,ada.Value)end end
function caa:execute(bba,cba,dba,_ca)
if not bba:FindFirstChild("entity")then return end;if not bba.entity.PrimaryPart then return end;local aca
for _da,ada in
pairs(self.animationName)do
local bda=bba.entity.AnimationController:LoadAnimation(dc[ada])bda.Looped=false;bda.Priority=Enum.AnimationPriority.Movement
bda:Play(0.05,1,1)aca=bda end;local bca=script.Magic:Clone()
bca.Parent=bba.entity.PrimaryPart;bca:Play()game.Debris:AddItem(bca,5)
local cca=cba["cast-origin"]local dca
if cba["holymagic"]then dca=Color3.fromRGB(255,234,110)end;if cba["solar wind"]then
dca=BrickColor.new("Cool yellow").Color end
if dba and bba.entity.PrimaryPart then if not
bba:FindFirstChild("entity")then return end
local _da=
dd:invoke("{952A8B11-BC62-42C8-9898-0A3A6E1B00C4}")or Vector3.new()
local ada=dd:invoke("{348D3B42-CC0E-4882-9083-A4CCFFD2EF04}")or Vector3.new()local bda=_da*Vector3.new(1,1,1)
local cda=math.clamp(ada.Y,-5,5)bda=bda+ (cda*Vector3.new(0,1,0))
local dda=(bda.magnitude>
1 and bda)or bba.entity.PrimaryPart.CFrame.lookVector;local __b=dda.unit;wait(self.windupTime)
if bda then
local a_b=bba.entity.PrimaryPart.Position;local b_b=cba["ability-statistics"]["power"]if
cba["solar wind"]then b_b=b_b*1.5 end
local c_b=bba.entity.PrimaryPart.Position+ (b_b*__b)local d_b=(c_b-a_b).unit
local _ab=cba["ability-statistics"].power*1.2;local aab=(aca.Length-self.windupTime)local bab=tick()
local cab=Ray.new(bba.entity.PrimaryPart.Position,(
c_b-bba.entity.PrimaryPart.Position))
local dab,_bb=workspace:FindPartOnRayWithIgnoreList(cab,{workspace:FindFirstChild("placeFolders")})local abb=_aa[cba["cast-weapon-id"]]
if
bba:FindFirstChild("clientHitboxToServerHitboxReference")then
bba.clientHitboxToServerHitboxReference.Value.CFrame=CFrame.new(_bb)_ba(cca,c_b,true,1.25,dca)
if cba["warpDamage"]then
local bbb=(cab.Origin-_bb).Magnitude
local cbb=CFrame.new(cab.Origin,_bb)*CFrame.new(0,0,-bbb/2)local dbb=Vector3.new(5,5,bbb)
local _cb=__a.getDamagableTargets(game.Players.LocalPlayer)local acb=a_a.boxcast_all(_cb,cbb,dbb)
for bcb,ccb in pairs(acb)do local dcb=ccb.Position
aba(dcb)
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",ccb,dcb,"ability",self.id,"warpDamage",_ca)end end end end elseif not dba and bba.entity.PrimaryPart then
wait(self.windupTime+0.15)
_ba(cca,bba.entity.PrimaryPart.Position,true,1.25,dca)end
if cba["poisonblink"]then local _da=true
local ada=script.LingeringSmokePart:Clone()ada.CFrame=CFrame.new(cca)ada.Parent=d_a
ada.sound:Play()
delay(5,function()_da=false;if ada and ada:FindFirstChild("Smoke")then
ada.Smoke.Enabled=false end
game.Debris:AddItem(ada,2)end)
if dba then
spawn(function()
while _da and ada and ada.Parent do
for bda,cda in
pairs(__a.getDamagableTargets(game.Players.LocalPlayer))do local dda=ada.CFrame+Vector3.new(0,3,0)
local __b=a_a.projection_Box(cda.CFrame,cda.Size,dda.p)
if a_a.boxcast_singleTarget(dda,ada.Size,__b)then
local a_b=(ada.Position+cda.Position)/2
dd:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",cda,a_b,"ability",self.id,"poison",_ca)end end;wait(0.33)end end)end end end;return caa