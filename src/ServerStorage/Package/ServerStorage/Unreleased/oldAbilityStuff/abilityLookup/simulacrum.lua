
local cd=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local dd=game:GetService("Debris")
local __a=game:GetService("RunService")
local a_a=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local b_a=a_a.load("network")local c_a=a_a.load("damage")
local d_a=a_a.load("placeSetup")local _aa=a_a.load("tween")
local aaa=a_a.load("ability_utilities")local baa=a_a.load("effects")local caa=a_a.load("detection")
local daa=d_a.awaitPlaceFolder("entities")
local _ba={id=57,name="Simulacrum",image="rbxassetid://4465750442",description="Use dark magic to create a simulacrum. It mimics Warlock abilities. Reactivate to order it to charge the nearest enemy and explode.",mastery="Shorter cooldown.",maxRank=5,statistics=aaa.calculateStats{maxRank=5,static={duration=20,radius=16},dynamic={manaCost={5,10}},staggered={cooldown={first=10,final=5,levels={3,5}},damageMultiplier={first=2,final=3,levels={2,4}}}},windupTime=0.9,securityData={playerHitMaxPerTag=64,isDamageContained=true,projectileOrigin="character"}}local aba="warlockSimulacrumData"
local function bba(_da,ada)for bda,cda in pairs(_da:GetDescendants())do if
cda:IsA("BasePart")then ada(cda)end end end;local function cba(_da,ada,bda)return _da+ (ada-_da)*bda end
local function dba(_da)local ada=
_da["mouse-world-position"]+Vector3.new(0,8,0)local bda=Ray.new(ada,Vector3.new(0,
-16,0))
local cda,dda=aaa.raycastMap(bda)return dda+Vector3.new(0,2,0)end
function _ba:execute_server(_da,ada,bda,cda)if not bda then return end;local dda=_da.Character;if not dda then return end
local __b=dda.PrimaryPart;if not __b then return end;local a_b=_da:FindFirstChild(aba)if not a_b then
a_b=Instance.new("Folder")a_b.Name=aba;a_b.Parent=_da end;local b_b=#
a_b:GetChildren()
if b_b==0 then
b_a:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",ada,self.id,"creationEffect")wait(1)local c_b=Instance.new("Folder")c_b.Name="simulacrum"
local d_b=Instance.new("CFrameValue")d_b.Name="cframe"
d_b.Value=CFrame.new(dba(ada))*CFrame.Angles(0,math.pi*2 *
math.random(),0)d_b.Parent=c_b;c_b.Parent=a_b
dd:AddItem(c_b,ada["ability-statistics"]["duration"])
b_a:invoke("{5517DD42-A175-4E6C-8DD5-842CB17CE9F3}",_da,self.id)else local c_b=a_b:GetChildren()[1]
local d_b=c_a.getDamagableTargets(_da)local _ab=32 ^2;local aab=nil
for bab,cab in pairs(d_b)do
local dab=cab.Position-c_b.cframe.Value.Position;local _bb=dab.X^2 +dab.Y^2 +dab.Z^2;if _bb<_ab then aab=cab
_ab=_bb end end
b_a:fireAllClientsExcludingPlayer("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_da,ada,self.id,"detonateSimulacrums",a_b,aab,false)
b_a:invokeClient("{BE1205CC-1952-4C32-BE72-9A9C3C53E41C}",_da,ada,self.id,"detonateSimulacrums",a_b,aab,true,cda)a_b:ClearAllChildren()end end
function _ba:detonateSimulacrums(_da,ada,bda,cda,dda)local __b=aaa.getCastingPlayer(_da)
local a_b=_da["ability-statistics"]["radius"]local b_b=a_b^2
for c_b,d_b in pairs(ada:GetChildren())do
local _ab=d_b:FindFirstChild("modelRef")
if _ab then _ab=_ab.Value
local aab=_ab:FindFirstChild("animationController")
if aab then local bab=_ab:FindFirstChild("animations")if bab then
local cab=bab:FindFirstChild("cast")
if cab then local dab=aab:LoadAnimation(cab)dab:Play()end end end
if bda then local bab=24
baa.onHeartbeatFor(self.windupTime,function(cab,dab,_bb)
local abb=bda.Position-_ab.PrimaryPart.Position;local bbb=abb.Magnitude;local cbb=abb/bbb;local dbb=bab*cab;local _cb;if bbb<1 then
_cb=Vector3.new()elseif dbb>=bbb then _cb=abb else _cb=cbb*dbb end
_ab:SetPrimaryPartCFrame(CFrame.new(
_ab.PrimaryPart.Position+_cb,bda.Position))end)end
delay(self.windupTime,function()if not _ab.Parent then return end
do
local bab=script.darkSphere:Clone()bab.Position=_ab.PrimaryPart.Position;bab.Parent=daa
bab.hit:Play()
_aa(bab,{"Size","Transparency"},{Vector3.new(1,1,1)*a_b*2,1},0.5)end
bba(_ab,function(bab)_aa(bab,{"Transparency"},1,0.5)end)
if cda then local bab=c_a.getDamagableTargets(__b)
for cab,dab in pairs(bab)do local _bb=dab.Position-
_ab.PrimaryPart.Position
local abb=_bb.X^2 +_bb.Y^2 +_bb.Z^2;if abb<=b_b then
b_a:fire("{1024DC5D-10A4-4107-B168-D2EB7CB3AAF8}",dab,dab.Position,"ability",self.id,"explode",dda)end end end end)end end;wait(self.windupTime)end
function _ba:creationEffect(_da)local ada=aaa.getCastingPlayer(_da)if not ada then return end
local bda=ada.Character;if not bda then return end;local cda=bda.PrimaryPart;if not cda then return end
local dda=b_a:invoke("{CA09ED16-A4C8-4148-9701-4B531599C9E9}",cda)if not dda then return end;local __b=dda.PrimaryPart;if not __b then return end
local a_b=dba(_da)
do local b_b={}local c_b=3;local d_b=math.pi*2 /c_b;for darkNumber=1,c_b do
local bbb=script.dark:Clone()bbb.Parent=daa
table.insert(b_b,{part=bbb,rotOffset=d_b* (darkNumber-1)})end;local _ab=0.5
local aab=0;local bab=math.pi*3 /_ab;local cab=-2;local dab=4 /_ab;local _bb=3
local function abb(bbb)
local cbb=aab+bbb.rotOffset;local dbb=math.cos(cbb)*_bb;local _cb=cab
local acb=math.sin(cbb)*_bb
bbb.part.CFrame=CFrame.new(a_b)+Vector3.new(dbb,_cb,acb)end
baa.onHeartbeatFor(_ab,function(bbb,cbb,dbb)aab=aab+bab*bbb;cab=cab+dab*bbb;for _cb,acb in pairs(b_b)do
if dbb<1 then
abb(acb)if dbb<0.5 then local bcb=dbb*2
acb.part.Position=cba(__b.Position,acb.part.Position,bcb)end end end
if
dbb==1 then _ab=0.5;dab=-2 /_ab;local _cb=-3 /_ab
baa.onHeartbeatFor(_ab,function(acb,bcb,ccb)aab=aab+bab*acb;cab=
cab+dab*acb;_bb=_bb+_cb*acb
for dcb,_db in pairs(b_b)do
if ccb<1 then abb(_db)elseif ccb==1 then
_aa(_db.part,{"Transparency"},1,_db.part.trail.Lifetime)_db.part.trail.Enabled=false
dd:AddItem(_db.part,_db.part.trail.Lifetime)local adb=script.darkSphere:Clone()adb.Position=a_b
adb.Parent=daa;adb.summon:Play()
_aa(adb,{"Size","Transparency"},{Vector3.new(8,8,8),1},1)dd:AddItem(adb,1)end end end)end end)end end
function _ba:execute_client(_da,ada,...)return self[ada](self,_da,...)end
local function _ca(_da)local ada=script.simulacrum:Clone()
local bda=ada.animationController;local cda=Instance.new("ObjectValue")cda.Name="modelRef"
cda.Value=ada;cda.Parent=_da
bba(ada,function(dda)local __b=dda.Transparency;dda.Transparency=1
_aa(dda,{"Transparency"},__b,1)end)
ada:SetPrimaryPartCFrame(_da:WaitForChild("cframe").Value)ada.Parent=daa
bda:LoadAnimation(ada.animations.idle):Play()end;local function aca(_da)local ada=_da:FindFirstChild("modelRef")if not ada then return end
ada.Value:Destroy()end
local function bca(_da)for ada,bda in
pairs(_da:GetChildren())do _ca(bda)end
_da.ChildAdded:Connect(_ca)_da.ChildRemoved:Connect(aca)end
local function cca(_da)
if _da:FindFirstChild(aba)then bca(_da[aba])else local ada;local function bda(cda)if cda.Name==aba then bca(cda)
ada:Disconnect()end end
ada=_da.ChildAdded:Connect(bda)end end;local function dca(_da)
if _da:FindFirstChild(aba)then for ada,bda in pairs(_da[aba]:GetChildren())do
aca(bda)end end end
if __a:IsClient()then
local _da=game:GetService("Players")_da.PlayerAdded:Connect(cca)
_da.PlayerRemoving:Connect(dca)for ada,bda in pairs(_da:GetPlayers())do cca(bda)end end
function _ba:execute(_da,ada,bda,cda)local dda=_da.PrimaryPart;if not dda then return end
local __b=_da:FindFirstChild("entity")if not __b then return end;if bda then
b_a:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",ada,self.id,cda)end end;return _ba