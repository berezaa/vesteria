
local _c=game:GetService("ReplicatedStorage"):WaitForChild("abilityAnimations")local ac=game:GetService("Debris")
local bc=game:GetService("Players")
local cc=require(game:GetService("ReplicatedStorage"):WaitForChild("modules"))local dc=cc.load("network")local _d=cc.load("damage")
local ad=cc.load("placeSetup")local bd=cc.load("tween")
local cd=ad.awaitPlaceFolder("entities")
local dd={id=45,name="Resurrect",image="rbxassetid://4079577146",description="Cast on a fallen player's tombstone to return them to life. (Requires staff.)",mastery="",layoutOrder=0,maxRank=1,statistics={[1]={cooldown=120,manaCost=250}},windupTime=0.75,securityData={},equipmentTypeNeeded="staff"}local __a=24
local function a_a()local d_a=Instance.new("Part")d_a.Anchored=true
d_a.CanCollide=false;d_a.TopSurface=Enum.SurfaceType.Smooth
d_a.BottomSurface=Enum.SurfaceType.Smooth;return d_a end
local function b_a(d_a)local _aa=a_a()_aa.Material="Neon"_aa.Shape=Enum.PartType.Ball
_aa.Position=d_a;_aa.Color=script.ring.Color;_aa.Size=Vector3.new(1,1,1)
_aa.Parent=cd
bd(_aa,{"Size","Transparency"},{_aa.Size*16,1},1)ac:AddItem(_aa,1)local aaa=a_a()aaa.Material="Neon"
aaa.Shape=Enum.PartType.Cylinder;aaa.Size=Vector3.new(64,1,1)
aaa.CFrame=CFrame.new(d_a)*CFrame.Angles(0,0,
math.pi/2)*CFrame.new(28,0,0)aaa.Color=script.ring.Color;aaa.Parent=cd
bd(aaa,{"Size","Transparency"},{Vector3.new(64,8,8),1},1)ac:AddItem(aaa,1)local baa=script.ring:Clone()
baa.Position=d_a;baa.Parent=cd
bd(baa,{"Size","Transparency"},{baa.Size*16,1},1)ac:AddItem(baa)local caa=a_a()caa.Size=Vector3.new(0,0,0)
caa.Transparency=1;caa.Position=d_a;caa.Parent=cd
local daa=script.revive:Clone()daa.Parent=caa;daa:Play()
ac:AddItem(caa,daa.TimeLength)end
local function c_a(d_a)local _aa=a_a()_aa.Material="Neon"_aa.Shape=Enum.PartType.Ball
_aa.Position=d_a;_aa.Color=script.ring.Color;_aa.Size=Vector3.new(1,1,1)
_aa.Parent=cd
bd(_aa,{"Size","Transparency"},{_aa.Size*8,1},1)ac:AddItem(_aa,1)local aaa=a_a()aaa.Size=Vector3.new(6,6,6)
aaa.Position=d_a;aaa.Transparency=1
local baa=script.sparklesEmitter:Clone()baa.Parent=aaa;aaa.Parent=cd
delay(5,function()baa.Enabled=false
wait(baa.Lifetime.Max)aaa:Destroy()end)end
function dd:execute_server(d_a,_aa,aaa,baa)if not aaa then return end;if not baa then return end;local caa=baa.Character;if
not caa then return end;local daa=caa.PrimaryPart;if not daa then return end
local _ba=daa:FindFirstChild("state")if not _ba then return end
local aba=baa:FindFirstChild("isPlayerSpawning")if not aba then return end;if _ba.Value=="dead"then
local cba=Instance.new("BoolValue")cba.Name="resurrecting"cba.Value=true;cba.Parent=baa
baa:LoadCharacter()end
local bba=daa.Position
dc:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_aa,self.id,"markTombstone",bba)while aba.Value do wait()end
dc:invoke("{DBDAF4CE-3206-4B42-A396-15CCA3DFE8EC}",baa,CFrame.new(bba))
dc:fireAllClients("{006F08C2-1541-41ED-90BE-192482E14530}",{Text="✨ "..baa.Name..
" was resurrected by "..d_a.Name.." ✨",Font=Enum.Font.SourceSansBold,Color=Color3.fromRGB(255,223,106)})
dc:fireAllClients("{04BC293A-E219-4FFD-AFDC-1E71EA3B6921}",_aa,self.id,"resurrect",bba)end;function dd:execute_client(d_a,_aa,aaa)
if _aa=="resurrect"then b_a(aaa)elseif _aa=="markTombstone"then c_a(aaa)end end
function dd:execute(d_a,_aa,aaa,baa)
local caa=d_a.PrimaryPart;if not caa then return end
local daa=dc:invoke("{CA61CBF0-3B04-4617-8D2D-50C80D51AB19}",d_a.entity)local _ba=daa["1"]and daa["1"].manifest
if not _ba then return end;local aba=_ba:FindFirstChild("magic")if not aba then return end
local bba=aba:FindFirstChild("castEffect")if not bba then return end;bba.Enabled=true
local cba=d_a.entity.AnimationController:LoadAnimation(_c["mage_ascend"])cba:Play()
if aaa then
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",true)
delay(cba.Length,function()
dc:invoke("{27791132-7095-4A6F-B12B-2480E95768A2}",false)end)end;local dba=script.channel:Clone()dba.Parent=caa
dba:Play()ac:AddItem(dba,dba.TimeLength)
wait(self.windupTime)bba.Enabled=false;local _ca=script.cast:Clone()_ca.Parent=caa
_ca:Play()ac:AddItem(_ca,_ca.TimeLength)
if aaa then
local aca=game.Players:GetPlayers()local bca=nil;local cca=nil;local dca=__a
local function _da(ada)local bda=ada.Character;if not bda then return end
print("char")local cda=bda.PrimaryPart;if not cda then return end;print("manifest")
local dda=cda:FindFirstChild("state")if not dda then return end;print("state",dda.Value)
if dda.Value=="dead"then
print("dead")local __b=(cda.Position-caa.Position).Magnitude;if
__b<dca then print("range")bca=ada;cca=ada;dca=__b end end end;for ada,bda in pairs(aca)do _da(bda)end;if not cca then return end
if not bca then return end
dc:fireServer("{7170F8E2-9C53-42D1-A10A-E8383DB284E0}",_aa,self.id,bca)end end;return dd